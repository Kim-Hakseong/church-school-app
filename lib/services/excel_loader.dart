import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import '../models/verse.dart';
import '../models/event.dart';

class ExcelLoader {
  static Future<Map<String, List<Verse>>> loadVerses() async {
    try {
      final ByteData data = await rootBundle.load('assets/verses.xlsx');
      final Uint8List bytes = data.buffer.asUint8List();
      final excel = Excel.decodeBytes(bytes);
      
      Map<String, List<Verse>> result = {};
      
      for (String sheetName in excel.tables.keys) {
        if (sheetName == '초등월암송') continue; // Skip monthly verses for now
        
        final sheet = excel.tables[sheetName];
        if (sheet == null) continue;
        
        List<Verse> verses = [];
        
        // Skip header row (row 0)
        for (int row = 1; row < sheet.maxRows; row++) {
          try {
            final lessonCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row));
            final verseCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row));
            final dateCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row));
            
            if (verseCell?.value != null && dateCell?.value != null) {
              final verseText = verseCell.value.toString();
              final dateValue = dateCell.value;
              
              DateTime? date;
              if (dateValue != null) {
                // Convert cell value to string and try to parse as DateTime
                final dateString = dateValue.toString();
                date = DateTime.tryParse(dateString);
              }
              
              if (date != null && verseText.isNotEmpty) {
                verses.add(Verse(
                  date: date,
                  text: verseText,
                  extra: lessonCell?.value?.toString(),
                ));
              }
            }
          } catch (e) {
            print('Error parsing row $row in sheet $sheetName: $e');
          }
        }
        
        result[sheetName] = verses;
      }
      
      return result;
    } catch (e) {
      print('Error loading Excel file: $e');
      return {};
    }
  }
  
  static Future<List<Event>> loadEvents() async {
    try {
      final ByteData data = await rootBundle.load('assets/verses.xlsx');
      final Uint8List bytes = data.buffer.asUint8List();
      final excel = Excel.decodeBytes(bytes);
      
      List<Event> events = [];
      
      for (String sheetName in excel.tables.keys) {
        final sheet = excel.tables[sheetName];
        if (sheet == null) continue;
        
        // Skip header row (row 0)
        for (int row = 1; row < sheet.maxRows; row++) {
          try {
            final lessonCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row));
            final verseCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row));
            final dateCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row));
            
            if (lessonCell?.value != null && dateCell?.value != null) {
              final lessonName = lessonCell.value.toString();
              final dateValue = dateCell.value;
              
              DateTime? date;
              if (dateValue != null) {
                // Convert cell value to string and try to parse as DateTime
                final dateString = dateValue.toString();
                date = DateTime.tryParse(dateString);
              }
              
              if (date != null && lessonName.isNotEmpty) {
                events.add(Event(
                  date: date,
                  title: '$sheetName - $lessonName',
                  note: verseCell?.value?.toString(),
                ));
              }
            }
          } catch (e) {
            print('Error parsing event row $row in sheet $sheetName: $e');
          }
        }
      }
      
      return events;
    } catch (e) {
      print('Error loading events: $e');
      return [];
    }
  }
}
