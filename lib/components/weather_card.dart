import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final double height;
  final double width;
  final String heading;
  final String text;
  final TextStyle textStyle;
  final TextStyle headingStyle;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  //final BoxBorder? border;

  const WeatherCard({
    super.key,
    required this.height,
    required this.width,
    required this.heading,
    required this.text,
    required this.textStyle,
    required this.headingStyle,
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
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        //border: border,
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom:30),
            child: Text(heading, style: headingStyle, textAlign: TextAlign.start),
          ),
          Text(text, style: textStyle, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
