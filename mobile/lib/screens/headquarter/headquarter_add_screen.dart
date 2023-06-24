import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:mobile/components/inputs/dropdown_form_input.dart';
import 'package:mobile/components/inputs/text_form_input.dart';
import 'package:mobile/components/template/screen_layout.dart';
import 'package:mobile/components/template/screen_progress_indicator.dart';
import 'package:mobile/models/headquarter/headquarter_create_model.dart';
import 'package:mobile/models/shared/address_model.dart';
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

    await provider.initialFetch(context);

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

    HeadquarterService(context).create(data).then((_) {
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
          ? const ScreenProgressIndicator()
          : Form(
              key: _formKey,
              child: ScreenLayout(
                children: [
                  TextFormInput(
                    isRequired: true,
                    requiredMessage: 'Preencha o nome',
                    isDense: true,
                    hintText: 'Nome',
                    controller: nameController,
                  ),
                  TextFormInput(
                    isRequired: true,
                    requiredMessage: 'Preencha o CEP',
                    isDense: true,
                    hintText: 'CEP',
                    controller: addressZipCodeController,
                  ),
                  DropdownFormInput<String>(
                    isRequired: true,
                    requiredMessage: 'Preencha o UF',
                    value: stateSelected,
                    onChanged: (String? state) {
                      setState(() {
                        stateSelected = state;
                      });
                    },
                    items: locationStore.states,
                    labelText: 'UF',
                    labelToOnlyOneOption: 'UF',
                    renderLabel: (String item) => item,
                  ),
                  DropdownFormInput<String>(
                    isRequired: true,
                    requiredMessage: 'Preencha a cidade',
                    value: citySelected,
                    onChanged: (String? state) {
                      setState(() {
                        citySelected = state;
                      });
                    },
                    items: stateSelected != null
                        ? locationStore.getCities(stateSelected!)
                        : null,
                    labelText: 'Cidade',
                    labelToOnlyOneOption: 'Cidade',
                    renderLabel: (String item) => item,
                  ),
                  TextFormInput(
                    isRequired: true,
                    requiredMessage: 'Preencha o bairro',
                    isDense: true,
                    hintText: 'Bairro',
                    controller: addressDistrictController,
                  ),
                  TextFormInput(
                    isRequired: true,
                    requiredMessage: 'Preencha a rua',
                    isDense: true,
                    hintText: 'Rua',
                    controller: addressStreetController,
                  ),
                  TextFormInput(
                    isRequired: true,
                    requiredMessage: 'Preencha o número',
                    hintText: 'Número',
                    controller: addressNumberController,
                  ),
                  TextFormInput(
                    hintText: 'Complemento',
                    controller: addressComplementController,
                  ),
                ],
              ),
            ),
    );
  }
}
