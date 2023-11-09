import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pomodoro/components/CronometroBotao.dart';
import 'package:provider/provider.dart';
import '../store/pomodoro.store.dart';

class Cronometro extends StatelessWidget {
  const Cronometro({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<PomodoroStore>(context);

    return Observer(
  builder: (_) {
    return Container(    
      color: store.estaTrabalhando() ?  Colors.red : Colors.green, // Cor de fundo do Container
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          SizedBox(height: 30), 
          Container(
            width: 150,
            height: 75,
            decoration: BoxDecoration(
              color: store.estaTrabalhando() ?  Color.fromARGB(244, 175, 45, 36) : const Color.fromARGB(255, 58, 134, 60), // Cor de fundo do Container
              borderRadius: BorderRadius.circular(10.0), // Valor define o raio de arredondamento
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Meta',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${store.minutosMeta.toString().padLeft(2, '0')}:${store.segundosMeta.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          if (store.concluido)
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 48,
                  ),
          SizedBox(height: 5), // Espaçamento
          
          Text(
            store.estaTrabalhando() ? 'Período de foco' : 'Período de descanso',
            style: const TextStyle(
              fontSize: 35,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${store.minutos.toString().padLeft(2, '0')}:${store.segundos.toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontSize: 85,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!store.iniciado)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CronometroBotao(
                    texto: 'Iniciar',
                    icone: Icons.play_arrow,
                    click: store.iniciar,
                  ),
                ),
              if (store.iniciado)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CronometroBotao(
                    texto: 'Parar',
                    icone: Icons.stop,
                    click: store.parar,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: CronometroBotao(
                  texto: 'Reiniciar',
                  icone: Icons.refresh,
                  click: store.reiniciar,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  },
);


  }
}
