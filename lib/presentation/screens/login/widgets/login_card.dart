import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rick_and_morty_fase_2/data/shared/utilis/logger.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/home/home_screen.dart';
import 'package:rick_and_morty_fase_2/presentation/screens/login/controller/login_controller.dart';
import 'package:rick_and_morty_fase_2/presentation/shared/enum/ui_state.dart';

// PASO 2: Reemplazar Stateless Widgwed por ConsumerWidget
// y añadir WidgetRef ref en el build
class LoginCard extends ConsumerWidget {
  // PASO 3: Generar instacia de mi Ligin Provider
  final ChangeNotifierProvider<LoginController> loginProvider;

  const LoginCard({super.key, required this.loginProvider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginProvider);

    final TextEditingController usernameController =
        TextEditingController(text: 'emilys');
    final TextEditingController passwordController =
        TextEditingController(text: 'emilyspass');

    final loginUIStateSelected = loginState.getUiState;

    bool isLoading = loginUIStateSelected == UiState.loading;
    logger.d("[LoginCard]: isLoading $isLoading");

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      loginState
                          .login(
                              usernameController.text, passwordController.text)
                          .then((value) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const HomeScreen()));
                      }).catchError((error) {
                        logger.e(
                            "[LoginCard]: Error on login: ${error.toString()}");
                      });
                    },
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login'),
            ),
          ),
        ],
      ),
    );
  }
}
