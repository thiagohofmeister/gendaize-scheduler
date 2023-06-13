import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:mobile/models/enums/organization_type.dart';
import 'package:mobile/models/register/register_model.dart';

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
          const Text('Dados do estabelecimento'),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: isEnterprise ? 'CNPJ' : 'CPF',
              ),
              keyboardType: TextInputType.number,
              controller: documentNumberController,
              onChanged: (value) {
                setState(() {
                  documentNumberController.updateMask(value.length > 14
                      ? '00.000.000/0000-00'
                      : '000.000.000-00');
                });
              },
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return "Preencha o documento";
                }

                return null;
              },
            ),
          ),
          AnimatedOpacity(
            opacity: isEnterprise ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: Visibility(
              visible: isEnterprise,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Razão social',
                  ),
                  keyboardType: TextInputType.name,
                  controller: documentNameController,
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Preencha a razão social";
                    }

                    return null;
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Telefone',
              ),
              keyboardType: TextInputType.phone,
              controller: phoneController,
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return "Preencha o telefone";
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => widget.previousStep(),
                  child: Text('Voltar'),
                ),
                ElevatedButton(
                    onPressed: handleSubmit, child: Text('Continuar'))
              ],
            ),
          )
        ],
      ),
    );
  }
}
