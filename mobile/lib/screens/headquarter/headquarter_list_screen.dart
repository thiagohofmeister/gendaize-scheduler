import 'package:flutter/material.dart';
import 'package:mobile/components/template/screen_list.dart';
import 'package:mobile/models/headquarter/headquarter_model.dart';
import 'package:mobile/screens/headquarter/components/headquarter_list_item.dart';
import 'package:mobile/store/headquarter_store.dart';
import 'package:provider/provider.dart';

class HeadquarterListScreen extends StatelessWidget {
  const HeadquarterListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenList<HeadquarterModel>(
      title: 'Filiais',
      navigatorAddPathAction: 'headquarter-add',
      provider: Provider.of<HeadquarterStore>(context, listen: false),
      store: Provider.of<HeadquarterStore>(context, listen: true),
      renderItem: (item) => HeadquarterListItem(item),
      noDataMessage: 'Você não possui nenhuma filial cadastrada',
    );
  }
}
