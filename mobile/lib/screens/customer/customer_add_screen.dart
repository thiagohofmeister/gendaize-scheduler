import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:mobile/components/dialogs/choose_contact_from_device_dialog.dart';
import 'package:mobile/components/dialogs/search_zipcode_dialog.dart';
import 'package:mobile/components/inputs/text_form_input.dart';
import 'package:mobile/components/template/screen_layout.dart';
import 'package:mobile/components/template/screen_progress_indicator.dart';
import 'package:mobile/models/customer/customer_address_create_model.dart';
import 'package:mobile/models/customer/customer_create_model.dart';
import 'package:mobile/services/customer_service.dart';

class CustomerAddScreen extends StatefulWidget {
  const CustomerAddScreen({Key? key}) : super(key: key);

  @override
  State<CustomerAddScreen> createState() => _CustomerAddScreenState();
}

class _CustomerAddScreenState extends State<CustomerAddScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isSaving = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController =
      MaskedTextController(mask: '(00) 00000-0000');
  final TextEditingController _zipCodeController =
      MaskedTextController(mask: '00000-000');
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _complementController = TextEditingController();

  void onSave() {
    setState(() {
      isSaving = true;
    });

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos!'),
        ),
      );

      setState(() {
        isSaving = false;
      });

      return;
    }

    CustomerCreateModel customer = CustomerCreateModel(
      name: _nameController.text,
      phone: _phoneController.text,
      address: CustomerAddressCreateModel(
        zipCode: _zipCodeController.text,
        number: _numberController.text,
        complement: _complementController.text,
      ),
    );

    CustomerService(context).create(customer).then((_) {
      Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar cliente"),
        actions: [
          MenuItemButton(
            onPressed: onSave,
            child: const Text(
              "Concluir",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: isSaving
          ? const ScreenProgressIndicator()
          : Form(
              key: _formKey,
              child: ScreenLayout(
                children: [
                  TextFormInput(
                    suffixIcon: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const ChooseContactFromDeviceDialog();
                          },
                        ).then(
                          (value) {
                            if (value != null) {
                              _nameController.text = (value['name'] as String);

                              _phoneController.text =
                                  (value['phone'] as String);
                            }
                          },
                        );
                      },
                      child: const Icon(Icons.contacts_sharp),
                    ),
                    isRequired: true,
                    requiredMessage: 'Preencha o nome',
                    hintText: 'Nome',
                    isDense: true,
                    keyboardType: TextInputType.name,
                    controller: _nameController,
                  ),
                  TextFormInput(
                    isRequired: true,
                    requiredMessage: 'Preencha o telefone',
                    keyboardType: TextInputType.phone,
                    hintText: 'Telefone',
                    controller: _phoneController,
                  ),
                  TextFormInput(
                    isRequired: true,
                    requiredMessage: 'Preencha o CEP',
                    hintText: 'CEP',
                    suffixIcon: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SearchZipcodeDialog(
                              zipcodeController: _zipCodeController,
                            );
                          },
                        );
                      },
                      child: const Icon(Icons.search),
                    ),
                    keyboardType: TextInputType.number,
                    controller: _zipCodeController,
                  ),
                  TextFormInput(
                    isRequired: true,
                    requiredMessage: 'Preencha o número',
                    hintText: 'Número',
                    controller: _numberController,
                  ),
                  TextFormInput(
                    hintText: 'Complemento',
                    controller: _complementController,
                  ),
                ],
              ),
            ),
    );
  }
}
