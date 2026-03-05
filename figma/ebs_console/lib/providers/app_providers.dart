import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mock_data.dart';

// Active tab index for settings panel (0=Sources, 1=Outputs, 2=GFX, 3=System)
final activeTabProvider = StateProvider<int>((ref) => 0);

// Command palette visibility
final commandPaletteVisibleProvider = StateProvider<bool>((ref) => false);

// Game state
final gameStateProvider = Provider<MockGameState>((ref) => MockData.gameState);

// System state
final systemStateProvider = Provider<MockSystemState>((ref) => MockData.systemState);

// Video sources
final videoSourcesProvider = Provider<List<MockVideoSource>>((ref) => MockData.videoSources);

// Command items
final commandItemsProvider = Provider<List<MockCommandItem>>((ref) => MockData.commandItems);

// Settings state providers
final chromaKeyEnabledProvider = StateProvider<bool>((ref) => true);
final cameraModeProvider = StateProvider<int>((ref) => 0); // 0=STATIC, 1=DYNAMIC
final chromaColorProvider = StateProvider<int>((ref) => 0xFF0000FF);

// Outputs
final resolutionProvider = StateProvider<String>((ref) => '1920x1080');
final frameRateProvider = StateProvider<String>((ref) => '60fps');
final fillKeyEnabledProvider = StateProvider<bool>((ref) => true);
final verticalOutputProvider = StateProvider<bool>((ref) => false);

// GFX
final boardPositionProvider = StateProvider<String>((ref) => 'Centre');
final playerLayoutProvider = StateProvider<String>((ref) => 'Horizontal');
final revealPlayersProvider = StateProvider<String>((ref) => 'On Action');
final transitionInProvider = StateProvider<String>((ref) => 'Slide');
final transitionOutProvider = StateProvider<String>((ref) => 'Fade');

// System
final allowAtAccessProvider = StateProvider<bool>((ref) => true);
final predictiveBetProvider = StateProvider<bool>((ref) => true);
final autoStartProvider = StateProvider<bool>((ref) => false);
final upcardAntennasProvider = StateProvider<bool>((ref) => false);
final disableMuckProvider = StateProvider<bool>((ref) => false);
final disableCommunityProvider = StateProvider<bool>((ref) => false);
final atemControlProvider = StateProvider<bool>((ref) => false);
