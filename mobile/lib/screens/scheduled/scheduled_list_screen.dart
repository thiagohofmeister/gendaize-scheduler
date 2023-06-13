import 'package:flutter/material.dart';
import 'package:mobile/components/lists/has_no_data.dart';
import 'package:mobile/components/template/nav_drawer.dart';
import 'package:mobile/screens/scheduled/components/scheduled_item.dart';
import 'package:mobile/store/scheduled_store.dart';
import 'package:provider/provider.dart';

class ScheduledListScreen extends StatefulWidget {
  const ScheduledListScreen({Key? key}) : super(key: key);

  @override
  State<ScheduledListScreen> createState() => _ScheduledListScreenState();
}

class _ScheduledListScreenState extends State<ScheduledListScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  String periodity = "TODAY";

  Future<void> _fetch({bool isRefetch = true}) async {
    final dataProvider = Provider.of<ScheduledStore>(context, listen: false);
    Map<String, String> params = {'periodity': periodity};

    if (isRefetch) {
      dataProvider.refetch(params: params);
      return;
    }

    dataProvider.initialFetch(params: params);
  }

  String getMessageEmpty() {
    switch (periodity) {
      case "TODAY":
        return 'hoje';

      case "TOMORROW":
        return 'amanhã';

      case "WEEK":
        return 'esta semana';

      case "MONTH":
        return 'este mês';

      default:
        return 'este período';
    }
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
        title: const Text('Agenda'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                periodity = value;
                _fetch(isRefetch: true);
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'TODAY',
                  child: Text('Hoje'),
                ),
                const PopupMenuItem(
                  value: 'TOMORROW',
                  child: Text('Amanhã'),
                ),
                const PopupMenuItem(
                  value: 'WEEK',
                  child: Text('Semana'),
                ),
                const PopupMenuItem(
                  value: 'MONTH',
                  child: Text('Mês'),
                ),
              ];
            },
          ),
        ],
      ),
      drawer: const NavDrawer(),
      // bottomNavigationBar: const NavBottom(),
      body: Consumer<ScheduledStore>(
        builder: (context, store, child) {
          if (store.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (store.hasNoData()) {
            return HasNoData(
              message:
                  'Você não possui nenhuma agenda para ${getMessageEmpty()}',
              subMessage: 'Tente alterar o período.',
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
                        ScheduledItem(scheduled: store.items[index]),
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
