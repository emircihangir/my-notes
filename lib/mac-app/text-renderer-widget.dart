import 'package:flutter/material.dart';

TextSpan boldText(String data) => TextSpan(
  text: data,
  style: const TextStyle(fontWeight: FontWeight.bold),
);

TextSpan tagText(String data) => TextSpan(
  text: data,
  style: TextStyle(color: Colors.black.withAlpha(100)),
);
TextSpan linedText(String data) => TextSpan(
  text: data,
  style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.black.withAlpha(100)),
);
TextSpan plainText(String data) => TextSpan(text: data);

Widget textRenderer({required String data}) {
  List<TextSpan> textSpanChildrenBuilder() {
    var dataSplit = data.split("");
    List<TextSpan> result = [];

    List<String> plainStack = [];
    List<String> boldStack = [];
    List<String> linedStack = [];
    List<String> tagStack = [];

    var mode = "plain";

    // loop through characters
    for (var i = 0; i < dataSplit.length; i++) {
      var c = dataSplit[i]; // c: character

      if (c == ">" && i != (dataSplit.length - 1)) {
        // '>' character encountered, possible mode change is coming.
        var nextC = dataSplit[i + 1];
        if (nextC == "*") {
          result.add(plainText(plainStack.join("")));
          plainStack.clear();
          mode = "bold";
          i += 1;
          continue;
        } else if (nextC == "-") {
          result.add(plainText(plainStack.join("")));
          plainStack.clear();
          mode = "lined";
          i += 1;
          continue;
        } else if (nextC == "#") {
          result.add(plainText(plainStack.join("")));
          plainStack.clear();
          mode = "tag";
          i += 1;
          continue;
        }
      }

      if (mode == "bold" && c == "*") {
        // turn off bold mode and register bold text
        result.add(boldText(boldStack.join("")));
        mode = "plain";
        boldStack.clear();
        i += 1;
        continue;
      }
      if (mode == "lined" && c == "-") {
        // turn off lined mode.
        result.add(linedText(linedStack.join("")));
        mode = "plain";
        linedStack.clear();
        i += 1;
        continue;
      }
      if (mode == "tag" && c == "#") {
        // turn off tag mode.
        result.add(tagText(tagStack.join("")));
        mode = "plain";
        tagStack.clear();
        i += 1;
        continue;
      }

      if (mode == "bold") {
        boldStack.add(c);
      } else if (mode == "lined") {
        linedStack.add(c);
      } else if (mode == "tag") {
        tagStack.add(c);
      } else {
        plainStack.add(c);
      }
    }

    result.add(plainText(plainStack.join("")));
    return result;
  }

  return RichText(
    text: TextSpan(
      style: TextStyle(color: Colors.black, height: 1.5),
      children: textSpanChildrenBuilder(),
    ),
  );
}
