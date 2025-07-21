import 'package:flutter/material.dart';
import '../providers/verse_provider.dart';
import 'package:intl/intl.dart';

class VerseCard extends StatelessWidget {
  final String title;
  final WeekType weekType;
  final String sheetName;
  final VerseProvider provider;
  
  const VerseCard({
    super.key,
    required this.title,
    required this.weekType,
    required this.sheetName,
    required this.provider,
  });
  
  @override
  Widget build(BuildContext context) {
    final verse = provider.getVerseForWeek(sheetName, weekType);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isCompact = screenWidth < 600 || screenHeight < 700;
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isCompact ? 8.0 : 12.0,
        vertical: isCompact ? 4.0 : 6.0,
      ),
      decoration: BoxDecoration(
        gradient: _getGradientForWeekType(weekType),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 14.0 : 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 10 : 12, 
                    vertical: isCompact ? 4 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: isCompact ? 12 : 14,
                      fontWeight: FontWeight.w600,
                      color: _getColorForWeekType(weekType),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: isCompact ? 8 : 12),
            if (verse != null) ...[
              if (verse.extra != null && verse.extra!.isNotEmpty) ...[
                Text(
                  verse.extra!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _getColorForWeekType(weekType),
                    fontSize: isCompact ? 12 : 14,
                  ),
                ),
                SizedBox(height: isCompact ? 4 : 6),
              ],
              Text(
                verse.text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.3,
                  fontSize: isCompact ? 12 : 14,
                  color: Colors.black87,
                ),
                maxLines: isCompact ? 2 : 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isCompact ? 6 : 8),
              Text(
                DateFormat('yyyy년 M월 d일').format(verse.date),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _getColorForWeekType(weekType).withValues(alpha: 0.7),
                  fontSize: isCompact ? 10 : 11,
                ),
              ),
            ] else ...[
              Container(
                padding: EdgeInsets.all(isCompact ? 8 : 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.book_outlined,
                      size: isCompact ? 24 : 32,
                      color: _getColorForWeekType(weekType).withValues(alpha: 0.5),
                    ),
                    SizedBox(height: isCompact ? 4 : 6),
                    Text(
                      '해당 주의 말씀이 없습니다',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _getColorForWeekType(weekType).withValues(alpha: 0.7),
                        fontSize: isCompact ? 11 : 12,
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
        return const Color(0xFF8B7355);
      case WeekType.current:
        return const Color(0xFF5B7C99);
      case WeekType.next:
        return const Color(0xFF7A9B76);
    }
  }
  
  LinearGradient _getGradientForWeekType(WeekType weekType) {
    switch (weekType) {
      case WeekType.last:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF0EBE3),
            Color(0xFFE8E2D4),
          ],
        );
      case WeekType.current:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE3F2FD),
            Color(0xFFBBDEFB),
          ],
        );
      case WeekType.next:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8F5E8),
            Color(0xFFDCEDC8),
          ],
        );
    }
  }
}
