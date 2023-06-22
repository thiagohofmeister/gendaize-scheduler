import 'package:flutter/material.dart';
import 'package:mobile/components/inputs/date_picker_input.dart';
import 'package:mobile/components/inputs/time_picker_input.dart';
import 'package:mobile/components/template/data_label.dart';
import 'package:mobile/components/template/dropdown_form_input/dropdown_form_input.dart';
import 'package:mobile/components/template/screen_layout.dart';
import 'package:mobile/components/template/screen_progress_indicator.dart';
import 'package:mobile/models/customer/customer_model.dart';
import 'package:mobile/models/headquarter/headquarter_model.dart';
import 'package:mobile/models/scheduled/scheduled_create_calculate_amount_model.dart';
import 'package:mobile/models/scheduled/scheduled_create_model.dart';
import 'package:mobile/models/service/service_model.dart';
import 'package:mobile/models/shared/address_model.dart';
import 'package:mobile/models/shared/amount_model.dart';
import 'package:mobile/models/user/user_model.dart';
import 'package:mobile/services/scheduled_service.dart';
import 'package:mobile/store/customer_store.dart';
import 'package:mobile/store/headquarter_store.dart';
import 'package:mobile/store/service_store.dart';
import 'package:mobile/store/user_store.dart';
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
        selectCustomerAddress(
          _selectedCustomer!.addresses.firstOrNull,
        );
      }
    }
  }

  void selectCustomerAddress(AddressModel? address) {
    _selectedCustomerAddress = address;
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
                  Consumer<CustomerStore>(
                    builder: (context, store, child) {
                      return DropdownFormInput(
                        value: _selectedCustomer,
                        onChanged: (CustomerModel? customer) {
                          if (customer == null) {
                            return;
                          }

                          setState(() {
                            _selectedCustomer = customer;

                            if (customer.addresses.length == 1) {
                              selectCustomerAddress(
                                customer.addresses.firstOrNull,
                              );
                            }
                          });
                        },
                        items: store.items,
                        renderLabel: (CustomerModel? customer) =>
                            Text(customer!.name),
                        labelText: 'Selecione o cliente',
                        isRequired: true,
                        requiredMessage: 'Selecione o cliente',
                      );
                    },
                  ),
                  _selectedCustomer != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Selecione o endereço do cliente'),
                              ..._selectedCustomer!.addresses.map((address) {
                                return RadioListTile<AddressModel>(
                                  title: Text(address.getFullAddress()),
                                  value: address,
                                  groupValue: _selectedCustomerAddress,
                                  onChanged: (AddressModel? address) {
                                    setState(() {
                                      selectCustomerAddress(address);
                                    });
                                  },
                                );
                              })
                            ],
                          ),
                        )
                      : Container(),
                  Consumer<UserStore>(
                    builder: (context, store, child) {
                      if (store.total == 1) {
                        _selectedUser = store.items.first;
                        return Container();
                      }

                      return DropdownFormInput(
                        value: _selectedUser,
                        onChanged: (UserModel? user) {
                          if (user == null) {
                            return;
                          }

                          setState(() {
                            _selectedUser = user;
                          });
                        },
                        items: store.items,
                        renderLabel: (UserModel? user) => Text(user!.name),
                        isRequired: true,
                        requiredMessage: 'Selecione o profissional',
                        labelText: 'Selecione o profissional',
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Consumer<HeadquarterStore>(
                      builder: (context, store, child) {
                        if (store.total == 1) {
                          _selectedHeadquarter = store.items.first;
                          return Container();
                        }

                        return DropdownFormInput(
                          value: _selectedHeadquarter,
                          onChanged: (HeadquarterModel? headquarter) {
                            if (headquarter == null) {
                              return;
                            }

                            setState(() {
                              _selectedHeadquarter = headquarter;
                            });
                          },
                          items: store.items,
                          renderLabel: (HeadquarterModel? headquarter) =>
                              Text(headquarter!.name),
                          isRequired: true,
                          requiredMessage: 'Selecione a filial',
                          labelText: 'Selecione a filial',
                        );
                      },
                    ),
                  ),
                  Consumer<ServiceStore>(builder: (context, store, child) {
                    return DropdownFormInput(
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
                      items: store.items,
                      renderLabel: (ServiceModel? service) =>
                          Text(service!.name),
                      isRequired: true,
                      requiredMessage: 'Selecione o serviço',
                      labelText: 'Escolha o serviço',
                    );
                  }),
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
