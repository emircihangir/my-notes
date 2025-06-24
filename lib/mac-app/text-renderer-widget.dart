import 'package:flutter/material.dart';

Widget boldTextWidget({required String data}) =>
    Text(data.replaceFirst("* ", ""), style: const TextStyle(fontWeight: FontWeight.bold));
Widget bulletTextWidget({required String data}) => Text(data.replaceFirst("- ", "\u2022 "));
Widget tagTextWidget({required String data}) =>
    Text(data.replaceFirst("# ", ""), style: TextStyle(color: Colors.black.withAlpha(100)));
Widget strikeThroughTextWidget({required String data}) => Text(
  data.replaceFirst("-* ", ""),
  style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.black.withAlpha(100)),
);

Widget textRenderer({required String data}) {
  List<Widget> textBlocks = [];
  List<String> dataLines = data.split("\n");
  for (var dataLine in dataLines) {
    if (dataLine.trimLeft().startsWith("* ")) {
      // bold
      textBlocks.add(boldTextWidget(data: dataLine));
    } else if (dataLine.trimLeft().startsWith("- ")) {
      // bullet list
      textBlocks.add(bulletTextWidget(data: dataLine));
    } else if (dataLine.trimLeft().startsWith("# ")) {
      // tag
      textBlocks.add(tagTextWidget(data: dataLine));
    } else if (dataLine.trimLeft().startsWith("-* ")) {
      // strikethrough
      textBlocks.add(strikeThroughTextWidget(data: dataLine));
    } else {
      // plain text
      textBlocks.add(Text(dataLine));
    }
  }

  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: textBlocks,
    ),
  );
}
