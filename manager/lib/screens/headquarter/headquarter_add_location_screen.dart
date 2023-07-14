import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manager/components/inputs/text_form_input.dart';
import 'package:manager/components/template/screen_layout.dart';
import 'package:manager/components/template/screen_progress_indicator.dart';
import 'package:manager/models/headquarter/headquarter_model.dart';
import 'package:manager/models/location/location_model.dart';
import 'package:manager/services/headquarter_service.dart';
import 'package:manager/services/location_service.dart';

class HeadquarterAddLocationScreen extends StatefulWidget {
  const HeadquarterAddLocationScreen({Key? key}) : super(key: key);

  @override
  State<HeadquarterAddLocationScreen> createState() =>
      _HeadquarterAddLocationScreenState();
}

class _HeadquarterAddLocationScreenState
    extends State<HeadquarterAddLocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<LocationModel> _searchResults = [];
  List<LocationModel> _selectedLocations = [];
  Timer? _debounce;
  bool isFetching = false;

  HeadquarterModel? headquarter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final HeadquarterModel? headquarterFromArgs =
        ModalRoute.of(context)?.settings.arguments as HeadquarterModel?;

    if (headquarterFromArgs != null) {
      headquarter = headquarterFromArgs;

      _selectedLocations = headquarter!.locations;

      _fetchLocations(_searchController.text);
    }
  }

  void _addLocation(LocationModel location) {
    setState(() {
      _selectedLocations.add(location);
    });

    _fetchLocations(_searchController.text);
  }

  void _removeLocation(LocationModel location) {
    setState(() {
      _selectedLocations.remove(location);
    });

    _fetchLocations(_searchController.text);
  }

  void _saveLocations() {
    setState(() {
      isFetching = true;
    });

    HeadquarterService(context)
        .updateLocations(headquarter!.id, _selectedLocations)
        .then(
      (value) {
        Navigator.pop(context, true);
      },
    );

    setState(() {
      isFetching = false;
    });
  }

  void _searchLocations(String query) async {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(
      const Duration(seconds: 1),
      () {
        _fetchLocations(query);
      },
    );
  }

  Future<void> _fetchLocations(String query) async {
    setState(() {
      isFetching = true;
    });

    List<LocationModel> result = [];

    if (query.isNotEmpty) {
      result = (await LocationService(context).fetchAll({'query': query}))
          .items
          .where((element) =>
              _selectedLocations.where((e) => e.id == element.id).firstOrNull ==
              null)
          .toList();
    }

    setState(() {
      _searchResults = [..._selectedLocations, ...result];
      isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar localizações'),
        actions: [
          MenuItemButton(
            onPressed: _saveLocations,
            child: const Text('Salvar'),
          ),
        ],
      ),
      body: ScreenLayout(
        children: [
          TextFormInput(
            controller: _searchController,
            onChanged: _searchLocations,
            hintText: 'Buscar por estado ou cidade',
          ),
          Container(
            child: isFetching
                ? const ScreenProgressIndicator()
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final location = _searchResults[index];
                      bool isSelected = _selectedLocations
                              .where((element) => element.id == location.id)
                              .firstOrNull !=
                          null;

                      return ListTile(
                        title: Text('${location.city} - ${location.state}'),
                        trailing: IconButton(
                          icon: isSelected
                              ? const Icon(Icons.remove)
                              : const Icon(Icons.add),
                          onPressed: isSelected
                              ? () => _removeLocation(location)
                              : () => _addLocation(location),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
