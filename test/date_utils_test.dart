import 'package:flutter_test/flutter_test.dart';
import 'package:church_school_app/utils/date_utils.dart';

void main() {
  group('DateUtils Tests', () {
    test('getStartOfWeek should return Sunday for any day of the week', () {
      // Test with different days of the week
      final monday = DateTime(2024, 1, 8); // Monday
      final wednesday = DateTime(2024, 1, 10); // Wednesday
      final saturday = DateTime(2024, 1, 13); // Saturday
      final sunday = DateTime(2024, 1, 7); // Sunday
      
      final mondayStart = DateUtils.getStartOfWeek(monday);
      final wednesdayStart = DateUtils.getStartOfWeek(wednesday);
      final saturdayStart = DateUtils.getStartOfWeek(saturday);
      final sundayStart = DateUtils.getStartOfWeek(sunday);
      
      // All should return the same Sunday
      expect(mondayStart.weekday, 7); // Sunday is 7
      expect(wednesdayStart.weekday, 7);
      expect(saturdayStart.weekday, 7);
      expect(sundayStart.weekday, 7);
      
      // All should be the same date
      expect(mondayStart, equals(DateTime(2024, 1, 7)));
      expect(wednesdayStart, equals(DateTime(2024, 1, 7)));
      expect(saturdayStart, equals(DateTime(2024, 1, 7)));
      expect(sundayStart, equals(DateTime(2024, 1, 7)));
    });
    
    test('getEndOfWeek should return Saturday', () {
      final monday = DateTime(2024, 1, 8);
      final endOfWeek = DateUtils.getEndOfWeek(monday);
      
      expect(endOfWeek.weekday, 6); // Saturday is 6
      expect(endOfWeek, equals(DateTime(2024, 1, 13)));
    });
    
    test('getLastWeekStart should return previous Sunday', () {
      final currentDate = DateTime(2024, 1, 10); // Wednesday
      final lastWeekStart = DateUtils.getLastWeekStart(currentDate);
      
      expect(lastWeekStart.weekday, 7); // Sunday
      expect(lastWeekStart, equals(DateTime(2023, 12, 31))); // Previous Sunday
    });
    
    test('getNextWeekStart should return next Sunday', () {
      final currentDate = DateTime(2024, 1, 10); // Wednesday
      final nextWeekStart = DateUtils.getNextWeekStart(currentDate);
      
      expect(nextWeekStart.weekday, 7); // Sunday
      expect(nextWeekStart, equals(DateTime(2024, 1, 14))); // Next Sunday
    });
    
    test('isSameWeek should correctly identify same week', () {
      final monday = DateTime(2024, 1, 8);
      final wednesday = DateTime(2024, 1, 10);
      final nextMonday = DateTime(2024, 1, 15);
      
      expect(DateUtils.isSameWeek(monday, wednesday), isTrue);
      expect(DateUtils.isSameWeek(monday, nextMonday), isFalse);
    });
    
    test('isLastWeek should correctly identify last week', () {
      final currentDate = DateTime(2024, 1, 10); // Wednesday of current week
      final lastWeekDate = DateTime(2024, 1, 3); // Wednesday of last week
      final thisWeekDate = DateTime(2024, 1, 10); // Same week
      final nextWeekDate = DateTime(2024, 1, 17); // Next week
      
      expect(DateUtils.isLastWeek(lastWeekDate, currentDate), isTrue);
      expect(DateUtils.isLastWeek(thisWeekDate, currentDate), isFalse);
      expect(DateUtils.isLastWeek(nextWeekDate, currentDate), isFalse);
    });
    
    test('isThisWeek should correctly identify current week', () {
      final currentDate = DateTime(2024, 1, 10); // Wednesday
      final sameWeekDate = DateTime(2024, 1, 8); // Monday of same week
      final lastWeekDate = DateTime(2024, 1, 3); // Last week
      final nextWeekDate = DateTime(2024, 1, 17); // Next week
      
      expect(DateUtils.isThisWeek(sameWeekDate, currentDate), isTrue);
      expect(DateUtils.isThisWeek(lastWeekDate, currentDate), isFalse);
      expect(DateUtils.isThisWeek(nextWeekDate, currentDate), isFalse);
    });
    
    test('isNextWeek should correctly identify next week', () {
      final currentDate = DateTime(2024, 1, 10); // Wednesday
      final nextWeekDate = DateTime(2024, 1, 17); // Next Wednesday
      final thisWeekDate = DateTime(2024, 1, 10); // Same week
      final lastWeekDate = DateTime(2024, 1, 3); // Last week
      
      expect(DateUtils.isNextWeek(nextWeekDate, currentDate), isTrue);
      expect(DateUtils.isNextWeek(thisWeekDate, currentDate), isFalse);
      expect(DateUtils.isNextWeek(lastWeekDate, currentDate), isFalse);
    });
  });
}
