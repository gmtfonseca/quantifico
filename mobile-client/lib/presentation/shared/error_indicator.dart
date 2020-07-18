import 'package:flutter/material.dart';

class ErrorIndicator extends StatelessWidget {
  final String text;
  final VoidCallback onRetry;

  const ErrorIndicator({
    Key key,
    this.text,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildItems(),
    );
  }

  List<Widget> _buildItems() {
    final List<Widget> items = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(color: Colors.black45),
          ),
          const SizedBox(width: 5),
          Icon(
            Icons.sentiment_dissatisfied,
            color: Colors.black45,
          )
        ],
      ),
      const SizedBox(height: 5),
    ];

    if (onRetry != null) {
      items.add(FlatButton(
        child: Text(
          'TENTAR NOVAMENTE',
          style: TextStyle(color: Colors.deepPurple, fontSize: 12.0),
        ),
        onPressed: onRetry,
      ));
    }

    return items;
  }
}
