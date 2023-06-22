import 'package:flutter/material.dart';
import 'package:mobile/components/template/screen_list.dart';
import 'package:mobile/models/service/service_model.dart';
import 'package:mobile/screens/service/components/service_list_item.dart';
import 'package:mobile/store/service_store.dart';
import 'package:provider/provider.dart';

class ServiceListScreen extends StatelessWidget {
  const ServiceListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenList<ServiceModel>(
      title: 'Serviços',
      navigatorAddPathAction: 'service-add',
      provider: Provider.of<ServiceStore>(context, listen: false),
      store: Provider.of<ServiceStore>(context, listen: true),
      renderItem: (item) => ServiceListItem(item),
      noDataMessage: 'Você não possui nenhum serviço cadastrado',
    );
  }
}
