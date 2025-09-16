import 'dart:ui';

import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final double height;
  final double width;
  final String heading;
  final String text;
  final TextStyle textStyle;
  final TextStyle headingStyle;
  final Icon? icon;
  //final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  const WeatherCard({
    super.key,
    required this.height,
    required this.width,
    required this.heading,
    required this.text,
    required this.textStyle,
    required this.headingStyle,
    this.icon,
    //this.backgroundColor,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          height: height,
          width: width,
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: borderRadius,
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
          ),
          alignment: Alignment.center,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0, top: 15, left: 15),
                child: Row(
                  children: [
                    if (icon != null) icon!,
                    Text(
                      heading,
                      style: headingStyle,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              Text(text, style: textStyle, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
