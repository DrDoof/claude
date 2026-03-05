import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/ebs_colors.dart';
import '../models/mock_data.dart';
import '../providers/app_providers.dart';

class CommandPalette extends ConsumerStatefulWidget {
  const CommandPalette({super.key});

  @override
  ConsumerState<CommandPalette> createState() => _CommandPaletteState();
}

class _CommandPaletteState extends ConsumerState<CommandPalette> {
  final int _selectedIndex = 0;
  final _controller = TextEditingController(text: 'show');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close() {
    ref.read(commandPaletteVisibleProvider.notifier).state = false;
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(commandItemsProvider);
    final recentItems = items.where((e) => e.isRecent).toList();
    final commandItems = items.where((e) => !e.isRecent).toList();

    return GestureDetector(
      onTap: _close,
      child: Container(
        color: const Color(0xB805050F), // 0.72 alpha
        child: Center(
          child: GestureDetector(
            onTap: () {}, // absorb taps on the palette itself
            child: Container(
              width: 560,
              decoration: BoxDecoration(
                color: const Color(0xF5141424), // 0.96 alpha
                border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
                borderRadius: BorderRadius.circular(EbsColors.borderRadiusLg),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.7),
                    blurRadius: 64,
                    offset: const Offset(0, 24),
                  ),
                  BoxShadow(
                    color: EbsColors.accentGold.withValues(alpha: 0.05),
                    blurRadius: 40,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Search bar
                  _SearchBar(controller: _controller, onClose: _close),
                  // Results
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 360),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Recent
                          const _SectionLabel('Recent'),
                          for (int i = 0; i < recentItems.length; i++)
                            _ResultRow(
                              item: recentItems[i],
                              isSelected: i == _selectedIndex,
                              isRecent: true,
                            ),
                          // Commands
                          const _SectionLabel('Commands'),
                          for (int i = 0; i < commandItems.length; i++)
                            _ResultRow(
                              item: commandItems[i],
                              isSelected: (i + recentItems.length) == _selectedIndex,
                              isRecent: false,
                            ),
                        ],
                      ),
                    ),
                  ),
                  // Footer
                  const _PaletteFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClose;

  const _SearchBar({required this.controller, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: EbsColors.accentGold.withValues(alpha: 0.15),
              border: Border.all(color: EbsColors.accentGold.withValues(alpha: 0.4)),
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: const Text(
              '\u2318',
              style: TextStyle(fontSize: 14, color: EbsColors.accentGold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: true,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 16,
                color: EbsColors.textPrimary,
              ),
              cursorColor: EbsColors.accentGold,
              decoration: InputDecoration(
                hintText: 'Type a command...',
                hintStyle: GoogleFonts.jetBrainsMono(
                  fontSize: 16,
                  color: EbsColors.textMuted,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          GestureDetector(
            onTap: onClose,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'ESC',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: EbsColors.textMuted,
                  letterSpacing: 0.44,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
          color: EbsColors.textMuted,
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final MockCommandItem item;
  final bool isSelected;
  final bool isRecent;

  const _ResultRow({
    required this.item,
    required this.isSelected,
    required this.isRecent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: isSelected
          ? EbsColors.accentGold.withValues(alpha: 0.07)
          : Colors.transparent,
      child: Row(
        children: [
          // Arrow
          SizedBox(
            width: 12,
            child: Text(
              isRecent ? '\u2191' : '\u00B7',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? EbsColors.accentGold : EbsColors.textMuted,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Command
          Expanded(
            child: Text(
              item.command,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: EbsColors.textPrimary,
              ),
            ),
          ),
          // Description
          Expanded(
            child: Text(
              item.description,
              style: const TextStyle(fontSize: 12, color: EbsColors.textMuted),
            ),
          ),
          const SizedBox(width: 8),
          // Category badge
          _CategoryBadge(category: item.category),
          const SizedBox(width: 8),
          // Enter hint
          AnimatedOpacity(
            duration: const Duration(milliseconds: 100),
            opacity: isSelected ? 0.7 : 0.0,
            child: const Text(
              '\u21B5',
              style: TextStyle(fontSize: 10, color: EbsColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String category;
  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    final (bg, border, fg) = switch (category) {
      'OVERLAY' => (
        EbsColors.accentBlue.withValues(alpha: 0.12),
        EbsColors.accentBlue.withValues(alpha: 0.3),
        EbsColors.accentBlue,
      ),
      'RFID' => (
        EbsColors.accentGold.withValues(alpha: 0.15),
        EbsColors.accentGold.withValues(alpha: 0.35),
        EbsColors.accentGold,
      ),
      _ => (
        EbsColors.textMuted.withValues(alpha: 0.25),
        EbsColors.textMuted.withValues(alpha: 0.4),
        EbsColors.textMuted,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: fg,
        ),
      ),
    );
  }
}

class _PaletteFooter extends StatelessWidget {
  const _PaletteFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
      ),
      child: Row(
        children: [
          _Shortcut(keys: ['\u2191', '\u2193'], label: 'NAVIGATE'),
          const SizedBox(width: 20),
          _Shortcut(keys: ['\u21B5'], label: 'EXECUTE'),
          const SizedBox(width: 20),
          _Shortcut(keys: ['Esc'], label: 'CLOSE'),
          const SizedBox(width: 20),
          _Shortcut(keys: ['Tab'], label: 'AUTOCOMPLETE'),
        ],
      ),
    );
  }
}

class _Shortcut extends StatelessWidget {
  final List<String> keys;
  final String label;
  const _Shortcut({required this.keys, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final key in keys)
          Container(
            margin: const EdgeInsets.only(right: 4),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              key,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: EbsColors.textSecondary,
              ),
            ),
          ),
        const SizedBox(width: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            letterSpacing: 0.55,
            color: EbsColors.textMuted,
          ),
        ),
      ],
    );
  }
}
