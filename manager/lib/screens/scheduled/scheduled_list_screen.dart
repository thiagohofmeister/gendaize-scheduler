import 'package:flutter/material.dart';
import 'package:manager/components/template/screen_list.dart';
import 'package:manager/screens/scheduled/components/scheduled_list_item.dart';
import 'package:manager/store/scheduled_store.dart';
import 'package:provider/provider.dart';

class ScheduledListScreen extends StatefulWidget {
  const ScheduledListScreen({Key? key}) : super(key: key);

  @override
  State<ScheduledListScreen> createState() => _ScheduledListScreenState();
}

class _ScheduledListScreenState extends State<ScheduledListScreen> {
  String periodity = "TODAY";

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
  Widget build(BuildContext context) {
    return ScreenList(
      provider: Provider.of<ScheduledStore>(context, listen: false),
      providerParams: {'periodity': periodity},
      store: Provider.of<ScheduledStore>(context, listen: true),
      renderItem: (item) => ScheduledListItem(item),
      title: 'Agenda',
      noDataMessage: 'Você não possui nenhuma agenda para ${getMessageEmpty()}',
      noDataSubMessage: 'Tente alterar o período.',
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.filter_list),
          onSelected: (value) {
            setState(() {
              periodity = value;
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
    );
  }
}
