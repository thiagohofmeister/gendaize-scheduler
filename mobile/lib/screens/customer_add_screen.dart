import 'package:flutter/material.dart';
import 'package:mobile/components/dialogs/choose_contact_from_device_dialog.dart';
import 'package:mobile/components/dialogs/search_zipcode_dialog.dart';
import 'package:mobile/components/template/nav_bottom.dart';
import 'package:mobile/components/template/nav_drawer.dart';
import 'package:mobile/models/customer_address_create_model.dart';
import 'package:mobile/models/customer_create_model.dart';
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
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
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
      addresses: [
        CustomerAddressCreateModel(
          zipCode: _zipCodeController.text,
          number: _numberController.text,
        )
      ],
    );

    CustomerService().create(customer).then((_) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      bottomNavigationBar: const NavBottom(),
      appBar: AppBar(
        title: const Text("Cadastrar aluno"),
        actions: [
          MenuItemButton(
            onPressed: onSave,
            child: const Text(
              "Salvar",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: isSaving
          ? const Padding(
              padding: EdgeInsets.all(50),
              child: Center(child: CircularProgressIndicator()),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Preencha o nome';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            border: const OutlineInputBorder(),
                            hintText: 'Nome',
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
                                        _nameController.text =
                                            (value['name'] as String);

                                        _phoneController.text =
                                            (value['phone'] as String);
                                      }
                                    },
                                  );
                                },
                                child: const Icon(Icons.contacts_sharp)),
                          ),
                          controller: _nameController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Preencha o telefone';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Telefone',
                          ),
                          controller: _phoneController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Preencha o CEP';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
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
                              )),
                          controller: _zipCodeController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Preencha o número';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Número',
                          ),
                          controller: _numberController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Complemento',
                          ),
                          controller: _complementController,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
