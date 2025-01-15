import 'package:flutter/material.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/login/provider/login_provider.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/login/widgets/login_card.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // Paso 1: Importar y enviar mi login provider
        children: [LoginCard(loginProvider: loginProvider)],
      ),
    ));
  }
}
