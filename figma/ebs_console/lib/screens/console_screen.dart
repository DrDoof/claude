import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../widgets/header/app_header.dart';
import '../widgets/sidebar/sidebar.dart';
import '../widgets/preview/live_preview.dart';
import '../widgets/panel/settings_panel.dart';
import '../widgets/status_bar/status_bar.dart';
import 'command_palette.dart';

class ConsoleScreen extends ConsumerWidget {
  const ConsoleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showPalette = ref.watch(commandPaletteVisibleProvider);

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyK, meta: true): () {
          ref.read(commandPaletteVisibleProvider.notifier).state = true;
        },
        const SingleActivator(LogicalKeyboardKey.keyK, control: true): () {
          ref.read(commandPaletteVisibleProvider.notifier).state = true;
        },
        const SingleActivator(LogicalKeyboardKey.escape): () {
          ref.read(commandPaletteVisibleProvider.notifier).state = false;
        },
      },
      child: Focus(
        autofocus: true,
        child: Stack(
          children: [
            // Main 3-column layout
            Column(
              children: [
                // Header
                const AppHeader(),
                // Body: Sidebar | Preview | Settings Panel
                Expanded(
                  child: Row(
                    children: const [
                      Sidebar(),
                      Expanded(child: LivePreview()),
                      SettingsPanel(),
                    ],
                  ),
                ),
                // Status Bar
                const EbsStatusBar(),
              ],
            ),
            // Command Palette overlay
            if (showPalette) const CommandPalette(),
          ],
        ),
      ),
    );
  }
}
