/// Matching rule for the address suggestion panel on the booking form.
///
/// Lives on its own (no Flutter/GetX imports) so it can be unit-tested on the
/// VM — the widget file it serves reaches dart:html through its alert imports
/// and would force the whole app to compile to JS first.
library;

/// Whether the address `name` / `postcode` pair should stay in the suggestion
/// list for what the user typed.
///
/// `services/search` matches on tokens, so typing "A H" comes back with rows
/// like "ASDA, HIGH STREET". A plain `contains('a h')` over the row text throws
/// every one of those away, which is why a multi-word search rendered "No data"
/// while the backend had, in fact, returned results. So: split the query on
/// whitespace and require each token separately.
///
/// The space-stripped comparison at the end covers the other direction — a
/// postcode typed as "SW1A1AA" still finds the row stored as "SW1A 1AA".
bool addressMatchesQuery({
  String? name,
  String? postcode,
  required String query,
}) {
  final tokens = query
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((t) => t.isNotEmpty)
      .toList();
  if (tokens.isEmpty) return false;

  final haystack = '${name ?? ''} ${postcode ?? ''}'.toLowerCase();
  if (tokens.every(haystack.contains)) return true;

  final squashed = haystack.replaceAll(RegExp(r'\s+'), '');
  return squashed.isNotEmpty && squashed.contains(tokens.join());
}
