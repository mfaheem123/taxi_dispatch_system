import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import '../component/alert_close_button.dart';
import '../component/color.dart';
import '../component/textStyle.dart';

class EmailContentAlert extends StatelessWidget {
  final String emailContent;

  const EmailContentAlert({
    super.key,
    required this.emailContent,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final content = emailContent.trim();
    final blocks = content.isEmpty ? <Widget>[] : _EmailHtmlRenderer().render(content);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: math.min(1100, screenSize.width * 0.9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: DynamicColors.gryClr.withOpacity(0.5),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Icon(Icons.email_outlined, color: DynamicColors.primaryClr),
                  const SizedBox(width: 10),
                  Text(
                    "EMAIL CONTENT",
                    style: mozillaTextSemiBoldText(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  const FocusTraversalOrder(
                    order: NumericFocusOrder(999),
                    child: AlertCloseButton(),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1),

            // --- CONTENT BODY ---
            Flexible(
              child: Container(
                constraints: BoxConstraints(maxHeight: screenSize.height * 0.75),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: blocks.isEmpty
                      ? Text(
                    "No content available",
                    style: mozillaTextRegularText(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: blocks,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Inherited text formatting while walking the HTML tree.
class _Fmt {
  final bool bold;
  final Color? color;

  const _Fmt({this.bold = false, this.color});

  _Fmt apply(dom.Element el) {
    final tag = el.localName;
    final style = el.attributes['style'] ?? '';
    var isBold = bold || tag == 'strong' || tag == 'b' || tag == 'th';
    final weight = _cssValue(style, 'font-weight');
    if (weight != null) {
      final numeric = int.tryParse(weight);
      if (weight.contains('bold') || (numeric != null && numeric >= 700)) isBold = true;
    }
    final newColor = _parseColor(_cssValue(style, 'color') ?? el.attributes['color']);
    return _Fmt(bold: isBold, color: newColor ?? color);
  }

  static String? _cssValue(String style, String prop) {
    final match = RegExp('(?:^|;)\\s*$prop\\s*:\\s*([^;]+)', caseSensitive: false)
        .firstMatch(style);
    return match?.group(1)?.replaceAll('!important', '').trim().toLowerCase();
  }

  static Color? _parseColor(String? value) {
    if (value == null || value.isEmpty) return null;
    final v = value.trim().toLowerCase();
    final rgb = RegExp(r'rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)').firstMatch(v);
    if (rgb != null) {
      return Color.fromARGB(255, int.parse(rgb.group(1)!), int.parse(rgb.group(2)!),
          int.parse(rgb.group(3)!));
    }
    if (v.startsWith('#')) {
      var hex = v.substring(1);
      if (hex.length == 3) hex = hex.split('').map((c) => '$c$c').join();
      final parsed = int.tryParse(hex, radix: 16);
      if (hex.length == 6 && parsed != null) return Color(0xFF000000 | parsed);
    }
    const named = {
      'red': Colors.red,
      'green': Color(0xFF008000),
      'blue': Colors.blue,
      'black': Colors.black,
      'orange': Colors.orange,
    };
    return named[v];
  }
}

/// Converts the email HTML coming from the backend into native widgets:
/// `<table>` tags become bordered tables (with colspan support) and
/// everything else becomes rich text.
class _EmailHtmlRenderer {
  static const _textColor = Color(0xFF333333);
  static const _borderColor = Color(0xFFCCCCCC);
  static const _headerBg = Color(0xFFF9F9F9);
  static const _blockTags = {
    'p', 'div', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'li', 'ul', 'ol', 'tr', 'section',
  };
  static const _skipTags = {'script', 'style', 'colgroup', 'col', 'head', 'title'};

  List<Widget> render(String raw) {
    var source = raw.replaceAll(r'\"', '"').replaceAll(r'\n', '\n');
    // Plain text without any tags: keep its line breaks
    if (!source.contains('<')) source = source.replaceAll('\n', '<br>');
    final body = html_parser.parse(source).body;
    if (body == null) return [];
    return _buildBlocks(body.nodes, const _Fmt());
  }

  List<Widget> _buildBlocks(List<dom.Node> nodes, _Fmt fmt) {
    final blocks = <Widget>[];
    final spans = <_Span>[];
    var lastWasTable = false;

    void newline() {
      if (spans.isNotEmpty && !spans.last.text.endsWith('\n')) {
        spans.add(_Span('\n', fmt));
      }
    }

    void flush() {
      // Drop leading/trailing whitespace so empty <p><br></p> adds no height
      while (spans.isNotEmpty && spans.first.text.trim().isEmpty) {
        spans.removeAt(0);
      }
      while (spans.isNotEmpty && spans.last.text.trim().isEmpty) {
        spans.removeLast();
      }
      if (spans.isEmpty) return;
      final first = spans.first;
      spans[0] = _Span(first.text.trimLeft(), first.fmt);
      final last = spans.last;
      spans[spans.length - 1] = _Span(last.text.trimRight(), last.fmt);

      blocks.add(Padding(
        padding: EdgeInsets.only(top: lastWasTable ? 10 : 0, bottom: 4),
        child: Text.rich(TextSpan(
          children: spans.map((s) => TextSpan(text: s.text, style: _style(s.fmt))).toList(),
        )),
      ));
      spans.clear();
      lastWasTable = false;
    }

    void walk(dom.Node node, _Fmt f) {
      if (node is dom.Text) {
        final text = node.text.replaceAll(RegExp(r'[ \t\r\n]+'), ' ');
        if (text.isEmpty) return;
        // Avoid a leading space at the start of a new line
        if (text == ' ' && (spans.isEmpty || spans.last.text.endsWith('\n'))) return;
        spans.add(_Span(text.toUpperCase(), f));
        return;
      }
      if (node is! dom.Element) return;

      final tag = node.localName ?? '';
      if (_skipTags.contains(tag) || node.classes.contains('simditor-resize-handle')) return;
      if (tag == 'br') {
        spans.add(_Span('\n', f));
        return;
      }
      if (tag == 'table') {
        flush();
        blocks.add(_buildTable(node, f, withTopBorder: !lastWasTable || blocks.isEmpty));
        lastWasTable = true;
        return;
      }

      final childFmt = f.apply(node);
      final isBlock = _blockTags.contains(tag);
      if (isBlock) newline();
      for (final child in node.nodes) {
        walk(child, childFmt);
      }
      if (isBlock) newline();
    }

    for (final node in nodes) {
      walk(node, fmt);
    }
    flush();
    return blocks;
  }

  Widget _buildTable(dom.Element table, _Fmt fmt, {required bool withTopBorder}) {
    final rows = <dom.Element>[];
    for (final child in table.children) {
      if (child.localName == 'tr') {
        rows.add(child);
      } else if (const {'thead', 'tbody', 'tfoot'}.contains(child.localName)) {
        rows.addAll(child.children.where((e) => e.localName == 'tr'));
      }
    }
    if (rows.isEmpty) return const SizedBox.shrink();

    int spanOf(dom.Element cell) => math.max(1, int.tryParse(cell.attributes['colspan'] ?? '') ?? 1);
    List<dom.Element> cellsOf(dom.Element row) =>
        row.children.where((e) => e.localName == 'td' || e.localName == 'th').toList();

    final totalCols = rows
        .map((r) => cellsOf(r).fold<int>(0, (sum, c) => sum + spanOf(c)))
        .fold<int>(1, math.max);
    const cellBorder = BorderSide(color: _borderColor, width: 1);

    Widget cellBox({required int flex, Widget? child, bool header = false}) {
      return Expanded(
        flex: flex,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
          decoration: BoxDecoration(
            color: header ? _headerBg : null,
            border: const Border(right: cellBorder, bottom: cellBorder),
          ),
          child: child,
        ),
      );
    }

    final tableFmt = fmt.apply(table);
    return Container(
      decoration: BoxDecoration(
        border: Border(left: cellBorder, top: withTopBorder ? cellBorder : BorderSide.none),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: rows.map((row) {
          final cells = cellsOf(row);
          final used = cells.fold<int>(0, (sum, c) => sum + spanOf(c));
          final rowFmt = tableFmt.apply(row);
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final cell in cells)
                  cellBox(
                    flex: spanOf(cell),
                    header: cell.localName == 'th',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildBlocks(cell.nodes, rowFmt.apply(cell)),
                    ),
                  ),
                if (used < totalCols) cellBox(flex: totalCols - used),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  TextStyle _style(_Fmt fmt) => mozillaTextSemiBoldText(
    fontSize: 12.5,
    color: fmt.color ?? _textColor,
    fontWeight: fmt.bold ? FontWeight.w700 : FontWeight.w500,
  ).copyWith(height: 1.5);
}

class _Span {
  final String text;
  final _Fmt fmt;

  const _Span(this.text, this.fmt);
}