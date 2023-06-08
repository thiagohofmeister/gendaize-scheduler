import 'package:flutter/material.dart';
import 'package:mobile/components/template/nav_bottom.dart';
import 'package:mobile/components/template/nav_drawer.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({Key? key}) : super(key: key);

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const NavDrawer(),
      bottomNavigationBar: const NavBottom(),
      body: Container(
        alignment: Alignment.center,
        child: const Text('Meus Clientes'),
      ),
    );
  }
}
