import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/verse_provider.dart';
import '../widgets/verse_card.dart';

class AgeGroupScreen extends StatelessWidget {
  final String sheetName;
  final String displayName;
  
  const AgeGroupScreen({
    Key? key,
    required this.sheetName,
    required this.displayName,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Consumer<VerseProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('말씀을 불러오는 중...'),
              ],
            ),
          );
        }
        
        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  provider.error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red[700]),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.refresh(),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          );
        }
        
        return RefreshIndicator(
          onRefresh: () => provider.refresh(),
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '$displayName 암송구절',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              VerseCard(
                title: '지난주 말씀',
                weekType: WeekType.last,
                sheetName: sheetName,
                provider: provider,
              ),
              VerseCard(
                title: '이번주 말씀',
                weekType: WeekType.current,
                sheetName: sheetName,
                provider: provider,
              ),
              VerseCard(
                title: '다음주 말씀',
                weekType: WeekType.next,
                sheetName: sheetName,
                provider: provider,
              ),
            ],
          ),
        );
      },
    );
  }
}
