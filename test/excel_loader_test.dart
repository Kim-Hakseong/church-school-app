import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:church_school_app/services/excel_loader.dart';
import 'package:church_school_app/models/verse.dart';
import 'package:church_school_app/models/event.dart';

void main() {
  group('ExcelLoader Tests', () {
    setUpAll(() {
      // Initialize the binding first
      TestWidgetsFlutterBinding.ensureInitialized();
      
      // Mock the asset bundle for testing
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter/assets'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'loadString') {
            return '';
          }
          if (methodCall.method == 'load') {
            // Return empty bytes for testing - in real tests you'd load actual test data
            return ByteData(0);
          }
          return null;
        },
      );
    });

    test('loadVerses should return empty map when Excel file is empty', () async {
      final result = await ExcelLoader.loadVerses();
      expect(result, isA<Map<String, List<Verse>>>());
    });

    test('loadEvents should return empty list when Excel file is empty', () async {
      final result = await ExcelLoader.loadEvents();
      expect(result, isA<List<Event>>());
    });

    test('Verse model should serialize and deserialize correctly', () {
      final originalVerse = Verse(
        date: DateTime(2024, 1, 7),
        text: '테스트 구절',
        extra: '테스트 공과',
      );

      final json = originalVerse.toJson();
      final deserializedVerse = Verse.fromJson(json);

      expect(deserializedVerse.date, equals(originalVerse.date));
      expect(deserializedVerse.text, equals(originalVerse.text));
      expect(deserializedVerse.extra, equals(originalVerse.extra));
    });

    test('Event model should serialize and deserialize correctly', () {
      final originalEvent = Event(
        date: DateTime(2024, 1, 7),
        title: '테스트 이벤트',
        note: '테스트 노트',
      );

      final json = originalEvent.toJson();
      final deserializedEvent = Event.fromJson(json);

      expect(deserializedEvent.date, equals(originalEvent.date));
      expect(deserializedEvent.title, equals(originalEvent.title));
      expect(deserializedEvent.note, equals(originalEvent.note));
    });
  });
}
