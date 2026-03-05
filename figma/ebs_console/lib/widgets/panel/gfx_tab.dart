import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/ebs_colors.dart';
import '../../providers/app_providers.dart';
import '../common/ebs_toggle.dart';
import '../common/ebs_dropdown.dart';

class GfxTab extends ConsumerWidget {
  const GfxTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardPos = ref.watch(boardPositionProvider);
    final playerLayout = ref.watch(playerLayoutProvider);
    final revealPlayers = ref.watch(revealPlayersProvider);
    final transIn = ref.watch(transitionInProvider);
    final transOut = ref.watch(transitionOutProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LAYOUT
          _GfxSectionHeader('Layout'),
          _GfxBody(children: [
            _GfxRow(label: 'Board Position', child: EbsDropdown(
              value: boardPos, items: const ['Centre', 'Left', 'Right'], width: 130,
              onChanged: (v) => ref.read(boardPositionProvider.notifier).state = v,
            )),
            _GfxRow(label: 'Player Layout', child: EbsDropdown(
              value: playerLayout, items: const ['Horizontal', 'Vertical', 'Arc'], width: 130,
              onChanged: (v) => ref.read(playerLayoutProvider.notifier).state = v,
            )),
            _GfxRow(label: 'X Margin', child: _NumInput(value: '0.04')),
            _GfxRow(label: 'Top Margin', child: _NumInput(value: '0.05')),
            _GfxRow(label: 'Bot Margin', child: _NumInput(value: '0.04')),
            _GfxRow(label: 'Leaderboard Pos', child: EbsDropdown(
              value: 'Centre', items: const ['Centre', 'Left', 'Right'], width: 130,
            )),
          ]),

          const Divider(height: 1, color: EbsColors.glassBorder),

          // CARD & PLAYER
          _GfxSectionHeader('Card & Player'),
          _GfxBody(children: [
            _GfxRow(label: 'Reveal Players', child: EbsDropdown(
              value: revealPlayers, items: const ['On Action', 'Always', 'Manual'], width: 130,
              onChanged: (v) => ref.read(revealPlayersProvider.notifier).state = v,
            )),
            _GfxRow(label: 'Show Fold', child: Row(mainAxisSize: MainAxisSize.min, children: [
              EbsDropdown(value: 'Delayed', items: const ['Delayed', 'Immediate', 'Never'], width: 90),
              const SizedBox(width: 4),
              _NumInput(value: '3', width: 44),
              const SizedBox(width: 2),
              const Text('s', style: TextStyle(fontSize: 11, color: EbsColors.textMuted)),
            ])),
            _GfxRow(label: 'Reveal Cards', child: EbsDropdown(
              value: 'After Action', items: const ['After Action', 'Immediate', 'Manual'], width: 130,
            )),
          ]),

          const Divider(height: 1, color: EbsColors.glassBorder),

          // ANIMATION
          _GfxSectionHeader('Animation'),
          _GfxBody(children: [
            _GfxRow(label: 'Transition In', child: Row(mainAxisSize: MainAxisSize.min, children: [
              EbsDropdown(value: transIn, items: const ['Slide', 'Fade', 'Scale'], width: 90,
                onChanged: (v) => ref.read(transitionInProvider.notifier).state = v,
              ),
              const SizedBox(width: 4),
              _NumInput(value: '0.5', width: 52),
              const SizedBox(width: 2),
              const Text('s', style: TextStyle(fontSize: 11, color: EbsColors.textMuted)),
            ])),
            _GfxRow(label: 'Transition Out', child: Row(mainAxisSize: MainAxisSize.min, children: [
              EbsDropdown(value: transOut, items: const ['Fade', 'Slide', 'Scale'], width: 90,
                onChanged: (v) => ref.read(transitionOutProvider.notifier).state = v,
              ),
              const SizedBox(width: 4),
              _NumInput(value: '0.3', width: 52),
              const SizedBox(width: 2),
              const Text('s', style: TextStyle(fontSize: 11, color: EbsColors.textMuted)),
            ])),
            _GfxRow(label: 'Indent Action Player', child: EbsToggle(value: true)),
            _GfxRow(label: 'Bounce Action Player', child: EbsToggle(value: true)),
          ]),

          const Divider(height: 1, color: EbsColors.glassBorder),

          // BRANDING
          _GfxSectionHeader('Branding'),
          _GfxBody(children: [
            _GfxRow(label: 'Sponsor Logo 1', child: _DropZone()),
            _GfxRow(label: 'Sponsor Logo 2', child: _DropZone()),
          ]),
        ],
      ),
    );
  }
}

class _GfxSectionHeader extends StatelessWidget {
  final String title;
  const _GfxSectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: EbsColors.spacingMd,
        vertical: EbsColors.spacingSm,
      ),
      color: Colors.black.withValues(alpha: 0.2),
      child: Text(
        title.toUpperCase(),
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

class _GfxBody extends StatelessWidget {
  final List<Widget> children;
  const _GfxBody({required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(EbsColors.spacingMd),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: EbsColors.spacingSm),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _GfxRow extends StatelessWidget {
  final String label;
  final Widget child;
  const _GfxRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: EbsColors.textSecondary),
          ),
        ),
        const SizedBox(width: EbsColors.spacingSm),
        child,
      ],
    );
  }
}

class _NumInput extends StatelessWidget {
  final String value;
  final double width;
  const _NumInput({required this.value, this.width = 60});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: EbsColors.glassBorder),
        borderRadius: BorderRadius.circular(EbsColors.borderRadiusSm),
      ),
      child: Text(
        value,
        textAlign: TextAlign.right,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          color: EbsColors.accentGold,
        ),
      ),
    );
  }
}

class _DropZone extends StatelessWidget {
  const _DropZone();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(EbsColors.borderRadiusSm),
      ),
      alignment: Alignment.center,
      child: const Text(
        'DROP 120\u00D740',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
          color: EbsColors.textMuted,
        ),
      ),
    );
  }
}
