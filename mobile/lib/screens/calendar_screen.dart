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

  Future<void> _fetch({bool isRefetch = true}) async {
    final dataProvider = Provider.of<ScheduledStore>(context, listen: false);

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
      body: Consumer<ScheduledStore>(
        builder: (context, store, child) {
          if (store.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (store.hasNoData()) {
            return const Center(
              child: Text('Você não possui nenhuma aula para esse período.'),
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
