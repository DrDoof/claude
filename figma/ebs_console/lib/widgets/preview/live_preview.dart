import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/ebs_colors.dart';
import '../../providers/app_providers.dart';
import '../../models/mock_data.dart';
import '../common/ebs_badge.dart';

class LivePreview extends ConsumerWidget {
  const LivePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameStateProvider);

    return Container(
      color: EbsColors.bgPrimary,
      child: Column(
        children: [
          // Preview header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: EbsColors.spacingMd,
              vertical: 8,
            ),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: EbsColors.glassBorder)),
            ),
            child: Row(
              children: [
                Text(
                  'LIVE PREVIEW',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: EbsColors.textMuted,
                  ),
                ),
                const Spacer(),
                const EbsBadge(text: '1920\u00D71080', variant: BadgeVariant.muted, isMono: true),
                const SizedBox(width: 6),
                const EbsBadge(text: '60fps', variant: BadgeVariant.blue, isMono: true),
              ],
            ),
          ),
          // Canvas
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(EbsColors.spacingMd),
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0000FF), // Chroma blue
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Stack(
                      children: [
                        // Watermark center
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'POT',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.1,
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\u20A9${_formatNumber(game.pot)}',
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'LIVE PREVIEW',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 2.7,
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Chroma-key ready \u2014 16:9',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.25),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Player slots at bottom
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: _PlayerStrip(players: game.players),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int n) {
    final s = n.toString();
    final result = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) result.write(',');
      result.write(s[i]);
    }
    return result.toString();
  }
}

class _PlayerStrip extends StatelessWidget {
  final List<MockPlayer> players;
  const _PlayerStrip({required this.players});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          for (int i = 0; i < players.length; i++) ...[
            if (i > 0) const SizedBox(width: 3),
            Expanded(child: _PlayerSlot(player: players[i])),
          ],
        ],
      ),
    );
  }
}

class _PlayerSlot extends StatelessWidget {
  final MockPlayer player;
  const _PlayerSlot({required this.player});

  @override
  Widget build(BuildContext context) {
    final occupied = !player.isEmpty;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: occupied ? 1.0 : 0.3,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          border: Border.all(
            color: occupied
                ? EbsColors.accentGold.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.15),
          ),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              occupied ? 'P${player.seat} ${player.name}' : 'P${player.seat}',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.54,
                color: Colors.white.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            if (occupied) ...[
              const SizedBox(height: 2),
              Text(
                _formatStack(player.stack!),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  color: EbsColors.accentGold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatStack(int n) {
    final s = n.toString();
    final result = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) result.write(',');
      result.write(s[i]);
    }
    return result.toString();
  }
}
