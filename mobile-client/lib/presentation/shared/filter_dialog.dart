import 'package:flutter/material.dart';
import 'package:quantifico/config.dart';

class FilterDialog extends StatelessWidget {
  final Widget child;
  final VoidCallback onApply;
  final VoidCallback onClear;

  const FilterDialog({
    Key key,
    @required this.child,
    @required this.onApply,
    this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      backgroundColor: Colors.white,
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Center(
              child: Text(
                'Filtros',
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: child,
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: _buildButtons(context),
          )
        ],
      ),
    );
  }

  List<Widget> _buildButtons(BuildContext context) {
    final List<Widget> buttons = [
      FlatButton(
        child: const Text('CANCELAR'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      FlatButton(
        child: const Text('APLICAR'),
        onPressed: onApply != null
            ? () {
                onApply();
                Navigator.of(context).pop();
              }
            : null,
      ),
    ];

    if (onClear != null) {
      buttons.insert(
          1,
          FlatButton(
            child: const Text('LIMPAR'),
            onPressed: () => onClear(),
          ));
    }
    return buttons;
  }
}
