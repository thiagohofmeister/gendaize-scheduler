import 'package:flutter/material.dart';
import 'package:mobile/models/register_model.dart';
import 'package:mobile/screens/sign_up_steps/organization_step.dart';
import 'package:mobile/screens/sign_up_steps/user_step.dart';
import 'package:mobile/services/register_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  int currentStep = 0;
  int maxSteps = 2;

  RegisterOrganizationModel? organization;
  RegisterUserModel? user;

  void handleSubmit() {
    RegisterModel register =
        RegisterModel(organization: organization!, user: user!);

    RegisterService().register(register).then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.blue,
            content: Text('Cadastro finalizado com successo!'),
          ),
        );

        Navigator.pushReplacementNamed(context, 'home');
      },
    ).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Ocorreu um erro inesperado!'),
        ),
      );
    });
  }

  void previousStep() {
    int prevStep = currentStep - 1;
    if (prevStep < 0) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      currentStep = prevStep;
    });
  }

  void nextStep() {
    int nextStep = currentStep + 1;
    if (nextStep > maxSteps - 1) {
      handleSubmit();
      return;
    }

    setState(() {
      currentStep = nextStep;
    });
  }

  void setOrganizationData(RegisterOrganizationModel data) {
    setState(() {
      organization = data;
    });
  }

  void setUserData(RegisterUserModel data) {
    setState(() {
      user = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: [
              OrganizationStep(
                previousStep: previousStep,
                nextStep: nextStep,
                handleData: setOrganizationData,
                data: organization,
              ),
              UserStep(
                nextStep: nextStep,
                previousStep: previousStep,
                handleData: setUserData,
                data: user,
              ),
            ][currentStep],
          ),
        ),
      ),
    );
  }
}
