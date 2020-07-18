import 'package:flutter/material.dart';
import 'package:quantifico/util/date_util.dart' as date_util;

class TextDatePicker extends StatefulWidget {
  final String labelText;
  final DateTime initialValue;
  final bool enabled;
  final FormFieldState<DateTime> formFieldState;
  final void Function(DateTime value) onChanged;
  final TextEditingController controller;

  factory TextDatePicker({
    String labelText,
    DateTime initialValue,
    bool enabled,
    FormFieldState<DateTime> formFieldState,
    void Function(DateTime value) onChanged,
  }) {
    final date = initialValue ?? formFieldState?.value;
    final controller = TextEditingController(text: date != null ? date_util.formatDate(date) : '');
    return TextDatePicker._(
      labelText: labelText,
      initialValue: initialValue,
      enabled: enabled,
      formFieldState: formFieldState,
      onChanged: onChanged,
      controller: controller,
    );
  }

  const TextDatePicker._({
    this.labelText,
    this.initialValue,
    this.enabled = true,
    this.formFieldState,
    this.onChanged,
    this.controller,
  });

  @override
  _TextDatePickerState createState() => _TextDatePickerState();
}

class _TextDatePickerState extends State<TextDatePicker> {
  DateTime _date;

  @override
  void initState() {
    super.initState();
    _date = widget.initialValue ?? widget.formFieldState?.value;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.enabled,
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        icon: Icon(Icons.date_range),
        errorText: widget.formFieldState?.errorText,
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());

        final date = await showDatePicker(
          context: context,
          initialDate: _date ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );

        _handleSelection(date);
      },
    );
  }

  void _handleSelection(DateTime date) {
    if (date != null) {
      _date = date;
      widget.controller.text = date_util.formatDate(_date);

      if (widget.formFieldState != null) {
        widget.formFieldState.didChange(_date);
        widget.formFieldState.validate();
      }

      if (widget.onChanged != null) {
        widget.onChanged(_date);
      }
    }
  }
}
