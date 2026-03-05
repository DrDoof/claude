import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/ebs_colors.dart';
import '../../models/mock_data.dart';
import '../../providers/app_providers.dart';
import '../common/status_indicator.dart';
import '../common/ebs_badge.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameStateProvider);
    final system = ref.watch(systemStateProvider);

    return Container(
      width: EbsColors.sidebarWidth,
      decoration: const BoxDecoration(
        color: EbsColors.bgSecondary,
        border: Border(right: BorderSide(color: EbsColors.glassBorder)),
      ),
      child: Column(
        children: [
          // Tables section
          _SidebarSection(
            label: 'Tables',
            children: [
              for (final table in game.tables)
                _TableItem(
                  table: table,
                  isActive: table.name == game.activeTableName,
                ),
            ],
          ),
          // Quick Actions section
          Expanded(
            child: _SidebarSection(
              label: 'Quick Actions',
              children: const [
                _QuickActionItem(shortcut: 'R', label: 'Reset Hand'),
                _QuickActionItem(shortcut: 'D', label: 'Register Deck'),
                _QuickActionItem(shortcut: 'AT', label: 'Launch AT', wide: true),
                _QuickActionItem(shortcut: 'H', label: 'Hide GFX'),
              ],
            ),
          ),
          // Connection section
          _SidebarSection(
            label: 'Connection',
            isLast: true,
            children: [
              _ConnectionItem(
                name: 'RFID',
                status: system.rfid,
                label: 'CONN',
                labelColor: EbsColors.accentBlue,
              ),
              _ConnectionItem(
                name: 'AT',
                status: system.at,
                label: 'CONN',
                labelColor: EbsColors.accentBlue,
              ),
              _ConnectionItem(
                name: 'ENGINE',
                status: system.engine,
                label: 'OK',
                labelColor: EbsColors.success,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SidebarSection extends StatelessWidget {
  final String label;
  final List<Widget> children;
  final bool isLast;

  const _SidebarSection({
    required this.label,
    required this.children,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: EbsColors.spacingSm),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: EbsColors.glassBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: EbsColors.spacingMd,
              vertical: EbsColors.spacingXs,
            ),
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: EbsColors.textMuted,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _TableItem extends StatelessWidget {
  final MockTable table;
  final bool isActive;

  const _TableItem({required this.table, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: EbsColors.spacingMd, vertical: 7),
      decoration: BoxDecoration(
        color: isActive ? EbsColors.accentGold.withValues(alpha: 0.1) : null,
        border: Border(
          left: BorderSide(
            width: 2,
            color: isActive ? EbsColors.accentGold : Colors.transparent,
          ),
        ),
      ),
      child: Row(
        children: [
          StatusIndicator(
            type: table.status == TableStatus.active
                ? IndicatorType.active
                : IndicatorType.idle,
            size: 8,
          ),
          const SizedBox(width: EbsColors.spacingSm),
          Expanded(
            child: Text(
              table.name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? EbsColors.accentGold : EbsColors.textSecondary,
              ),
            ),
          ),
          if (table.phase != null)
            EbsBadge(
              text: _phaseLabel(table.phase!),
              variant: BadgeVariant.neon,
            )
          else
            Text(
              'IDLE',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 0.6,
                color: EbsColors.textMuted,
              ),
            ),
        ],
      ),
    );
  }

  String _phaseLabel(GamePhase phase) {
    switch (phase) {
      case GamePhase.preFlop:
        return 'PRE_FLOP';
      case GamePhase.flop:
        return 'FLOP';
      case GamePhase.turn:
        return 'TURN';
      case GamePhase.river:
        return 'RIVER';
      case GamePhase.showdown:
        return 'SHOWDOWN';
    }
  }
}

class _QuickActionItem extends StatelessWidget {
  final String shortcut;
  final String label;
  final bool wide;

  const _QuickActionItem({
    required this.shortcut,
    required this.label,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: EbsColors.spacingMd, vertical: 3.5),
      child: Row(
        children: [
          Container(
            width: wide ? 24 : 20,
            height: 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              shortcut,
              style: GoogleFonts.jetBrainsMono(
                fontSize: wide ? 8 : 10,
                fontWeight: FontWeight.w700,
                color: EbsColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: EbsColors.spacingSm),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: EbsColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ConnectionItem extends StatelessWidget {
  final String name;
  final ConnectionStatus status;
  final String label;
  final Color labelColor;

  const _ConnectionItem({
    required this.name,
    required this.status,
    required this.label,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: EbsColors.spacingMd, vertical: 3.5),
      child: Row(
        children: [
          StatusIndicator(
            type: status == ConnectionStatus.connected
                ? IndicatorType.active
                : IndicatorType.idle,
            size: 8,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 12, color: EbsColors.textSecondary),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: labelColor,
            ),
          ),
        ],
      ),
    );
  }
}
