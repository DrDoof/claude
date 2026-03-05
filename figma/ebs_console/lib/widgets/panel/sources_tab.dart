import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/ebs_colors.dart';
import '../../models/mock_data.dart';
import '../../providers/app_providers.dart';
import '../common/setting_row.dart';
import '../common/ebs_toggle.dart';
import '../common/segment_toggle.dart';
import '../common/color_swatch_widget.dart';
import '../common/ebs_button.dart';
import '../common/ebs_badge.dart';
import '../common/status_indicator.dart';
import '../common/ebs_dropdown.dart';

class SourcesTab extends ConsumerWidget {
  const SourcesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sources = ref.watch(videoSourcesProvider);
    final chromaEnabled = ref.watch(chromaKeyEnabledProvider);
    final cameraMode = ref.watch(cameraModeProvider);
    final atemControl = ref.watch(atemControlProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(EbsColors.spacingSm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // VIDEO SOURCES TABLE
          _SectionTitle('Video Sources'),
          const SizedBox(height: 8),
          _SourceTable(sources: sources),
          const SizedBox(height: EbsColors.spacingLg),

          // CAMERA MODE
          _SectionTitle('Camera Mode'),
          const SizedBox(height: 8),
          SettingRow(
            label: 'Mode',
            child: SegmentToggle(
              labels: const ['STATIC', 'DYNAMIC'],
              selectedIndex: cameraMode,
              onChanged: (i) => ref.read(cameraModeProvider.notifier).state = i,
            ),
          ),
          const SizedBox(height: EbsColors.spacingLg),

          // CHROMA KEY
          _SectionTitle('Chroma Key'),
          const SizedBox(height: 8),
          SettingRow(
            label: 'Enable',
            child: EbsToggle(
              value: chromaEnabled,
              onChanged: (v) => ref.read(chromaKeyEnabledProvider.notifier).state = v,
            ),
          ),
          SettingRow(
            label: 'Background Color',
            child: const ColorSwatchWidget(color: Color(0xFF0000FF), hexLabel: '#0000FF'),
          ),
          const SizedBox(height: EbsColors.spacingLg),

          // ATEM CONTROL
          _SectionTitle('ATEM Control'),
          const SizedBox(height: 8),
          SettingRow(
            label: 'Switcher Source',
            child: EbsDropdown(
              value: 'ATEM Mini Pro',
              items: const ['ATEM Mini Pro', 'ATEM Mini Extreme'],
              width: 140,
            ),
          ),
          SettingRow(
            label: 'ATEM IP',
            child: Container(
              width: 130,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                border: Border.all(color: EbsColors.glassBorder),
                borderRadius: BorderRadius.circular(EbsColors.borderRadiusSm),
              ),
              child: Text(
                '192.168.1.100',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  color: EbsColors.textPrimary,
                ),
              ),
            ),
          ),
          SettingRow(
            label: 'ATEM Control',
            child: EbsToggle(
              value: atemControl,
              onChanged: (v) => ref.read(atemControlProvider.notifier).state = v,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
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

class _SourceTable extends StatelessWidget {
  final List<MockVideoSource> sources;
  const _SourceTable({required this.sources});

  @override
  Widget build(BuildContext context) {
    final headerStyle = TextStyle(
      fontSize: 9,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.63,
      color: EbsColors.textMuted,
    );

    return Table(
      columnWidths: const {
        0: FixedColumnWidth(20),
        1: FlexColumnWidth(1),
        2: FixedColumnWidth(60),
        3: FixedColumnWidth(65),
        4: FixedColumnWidth(45),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        // Header
        TableRow(
          decoration: BoxDecoration(
            color: EbsColors.bgSecondary,
            border: Border(bottom: BorderSide(color: EbsColors.glassBorder)),
          ),
          children: [
            _cell(Text('L', style: headerStyle), pad: 5),
            _cell(Text('SOURCE', style: headerStyle), pad: 5),
            _cell(Text('FORMAT', style: headerStyle), pad: 5),
            _cell(Text('STATUS', style: headerStyle), pad: 5),
            _cell(Text('', style: headerStyle), pad: 5),
          ],
        ),
        // Rows
        for (final src in sources)
          TableRow(
            children: [
              _cell(
                src.status == SourceStatus.active
                    ? const StatusIndicator(type: IndicatorType.active, size: 7)
                    : const SizedBox(width: 7),
                pad: 6,
              ),
              _cell(
                Text(
                  src.name,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: src.isLive ? FontWeight.w700 : FontWeight.w400,
                    color: src.isLive ? EbsColors.textPrimary : EbsColors.textSecondary,
                  ),
                ),
                pad: 6,
              ),
              _cell(
                Text(
                  src.format ?? '\u2014',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: src.format != null ? EbsColors.textSecondary : EbsColors.textMuted,
                  ),
                ),
                pad: 6,
              ),
              _cell(
                EbsBadge(
                  text: _statusLabel(src.status),
                  variant: _statusVariant(src.status),
                ),
                pad: 6,
              ),
              _cell(
                EbsButton(
                  text: src.status == SourceStatus.noSignal ? 'LINK' : 'EDIT',
                  small: true,
                ),
                pad: 6,
              ),
            ],
          ),
      ],
    );
  }

  Widget _cell(Widget child, {double pad = 6}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: pad, horizontal: 4),
      child: child,
    );
  }

  String _statusLabel(SourceStatus s) {
    switch (s) {
      case SourceStatus.active:
        return 'Active';
      case SourceStatus.inactive:
        return 'Inactive';
      case SourceStatus.noSignal:
        return 'No Signal';
    }
  }

  BadgeVariant _statusVariant(SourceStatus s) {
    switch (s) {
      case SourceStatus.active:
        return BadgeVariant.success;
      case SourceStatus.inactive:
        return BadgeVariant.muted;
      case SourceStatus.noSignal:
        return BadgeVariant.danger;
    }
  }
}
