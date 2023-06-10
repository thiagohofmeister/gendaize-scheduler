import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerInput extends StatefulWidget {
  final DateTime date;
  final String label;
  final Function(DateTime) onChange;

  const DatePickerInput({
    Key? key,
    required this.label,
    required this.date,
    required this.onChange,
  }) : super(key: key);

  @override
  State<DatePickerInput> createState() => _DatePickerInputState();
}

class _DatePickerInputState extends State<DatePickerInput> {
  Future<DateTime?> showDate(DateTime currentDate) {
    return showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate,
      lastDate:
          DateTime(currentDate.year + 1, currentDate.month, currentDate.day),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark(),
          child: child!,
        );
      },
    );
  }

  void handleDateTime() async {
    DateTime? date = await showDate(widget.date);

    if (date != null) {
      widget.onChange(
        DateTime(
          date.year,
          date.month,
          date.day,
          widget.date.hour,
          widget.date.minute,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          width: const OutlineInputBorder().borderSide.width,
          color: Colors.grey,
        ),
        borderRadius: const OutlineInputBorder().borderRadius,
      ),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              text: '${widget.label}:',
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ),
          TextButton(
            onPressed: handleDateTime,
            child: Text(
              DateFormat('dd/MM/yyyy').format(widget.date),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
