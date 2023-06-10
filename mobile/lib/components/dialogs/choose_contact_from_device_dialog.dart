import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ChooseContactFromDeviceDialog extends StatefulWidget {
  const ChooseContactFromDeviceDialog({Key? key}) : super(key: key);

  @override
  State<ChooseContactFromDeviceDialog> createState() =>
      _ChooseContactFromDeviceDialogState();
}

class _ChooseContactFromDeviceDialogState
    extends State<ChooseContactFromDeviceDialog> {
  List<Contact> _contacts = [];
  bool isLoading = false;

  Future<void> _getContacts() async {
    setState(() {
      isLoading = true;
    });

    await Permission.contacts.request();

    if (await Permission.contacts.isGranted || Platform.isIOS) {
      Iterable<Contact> contacts = await ContactsService.getContacts();

      setState(() {
        _contacts = contacts.map((contact) {
          contact.displayName = contact.displayName!.trim();

          return contact;
        }).toList();
        _contacts.sort(
          (a, b) {
            return a.displayName!
                .toLowerCase()
                .compareTo(b.displayName!.toLowerCase());
          },
        );
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Selecione um contato'),
      content: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  Contact contact = _contacts[index];
                  return ListTile(
                    title: Text(contact.displayName ?? ''),
                    subtitle: Text(contact.phones?.first.value ?? ''),
                    onTap: () {
                      Navigator.of(context).pop({
                        'name': contact.displayName ?? '',
                        'phone': contact.phones?.first.value ?? '',
                      });
                    },
                  );
                },
              ),
            ),
    );
  }
}
