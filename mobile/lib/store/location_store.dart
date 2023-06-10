import 'package:mobile/models/location_model.dart';
import 'package:mobile/models/response_list.dart';
import 'package:mobile/services/location_service.dart';
import 'package:mobile/store/list_store_contract.dart';

class LocationStore extends ListStoreContract<LocationModel> {
  LocationStore() : super();

  @override
  Future<ResponseList<LocationModel>> getAll({Map<String, String>? params}) {
    return LocationService().fetchAll(params);
  }

  List<String> getStates() {
    return items.map((item) => item.state).toSet().toList();
  }

  List<String> getCities(String state) {
    return items
        .where((item) => item.state == state)
        .map((item) => item.city)
        .toList();
  }
}
