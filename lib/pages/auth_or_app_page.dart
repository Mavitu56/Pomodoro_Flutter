import 'package:pomodoro/core/models/user.dart';
import 'package:pomodoro/core/services/auth/auth_service.dart';
import 'package:pomodoro/pages/auth_page.dart';
import 'package:pomodoro/pages/Pomodoro.dart';
import 'package:pomodoro/pages/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthOrAppPage extends StatelessWidget {
  const AuthOrAppPage({super.key});

  Future<void> init(BuildContext context) async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(context),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPage();
        } else {
          return StreamBuilder<user?>(
            stream: AuthService().userChanges,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingPage();
              } else {
                return snapshot.hasData ? const Pomodoro() : const AuthPage();
              }
            },
          );
        }
      },
    );
  }
}