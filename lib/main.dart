import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/verse_provider.dart';
import 'screens/calendar_screen.dart';
import 'screens/age_group_screen.dart';

void main() {
  runApp(const ChurchSchoolApp());
}

class ChurchSchoolApp extends StatelessWidget {
  const ChurchSchoolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VerseProvider(),
      child: MaterialApp(
        title: '교회학교 암송 어플',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          fontFamily: 'NotoSans',
        ),
        home: const MainScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    final provider = Provider.of<VerseProvider>(context, listen: false);
    await provider.initialize();
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.church,
                size: 100,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const Text(
                '교회학교 암송 어플',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text('앱을 초기화하는 중...'),
            ],
          ),
        ),
      );
    }

    return Consumer<VerseProvider>(
      builder: (context, provider, child) {
        if (provider.error != null) {
          return Scaffold(
            body: Center(
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
                    onPressed: () => _initializeApp(),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: const [
              CalendarScreen(),
              AgeGroupScreen(sheetName: '유치부', displayName: '유치부'),
              AgeGroupScreen(sheetName: '초등부', displayName: '초등부'),
              AgeGroupScreen(sheetName: '중고등부', displayName: '중고등부'),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: '교회학교 캘린더',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.child_care),
                label: '유치부',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: '초등부',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.groups),
                label: '중고등부',
              ),
            ],
          ),
        );
      },
    );
  }
}
