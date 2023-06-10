import 'package:flutter/material.dart';
import 'package:mobile/components/customer_data.dart';
import 'package:mobile/components/inputs/date_picker_input.dart';
import 'package:mobile/components/inputs/time_picker_input.dart';
import 'package:mobile/components/template/data_label.dart';
import 'package:mobile/components/template/nav_drawer.dart';
import 'package:mobile/models/address_model.dart';
import 'package:mobile/models/amount_model.dart';
import 'package:mobile/models/customer_model.dart';
import 'package:mobile/models/headquarter_model.dart';
import 'package:mobile/models/scheduled_create_calculate_amount_model.dart';
import 'package:mobile/models/scheduled_create_model.dart';
import 'package:mobile/models/service_model.dart';
import 'package:mobile/models/user_model.dart';
import 'package:mobile/services/scheduled_service.dart';
import 'package:mobile/store/customer_store.dart';
import 'package:mobile/store/service_store.dart';
import 'package:provider/provider.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
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
    AmountModel price = await ScheduledService().createCalculatePrice(
      ScheduledCreateCalculateAmountModel(
        customerId: _selectedCustomer!.id,
        serviceId: _selectedService!.id,
        customerAddressesIdStart: _selectedCustomerAddress!.id!,
        headquarterId: _selectedHeadquarter!.id,
      ),
    );

    setState(() {
      _price = price;
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

    // ScheduledService().create(scheduleCreate: scheduleCreate).then((_) {
    //   Navigator.pushReplacementNamed(context, 'calendar');
    // });
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ServiceStore>(context, listen: false).initialFetch();
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
    }
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
              "Agendar",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      drawer: const NavDrawer(),
      body: SingleChildScrollView(
        child: isSaving ||
                Provider.of<CustomerStore>(context, listen: true).isLoading
            ? const Padding(
                padding: EdgeInsets.all(50),
                child: Center(child: CircularProgressIndicator()),
              )
            : Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<CustomerStore>(
                        builder: (context, store, child) {
                          return DropdownButtonFormField(
                            value: _selectedCustomer,
                            validator: (value) {
                              if (value == null) {
                                return 'Selecione o cliente';
                              }

                              return null;
                            },
                            onChanged: (CustomerModel? customer) {
                              if (customer == null) {
                                return;
                              }

                              setState(() {
                                _selectedCustomer = customer;
                              });
                            },
                            items: store.items.map((CustomerModel customer) {
                              return DropdownMenuItem<CustomerModel>(
                                value: customer,
                                child: Text(customer.name),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              labelText: "Selecione o cliente",
                              border: OutlineInputBorder(),
                            ),
                          );
                        },
                      ),
                      _selectedCustomer != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: CustomerData(
                                customer: _selectedCustomer!,
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Consumer<ServiceStore>(
                            builder: (context, store, child) {
                          return DropdownButtonFormField(
                            value: _selectedService,
                            validator: (value) {
                              if (value == null) {
                                return 'Selecione o serviço';
                              }

                              return null;
                            },
                            onChanged: (ServiceModel? value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                _selectedService = value;
                                // fetchAmount();
                              });
                            },
                            items: store.items
                                .map(
                                  (option) => DropdownMenuItem(
                                    value: option,
                                    child: Text(option.name),
                                  ),
                                )
                                .toList(),
                            decoration: const InputDecoration(
                              labelText: "Escolha o serviço",
                              border: OutlineInputBorder(),
                            ),
                          );
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
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
                        padding: const EdgeInsets.only(bottom: 16),
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
              ),
      ),
    );
  }
}
