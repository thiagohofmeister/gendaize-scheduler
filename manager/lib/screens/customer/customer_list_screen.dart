import 'package:flutter/material.dart';
import 'package:manager/components/template/screen_list.dart';
import 'package:manager/models/customer/customer_model.dart';
import 'package:manager/screens/customer/components/customer_list_item.dart';
import 'package:manager/store/customer_store.dart';
import 'package:provider/provider.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenList<CustomerModel>(
      title: 'Clientes',
      navigatorAddPathAction: 'customer-add',
      provider: Provider.of<CustomerStore>(context, listen: false),
      store: Provider.of<CustomerStore>(context, listen: true),
      renderItem: (item) => CustomerListItem(item),
      noDataMessage: 'Você não possui nenhum cliente cadastrado',
    );
  }
}
