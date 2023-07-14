import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:manager/components/inputs/checkbox_group_list.dart';
import 'package:manager/components/inputs/dropdown_form_input.dart';
import 'package:manager/components/inputs/text_form_input.dart';
import 'package:manager/components/template/screen_layout.dart';
import 'package:manager/components/template/screen_progress_indicator.dart';
import 'package:manager/models/enums/service_type.dart';
import 'package:manager/models/service/service_create_model.dart';
import 'package:manager/models/tax/tax_model.dart';
import 'package:manager/models/user/user_model.dart';
import 'package:manager/services/service_service.dart';
import 'package:manager/store/tax_store.dart';
import 'package:manager/store/user_store.dart';
import 'package:manager/utils/parse_utils.dart';
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
  List<UserModel> selectedUsers = [];
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

  @override
  void initState() {
    super.initState();

    Provider.of<UserStore>(context, listen: false).initialFetch(context);
    Provider.of<TaxStore>(context, listen: false).initialFetch(context);
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
                    renderLabel: (ServiceType type) => type.getLabel(),
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
                  CheckboxGroupList<UserModel>(
                    items: Provider.of<UserStore>(context, listen: true).items,
                    value: selectedUsers,
                    label: 'Selecione os profissionais',
                    labelToOnlyOneOption: 'Profissional',
                    renderTitle: (item) => item.name,
                  ),
                  CheckboxGroupList<TaxModel>(
                    items: Provider.of<TaxStore>(context, listen: true).items,
                    value: selectedTaxes,
                    label: 'Selecione as taxas',
                    labelToOnlyOneOption: 'Taxa',
                    renderTitle: (item) => item.label,
                  ),
                ],
              ),
            ),
    );
  }
}
