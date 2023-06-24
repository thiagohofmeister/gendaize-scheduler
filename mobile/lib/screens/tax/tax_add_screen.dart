import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:mobile/components/inputs/dropdown_form_input.dart';
import 'package:mobile/components/inputs/text_form_input.dart';
import 'package:mobile/components/template/screen_layout.dart';
import 'package:mobile/components/template/screen_progress_indicator.dart';
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
          ? const ScreenProgressIndicator()
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: ScreenLayout(
                  children: [
                    TextFormInput(
                      isDense: true,
                      hintText: 'Nome',
                      controller: labelController,
                      isRequired: true,
                      requiredMessage: 'Preencha o nome',
                    ),
                    DropdownFormInput(
                      value: taxTypeSelected,
                      isRequired: true,
                      requiredMessage: 'Selecione o tipo de taxa',
                      onChanged: (TaxType? taxType) {
                        setState(() {
                          taxTypeSelected = taxType;
                        });
                      },
                      items: TaxType.values,
                      renderLabel: (TaxType taxType) => taxType.getLabel(),
                      labelText: "Tipo de taxa",
                    ),
                    DropdownFormInput(
                      value: taxValueTypeSelected,
                      onChanged: (TaxValueType? taxValueType) {
                        setState(() {
                          taxValueTypeSelected = taxValueType;
                        });
                      },
                      isRequired: true,
                      requiredMessage: 'Selecione o tipo do valor da taxa',
                      items: TaxValueType.values,
                      renderLabel: (TaxValueType valueType) =>
                          valueType.getLabel(),
                      labelText: "Tipo do valor da taxa",
                    ),
                    TextFormInput(
                      isDense: true,
                      hintText: 'Valor',
                      isRequired: true,
                      requiredMessage: 'Preencha o valor',
                      controller: taxValueTypeSelected == TaxValueType.percent
                          ? valueController
                          : priceController,
                    ),
                    taxValueTypeSelected == TaxValueType.distance
                        ? TextFormInput(
                            isDense: true,
                            hintText: 'A cada X metros',
                            isRequired: true,
                            requiredMessage: 'Preencha os metros',
                            controller: valueDetailsController,
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
    );
  }
}
