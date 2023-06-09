import 'package:flutter/material.dart';
import 'package:mobile/components/customer_item.dart';
import 'package:mobile/components/template/nav_bottom.dart';
import 'package:mobile/components/template/nav_drawer.dart';
import 'package:mobile/store/customer_store.dart';
import 'package:provider/provider.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({Key? key}) : super(key: key);

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
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
      appBar: AppBar(),
      drawer: const NavDrawer(),
      bottomNavigationBar: const NavBottom(),
      body: Consumer<CustomerStore>(
        builder: (context, store, child) {
          if (store.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (store.hasNoData()) {
            return const Center(
              child: Text('Você não possui nenhum cliente.'),
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
                        CustomerItem(customer: store.items[index]),
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
