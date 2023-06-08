import 'package:flutter/material.dart';
import 'package:mobile/components/template/nav_bottom.dart';
import 'package:mobile/components/template/nav_drawer.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const NavDrawer(),
      bottomNavigationBar: const NavBottom(),
      body: Container(
        alignment: Alignment.center,
        child: const Text('Marcar horário'),
      ),
    );
  }
}
