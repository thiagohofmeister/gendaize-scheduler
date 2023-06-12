import 'package:flutter/material.dart';
import 'package:mobile/components/scheduled_item.dart';
import 'package:mobile/components/template/nav_bottom.dart';
import 'package:mobile/components/template/nav_drawer.dart';
import 'package:mobile/store/scheduled_store.dart';
import 'package:provider/provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
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
        return 'hoje.';

      case "TOMORROW":
        return 'amanhã.';

      case "WEEK":
        return 'esta semana.';

      case "MONTH":
        return 'este mês.';

      default:
        return 'este período.';
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
      bottomNavigationBar: const NavBottom(),
      body: Consumer<ScheduledStore>(
        builder: (context, store, child) {
          if (store.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (store.hasNoData()) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Você não possui nenhuma agenda para ${getMessageEmpty()}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Tente alterar o período.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
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