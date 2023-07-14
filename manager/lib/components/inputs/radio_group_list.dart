import 'package:flutter/material.dart';
import 'package:manager/components/template/data_label.dart';

class RadioGroupList<T> extends StatefulWidget {
  final List<T> items;
  final String label;
  final String Function(T) renderTitle;
  final T? value;
  final void Function(T?) onChanged;
  final String? labelToOnlyOneOption;
  final void Function(VoidCallback) setState;

  const RadioGroupList({
    Key? key,
    required this.items,
    required this.label,
    required this.renderTitle,
    required this.value,
    required this.onChanged,
    this.labelToOnlyOneOption,
    required this.setState,
  }) : super(key: key);

  @override
  State<RadioGroupList<T>> createState() => _RadioGroupListState<T>();
}

class _RadioGroupListState<T> extends State<RadioGroupList<T>> {
  @override
  Widget build(BuildContext context) {
    if (widget.items.length == 1) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: DataLabel(
          label: widget.labelToOnlyOneOption ?? widget.label,
          info: widget.renderTitle(widget.items.first),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label),
          ...widget.items.map((item) {
            return RadioListTile<T>(
              title: Text(widget.renderTitle(item)),
              value: item,
              groupValue: widget.value,
              onChanged: (T? item) {
                widget.setState(() => widget.onChanged(item));
              },
            );
          })
        ],
      ),
    );
  }
}
