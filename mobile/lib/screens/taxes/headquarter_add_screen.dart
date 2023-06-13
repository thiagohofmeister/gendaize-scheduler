import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:mobile/models/shared/address_model.dart';
import 'package:mobile/models/headquarter/headquarter_create_model.dart';
import 'package:mobile/services/headquarter_service.dart';
import 'package:mobile/store/location_store.dart';
import 'package:provider/provider.dart';

class HeadquarterAddScreen extends StatefulWidget {
  const HeadquarterAddScreen({Key? key}) : super(key: key);

  @override
  State<HeadquarterAddScreen> createState() => _HeadquarterAddScreenState();
}

class _HeadquarterAddScreenState extends State<HeadquarterAddScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isSaving = false;

  String? stateSelected;
  String? citySelected;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressZipCodeController =
      MaskedTextController(mask: '00000-000');
  final TextEditingController addressCityController = TextEditingController();
  final TextEditingController addressDistrictController =
      TextEditingController();
  final TextEditingController addressStreetController = TextEditingController();
  final TextEditingController addressNumberController = TextEditingController();
  final TextEditingController addressComplementController =
      TextEditingController();

  Future<void> getStates() async {
    LocationStore provider = Provider.of<LocationStore>(context, listen: false);

    await provider.initialFetch();

    setState(() {
      if (provider.states.length == 1) {
        stateSelected = provider.states.firstOrNull;
      }
    });
  }

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

    HeadquarterCreateModel data = HeadquarterCreateModel(
      name: nameController.text,
      address: AddressModel(
        zipCode: addressZipCodeController.text,
        state: stateSelected!,
        city: citySelected!,
        district: addressDistrictController.text,
        street: addressStreetController.text,
        number: addressNumberController.text,
      ),
    );

    HeadquarterService().create(data).then((_) {
      Navigator.pop(context, true);
    });

    setState(() {
      isSaving = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getStates();
  }

  @override
  Widget build(BuildContext context) {
    LocationStore locationStore = Provider.of<LocationStore>(context);

    print(locationStore.states);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar filial"),
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
                        child: TextFormField(
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Preencha o CEP';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            hintText: 'CEP',
                          ),
                          controller: addressZipCodeController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: DropdownButtonFormField(
                          value: stateSelected,
                          validator: (value) {
                            if (value == null) {
                              return 'Selecione o estado';
                            }

                            return null;
                          },
                          onChanged: (String? state) {
                            setState(() {
                              stateSelected = state;
                            });
                          },
                          items: locationStore.states.map((String state) {
                            return DropdownMenuItem<String>(
                                value: state,
                                child: Text(
                                  state,
                                  overflow: TextOverflow.ellipsis,
                                ));
                          }).toList(),
                          decoration: const InputDecoration(
                            labelText: "UF",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: DropdownButtonFormField(
                          value: citySelected,
                          validator: (value) {
                            if (value == null) {
                              return 'Selecione a cidade';
                            }

                            return null;
                          },
                          onChanged: (String? state) {
                            setState(() {
                              citySelected = state;
                            });
                          },
                          items: stateSelected != null
                              ? locationStore
                                  .getCities(stateSelected!)
                                  .map((String city) {
                                  return DropdownMenuItem<String>(
                                      value: city,
                                      child: Text(
                                        city,
                                        overflow: TextOverflow.ellipsis,
                                      ));
                                }).toList()
                              : null,
                          decoration: const InputDecoration(
                            labelText: "Cidade",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Preencha o bairro';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            hintText: 'Bairro',
                          ),
                          controller: addressDistrictController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Preencha a rua';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            hintText: 'Rua',
                          ),
                          controller: addressStreetController,
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
                          controller: addressNumberController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Complemento',
                          ),
                          controller: addressComplementController,
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
