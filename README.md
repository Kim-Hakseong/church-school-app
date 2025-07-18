# 교회학교 암송 어플 (Church School Memorization App)

Flutter 하이브리드 앱으로 개발된 교회학교 암송구절 관리 애플리케이션입니다.

## 프로젝트 개요

- **프로젝트명**: 교회학교 암송 어플
- **대상 OS**: iOS / Android (Flutter 하이브리드)
- **데이터 소스**: Excel 파일 (`assets/verses.xlsx`)
- **핵심 기능**: 주간별 암송구절 표시 및 월간 캘린더 이벤트 관리

## 주요 기능

### 1. 주간별 암송구절 표시
- 오늘 날짜 기준으로 "지난주/이번주/다음주" 암송구절 자동 표시
- 주일(일요일)을 주의 첫날로 정의한 주간 계산
- 연령별 구분: 유치부, 초등부, 중고등부

### 2. 월간 캘린더
- `table_calendar` 패키지를 사용한 월간 캘린더
- Excel에서 로드한 이벤트 표시
- 날짜별 상세 정보 확인 가능

### 3. 오프라인 저장
- 첫 실행 시 Excel 파일 파싱 후 Hive 로컬 DB에 저장
- 앱 재실행 시 오프라인 데이터 조회 가능

### 4. UI/UX
- 4개 탭 BottomNavigationBar
  1. 교회학교 캘린더
  2. 유치부
  3. 초등부
  4. 중고등부
- 전체 한글 UI
- 카드 형태의 직관적인 구절 표시

## 기술 스택

### Flutter 패키지
- **excel**: Excel 파일 파싱
- **hive & hive_flutter**: 로컬 데이터베이스
- **path_provider**: 파일 경로 관리
- **table_calendar**: 캘린더 UI
- **provider**: 상태 관리
- **intl**: 국제화 및 날짜 포맷팅

### 아키텍처
- **Clean Architecture** 패턴 적용
- **Provider** 패턴을 통한 상태 관리
- **Repository** 패턴을 통한 데이터 계층 분리

## 프로젝트 구조

```
lib/
├── main.dart                 # 앱 진입점
├── models/                   # 데이터 모델
│   ├── verse.dart           # 암송구절 모델
│   └── event.dart           # 이벤트 모델
├── services/                 # 데이터 서비스
│   ├── excel_loader.dart    # Excel 파일 로더
│   └── verse_repository.dart # 데이터 저장소
├── providers/               # 상태 관리
│   └── verse_provider.dart  # 구절 상태 관리
├── screens/                 # 화면
│   ├── calendar_screen.dart # 캘린더 화면
│   └── age_group_screen.dart # 연령별 구절 화면
├── widgets/                 # 위젯
│   └── verse_card.dart      # 구절 카드 위젯
└── utils/                   # 유틸리티
    └── date_utils.dart      # 날짜 계산 유틸
```

## 빌드 및 실행 방법

### 사전 요구사항
- Flutter 3.22.0 이상
- Dart SDK
- Android Studio (Android 빌드 시)
- Xcode (iOS 빌드 시)

### 설치 및 실행

1. **저장소 클론**
```bash
git clone <repository-url>
cd church_school_app
```

2. **의존성 설치**
```bash
flutter pub get
```

3. **코드 생성 (Hive 어댑터)**
```bash
flutter packages pub run build_runner build
```

4. **앱 실행**

**웹에서 실행:**
```bash
flutter run -d web-server --web-port=8080
```

**Android에서 실행:**
```bash
flutter run -d android
```

**iOS에서 실행:**
```bash
flutter run -d ios
```

### 빌드

**Android APK 빌드:**
```bash
flutter build apk --release
```

**iOS 빌드:**
```bash
flutter build ios --release
```

**웹 빌드:**
```bash
flutter build web --release
```

## 테스트

### 단위 테스트 실행
```bash
flutter test
```

### 테스트 커버리지
- 날짜 로직 테스트 (`test/date_utils_test.dart`)
- Excel 파싱 테스트 (`test/excel_loader_test.dart`)
- 위젯 테스트 (`test/widget_test.dart`)

## 데이터 구조

### Excel 파일 구조
- **시트**: 유치부, 초등부, 중고등부, 초등월암송
- **열 구조**: 
  - Column A: 공과명
  - Column B: 암송구절
  - Column C: 날짜

### 데이터 모델

**Verse 모델:**
```dart
class Verse {
  final DateTime date;    // 날짜
  final String text;      // 암송구절
  final String? extra;    // 추가 정보 (공과명)
}
```

**Event 모델:**
```dart
class Event {
  final DateTime date;    // 날짜
  final String title;     // 이벤트 제목
  final String? note;     // 추가 노트
}
```

## 주요 기능 설명

### 날짜 계산 로직
- 주일(일요일)을 주의 시작으로 정의
- 현재 날짜 기준으로 지난주/이번주/다음주 계산
- 정확한 주간 매칭이 없을 경우 연도별 주차를 이용한 순환 로직 적용

### 오프라인 저장
- 첫 실행 시 Excel 파일을 파싱하여 Hive 데이터베이스에 저장
- 이후 실행 시 로컬 데이터 사용으로 빠른 로딩
- 데이터 새로고침 기능 제공

### 에러 처리
- Excel 파싱 실패 시 사용자 친화적 에러 메시지
- 네트워크 오류 및 데이터 로딩 실패 처리
- 빈 데이터 상태에 대한 적절한 UI 표시

## 문제 해결

### 일반적인 문제들

1. **Flutter 버전 호환성**
   - Flutter 3.22.0 이상 사용 권장
   - `flutter doctor` 명령어로 환경 확인

2. **의존성 충돌**
   - `flutter clean` 후 `flutter pub get` 재실행
   - `pubspec.yaml`의 버전 호환성 확인

3. **빌드 오류**
   - `flutter packages pub run build_runner clean` 후 재빌드
   - 캐시 삭제: `flutter clean`

## 라이선스

이 프로젝트는 교회학교 교육 목적으로 개발되었습니다.

## 개발자 정보

- **개발**: Devin AI Assistant
- **요청자**: 김학성 (@Kim-Hakseong)
- **개발 세션**: https://app.devin.ai/sessions/80469388d0394fb99b919b1bef2e8f85
