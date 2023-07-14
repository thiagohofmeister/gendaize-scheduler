import 'package:flutter/material.dart';
import 'package:manager/components/lists/has_no_data.dart';
import 'package:manager/components/template/nav_drawer.dart';
import 'package:manager/components/template/screen_layout.dart';
import 'package:manager/store/list_store_contract.dart';

class ScreenList<T> extends StatefulWidget {
  final ListStoreContract<T> provider;
  final Map<String, String>? providerParams;
  final ListStoreContract<T> store;
  final Function(dynamic) renderItem;
  final String? navigatorAddPathAction;
  final String title;
  final String noDataMessage;
  final String? noDataSubMessage;
  final List<Widget>? actions;

  const ScreenList({
    Key? key,
    required this.provider,
    this.providerParams,
    required this.store,
    required this.renderItem,
    this.navigatorAddPathAction,
    required this.title,
    required this.noDataMessage,
    this.noDataSubMessage,
    this.actions,
  }) : super(key: key);

  @override
  State<ScreenList> createState() => _ScreenListState();
}

class _ScreenListState<T> extends State<ScreenList<T>> {
  Future<void> _fetch({bool isRefetch = true}) async {
    if (isRefetch) {
      widget.provider.refetch(context, params: widget.providerParams);
      return;
    }

    widget.provider.initialFetch(context, params: widget.providerParams);
  }

  @override
  void initState() {
    super.initState();
    _fetch(isRefetch: false);
  }

  @override
  void didUpdateWidget(ScreenList oldWidget) {
    if (widget.providerParams.toString() !=
        oldWidget.providerParams.toString()) {
      _fetch(isRefetch: false);
    }

    super.didUpdateWidget(oldWidget as ScreenList<T>);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
        GlobalKey<RefreshIndicatorState>();

    List<Widget> actions = [];

    if (widget.actions != null) {
      actions.addAll(widget.actions!.toList());
    }

    if (widget.navigatorAddPathAction != null) {
      actions.add(IconButton(
        onPressed: () {
          Navigator.pushNamed(context, widget.navigatorAddPathAction!).then(
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
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: actions,
      ),
      drawer: const NavDrawer(),
      body: ScreenLayout(
        child: RefreshIndicator(
          key: refreshIndicatorKey,
          onRefresh: _fetch,
          child: Builder(
            builder: (context) {
              if (widget.store.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (widget.store.hasNoData()) {
                return HasNoData(
                  message: widget.noDataMessage,
                  subMessage: widget.noDataSubMessage,
                );
              }

              return CustomScrollView(
                shrinkWrap: true,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          widget.renderItem(widget.store.items[index]),
                      childCount: widget.store.items.length,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
