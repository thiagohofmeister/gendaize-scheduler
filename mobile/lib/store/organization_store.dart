import 'package:mobile/models/location_model.dart';
import 'package:mobile/services/organization_service.dart';
import 'package:mobile/store/store_contract.dart';

class OrganizationStore extends StoreContract {
  List<LocationModel> locations = [];
  List<String> states = [];
  List<String> cities = [];

  OrganizationStore() : super();

  Future<void> getAll() async {
    locations = await OrganizationService().fetchAll({});
    fillStates();
  }

  void fillStates() {
    states = locations.map((item) => item.state).toSet().toList();
  }

  List<String> getCities(String state) {
    return locations
        .where((item) => item.state == state)
        .map((item) => item.city)
        .toList();
  }
}
