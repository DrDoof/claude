---
doc_type: "prd"
doc_id: "EBS-Flutter-Console-Mock"
version: "1.0.0"
status: "active"
owner: "BRACELET STUDIO"
created: "2026-03-05"
depends_on:
  - "EBS-UI-Design-v3.prd.md (UI 설계 원본)"
  - "figma/mockups/index.html (HTML Hi-Fi 프로토타입)"
---

# EBS Console Flutter Mock App PRD

## 1. 개요

### 1.1 목적

HTML Hi-Fi 목업(`figma/mockups/console/`)과 PRD v3.0의 Console 설계를 **Flutter Desktop (Windows)** 앱으로 구현한다. 모든 백엔드 기능(RFID, WebSocket, NDI, Game Engine)은 mock 데이터로 대체하여 **UI만 검증** 가능한 인터랙티브 프로토타입을 만든다.

### 1.2 범위

| 포함 | 제외 |
|------|------|
| Console 6화면 (C01-C06) | Action Tracker (AT) |
| Mock 데이터 레이어 | 실제 RFID/WebSocket 연동 |
| 탭 전환/네비게이션 | Overlay 렌더링 엔진 |
| Rive 상태 애니메이션 | NDI/DeckLink 출력 |
| Dark Glassmorphism 테마 | 실제 비디오 입력 |

### 1.3 기술 스택

| 항목 | 선택 |
|------|------|
| Framework | Flutter 3.41+ (Desktop Windows) |
| 언어 | Dart |
| 상태 관리 | Riverpod |
| 애니메이션 | Rive + Flutter 내장 |
| 폰트 | Inter (UI) + JetBrains Mono (데이터) |
| 디자인 | PRD v3.0 색상 토큰 + Glassmorphism |

## 2. 화면 설계 (Console 6화면)

### 2.1 공통 레이아웃 (3-Column Hybrid)

```
+--[Header 40px]---------------------------+
| EBS | Table: Main Event #3 | [Cmd+K] LIVE |
+--[Sidebar 220px]+--[Preview]+--[Panel 320px]--+
| Tables           | 16:9     | [Sources]       |
|  Main Event #3   | Chroma   | [Outputs]       |
|  Cash Game #1    | Preview  | [GFX]           |
| Quick Actions    |          | [System]        |
| Connection       |          | (설정 내용)      |
+--[Status Bar 36px]------------------------+
| RFID: Connected | Hand #247 | CPU 12% MEM 45% |
+-----------------------------------------------+
```

### 2.2 C01: Main (Dashboard)

- Header: EBS 로고, 테이블명, Cmd+K 버튼, LIVE 뱃지
- Sidebar: 테이블 목록 (3개 mock), Quick Actions (4개), Connection (3개)
- Preview: 16:9 chroma-key blue 캔버스, POT 표시, 플레이어 슬롯 9개
- Panel: Sources 탭 활성 (Video Input, Camera Mode, Chroma Key, Board Sync)
- Status Bar: RFID, Hand#, Delay, CPU/MEM

### 2.3 C02: Sources 탭

- Panel: Video Sources 테이블 (4행: Camera1/2, NDI1/2)
- Camera Mode: STATIC/DYNAMIC 세그먼트 토글
- Chroma Key: Enable 토글 + Color 스와치
- ATEM Control: Switcher, IP, Enable

### 2.4 C03: Outputs 탭

- Panel: Resolution (Video Size 드롭다운, 9x16 토글, Frame Rate)
- Live Pipeline: Video/Audio/Device Output 드롭다운
- Fill & Key: Enable 토글, Key Color, 듀얼 미니 프리뷰

### 2.5 C04: GFX 탭

- Panel: Layout (Board Position, Player Layout, Margins)
- Card & Player: Reveal Players, Show Fold, Reveal Cards
- Animation: Transition In/Out (타입+시간), Indent/Bounce 토글
- Branding: Sponsor Logo 드롭존 2개

### 2.6 C05: System 탭

- Panel: RFID (Connected 상태, Reset/Calibrate, 안테나 토글 3개)
- Table: Name/Password 입력
- Action Tracker: Allow Access, Predictive Bet 토글
- Diagnostics: Table Diagnostics/System Log 버튼, Export Folder
- Startup: Auto Start 토글

### 2.7 C06: Command Palette (Modal)

- 배경 dimming + blur
- 560px 모달: 검색 입력 + ESC 키
- Results: Recent (2건) + Commands (5건)
- Footer: 키보드 단축키 가이드

## 3. Mock 데이터 설계

### 3.1 MockGameState

