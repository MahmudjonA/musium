import 'package:flutter/material.dart';
import '../../../../core/responsiveness/app_responsive.dart';

class TopMixesWg extends StatelessWidget {
  final String image;
  final String title;
  final String borderColor;

  const TopMixesWg({
    super.key,
    required this.image,
    required this.title,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: appH(150),
      width: appW(150),
      margin: EdgeInsets.only(right: appW(12)),
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
        border: Border(
          bottom: BorderSide(color: _parseColor(borderColor), width: 10),
        ),
      ),
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 10),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _parseColor(String hexColor) {
    final buffer = StringBuffer();
    if (hexColor.length == 6) buffer.write('FF');
    buffer.write(hexColor.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
