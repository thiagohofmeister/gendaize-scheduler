import 'package:flutter/material.dart';

class TextFormInput extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isRequired;
  final String requiredMessage;
  final TextInputType keyboardType;
  final bool isObscured;
  final bool isDense;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;

  const TextFormInput({
    Key? key,
    required this.hintText,
    required this.controller,
    this.isRequired = false,
    this.requiredMessage = "Campo obrigatório",
    this.keyboardType = TextInputType.text,
    this.isObscured = false,
    this.isDense = false,
    this.onChanged,
    this.suffixIcon,
  }) : super(key: key);

  @override
  State<TextFormInput> createState() => _TextFormInputState();
}

class _TextFormInputState extends State<TextFormInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: widget.hintText,
          isDense: widget.isDense,
          suffixIcon: widget.suffixIcon,
        ),
        onChanged: widget.onChanged,
        keyboardType: widget.keyboardType,
        obscureText: widget.isObscured,
        validator: (value) {
          if (value != null && value.isEmpty && widget.isRequired) {
            return widget.requiredMessage;
          }

          return null;
        },
        controller: widget.controller,
      ),
    );
  }
}
