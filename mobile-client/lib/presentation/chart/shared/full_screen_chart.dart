import 'package:flutter/material.dart';
import 'package:quantifico/config.dart';

class FullScreenChart extends StatelessWidget {
  final String title;
  final Color appBarColor;
  final Widget child;

  const FullScreenChart({
    Key key,
    this.title,
    this.appBarColor,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final brightess = ThemeData.estimateBrightnessForColor(appBarColor);
    final textColor = brightess == Brightness.light ? Colors.black.withOpacity(0.70) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: textColor,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          title,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: appBarColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: SizeConfig.safeBlockVertical * 100,
            child: child,
          ),
        ),
      ),
    );
  }
}
