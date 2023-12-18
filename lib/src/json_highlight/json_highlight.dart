import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:json_text_field_editor/src/json_highlight/highlight_strategy.dart';

class JsonHighlight extends SpecialTextSpanBuilder {
  final TextStyle keyHighlightStyle;
  final TextStyle stringHighlightStyle;
  final TextStyle numberHighlightStyle;
  final TextStyle boolHighlightStyle;
  final TextStyle nullHighlightStyle;
  final TextStyle specialCharHighlightStyle;
  final TextStyle commonTextStyle;

  JsonHighlight(
      {required this.keyHighlightStyle,
      required this.stringHighlightStyle,
      required this.numberHighlightStyle,
      required this.boolHighlightStyle,
      required this.nullHighlightStyle,
      required this.specialCharHighlightStyle,
      required this.commonTextStyle});

  @override
  TextSpan build(String data, {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap}) {
    List<HighlightStrategy> strategies = [
      KeyHighlightStrategy(textStyle: keyHighlightStyle),
      StringHighlightStrategy(textStyle: stringHighlightStyle),
      NumberHighlightStrategy(textStyle: numberHighlightStyle),
      BoolHighlightStrategy(textStyle: boolHighlightStyle),
      NullHighlightStrategy(textStyle: nullHighlightStyle),
      SpecialCharHighlightStrategy(textStyle: specialCharHighlightStyle),
    ];

    List<TextSpan> spans = [];

    data.splitMapJoin(
      RegExp(r'\".*?\"\s*:|\".*?\"|\s*\b(\d+(\.\d+)?)\b|\b(true|false|null)\b|[{}\[\],]'),
      onMatch: (m) {
        String word = m.group(0)!;
        spans.add(strategies.firstWhere((element) => element.match(word)).textSpan(word));
        return '';
      },
      onNonMatch: (n) {
        spans.add(TextSpan(text: n, style: commonTextStyle));
        return '';
      },
    );

    return TextSpan(children: spans);
  }

  @override
  SpecialText? createSpecialText(String flag,
      {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap, required int index}) {
    throw UnimplementedError();
  }
}
