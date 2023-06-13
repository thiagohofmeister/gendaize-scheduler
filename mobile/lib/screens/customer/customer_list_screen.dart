import 'package:flutter/material.dart';
import 'package:mobile/components/lists/has_no_data.dart';
import 'package:mobile/components/template/nav_drawer.dart';
import 'package:mobile/screens/customer/components/customer_list_item.dart';
import 'package:mobile/store/customer_store.dart';
import 'package:provider/provider.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({Key? key}) : super(key: key);

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _fetch({bool isRefetch = true}) async {
    final dataProvider = Provider.of<CustomerStore>(context, listen: false);

    if (isRefetch) {
      dataProvider.refetch();
      return;
    }

    dataProvider.initialFetch();
  }

  @override
  void initState() {
    super.initState();
    _fetch(isRefetch: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'customer-add').then((value) {
                if (value == true) {
                  _fetch(isRefetch: true);
                }
              });
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: const NavDrawer(),
      //bottomNavigationBar: const NavBottom(),
      body: Consumer<CustomerStore>(
        builder: (context, store, child) {
          if (store.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (store.hasNoData()) {
            return const HasNoData(
              message: 'Você não possui nenhum cliente.',
            );
          }

          return RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _fetch,
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        CustomerListItem(customer: store.items[index]),
                    childCount: store.items.length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
