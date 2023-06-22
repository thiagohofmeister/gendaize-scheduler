import 'package:flutter/material.dart';

class DropdownFormInput<T> extends StatefulWidget {
  final T? value;
  final bool isRequired;
  final String requiredMessage;
  final ValueChanged<T?>? onChanged;
  final List<T>? items;
  final String? labelText;
  final String? hintText;
  final Function(T) renderLabel;

  const DropdownFormInput(
      {Key? key,
      required this.value,
      this.isRequired = false,
      this.requiredMessage = 'Preencha o campo',
      required this.onChanged,
      required this.items,
      this.labelText,
      this.hintText,
      required this.renderLabel})
      : super(key: key);

  @override
  State<DropdownFormInput> createState() => _DropdownFormInputState<T>();
}

class _DropdownFormInputState<T> extends State<DropdownFormInput<T>> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0, bottom: 10.0),
      child: DropdownButtonFormField<T>(
        value: widget.value,
        validator: (value) {
          if (value == null && widget.isRequired) {
            return widget.requiredMessage;
          }

          return null;
        },
        onChanged: widget.onChanged,
        items: widget.items?.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: widget.renderLabel(item),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
