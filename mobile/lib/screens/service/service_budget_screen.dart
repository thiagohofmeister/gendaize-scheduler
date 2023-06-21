import 'package:flutter/material.dart';
import 'package:mobile/components/template/data_label.dart';
import 'package:mobile/models/customer/customer_model.dart';
import 'package:mobile/models/headquarter/headquarter_model.dart';
import 'package:mobile/models/scheduled/scheduled_create_calculate_amount_model.dart';
import 'package:mobile/models/service/service_model.dart';
import 'package:mobile/models/shared/address_model.dart';
import 'package:mobile/models/shared/amount_model.dart';
import 'package:mobile/models/user/user_model.dart';
import 'package:mobile/services/scheduled_service.dart';
import 'package:mobile/store/customer_store.dart';
import 'package:mobile/store/headquarter_store.dart';
import 'package:mobile/store/service_store.dart';
import 'package:mobile/store/user_logged_store.dart';
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
  bool isSaving = false;

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

  void toSchedule() async {
    setState(() {
      isSaving = true;
    });

    if (!_formKey.currentState!.validate() || _amounts == null) {
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

    UserModel user = Provider.of<UserLoggedStore>(context, listen: false).user!;

    String message = "Olá!\n\n"
        "Temos as seguintes opções e seus respectivos valores:\n";

    int count = 1;
    for (AmountModel amount in _amounts!) {
      message += "$count - ${amount.service!.name}: ${amount.getTotal()}\n";
      count++;
    }

    message += "\nQuaisquer dúvidas fico a disposição!\n\n"
        "Atenciosamente,\n${user.name}";

    Share.share(message);

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
        selectCustomerAddress(_selectedCustomer!.addresses.firstOrNull);
      }
    }
  }

  void selectCustomerAddress(AddressModel? index) {
    _selectedCustomerAddress = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orçamento"),
        actions: [
          MenuItemButton(
            onPressed: toSchedule,
            child: const Text(
              "Copiar",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
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

                                if (customer.addresses.length == 1) {
                                  selectCustomerAddress(null);
                                }
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
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Selecione o endereço do cliente'),
                                  ..._selectedCustomer!.addresses
                                      .map((address) {
                                    return RadioListTile<AddressModel>(
                                      title: Text(address.getFullAddress()),
                                      value: address,
                                      groupValue: _selectedCustomerAddress,
                                      onChanged: (AddressModel? index) {
                                        setState(() {
                                          selectCustomerAddress(index);
                                        });
                                      },
                                    );
                                  })
                                ],
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Consumer<HeadquarterStore>(
                          builder: (context, store, child) {
                            if (store.total == 1) {
                              _selectedHeadquarter = store.items.first;
                              return Container();
                            }

                            return DropdownButtonFormField(
                              value: _selectedHeadquarter,
                              validator: (value) {
                                if (value == null) {
                                  return 'Selecione a filial';
                                }

                                return null;
                              },
                              onChanged: (HeadquarterModel? headquarter) {
                                if (headquarter == null) {
                                  return;
                                }

                                setState(() {
                                  _amounts = [];
                                  _selectedHeadquarter = headquarter;
                                  fetchAmount();
                                });
                              },
                              items: store.items
                                  .map((HeadquarterModel headquarter) {
                                return DropdownMenuItem<HeadquarterModel>(
                                  value: headquarter,
                                  child: Text(headquarter.name),
                                );
                              }).toList(),
                              decoration: const InputDecoration(
                                labelText: "Selecione a filial",
                                border: OutlineInputBorder(),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Selecione os serviços'),
                            ...Provider.of<ServiceStore>(context, listen: true)
                                .items
                                .map((service) {
                              return ListTile(
                                title: Text(service.name),
                                trailing: Checkbox(
                                  value: _selectedServices.contains(service),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _amounts = [];

                                      if (value == true) {
                                        _selectedServices.add(service);
                                      } else {
                                        _selectedServices.remove(service);
                                      }

                                      fetchAmount();
                                    });
                                  },
                                ),
                              );
                            })
                          ],
                        ),
                      ),
                      _selectedServices.isNotEmpty &&
                              _amounts != null &&
                              _amounts!.isNotEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    child: Text('Valores'),
                                  ),
                                  ..._amounts!.map((amount) {
                                    ServiceModel service = _selectedServices
                                        .firstWhere((service) =>
                                            service.id == amount.service!.id);

                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: DataLabel(
                                              label: 'Serviço',
                                              info: service.name,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: DataLabel(
                                              label: 'Duração',
                                              info: service.getDuration(),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: DataLabel(
                                              label: 'Valor aula',
                                              info: amount.getSubtotal(),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: DataLabel(
                                              label: 'Taxa de deslocamento',
                                              info: amount.taxes > 0
                                                  ? amount.getTaxes()
                                                  : 'Grátis',
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: DataLabel(
                                              label: 'Total',
                                              info: amount.getTotal(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ])
                          : Container(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
