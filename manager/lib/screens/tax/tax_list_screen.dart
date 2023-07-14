import 'package:flutter/material.dart';
import 'package:manager/components/template/screen_list.dart';
import 'package:manager/models/tax/tax_model.dart';
import 'package:manager/screens/tax/components/tax_list_item.dart';
import 'package:manager/store/tax_store.dart';
import 'package:provider/provider.dart';

class TaxListScreen extends StatelessWidget {
  const TaxListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenList<TaxModel>(
      title: 'Taxas',
      navigatorAddPathAction: 'tax-add',
      provider: Provider.of<TaxStore>(context, listen: false),
      store: Provider.of<TaxStore>(context, listen: true),
      renderItem: (item) => TaxListItem(item),
      noDataMessage: 'Você não possui nenhuma taxa cadastrada',
    );
  }
}
