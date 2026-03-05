import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/ebs_colors.dart';
import '../../providers/app_providers.dart';
import '../common/ebs_badge.dart';
import '../common/status_indicator.dart';

class AppHeader extends ConsumerWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameStateProvider);

    return Container(
      height: EbsColors.headerHeight,
      padding: const EdgeInsets.symmetric(horizontal: EbsColors.spacingMd),
      decoration: const BoxDecoration(
        color: EbsColors.bgSecondary,
        border: Border(bottom: BorderSide(color: EbsColors.glassBorder)),
      ),
      child: Row(
        children: [
          Text(
            'E B S',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: EbsColors.accentGold,
            ),
          ),
          const SizedBox(width: EbsColors.spacingMd),
          Container(width: 1, height: 20, color: EbsColors.glassBorder),
          const SizedBox(width: EbsColors.spacingMd),
          Text(
            'Table:',
            style: TextStyle(fontSize: 11, color: EbsColors.textSecondary),
          ),
          const SizedBox(width: 4),
          Text(
            game.activeTableName,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: EbsColors.textPrimary,
            ),
          ),
          const Spacer(),
          // Command palette button
          GestureDetector(
            onTap: () => ref.read(commandPaletteVisibleProvider.notifier).state = true,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                border: Border.all(color: EbsColors.glassBorder),
                borderRadius: BorderRadius.circular(EbsColors.borderRadiusSm),
              ),
              child: Text(
                '\u2318K',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: EbsColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: EbsColors.spacingMd),
          // LIVE badge
          EbsBadge(
            text: 'LIVE',
            variant: BadgeVariant.danger,
            leading: const StatusIndicator(type: IndicatorType.live, size: 6),
          ),
          const SizedBox(width: 8),
          const EbsBadge(text: 'OP.1', variant: BadgeVariant.muted),
        ],
      ),
    );
  }
}
