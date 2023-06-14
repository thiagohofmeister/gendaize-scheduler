import 'package:flutter/material.dart';
import 'package:mobile/components/lists/has_no_data.dart';
import 'package:mobile/components/template/nav_drawer.dart';
import 'package:mobile/screens/service/components/service_list_item.dart';
import 'package:mobile/store/service_store.dart';
import 'package:provider/provider.dart';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({Key? key}) : super(key: key);

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _fetch({bool isRefetch = true}) async {
    final dataProvider = Provider.of<ServiceStore>(context, listen: false);

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
        title: const Text('Serviços'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'service-add').then(
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
        child: Consumer<ServiceStore>(
          builder: (context, store, child) {
            if (store.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (store.hasNoData()) {
              return const HasNoData(
                message: 'Você não possui nenhum serviço cadastrado',
              );
            }

            return RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _fetch,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ServiceListItem(
                        service: store.items[index],
                      ),
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
