import 'package:flutter/material.dart';
import 'package:mobile/models/location_get_address_model.dart';
import 'package:mobile/models/location_model.dart';
import 'package:mobile/models/zipcode_model.dart';
import 'package:mobile/services/location_service.dart';
import 'package:mobile/store/location_store.dart';
import 'package:provider/provider.dart';

class SearchZipcodeDialog extends StatefulWidget {
  final TextEditingController zipcodeController;

  const SearchZipcodeDialog({Key? key, required this.zipcodeController})
      : super(key: key);

  @override
  State<SearchZipcodeDialog> createState() => _SearchZipcodeDialogState();
}

class _SearchZipcodeDialogState extends State<SearchZipcodeDialog> {
  final _formKey = GlobalKey<FormState>();
  LocationModel? _selectedLocation;
  ZipcodeModel? _selectedZipcode;
  String? _selectedCity;
  List<ZipcodeModel> _zipCodes = [];
  bool isSearching = false;

  final TextEditingController _streetController = TextEditingController();

  Future<void> _getStates() async {
    LocationStore provider = Provider.of<LocationStore>(context, listen: false);

    await provider.initialFetch();

    setState(() {
      if (provider.items.length == 1) {
        _selectedLocation = provider.items.firstOrNull();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getStates();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Buscar CEP'),
      content: SingleChildScrollView(
        child: isSearching
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: DropdownButtonFormField(
                      value: _selectedLocation,
                      validator: (value) {
                        if (value == null) {
                          return 'Selecione o estado';
                        }

                        return null;
                      },
                      onChanged: (LocationModel? location) {
                        setState(() {
                          _selectedLocation = location;
                        });
                      },
                      items: _locations.map((LocationModel location) {
                        return DropdownMenuItem<LocationModel>(
                            value: location,
                            child: Text(
                              location.state,
                              overflow: TextOverflow.ellipsis,
                            ));
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: "UF",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  _selectedLocation != null
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: DropdownButtonFormField(
                            value: _selectedCity,
                            validator: (value) {
                              if (value == null) {
                                return 'Selecione a cidade';
                              }

                              return null;
                            },
                            onChanged: (String? city) {
                              setState(() {
                                _selectedCity = city;
                              });
                            },
                            items: _selectedLocation!.cities.map((String city) {
                              return DropdownMenuItem<String>(
                                value: city,
                                child: Text(city),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              labelText: "Cidade",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Preencha a rua';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Rua',
                      ),
                      controller: _streetController,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      setState(() {
                        isSearching = true;
                      });

                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (currentFocus.isFirstFocus) {
                        currentFocus.unfocus();
                      }

                      LocationGetAddressModel address = LocationGetAddressModel(
                          state: _selectedLocation!.state,
                          city: _selectedCity!,
                          street: _streetController.text);

                      LocationService()
                          .getZipcodeByAddress(address)
                          .then((response) {
                        setState(() {
                          _zipCodes = response;

                          if (_zipCodes.length == 1) {
                            _selectedZipcode = _zipCodes.first;
                            widget.zipcodeController.text =
                                _selectedZipcode!.zipCode.replaceAll('-', '');
                          }
                        });

                        setState(() {
                          isSearching = false;
                        });
                      });
                    },
                    child: const Text("Buscar"),
                  ),
                  _zipCodes.isNotEmpty
                      ? DropdownButtonFormField(
                          value: _selectedZipcode,
                          isExpanded: true,
                          onChanged: (ZipcodeModel? zipCode) {
                            if (zipCode == null) {
                              return;
                            }

                            setState(() {
                              widget.zipcodeController.text = zipCode.zipCode;
                            });
                          },
                          items: _zipCodes.map((ZipcodeModel zipCode) {
                            return DropdownMenuItem<ZipcodeModel>(
                              value: zipCode,
                              child: Text(
                                '${zipCode.street} - ${zipCode.district}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            labelText: "Logradouro",
                            border: OutlineInputBorder(),
                          ),
                        )
                      : Container(),
                  _selectedZipcode != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Confirmar'),
                          ),
                        )
                      : Container(),
                ]),
              ),
      ),
    );
  }
}
