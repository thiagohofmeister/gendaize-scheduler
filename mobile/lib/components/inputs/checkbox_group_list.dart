import 'package:flutter/material.dart';
import 'package:mobile/components/template/data_label.dart';

class CheckboxGroupList<T> extends StatefulWidget {
  final List<T> items;
  final void Function(List<T>)? onChanged;
  final String label;
  final String Function(T) renderTitle;
  final List<T> value;
  final String labelToOnlyOneOption;

  const CheckboxGroupList({
    Key? key,
    required this.items,
    this.onChanged,
    required this.label,
    required this.renderTitle,
    required this.value,
    required this.labelToOnlyOneOption,
  }) : super(key: key);

  @override
  State<CheckboxGroupList> createState() => _CheckboxGroupListState<T>();
}

class _CheckboxGroupListState<T> extends State<CheckboxGroupList<T>> {
  @override
  void initState() {
    super.initState();

    if (widget.items.length == 1) {
      widget.value.add(widget.items.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.length == 1) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: DataLabel(
          label: widget.labelToOnlyOneOption,
          info: widget.renderTitle(widget.items.first),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label),
          ...widget.items.map((item) {
            return ListTile(
              title: Text(widget.renderTitle(item)),
              trailing: Checkbox(
                value: widget.value.contains(item),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      widget.value.add(item);
                    } else {
                      widget.value.remove(item);
                    }

                    if (widget.onChanged != null) {
                      widget.onChanged!(widget.value);
                    }
                  });
                },
              ),
            );
          })
        ],
      ),
    );
  }
}
