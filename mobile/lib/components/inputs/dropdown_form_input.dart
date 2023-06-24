import 'package:flutter/material.dart';
import 'package:mobile/components/template/data_label.dart';

class DropdownFormInput<T> extends StatefulWidget {
  final T? value;
  final bool isRequired;
  final String requiredMessage;
  final ValueChanged<T?> onChanged;
  final List<T>? items;
  final String labelText;
  final String? hintText;
  final String Function(T) renderLabel;
  final String? labelToOnlyOneOption;

  const DropdownFormInput({
    Key? key,
    required this.value,
    this.isRequired = false,
    this.requiredMessage = 'Preencha o campo',
    required this.onChanged,
    required this.items,
    required this.labelText,
    this.hintText,
    required this.renderLabel,
    this.labelToOnlyOneOption,
  }) : super(key: key);

  @override
  State<DropdownFormInput> createState() => _DropdownFormInputState<T>();
}

class _DropdownFormInputState<T> extends State<DropdownFormInput<T>> {
  @override
  Widget build(BuildContext context) {
    if (widget.items?.length == 1) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: DataLabel(
          label: widget.labelToOnlyOneOption ?? widget.labelText,
          info: widget.renderLabel(widget.items!.first),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
            child: Text(widget.renderLabel(item)),
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
