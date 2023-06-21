import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:mobile/models/enums/tax_type.dart';
import 'package:mobile/models/enums/tax_value_type.dart';
import 'package:mobile/models/tax/tax_create_model.dart';
import 'package:mobile/services/tax_service.dart';

class TaxAddScreen extends StatefulWidget {
  const TaxAddScreen({Key? key}) : super(key: key);

  @override
  State<TaxAddScreen> createState() => _TaxAddScreenState();
}

class _TaxAddScreenState extends State<TaxAddScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isSaving = false;

  TaxType? taxTypeSelected;
  TaxValueType? taxValueTypeSelected;

  final TextEditingController labelController = TextEditingController();
  final TextEditingController valueController = MoneyMaskedTextController(
    decimalSeparator: '.',
    precision: 2,
    rightSymbol: '%',
  );

  final TextEditingController priceController = MoneyMaskedTextController(
    decimalSeparator: ',',
    precision: 2,
    leftSymbol: 'R\$ ',
  );
  final TextEditingController valueDetailsController = TextEditingController();

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

    TaxCreateModel data = TaxCreateModel(
      label: labelController.text,
      value: taxValueTypeSelected == TaxValueType.percent
          ? valueController.text
          : priceController.text,
      valueType: taxValueTypeSelected!,
      type: taxTypeSelected!,
      valueDetails: valueDetailsController.text,
    );

    TaxService(context).create(data).then((_) {
      Navigator.pop(context, true);
    });

    setState(() {
      isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar taxa"),
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
                          controller: labelController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: DropdownButtonFormField(
                          value: taxTypeSelected,
                          validator: (value) {
                            if (value == null) {
                              return 'Selecione o tipo de taxa';
                            }

                            return null;
                          },
                          onChanged: (TaxType? taxType) {
                            setState(() {
                              taxTypeSelected = taxType;
                            });
                          },
                          items: TaxType.values.map((TaxType taxType) {
                            return DropdownMenuItem<TaxType>(
                              value: taxType,
                              child: Text(
                                taxType.getLabel(),
                              ),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            labelText: "Tipo de taxa",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: DropdownButtonFormField(
                          value: taxValueTypeSelected,
                          validator: (value) {
                            if (value == null) {
                              return 'Selecione o tipo do valor da taxa';
                            }

                            return null;
                          },
                          onChanged: (TaxValueType? taxValueType) {
                            setState(() {
                              taxValueTypeSelected = taxValueType;
                            });
                          },
                          items: TaxValueType.values
                              .map((TaxValueType taxValueType) {
                            return DropdownMenuItem<TaxValueType>(
                              value: taxValueType,
                              child: Text(
                                taxValueType.getLabel(),
                              ),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            labelText: "Tipo do valor da taxa",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Preencha o valor';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            hintText: 'Valor',
                          ),
                          controller:
                              taxValueTypeSelected == TaxValueType.percent
                                  ? valueController
                                  : priceController,
                        ),
                      ),
                      taxValueTypeSelected == TaxValueType.distance
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value != null && value.isEmpty) {
                                    return 'Preencha os metros';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  hintText: 'A cada X metros',
                                ),
                                controller: valueDetailsController,
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
