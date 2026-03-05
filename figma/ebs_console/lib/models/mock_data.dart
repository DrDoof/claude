enum TableStatus { active, idle }
enum GamePhase { preFlop, flop, turn, river, showdown }
enum ConnectionStatus { connected, disconnected }
enum SourceStatus { active, inactive, noSignal }

class MockTable {
  final String name;
  final TableStatus status;
  final GamePhase? phase;

  const MockTable({
    required this.name,
    required this.status,
    this.phase,
  });
}

class MockPlayer {
  final int seat;
  final String? name;
  final int? stack;
  bool get isEmpty => name == null;

  const MockPlayer({required this.seat, this.name, this.stack});
}

class MockVideoSource {
  final String name;
  final String? format;
  final SourceStatus status;
  final bool isLive;
  final bool isRecording;

  const MockVideoSource({
    required this.name,
    this.format,
    required this.status,
    this.isLive = false,
    this.isRecording = false,
  });
}

class MockCommandItem {
  final String command;
  final String description;
  final String category;
  final bool isRecent;

  const MockCommandItem({
    required this.command,
    required this.description,
    required this.category,
    this.isRecent = false,
  });
}

class MockGameState {
  final List<MockTable> tables;
  final List<MockPlayer> players;
  final int handNumber;
  final int pot;
  final bool isLive;
  final String activeTableName;

  const MockGameState({
    required this.tables,
    required this.players,
    required this.handNumber,
    required this.pot,
    required this.isLive,
    required this.activeTableName,
  });
}

class MockSystemState {
  final ConnectionStatus rfid;
  final ConnectionStatus at;
  final ConnectionStatus engine;
  final int cpuPercent;
  final int memPercent;
  final String delayTime;

  const MockSystemState({
    required this.rfid,
    required this.at,
    required this.engine,
    required this.cpuPercent,
    required this.memPercent,
    required this.delayTime,
  });
}

// Default mock data
class MockData {
  MockData._();

  static const gameState = MockGameState(
    tables: [
      MockTable(name: 'Main Event #3', status: TableStatus.active, phase: GamePhase.preFlop),
      MockTable(name: 'Cash Game #1', status: TableStatus.idle),
      MockTable(name: 'Cash Game #2', status: TableStatus.idle),
    ],
    players: [
      MockPlayer(seat: 1, name: 'KIM', stack: 48200),
      MockPlayer(seat: 2),
      MockPlayer(seat: 3, name: 'LEE', stack: 31750),
      MockPlayer(seat: 4),
      MockPlayer(seat: 5, name: 'PARK', stack: 12900),
      MockPlayer(seat: 6),
      MockPlayer(seat: 7),
      MockPlayer(seat: 8),
      MockPlayer(seat: 9),
    ],
    handNumber: 247,
    pot: 2450,
    isLive: true,
    activeTableName: 'Main Event #3',
  );

  static const systemState = MockSystemState(
    rfid: ConnectionStatus.connected,
    at: ConnectionStatus.connected,
    engine: ConnectionStatus.connected,
    cpuPercent: 12,
    memPercent: 45,
    delayTime: '00:28',
  );

  static const videoSources = [
    MockVideoSource(name: 'Camera 1', format: '1080p60', status: SourceStatus.active, isLive: true),
    MockVideoSource(name: 'Camera 2', format: '720p30', status: SourceStatus.inactive),
    MockVideoSource(name: 'NDI Input 1', status: SourceStatus.noSignal),
    MockVideoSource(name: 'NDI Input 2', status: SourceStatus.noSignal),
  ];

  static const commandItems = [
    MockCommandItem(command: 'show leaderboard', description: 'Show Leaderboard overlay', category: 'OVERLAY', isRecent: true),
    MockCommandItem(command: 'hide player 3', description: 'Hide Player 3 Graphic', category: 'OVERLAY', isRecent: true),
    MockCommandItem(command: 'reset', description: 'Reset current hand', category: 'SYSTEM'),
    MockCommandItem(command: 'theme dark-blue', description: 'Switch theme', category: 'SYSTEM'),
    MockCommandItem(command: 'output ndi-1', description: 'Change NDI output', category: 'SYSTEM'),
    MockCommandItem(command: 'delay 30', description: 'Set Secure Delay to 30s', category: 'SYSTEM'),
    MockCommandItem(command: 'register deck', description: 'Start RFID deck registration', category: 'RFID'),
  ];
}
