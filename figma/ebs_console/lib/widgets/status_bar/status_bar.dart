import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/ebs_colors.dart';
import '../../providers/app_providers.dart';
import '../common/status_indicator.dart';

class EbsStatusBar extends ConsumerWidget {
  const EbsStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final system = ref.watch(systemStateProvider);
    final game = ref.watch(gameStateProvider);
    final mono = GoogleFonts.jetBrainsMono(fontSize: 11);

    return Container(
      height: EbsColors.statusBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: EbsColors.spacingMd),
      decoration: const BoxDecoration(
        color: EbsColors.bgStatusBar,
        border: Border(top: BorderSide(color: EbsColors.glassBorder)),
      ),
      child: Row(
        children: [
          // Left group
          _StatusGroup(children: [
            _StatusItem(children: [
              const StatusIndicator(type: IndicatorType.active, size: 7),
              const SizedBox(width: 5),
              const Text('RFID:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: EbsColors.textPrimary)),
              const SizedBox(width: 4),
              const Text('Connected', style: TextStyle(fontSize: 11, color: EbsColors.textMuted)),
            ]),
            _StatusItem(children: [
              const Text('Hand', style: TextStyle(fontSize: 11, color: EbsColors.textMuted)),
              const SizedBox(width: 4),
              Text('#${game.handNumber}', style: mono.copyWith(fontWeight: FontWeight.w700, color: EbsColors.accentGold)),
            ]),
            _StatusItem(children: [
              const StatusIndicator(type: IndicatorType.warning, size: 7),
              const SizedBox(width: 5),
              const Text('DELAYED', style: TextStyle(fontSize: 11, color: EbsColors.textMuted)),
              const SizedBox(width: 4),
              Text(system.delayTime, style: mono.copyWith(fontWeight: FontWeight.w700, color: EbsColors.warning)),
            ]),
          ]),
          const Spacer(),
          // Center group
          _StatusGroup(children: [
            _StatusItem(children: [
              const Text('CPU', style: TextStyle(fontSize: 11, color: EbsColors.textMuted)),
              const SizedBox(width: 4),
              Text('${system.cpuPercent}%', style: mono.copyWith(color: EbsColors.textMuted)),
            ]),
            _StatusItem(children: [
              const Text('MEM', style: TextStyle(fontSize: 11, color: EbsColors.textMuted)),
              const SizedBox(width: 4),
              Text('${system.memPercent}%', style: mono.copyWith(color: EbsColors.textMuted)),
            ]),
          ]),
          const Spacer(),
          // Right group
          Text('Ctrl+?', style: mono.copyWith(color: EbsColors.textMuted.withValues(alpha: 0.45))),
        ],
      ),
    );
  }
}

class _StatusGroup extends StatelessWidget {
  final List<Widget> children;
  const _StatusGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: EbsColors.spacingMd),
          children[i],
        ],
      ],
    );
  }
}

class _StatusItem extends StatelessWidget {
  final List<Widget> children;
  const _StatusItem({required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }
}
