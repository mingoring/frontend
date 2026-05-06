## 핵심 기술 스택
- **언어**: Dart 3.6.0
- **프레임워크**: Flutter 3.27.0
- **상태 관리**:
  - flutter_riverpod: 2.6.1
  - riverpod: 2.6.1
  - riverpod_annotation: 2.6.1
  - riverpod_generator: 2.6.4 (dev)
- **아키텍처**: MVVM + Clean Architecture (Layered Architecture)
- **직렬화**:
  - freezed: 2.5.8 (dev)
  - freezed_annotation: 2.4.4
  - json_serializable: 6.9.5 (dev)
  - json_annotation: 4.9.0
- **코드 생성**: build_runner: 2.5.4 (dev)
- **린트**: flutter_lints: 5.0.0 (dev)


## 디렉토리 구조 (기준안)
```
lib/
├── main.dart
├── core/                    # 전역 공유 코드
│   ├── constants/           # 상수 (색상, 문자열, 사이즈 등)
│   ├── utils/               # 공통 유틸 함수
│   ├── extensions/          # extension 메서드
│   └── errors/              # 공통 에러 정의
│
├── data/                    # 데이터 계층 (구현 중심)
│   ├── models/              # DTO / 데이터 모델 (JSON 직렬화)
│   ├── repositories/        # Repository 구현체 (Domain의 인터페이스 구현)
│   └── datasources/         # 데이터 소스 (API, Local DB)
│       ├── remote/          # 원격 API 호출
│       └── local/           # 로컬 저장소
│
├── domain/                  # 비즈니스 로직 계층
│   ├── entities/            # 순수 비즈니스 엔티티 (JSON 의존성 X)
│   ├── repositories/        # Repository 인터페이스 (추상)
│   └── usecases/            # 유스케이스 (행동 단위)
│
└── presentation/            # UI 계층
    ├── screens/             # 화면(Page)
    ├── widgets/             # 재사용 UI 컴포넌트
    ├── themes/              # Theme, ColorScheme
    └── viewmodels/          # 상태 관리 (MVVM)
```


## 코드 생성 명령어
```bash
# 코드 생성 실행 (한 번만)
flutter pub run build_runner build

# 코드 생성 실행 (변경 감지 및 자동 재생성)
flutter pub run build_runner watch

# 기존 생성 파일 삭제 후 재생성
flutter pub run build_runner build --delete-conflicting-outputs
```


## 실행 명령어
### 1. 가상 기기(에뮬레이터) 실행

Android:
```bash
# 등록된 에뮬레이터 목록 확인
flutter emulators

# 에뮬레이터 시작
flutter emulators --launch <emulator-id>
```
IOS:
```bash
# 에뮬레이터 시작
open -a Simulator
```
Simulator 실행 후 [File > Open Simulator > iOS]에서 iPhone 기종 선택 가능


### 2. 앱 실행
Android & IOS:
```bash
# 연결된 디바이스 확인
flutter devices

# 디바이스 ID로 실행
flutter run -d <device-id>
```

### 3. 작업 후 reload
실행 중이면 r 키 누르기
- hot reload(r): 위젯 트리만 다시 빌드
- hot restart(R): 앱 상태를 초기화하고 전체를 다시 시작 (클래스 구조 변경 시에는 항상 hot restart가 필요)