import 'package:flutter/material.dart';
import 'package:manager/components/template/nav_drawer.dart';
import 'package:manager/components/template/screen_layout.dart';
import 'package:manager/models/headquarter/headquarter_model.dart';
import 'package:manager/services/headquarter_service.dart';

import 'components/headquarter_list_location_item.dart';

class HeadquarterListLocationsScreen extends StatefulWidget {
  const HeadquarterListLocationsScreen({Key? key}) : super(key: key);

  @override
  State<HeadquarterListLocationsScreen> createState() =>
      _HeadquarterListLocationsScreenState();
}

class _HeadquarterListLocationsScreenState
    extends State<HeadquarterListLocationsScreen> {
  HeadquarterModel? headquarter;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final HeadquarterModel? headquarterFromArgs =
        ModalRoute.of(context)?.settings.arguments as HeadquarterModel?;

    if (headquarterFromArgs != null) {
      headquarter = headquarterFromArgs;
    }
  }

  Future _fetch() async {
    HeadquarterService(context).fetchById(headquarter!.id).then((value) {
      setState(() {
        headquarter = value;
      });
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Falha ao buscar a filial."),
      ));

      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localizações atendidas'),
        actions: [
          MenuItemButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                'headquarter-add-location',
                arguments: headquarter,
              ).then(
                (value) {
                  if (value == true) {
                    _fetch();
                  }
                },
              );
            },
            child: const Text('Editar'),
          )
        ],
      ),
      drawer: const NavDrawer(),
      body: ScreenLayout(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _fetch,
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => HeadquarterListItem(
                    location: headquarter!.locations[index],
                  ),
                  childCount: headquarter!.locations.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
