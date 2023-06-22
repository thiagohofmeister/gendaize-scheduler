import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:mobile/components/template/dropdown_form_input/dropdown_form_input.dart';
import 'package:mobile/components/template/screen_layout.dart';
import 'package:mobile/components/template/screen_progress_indicator.dart';
import 'package:mobile/components/template/text_form_input.dart';
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

    ServiceService(context).create(data).then((_) {
      Navigator.pop(context, true);
    });

    setState(() {
      isSaving = false;
    });
  }

  Future<void> fetchUsers() async {
    UserStore userStore = Provider.of<UserStore>(context, listen: false);
    await userStore.initialFetch(context);

    if (userStore.total == 1) {
      selectedUsers.add(userStore.items.first);
    }
  }

  Future<void> fetchTaxes() async {
    TaxStore taxStore = Provider.of<TaxStore>(context, listen: false);
    await taxStore.initialFetch(context);

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
          ? const ScreenProgressIndicator()
          : Form(
              key: _formKey,
              child: ScreenLayout(
                children: [
                  TextFormInput(
                    hintText: 'Nome',
                    controller: nameController,
                    isRequired: true,
                    requiredMessage: 'Preencha o nome',
                  ),
                  DropdownFormInput(
                    value: serviceTypeSelected,
                    isRequired: true,
                    requiredMessage: 'Selecione a forma de atendimento',
                    labelText: 'Selecione a forma de atendimento',
                    onChanged: (ServiceType? type) {
                      setState(() {
                        serviceTypeSelected = type;
                      });
                    },
                    items: ServiceType.values,
                    renderLabel: (ServiceType? type) => Text(
                      type!.getLabel(),
                    ),
                  ),
                  TextFormInput(
                    isDense: true,
                    hintText: 'Preço',
                    isRequired: true,
                    requiredMessage: 'Preencha o preço',
                    controller: priceController,
                  ),
                  TextFormInput(
                    isDense: true,
                    hintText: 'Duração',
                    isRequired: true,
                    requiredMessage: 'Preencha a duração',
                    controller: durationController,
                  ),
                  TextFormInput(
                    isDense: true,
                    hintText: 'Quantidade simultânea',
                    controller: sameTimeQuantityController,
                    isRequired: true,
                    requiredMessage: 'Preencha a quantidade simultânea',
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
    );
  }
}
