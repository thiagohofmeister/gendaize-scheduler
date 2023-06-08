import 'package:flutter/material.dart';
import 'package:mobile/services/authentication_service.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final userController = TextEditingController();
    final passwordController = TextEditingController();

    handleSignUp() {
      Navigator.pushNamed(context, 'signup');
    }

    handleSignIn() {
      if (!formKey.currentState!.validate()) {
        return;
      }

      AuthenticationService()
          .authenticate(
        userController.text,
        passwordController.text,
      )
          .then((value) {
        Navigator.pushReplacementNamed(context, 'home');
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Usuário e/ou senha inválido. Tente novamente!'),
          ),
        );
      });
    }

    return Scaffold(
      body: Form(
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'E-mail ou CPF',
                      ),
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Preencha o usuário";
                        }

                        return null;
                      },
                      controller: userController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: true,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Preencha a senha";
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Senha',
                      ),
                      controller: passwordController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ElevatedButton(
                      onPressed: handleSignIn,
                      child: const Text('Acessar'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 50,
                    ),
                    child: Container(
                      height: 3,
                      color: Colors.black26,
                    ),
                  ),
                  const Text('Ainda não é cliente?'),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                      onPressed: handleSignUp,
                      child: const Text('Cadastre-se'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
