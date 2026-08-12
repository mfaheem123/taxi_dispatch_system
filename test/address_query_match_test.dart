// Regression cover for the PICKUP/DROP suggestion panel dropping backend
// results: "A H" returned rows from services/search, but the panel filtered
// them out locally and rendered "No data".
import 'package:dashboard_new1/view/dashboard_view/utils/address_query_match.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('addressMatchesQuery', () {
    test('keeps rows the backend matched token-wise ("A H")', () {
      // Exactly what services/search answers "A H" with.
      expect(
        addressMatchesQuery(
          name: 'ASDA, HIGH STREET',
          postcode: 'NW10 2SR',
          query: 'A H',
        ),
        isTrue,
      );
      expect(
        addressMatchesQuery(
          name: 'ALBERT HOUSE, KILBURN',
          postcode: 'NW6 7YR',
          query: 'A H',
        ),
        isTrue,
      );
    });

    test('tokens may span the name and the postcode', () {
      expect(
        addressMatchesQuery(
          name: 'ALBERT HALL',
          postcode: 'SW7 2AP',
          query: 'ALBERT SW7',
        ),
        isTrue,
      );
    });

    test('still matches a plain single-word query', () {
      expect(
        addressMatchesQuery(
          name: 'HEATHROW TERMINAL 5',
          postcode: 'TW6 2GA',
          query: 'HEATHROW',
        ),
        isTrue,
      );
    });

    test('matches on postcode alone, spaced or not', () {
      expect(
        addressMatchesQuery(name: 'ALBERT HALL', postcode: 'SW7 2AP', query: 'SW7 2AP'),
        isTrue,
      );
      expect(
        addressMatchesQuery(name: 'ALBERT HALL', postcode: 'SW7 2AP', query: 'SW72AP'),
        isTrue,
      );
    });

    test('is case insensitive both ways', () {
      // The field force-uppercases what is typed; the API rows are mixed case.
      expect(
        addressMatchesQuery(name: 'Asda, High Street', postcode: 'nw10 2sr', query: 'A H'),
        isTrue,
      );
    });

    test('drops rows that miss a token', () {
      expect(
        addressMatchesQuery(name: 'BAKER STREET', postcode: 'NW1 6XE', query: 'A H'),
        isFalse,
      );
    });

    test('an empty or whitespace-only query matches nothing', () {
      expect(addressMatchesQuery(name: 'ASDA', postcode: 'NW10', query: ''), isFalse);
      expect(addressMatchesQuery(name: 'ASDA', postcode: 'NW10', query: '   '), isFalse);
    });

    test('survives rows with a null name or postcode', () {
      // openStreetMapApi() builds rows whose postcode can come back null.
      expect(
        addressMatchesQuery(name: 'BRONDESBURY PARK, BRENT', postcode: null, query: 'B P'),
        isTrue,
      );
      expect(addressMatchesQuery(name: null, postcode: 'NW6 7YR', query: 'NW6'), isTrue);
      expect(addressMatchesQuery(name: null, postcode: null, query: 'A H'), isFalse);
    });
  });
}
