import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:mobile/components/dialogs/search_zipcode_dialog.dart';
import 'package:mobile/components/inputs/text_form_input.dart';
import 'package:mobile/components/template/screen_layout.dart';
import 'package:mobile/models/customer/customer_address_create_model.dart';
import 'package:mobile/models/customer/customer_model.dart';
import 'package:mobile/services/customer_service.dart';
import 'package:mobile/store/customer_store.dart';
import 'package:provider/provider.dart';

class CustomerAddressAddScreen extends StatefulWidget {
  const CustomerAddressAddScreen({Key? key}) : super(key: key);

  @override
  State<CustomerAddressAddScreen> createState() =>
      _CustomerAddressAddScreenState();
}

class _CustomerAddressAddScreenState extends State<CustomerAddressAddScreen> {
  CustomerModel? customer;
  bool isSaving = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

    CustomerAddressCreateModel customerAddress = CustomerAddressCreateModel(
      zipCode: _zipCodeController.text,
      number: _numberController.text,
      complement: _complementController.text,
    );

    CustomerService(context)
        .createAddress(customer!.id, customerAddress)
        .then((_) {
      Navigator.pop(context, true);
    });

    setState(() {
      isSaving = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final CustomerModel? customerFromArgs =
        ModalRoute.of(context)?.settings.arguments as CustomerModel?;

    if (customerFromArgs != null) {
      customer = Provider.of<CustomerStore>(context, listen: false)
          .items
          .firstWhere((i) => i.id == customerFromArgs.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar endereço'),
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
      body: Form(
        key: _formKey,
        child: ScreenLayout(
          isLoading: isSaving,
          children: [
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
              hintText: 'Número',
              controller: _numberController,
              isRequired: true,
              requiredMessage: 'Preencha o número',
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