```dart
class MockGameState {
  String tableName;          // "Main Event #3"
  String gamePhase;          // PRE_FLOP, FLOP, TURN, RIVER, SHOWDOWN
  int handNumber;            // 247
  int potAmount;             // 2450
  List<MockPlayer> players;  // 9 slots
  bool isLive;               // true
  Duration delay;            // Duration(seconds: 28)
}
```

### 3.2 MockPlayer

```dart
class MockPlayer {
  int seat;          // 1-9
  String name;       // "KIM"
  int stack;         // 48200
  bool isActive;     // true
  bool isDealer;     // false
  String? action;    // "BET", "CALL", "FOLD"
}
```

### 3.3 MockSystemState

```dart
class MockSystemState {
  bool rfidConnected;     // true
  bool atConnected;       // true
  bool engineOk;          // true
  double cpuUsage;        // 0.12
  double memUsage;        // 0.45
  String cameraMode;      // "STATIC"
  bool chromaKeyEnabled;  // true
  Color chromaKeyColor;   // Color(0xFF0000FF)
}
```

## 4. 색상 토큰 (PRD v3.0 매핑)

| 토큰 | Hex | 용도 |
|------|-----|------|
| bgPrimary | #0D0D1A | 메인 배경 |
| bgSecondary | #1A1A2E | 사이드바/헤더 |
| bgTertiary | #16213E | 설정 패널 |
| accentGold | #D4AF37 | 주요 강조 |
| accentBlue | #00D4FF | 보조 강조 |
| accentNeon | #FF6B35 | 알림/경고 |
| textPrimary | #FFFFFF | 주요 텍스트 |
| textSecondary | #A0A0B0 | 보조 텍스트 |
| textMuted | #606070 | 비활성 텍스트 |
| success | #4CAF50 | 연결 성공 |
| danger | #FF4444 | 에러/LIVE |
| warning | #FFC107 | 경고/딜레이 |

## 5. Rive 애니메이션 계획

| 요소 | 애니메이션 | 상태 머신 |
|------|----------|----------|
| Status Indicator | pulse (live), steady (active), dim (idle) | 3-state |
| LIVE Badge | pulse-red 1.5s infinite | 1-state loop |
| Toggle Switch | slide + color transition | on/off |
| Tab Underline | slide-x to active tab | position-based |
| Sidebar Item | hover highlight + active gold border | 3-state |

## 6. 파일 구조

```
ebs_console/
  lib/
    main.dart
    app.dart
    theme/
      ebs_theme.dart         # 색상 토큰 + 텍스트 스타일
      ebs_colors.dart
    models/
      mock_game_state.dart
      mock_player.dart
      mock_system_state.dart
    providers/
      game_state_provider.dart
      system_state_provider.dart
      tab_provider.dart
    screens/
      console_screen.dart     # 메인 3-column 레이아웃
      command_palette.dart    # 모달 오버레이
    widgets/
      header/
        app_header.dart
      sidebar/
        sidebar.dart
        table_list.dart
        quick_actions.dart
        connection_status.dart
      preview/
        live_preview.dart
        player_slot.dart
      panel/
        settings_panel.dart
        sources_tab.dart
        outputs_tab.dart
        gfx_tab.dart
        system_tab.dart
      status_bar/
        status_bar.dart
      common/
        ebs_badge.dart
        ebs_toggle.dart
        ebs_button.dart
        segment_toggle.dart
        setting_row.dart
        status_indicator.dart
        color_swatch.dart
  pubspec.yaml
```

## 7. 구현 우선순위

| 순서 | 항목 | 이유 |
|:----:|------|------|
| 1 | Theme + Colors + 공통 위젯 | 모든 화면의 기반 |
| 2 | 3-Column 레이아웃 셸 | 구조 확립 |
| 3 | Header + Status Bar | 고정 요소 |
| 4 | Sidebar | 네비게이션 |
| 5 | Live Preview | 중앙 핵심 |
| 6 | Sources/Outputs/GFX/System 탭 | 설정 패널 |
| 7 | Command Palette | 모달 오버레이 |
| 8 | Mock 데이터 연동 | 상태 변경 시연 |

## 8. 검증 기준

| 항목 | 기준 |
|------|------|
| 레이아웃 | HTML 목업과 1:1 매칭 (3-column, 고정폭) |
| 색상 | PRD v3.0 토큰 100% 적용 |
| 폰트 | Inter + JetBrains Mono |
| 인터랙션 | 탭 전환, 토글, 사이드바 선택 동작 |
| 반응성 | 1920x1080 기준, 1024x768 최소 |
| Mock 데이터 | 모든 화면에 의미 있는 샘플 데이터 표시 |

## Changelog

| 날짜 | 버전 | 변경 내용 | 결정 근거 |
|------|------|-----------|----------|
| 2026-03-05 | v1.0.0 | 최초 작성 | HTML 목업 + PRD v3.0 분석 기반 |
