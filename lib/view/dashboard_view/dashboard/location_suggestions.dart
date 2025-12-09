import 'package:field_suggestion/field_suggestion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SuggestionExample extends StatefulWidget {
  @override
  _SuggestionExampleState createState() => _SuggestionExampleState();
}

class _SuggestionExampleState extends State<SuggestionExample> {
  final TextEditingController controller = TextEditingController();
  // final SuggestionBoxController boxController = SuggestionBoxController();

  final FocusNode keyboardFocusNode = FocusNode();
  int highlightedIndex = -1;
  List<String> currentResults = [];

  // 🔹 Example: Simulated network future
  Future<List<String>> fetchSuggestions(String input) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (input.isEmpty) return [];
    return List.generate(6, (i) => '$input suggestion ${i + 1}');
  }

  void moveHighlightUp() {
    if (currentResults.isEmpty) return;
    setState(() {
      highlightedIndex =
          (highlightedIndex - 1 + currentResults.length) % currentResults.length;
    });
  }

  void moveHighlightDown() {
    if (currentResults.isEmpty) return;
    setState(() {
      highlightedIndex = (highlightedIndex + 1) % currentResults.length;
    });
  }

  void selectHighlighted() {
    if (highlightedIndex >= 0 && highlightedIndex < currentResults.length) {
      controller.text = currentResults[highlightedIndex];
      // boxController.close?.call();
      highlightedIndex = -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: keyboardFocusNode,
      autofocus: true,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            moveHighlightDown();
          } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            moveHighlightUp();
          } else if (event.logicalKey == LogicalKeyboardKey.enter) {
            selectHighlighted();
          }
        }
      },

      child: FieldSuggestion<String>.network(
        inputDecoration: const InputDecoration(
          hintText: 'Search something...',
          border: OutlineInputBorder(),
        ),
        textController: controller,
        // boxController: boxController,
        future: (input) async {
          final result = await fetchSuggestions(input);
          setState(() {
            currentResults = result;
            highlightedIndex = result.isEmpty ? -1 : 0;
          });
          return result;
        },
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final result = snapshot.data ?? [];

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: result.length,
            itemBuilder: (context, index) {
              final isHighlighted = index == highlightedIndex;
              return Container(
                color:
                isHighlighted ? const Color(0xffA0DCFF) : Colors.white,
                child: ListTile(
                  title: Text(
                    result[index],
                    style: TextStyle(
                      fontWeight: isHighlighted
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color:
                      isHighlighted ? Colors.blue : Colors.black,
                    ),
                  ),
                  onTap: () {
                    controller.text = result[index];
                    // boxController.close?.call();
                    setState(() => highlightedIndex = -1);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
