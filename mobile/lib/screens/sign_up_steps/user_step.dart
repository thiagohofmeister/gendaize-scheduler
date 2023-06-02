import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:mobile/models/register_model.dart';

class UserStep extends StatefulWidget {
  final Function previousStep;
  final Function nextStep;
  final Function(RegisterUserModel) handleData;
  final RegisterUserModel? data;

  const UserStep(
      {Key? key,
      required this.previousStep,
      required this.nextStep,
      required this.handleData,
      required this.data})
      : super(key: key);

  @override
  State<UserStep> createState() => _UserStepState();
}

class _UserStepState extends State<UserStep> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final MaskedTextController documentNumberController =
      MaskedTextController(mask: '000.000.000-00');
  final TextEditingController documentNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  handleSubmit() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    RegisterUserModel user = RegisterUserModel.fromMap({
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'documentNumber': documentNumberController.text,
    });

    widget.handleData(user);

    widget.nextStep();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          const Text('Dados do usuário'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nome',
              ),
              keyboardType: TextInputType.name,
              controller: nameController,
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return "Preencha o nome";
                }

                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'CPF',
              ),
              keyboardType: TextInputType.number,
              controller: documentNumberController,
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return "Preencha o CPF";
                }

                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'E-mail',
              ),
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return "Preencha o e-mail";
                }

                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Senha',
              ),
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              controller: passwordController,
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return "Preencha a senha";
                }

                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => widget.previousStep(),
                  child: const Text('Voltar'),
                ),
                ElevatedButton(
                    onPressed: handleSubmit, child: const Text('Cadastrar'))
              ],
            ),
          )
        ],
      ),
    );
  }
}
