import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pomodoro/components/Cronometro.dart';
import 'package:pomodoro/components/EntradaTempo.dart';
import 'package:provider/provider.dart';
import 'package:pomodoro/core/services/auth/auth_service.dart';
import '../store/pomodoro.store.dart';

class Pomodoro extends StatelessWidget {
  const Pomodoro({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<PomodoroStore>(context);

    return Scaffold(
  resizeToAvoidBottomInset: true,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Cronometro(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Observer(
              builder: (_) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        EntradaTempo(
                          titulo: 'Trabalho',
                          valor: store.tempoTrabalho,
                          inc: store.iniciado && store.estaTrabalhando()
                              ? null
                              : store.incrementarTempoTrabalho,
                          dec: store.iniciado && store.estaTrabalhando()
                              ? null
                              : store.decrementarTempoTrabalho,
                        ),
                        EntradaTempo(
                          titulo: 'Descanso',
                          valor: store.tempoDescanso,
                          inc: store.iniciado && store.estaDescansando()
                              ? null
                              : store.incrementarTempoDescanso,
                          dec: store.iniciado && store.estaDescansando()
                              ? null
                              : store.decrementarTempoDescanso,
                        ),
                      ],
                    ),
                    SizedBox(height: 20), // Espaçamento
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        EntradaTempo(
                          titulo: 'Meta',
                          valor: store.tempoMeta,
                          inc: store.iniciado
                              ? null
                              : store.incrementarMeta,
                          dec: store.iniciado
                              ? null
                              : store.decrementarMeta,
                        ),
                      ],
                    ),
                    SizedBox(height: 5), // Espaçamento
                    ElevatedButton(
                      onPressed: () {
                        AuthService().logout();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black, // Cor de fundo do botão
                      ),
                      child: Text('Sair'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
