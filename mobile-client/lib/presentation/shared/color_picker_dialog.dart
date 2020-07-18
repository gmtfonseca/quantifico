import 'package:flutter/material.dart';

class ColorPickerDialog extends StatefulWidget {
  final List<Color> colors;
  final Color initialColor;
  final void Function(Color color) onSelected;

  const ColorPickerDialog({
    Key key,
    @required this.colors,
    @required this.onSelected,
    this.initialColor,
  }) : super(key: key);

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      backgroundColor: Colors.white,
      child: ListView(
        shrinkWrap: true,
        children: [
          _buildColors(),
          _buildButtonBar(),
        ],
      ),
    );
  }

  Widget _buildColors() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: widget.colors.map((color) => _buildColorTile(color)).toList().cast<Widget>(),
        ),
      ),
    );
  }

  Widget _buildColorTile(Color color) {
    final brightness = ThemeData.estimateBrightnessForColor(color);
    final iconColor = brightness == Brightness.light ? Colors.black : Colors.white;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: Material(
        elevation: 4.0,
        shape: const CircleBorder(),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: color,
          child: _selectedColor.value == color.value ? Icon(Icons.check, color: iconColor) : null,
        ),
      ),
    );
  }

  Widget _buildButtonBar() {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceEvenly,
      children: [
        FlatButton(
          child: const Text('CANCELAR'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: const Text('OK'),
          onPressed: () {
            widget.onSelected(_selectedColor);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
