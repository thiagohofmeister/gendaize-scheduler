import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:mobile/models/enums/service_type.dart';
import 'package:mobile/models/service/service_create_model.dart';
import 'package:mobile/models/tax/tax_model.dart';
import 'package:mobile/models/user/user_model.dart';
import 'package:mobile/services/service_service.dart';
import 'package:mobile/store/tax_store.dart';
import 'package:mobile/store/user_store.dart';
import 'package:mobile/utils/parse_utils.dart';
import 'package:provider/provider.dart';

class ServiceAddScreen extends StatefulWidget {
  const ServiceAddScreen({Key? key}) : super(key: key);

  @override
  State<ServiceAddScreen> createState() => _ServiceAddScreenState();
}

class _ServiceAddScreenState extends State<ServiceAddScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isSaving = false;

  ServiceType? serviceTypeSelected;
  final List<UserModel> selectedUsers = [];
  final List<TaxModel> selectedTaxes = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = MoneyMaskedTextController(
    decimalSeparator: ',',
    precision: 2,
    leftSymbol: 'R\$ ',
  );
  final TextEditingController sameTimeQuantityController =
      TextEditingController();
  final TextEditingController durationController = TextEditingController();

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

    ServiceCreateModel data = ServiceCreateModel(
      name: nameController.text,
      duration: int.parse(durationController.text),
      price: ParseUtils.fromMoneyToDouble(priceController.text),
      sameTimeQuantity: int.parse(sameTimeQuantityController.text),
      type: serviceTypeSelected!,
      users: selectedUsers,
      taxes: selectedTaxes,
    );

    ServiceService().create(data).then((_) {
      Navigator.pop(context, true);
    });

    setState(() {
      isSaving = false;
    });
  }

  Future<void> fetchUsers() async {
    UserStore userStore = Provider.of<UserStore>(context, listen: false);
    await userStore.initialFetch();

    if (userStore.total == 1) {
      selectedUsers.add(userStore.items.first);
    }
  }

  Future<void> fetchTaxes() async {
    TaxStore taxStore = Provider.of<TaxStore>(context, listen: false);
    await taxStore.initialFetch();

    if (taxStore.total == 1) {
      selectedTaxes.add(taxStore.items.first);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
    fetchTaxes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar serviço"),
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
          ? const Padding(
              padding: EdgeInsets.all(50),
              child: Center(child: CircularProgressIndicator()),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(30),
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
                          decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            hintText: 'Nome',
                          ),
                          controller: nameController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: DropdownButtonFormField(
                          value: serviceTypeSelected,
                          validator: (value) {
                            if (value == null) {
                              return 'Selecione a forma de atendimento';
                            }

                            return null;
                          },
                          onChanged: (ServiceType? type) {
                            setState(() {
                              serviceTypeSelected = type;
                            });
                          },
                          items: ServiceType.values.map((ServiceType type) {
                            return DropdownMenuItem<ServiceType>(
                              value: type,
                              child: Text(
                                type.getLabel(),
                              ),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            labelText: "Forma de atendimento",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Preencha o preço';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            hintText: 'Preço',
                          ),
                          controller: priceController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Preencha a duração';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            hintText: 'Duração',
                          ),
                          controller: durationController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Preencha a quantidade simultânea';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            hintText: 'Quantidade simultânea',
                          ),
                          controller: sameTimeQuantityController,
                        ),
                      ),
                      Provider.of<UserStore>(context, listen: true).total > 1
                          ? Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Selecione os profissionais'),
                                  ...Provider.of<UserStore>(
                                    context,
                                    listen: true,
                                  ).items.map((user) {
                                    return ListTile(
                                      title: Text(user.name),
                                      trailing: Checkbox(
                                        value: selectedUsers.contains(user),
                                        onChanged: (bool? value) {
                                          setState(() {
                                            if (value == true) {
                                              selectedUsers.add(user);
                                            } else {
                                              selectedUsers.remove(user);
                                            }
                                          });
                                        },
                                      ),
                                    );
                                  })
                                ],
                              ),
                            )
                          : Container(),
                      Provider.of<TaxStore>(context, listen: true).total > 0
                          ? Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Selecione as taxas'),
                                  ...Provider.of<TaxStore>(
                                    context,
                                    listen: true,
                                  ).items.map((tax) {
                                    return ListTile(
                                      title: Text(tax.label),
                                      trailing: Checkbox(
                                        value: selectedTaxes.contains(tax),
                                        onChanged: (bool? value) {
                                          setState(() {
                                            if (value == true) {
                                              selectedTaxes.add(tax);
                                            } else {
                                              selectedTaxes.remove(tax);
                                            }
                                          });
                                        },
                                      ),
                                    );
                                  })
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
