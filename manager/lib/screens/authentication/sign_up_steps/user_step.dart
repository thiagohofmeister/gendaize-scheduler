import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:manager/components/inputs/text_form_input.dart';
import 'package:manager/models/register/register_model.dart';
import 'package:manager/screens/authentication/components/step_title.dart';

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

    if (widget.data != null) {
      nameController.text = widget.data!.name;
      documentNumberController.text = widget.data!.documentNumber;
      passwordController.text = widget.data!.password;
      emailController.text = widget.data!.email;
    }
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
          const StepTitle(title: 'Dados do usuário'),
          TextFormInput(
            hintText: 'Nome',
            keyboardType: TextInputType.name,
            controller: nameController,
            isRequired: true,
            requiredMessage: 'Preencha o nome',
          ),
          TextFormInput(
            hintText: 'CPF',
            keyboardType: TextInputType.number,
            controller: documentNumberController,
            isRequired: true,
            requiredMessage: 'Preencha o CPF',
          ),
          TextFormInput(
            hintText: 'E-mail',
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            isRequired: true,
            requiredMessage: 'Preencha o e-mail',
          ),
          TextFormInput(
            hintText: 'Senha',
            isObscured: true,
            keyboardType: TextInputType.visiblePassword,
            controller: passwordController,
            isRequired: true,
            requiredMessage: 'Preencha a senha',
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
