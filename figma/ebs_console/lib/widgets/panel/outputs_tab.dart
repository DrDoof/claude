import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/ebs_colors.dart';
import '../../providers/app_providers.dart';
import '../common/setting_row.dart';
import '../common/ebs_toggle.dart';
import '../common/color_swatch_widget.dart';
import '../common/ebs_dropdown.dart';

class OutputsTab extends ConsumerWidget {
  const OutputsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolution = ref.watch(resolutionProvider);
    final frameRate = ref.watch(frameRateProvider);
    final vertical = ref.watch(verticalOutputProvider);
    final fillKey = ref.watch(fillKeyEnabledProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(EbsColors.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // RESOLUTION
          _SectionTitle('Resolution'),
          const SizedBox(height: 8),
          SettingRow(
            label: 'Video Size',
            child: EbsDropdown(
              value: resolution,
              items: const ['1920x1080', '1280x720', '3840x2160'],
              width: 140,
              onChanged: (v) => ref.read(resolutionProvider.notifier).state = v,
            ),
          ),
          SettingRow(
            label: '9\u00D716 Vertical',
            child: EbsToggle(
              value: vertical,
              onChanged: (v) => ref.read(verticalOutputProvider.notifier).state = v,
            ),
          ),
          SettingRow(
            label: 'Frame Rate',
            child: EbsDropdown(
              value: frameRate,
              items: const ['60fps', '30fps', '50fps'],
              width: 100,
              onChanged: (v) => ref.read(frameRateProvider.notifier).state = v,
            ),
          ),
          const SizedBox(height: EbsColors.spacingLg),

          // LIVE PIPELINE
          _SectionTitle('Live Pipeline'),
          const SizedBox(height: 8),
          SettingRow(
            label: 'Video Output',
            child: EbsDropdown(
              value: 'DeckLink 4K Extreme',
              items: const ['DeckLink 4K Extreme', 'DeckLink Mini Monitor'],
              width: 160,
            ),
          ),
          SettingRow(
            label: 'Audio Output',
            child: EbsDropdown(
              value: 'DeckLink 4K Extreme',
              items: const ['DeckLink 4K Extreme', 'System Default'],
              width: 160,
            ),
          ),
          SettingRow(
            label: 'Device Port',
            child: EbsDropdown(
              value: 'Port 1',
              items: const ['Port 1', 'Port 2'],
              width: 80,
            ),
          ),
          const SizedBox(height: EbsColors.spacingLg),

          // FILL & KEY
          _SectionTitle('Fill & Key'),
          const SizedBox(height: 8),
          SettingRow(
            label: 'Key & Fill',
            child: EbsToggle(
              value: fillKey,
              onChanged: (v) => ref.read(fillKeyEnabledProvider.notifier).state = v,
            ),
          ),
          SettingRow(
            label: 'Key Color',
            child: const ColorSwatchWidget(
              color: Color(0xFF000000),
              hexLabel: '#FF000000',
            ),
          ),
          const SizedBox(height: 12),

          // Fill/Key preview boxes
          Row(
            children: [
              Expanded(child: _FkPreviewBox(label: 'FILL', port: 'Port 1', color: Colors.white.withValues(alpha: 0.06))),
              const SizedBox(width: 8),
              Expanded(child: _FkPreviewBox(label: 'KEY', port: 'Port 2', color: Colors.black)),
            ],
          ),
          const SizedBox(height: 12),

          // Port mapping
          Container(
            padding: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: EbsColors.glassBorder)),
            ),
            child: Column(
              children: [
                _PortRow('Fill', 'Port 1'),
                const SizedBox(height: 4),
                _PortRow('Key', 'Port 2'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
        color: EbsColors.textMuted,
      ),
    );
  }
}

class _FkPreviewBox extends StatelessWidget {
  final String label;
  final String port;
  final Color color;
  const _FkPreviewBox({required this.label, required this.port, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: EbsColors.glassBorder),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.72,
            color: EbsColors.textMuted,
          ),
        ),
        Text(port, style: const TextStyle(fontSize: 10, color: EbsColors.textSecondary)),
      ],
    );
  }
}

class _PortRow extends StatelessWidget {
  final String from;
  final String to;
  const _PortRow(this.from, this.to);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(from, style: const TextStyle(fontSize: 11, color: EbsColors.textMuted)),
        const SizedBox(width: 8),
        const Text('\u2192', style: TextStyle(fontSize: 11, color: EbsColors.textSecondary)),
        const SizedBox(width: 8),
        Text(to, style: const TextStyle(fontSize: 11, color: EbsColors.textMuted)),
      ],
    );
  }
}
