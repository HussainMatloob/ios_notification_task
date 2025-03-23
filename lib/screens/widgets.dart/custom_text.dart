import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final FontWeight? fw;
  final Color? color;
  final double? size;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final FontStyle? fontStyle;
  final String? fontFamily;
  final int? maxLines;
  final TextStyle? textStyle;
  CustomText(this.text,
      {super.key,
      this.fw,
      this.color,
      this.size,
      this.textAlign,
      this.textOverflow,
      this.fontStyle,
      this.fontFamily,
      this.maxLines,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? "",
      maxLines: maxLines,
      overflow: textOverflow ?? null,
      textAlign: textAlign,
      style: textStyle ??
          GoogleFonts.anybody(
            color: color ?? Colors.black,
            fontSize: size,
            fontWeight: fw,
            fontStyle: fontStyle,
          ),
    );
  }
}
