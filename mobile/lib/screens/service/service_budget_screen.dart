import 'package:flutter/material.dart';
import 'package:mobile/components/inputs/checkbox_group_list.dart';
import 'package:mobile/components/inputs/dropdown_form_input.dart';
import 'package:mobile/components/inputs/radio_group_list.dart';
import 'package:mobile/components/template/screen_layout.dart';
import 'package:mobile/models/customer/customer_model.dart';
import 'package:mobile/models/headquarter/headquarter_model.dart';
import 'package:mobile/models/scheduled/scheduled_create_calculate_amount_model.dart';
import 'package:mobile/models/service/service_model.dart';
import 'package:mobile/models/shared/address_model.dart';
import 'package:mobile/models/shared/amount_model.dart';
import 'package:mobile/screens/customer/components/customer_data.dart';
import 'package:mobile/screens/service/components/service_budget_list.dart';
import 'package:mobile/services/scheduled_service.dart';
import 'package:mobile/store/customer_store.dart';
import 'package:mobile/store/headquarter_store.dart';
import 'package:mobile/store/service_store.dart';
import 'package:mobile/store/user_store.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ServiceBudgetScreen extends StatefulWidget {
  const ServiceBudgetScreen({Key? key}) : super(key: key);

  @override
  State<ServiceBudgetScreen> createState() => _ServiceBudgetScreenState();
}

class _ServiceBudgetScreenState extends State<ServiceBudgetScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isLoadingAmount = false;
  CustomerModel? _selectedCustomer;
  AddressModel? _selectedCustomerAddress;
  final List<ServiceModel> _selectedServices = [];
  HeadquarterModel? _selectedHeadquarter;
  List<AmountModel>? _amounts;

  Future<void> fetchAmount() async {
    if (_selectedCustomer == null ||
        _selectedServices.isEmpty ||
        _selectedCustomerAddress == null ||
        _selectedHeadquarter == null) {
      return;
    }

    setState(() {
      isLoadingAmount = true;
    });

    List<AmountModel> prices =
        await ScheduledService(context).createCalculatePrice(
      ScheduledCreateCalculateAmountModel(
        customerId: _selectedCustomer!.id,
        services: _selectedServices.map((service) => service.id).toList(),
        customerAddressesIdStart: _selectedCustomerAddress!.id!,
        headquarterId: _selectedHeadquarter!.id,
      ),
    );

    setState(() {
      _amounts = prices;
      isLoadingAmount = false;
    });
  }

  void toShare() async {
    if (!_formKey.currentState!.validate() || _amounts == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos!'),
        ),
      );

      return;
    }

    String message = "Olá!\n\n"
        "Temos as seguintes opções e seus respectivos valores:\n";

    int count = 1;
    for (AmountModel amount in _amounts!) {
      message += "$count - ${amount.service!.name}: ${amount.getTotal()}\n";
      count++;
    }

    message += "\nQuaisquer dúvidas fico a disposição!";

    Share.share(message);
  }

  void fetchInitialData() async {
    Provider.of<ServiceStore>(context, listen: false).initialFetch(context);
    Provider.of<HeadquarterStore>(context, listen: false).initialFetch(context);
    Provider.of<UserStore>(context, listen: false).initialFetch(context);
  }

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final CustomerModel? customerFromArgs =
        ModalRoute.of(context)?.settings.arguments as CustomerModel?;

    if (customerFromArgs != null) {
      _selectedCustomer = Provider.of<CustomerStore>(context, listen: false)
          .items
          .firstWhere((i) => i.id == customerFromArgs.id);

      if (_selectedCustomer!.addresses.length == 1) {
        selectCustomerAddress(_selectedCustomer!.addresses.firstOrNull);
      }
    }
  }

  void selectCustomerAddress(AddressModel? address) {
    setState(() {
      _selectedCustomerAddress = address;
    });
    fetchAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orçamento"),
        actions: [
          MenuItemButton(
            onPressed: toShare,
            child: const Text(
              "Compartilhar",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: ScreenLayout(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Dados do cliente',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              CustomerData(
                customer: _selectedCustomer!,
              ),
              RadioGroupList<AddressModel>(
                setState: setState,
                items: _selectedCustomer!.addresses,
                label: 'Selecione o endereço do cliente',
                renderTitle: (item) => item.getFullAddress(),
                value: _selectedCustomerAddress,
                onChanged: (item) => selectCustomerAddress(item),
                labelToOnlyOneOption: 'Endereço',
              ),
              DropdownFormInput(
                value: _selectedHeadquarter,
                onChanged: (HeadquarterModel? headquarter) {
                  if (headquarter == null) {
                    return;
                  }

                  setState(() {
                    _selectedHeadquarter = headquarter;
                  });

                  fetchAmount();
                },
                items: Provider.of<HeadquarterStore>(context).items,
                renderLabel: (HeadquarterModel headquarter) => headquarter.name,
                isRequired: true,
                requiredMessage: 'Selecione a filial',
                labelText: 'Selecione a filial',
              ),
              CheckboxGroupList<ServiceModel>(
                items: Provider.of<ServiceStore>(context, listen: true).items,
                value: _selectedServices,
                onChanged: (List<ServiceModel> services) {
                  _amounts = [];

                  fetchAmount();
                },
                renderTitle: (service) => service.name,
                label: 'Selecione os serviços',
                labelToOnlyOneOption: 'Serviço',
              ),
              ServiceBudgetList(
                services: _selectedServices,
                amounts: _amounts,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
