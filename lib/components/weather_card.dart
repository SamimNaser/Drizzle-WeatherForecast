import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final double height;
  final double width;
  final String text;
  final TextStyle textStyle;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  //final BoxBorder? border;

  const WeatherCard({
    super.key,
    required this.height,
    required this.width,
    required this.text,
    required this.textStyle,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
    //this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding ?? const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[200],
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        //border: border,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: textStyle,
        textAlign: TextAlign.center
      ),
    );
  }
}
