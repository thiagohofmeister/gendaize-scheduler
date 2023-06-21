import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:mobile/components/template/text_form_input.dart';
import 'package:mobile/models/enums/organization_type.dart';
import 'package:mobile/models/register/register_model.dart';
import 'package:mobile/screens/authentication/components/step_title.dart';

class OrganizationStep extends StatefulWidget {
  final Function previousStep;
  final Function nextStep;
  final Function(RegisterOrganizationModel) handleData;
  final RegisterOrganizationModel? data;

  const OrganizationStep(
      {Key? key,
      required this.previousStep,
      required this.nextStep,
      required this.handleData,
      required this.data})
      : super(key: key);

  @override
  State<OrganizationStep> createState() => _OrganizationStepState();
}

class _OrganizationStepState extends State<OrganizationStep> {
  bool isEnterprise = false;
  OrganizationType documentType = OrganizationType.personal;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final MaskedTextController documentNumberController =
      MaskedTextController(mask: '000.000.000-00');
  final TextEditingController documentNameController = TextEditingController();
  final TextEditingController phoneController =
      MaskedTextController(mask: '(00) 00000-0000');
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      nameController.text = widget.data!.name;
      emailController.text = widget.data!.email;
      phoneController.text = widget.data!.phone;
      documentNumberController.text = widget.data!.documentNumber;
      documentNameController.text = widget.data!.documentName ?? '';
    }
  }

  void toggleOrganizationType() {
    setState(() {
      isEnterprise = !isEnterprise;

      documentType = isEnterprise
          ? OrganizationType.enterprise
          : OrganizationType.personal;

      documentNumberController
          .updateMask(isEnterprise ? '00.000.000/0000-00' : '000.000.000-00');
    });
  }

  handleSubmit() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    RegisterOrganizationModel org = RegisterOrganizationModel.fromMap({
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'document': {
        'type': documentType == OrganizationType.enterprise
            ? 'ENTERPRISE'
            : 'PERSONAL',
        'number': documentNumberController.text,
        'name': documentNameController.text,
      }
    });

    widget.handleData(org);

    widget.nextStep();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          const StepTitle(title: 'Dados da empresa'),
          TextFormInput(
            hintText: 'Nome',
            controller: nameController,
            isRequired: true,
            requiredMessage: 'Preencha o nome',
            keyboardType: TextInputType.name,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Possui CNPJ?'),
                Switch(
                  value: isEnterprise,
                  onChanged: (value) {
                    toggleOrganizationType();
                  },
                )
              ],
            ),
          ),
          TextFormInput(
            hintText: isEnterprise ? 'CNPJ' : 'CPF',
            keyboardType: TextInputType.number,
            controller: documentNumberController,
            isRequired: true,
            requiredMessage:
                isEnterprise ? 'Preencha o CNPJ' : 'Preencha o CPF',
          ),
          AnimatedOpacity(
            opacity: isEnterprise ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: Visibility(
              visible: isEnterprise,
              child: TextFormInput(
                hintText: 'Razão social',
                keyboardType: TextInputType.name,
                controller: documentNameController,
                isRequired: true,
                requiredMessage: 'Preencha a razão social',
              ),
            ),
          ),
          TextFormInput(
            hintText: 'Telefone',
            keyboardType: TextInputType.phone,
            controller: phoneController,
            isRequired: true,
            requiredMessage: 'Preencha o telefone',
          ),
          TextFormInput(
            hintText: 'E-mail',
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            isRequired: true,
            requiredMessage: 'Preencha o e-mail',
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
                    onPressed: handleSubmit, child: const Text('Continuar'))
              ],
            ),
          )
        ],
      ),
    );
  }
}
