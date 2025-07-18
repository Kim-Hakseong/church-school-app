import 'package:flutter/material.dart';
import '../providers/verse_provider.dart';
import 'package:intl/intl.dart';

class VerseCard extends StatelessWidget {
  final String title;
  final WeekType weekType;
  final String sheetName;
  final VerseProvider provider;
  
  const VerseCard({
    Key? key,
    required this.title,
    required this.weekType,
    required this.sheetName,
    required this.provider,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final verse = provider.getVerseForWeek(sheetName, weekType);
    
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getColorForWeekType(weekType),
              ),
            ),
            const SizedBox(height: 12),
            if (verse != null) ...[
              if (verse.extra != null && verse.extra!.isNotEmpty) ...[
                Text(
                  verse.extra!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Text(
                verse.text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                DateFormat('yyyy년 M월 d일').format(verse.date),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.book_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '해당 주의 말씀이 없습니다',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Color _getColorForWeekType(WeekType weekType) {
    switch (weekType) {
      case WeekType.last:
        return Colors.grey[600]!;
      case WeekType.current:
        return Colors.blue[700]!;
      case WeekType.next:
        return Colors.green[600]!;
    }
  }
}
