import 'package:flutter/foundation.dart';
import '../models/verse.dart';
import '../models/event.dart';
import '../services/verse_repository.dart';
import '../utils/date_utils.dart';

class VerseProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  Map<String, List<Verse>> _allVerses = {};
  List<Event> _allEvents = [];
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Event> get allEvents => _allEvents;
  
  Future<void> initialize() async {
    _setLoading(true);
    _setError(null);
    
    try {
      await VerseRepository.initialize();
      await VerseRepository.loadAndCacheData();
      await _loadData();
    } catch (e) {
      _setError('데이터를 불러오는 중 오류가 발생했습니다: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  Future<void> _loadData() async {
    try {
      // Load verses for each sheet
      final sheets = ['유치부', '초등부', '중고등부'];
      for (String sheet in sheets) {
        _allVerses[sheet] = VerseRepository.getVersesForSheet(sheet);
      }
      
      // Load events
      _allEvents = VerseRepository.getAllEvents();
      
      // Don't call notifyListeners here as it will be called by _setLoading(false)
    } catch (e) {
      _setError('데이터 로딩 중 오류: $e');
    }
  }
  
  List<Verse> getVersesForSheet(String sheetName) {
    return _allVerses[sheetName] ?? [];
  }
  
  Verse? getVerseForWeek(String sheetName, WeekType weekType) {
    final verses = getVersesForSheet(sheetName);
    if (verses.isEmpty) return null;
    
    final now = DateTime.now();
    
    // First try to find exact week matches
    for (Verse verse in verses) {
      switch (weekType) {
        case WeekType.last:
          if (DateUtils.isLastWeek(verse.date, now)) {
            return verse;
          }
          break;
        case WeekType.current:
          if (DateUtils.isThisWeek(verse.date, now)) {
            return verse;
          }
          break;
        case WeekType.next:
          if (DateUtils.isNextWeek(verse.date, now)) {
            return verse;
          }
          break;
      }
    }
    
    // If no exact match found, use week-of-year logic to cycle through verses
    final currentWeekOfYear = DateUtils.getWeekOfYear(now);
    final versesCount = verses.length;
    
    if (versesCount == 0) return null;
    
    int targetWeekOffset = 0;
    switch (weekType) {
      case WeekType.last:
        targetWeekOffset = -1;
        break;
      case WeekType.current:
        targetWeekOffset = 0;
        break;
      case WeekType.next:
        targetWeekOffset = 1;
        break;
    }
    
    final targetWeek = currentWeekOfYear + targetWeekOffset;
    final verseIndex = (targetWeek - 1) % versesCount;
    final adjustedIndex = verseIndex < 0 ? versesCount + verseIndex : verseIndex;
    
    return verses[adjustedIndex];
  }
  
  List<Event> getEventsForDate(DateTime date) {
    return _allEvents.where((event) {
      return event.date.year == date.year &&
             event.date.month == date.month &&
             event.date.day == date.day;
    }).toList();
  }
  
  Future<void> refresh() async {
    await VerseRepository.clearCache();
    await initialize();
  }
  
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }
}

enum WeekType { last, current, next }
