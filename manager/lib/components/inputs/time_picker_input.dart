import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimePickerInput extends StatefulWidget {
  final DateTime date;
  final String label;
  final Function(DateTime) onChange;

  const TimePickerInput({
    Key? key,
    required this.label,
    required this.date,
    required this.onChange,
  }) : super(key: key);

  @override
  State<TimePickerInput> createState() => _TimePickerInputState();
}

class _TimePickerInputState extends State<TimePickerInput> {
  Future<TimeOfDay?> showTime(TimeOfDay currentTime) {
    return showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
  }

  void handleDateTime() async {
    TimeOfDay? time = await showTime(TimeOfDay.fromDateTime(widget.date));

    if (time != null) {
      widget.onChange(
        DateTime(
          widget.date.year,
          widget.date.month,
          widget.date.day,
          time.hour,
          time.minute,
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
              DateFormat('HH:mm').format(widget.date),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
