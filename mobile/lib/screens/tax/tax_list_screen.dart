import 'package:flutter/material.dart';
import 'package:mobile/components/lists/has_no_data.dart';
import 'package:mobile/components/template/nav_drawer.dart';
import 'package:mobile/screens/tax/components/tax_list_item.dart';
import 'package:mobile/store/tax_store.dart';
import 'package:provider/provider.dart';

class TaxListScreen extends StatefulWidget {
  const TaxListScreen({Key? key}) : super(key: key);

  @override
  State<TaxListScreen> createState() => _TaxListScreenState();
}

class _TaxListScreenState extends State<TaxListScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _fetch({bool isRefetch = true}) async {
    final dataProvider = Provider.of<TaxStore>(context, listen: false);

    if (isRefetch) {
      dataProvider.refetch(context);
      return;
    }

    dataProvider.initialFetch(context);
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
        title: const Text('Taxas'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'tax-add').then(
                (value) {
                  if (value == true) {
                    _fetch(isRefetch: true);
                  }
                },
              );
            },
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
          )
        ],
      ),
      drawer: const NavDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: Consumer<TaxStore>(
          builder: (context, store, child) {
            if (store.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (store.hasNoData()) {
              return const HasNoData(
                message: 'Você não possui nenhuma taxa cadastrada',
              );
            }

            return RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _fetch,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => TaxListItem(tax: store.items[index]),
                      childCount: store.items.length,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
