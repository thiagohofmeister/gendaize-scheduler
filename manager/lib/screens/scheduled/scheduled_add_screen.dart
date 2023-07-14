import 'package:flutter/material.dart';
import 'package:manager/components/inputs/date_picker_input.dart';
import 'package:manager/components/inputs/dropdown_form_input.dart';
import 'package:manager/components/inputs/radio_group_list.dart';
import 'package:manager/components/inputs/time_picker_input.dart';
import 'package:manager/components/template/data_label.dart';
import 'package:manager/components/template/screen_layout.dart';
import 'package:manager/components/template/screen_progress_indicator.dart';
import 'package:manager/models/customer/customer_model.dart';
import 'package:manager/models/headquarter/headquarter_model.dart';
import 'package:manager/models/scheduled/scheduled_create_calculate_amount_model.dart';
import 'package:manager/models/scheduled/scheduled_create_model.dart';
import 'package:manager/models/service/service_model.dart';
import 'package:manager/models/shared/address_model.dart';
import 'package:manager/models/shared/amount_model.dart';
import 'package:manager/models/user/user_model.dart';
import 'package:manager/screens/customer/components/customer_data.dart';
import 'package:manager/services/scheduled_service.dart';
import 'package:manager/store/customer_store.dart';
import 'package:manager/store/headquarter_store.dart';
import 'package:manager/store/service_store.dart';
import 'package:manager/store/user_store.dart';
import 'package:provider/provider.dart';

class ScheduledAddScreen extends StatefulWidget {
  const ScheduledAddScreen({Key? key}) : super(key: key);

  @override
  State<ScheduledAddScreen> createState() => _ScheduledAddScreenState();
}

class _ScheduledAddScreenState extends State<ScheduledAddScreen> {
  final _formKey = GlobalKey<FormState>();

  UserModel? _selectedUser;
  CustomerModel? _selectedCustomer;
  AddressModel? _selectedCustomerAddress;
  ServiceModel? _selectedService;
  HeadquarterModel? _selectedHeadquarter;
  DateTime _selectedDateTime = DateTime.now();
  AmountModel? _price;
  bool isSaving = false;

  Future<void> fetchAmount() async {
    if (_selectedCustomer == null ||
        _selectedService == null ||
        _selectedCustomerAddress == null ||
        _selectedHeadquarter == null ||
        _selectedUser == null) {
      return;
    }

    List<AmountModel> prices =
        await ScheduledService(context).createCalculatePrice(
      ScheduledCreateCalculateAmountModel(
        customerId: _selectedCustomer!.id,
        services: [_selectedService!.id],
        customerAddressesIdStart: _selectedCustomerAddress!.id!,
        headquarterId: _selectedHeadquarter!.id,
      ),
    );

    setState(() {
      _price = prices.first;
    });
  }

  void toSchedule() {
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

    ScheduledCreateModel scheduledCreate = ScheduledCreateModel(
      customerId: _selectedCustomer!.id,
      serviceId: _selectedService!.id,
      customerAddressesIdStart: _selectedCustomerAddress!.id!,
      headquarterId: _selectedHeadquarter!.id,
      startAt: _selectedDateTime,
      userId: _selectedUser!.id,
    );

    ScheduledService(context).create(scheduledCreate).then((_) {
      Navigator.pop(
        context,
        'scheduled-list',
      );
    });

    setState(() {
      isSaving = false;
    });
  }

  void fetchServices() async {
    ServiceStore store = Provider.of<ServiceStore>(context, listen: false);
    await store.initialFetch(context);

    if (store.items.length == 1) {
      setState(() {
        _selectedService = store.items.firstOrNull;
      });
    }
  }

  void fetchHeadquarters() async {
    HeadquarterStore store =
        Provider.of<HeadquarterStore>(context, listen: false);

    await store.initialFetch(context);

    if (store.items.length == 1) {
      setState(() {
        _selectedHeadquarter = store.items.firstOrNull;
      });
    }
  }

  void fetchUsers() async {
    UserStore store = Provider.of<UserStore>(context, listen: false);

    await store.initialFetch(context);

    if (store.items.length == 1) {
      setState(() {
        _selectedUser = store.items.firstOrNull;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchServices();
    fetchHeadquarters();
    fetchUsers();
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
        selectCustomerAddress(
          _selectedCustomer!.addresses.firstOrNull,
        );
      }
    }
  }

  void selectCustomerAddress(AddressModel? address) {
    setState(() {
      _selectedCustomerAddress = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agendamento"),
        actions: [
          MenuItemButton(
            onPressed: toSchedule,
            child: const Text(
              "Concluir",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: isSaving ||
              Provider.of<CustomerStore>(context, listen: true).isLoading
          ? const ScreenProgressIndicator()
          : Form(
              key: _formKey,
              child: ScreenLayout(
                children: [
                  CustomerData(customer: _selectedCustomer!),
                  RadioGroupList(
                    setState: setState,
                    items: _selectedCustomer!.addresses,
                    label: 'Selecione o endereço do cliente',
                    labelToOnlyOneOption: 'Endereço do cliente',
                    renderTitle: (item) => item.getFullAddress(),
                    value: _selectedCustomerAddress,
                    onChanged: (AddressModel? address) {
                      selectCustomerAddress(address);
                    },
                  ),
                  DropdownFormInput(
                    value: _selectedUser,
                    onChanged: (UserModel? user) {
                      if (user == null) {
                        return;
                      }

                      setState(() {
                        _selectedUser = user;
                      });
                    },
                    items: Provider.of<UserStore>(context).items,
                    renderLabel: (UserModel? user) => user!.name,
                    isRequired: true,
                    requiredMessage: 'Selecione o profissional',
                    labelText: 'Profissional',
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
                    },
                    items: Provider.of<HeadquarterStore>(context).items,
                    renderLabel: (HeadquarterModel headquarter) =>
                        headquarter.name,
                    isRequired: true,
                    requiredMessage: 'Selecione a filial',
                    labelText: 'Filial',
                  ),
                  DropdownFormInput(
                    value: _selectedService,
                    onChanged: (ServiceModel? value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedService = value;
                        fetchAmount();
                      });
                    },
                    items: Provider.of<ServiceStore>(context).items,
                    renderLabel: (ServiceModel service) => service.name,
                    isRequired: true,
                    requiredMessage: 'Selecione o serviço',
                    labelText: 'Serviço',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: DatePickerInput(
                      label: 'Data da aula',
                      date: _selectedDateTime,
                      onChange: (DateTime date) {
                        setState(() {
                          _selectedDateTime = date;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TimePickerInput(
                      label: 'Hora da aula',
                      date: _selectedDateTime,
                      onChange: (DateTime date) {
                        setState(() {
                          _selectedDateTime = date;
                        });
                      },
                    ),
                  ),
                  _selectedService != null && _price != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'Informações do agendamento',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: DataLabel(
                                label: 'Duração',
                                info: _selectedService!.getDuration(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: DataLabel(
                                label: 'Valor aula',
                                info: _selectedService!.getAmount(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: DataLabel(
                                label: 'Taxa de deslocamento',
                                info: _price!.taxes > 0
                                    ? _price!.getTaxes()
                                    : 'Grátis',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: DataLabel(
                                label: 'Total',
                                info: _price!.getTotal(),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
    );
  }
}
