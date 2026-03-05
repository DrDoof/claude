import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/ebs_colors.dart';
import '../../providers/app_providers.dart';
import '../common/setting_row.dart';
import '../common/ebs_toggle.dart';
import '../common/ebs_button.dart';

class SystemTab extends ConsumerWidget {
  const SystemTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allowAt = ref.watch(allowAtAccessProvider);
    final predictiveBet = ref.watch(predictiveBetProvider);
    final autoStart = ref.watch(autoStartProvider);
    final upcardAntennas = ref.watch(upcardAntennasProvider);
    final disableMuck = ref.watch(disableMuckProvider);
    final disableCommunity = ref.watch(disableCommunityProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(EbsColors.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // RFID
          _SectionTitle('RFID'),
          const SizedBox(height: 8),
          // Connected status
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: EbsColors.success,
                  boxShadow: [BoxShadow(color: EbsColors.success.withValues(alpha: 0.6), blurRadius: 8)],
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'CONNECTED',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.04,
                  color: EbsColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: EbsButton(text: 'RESET', small: true)),
              const SizedBox(width: 8),
              Expanded(child: EbsButton(text: 'CALIBRATE', small: true)),
            ],
          ),
          const SizedBox(height: 8),
          SettingRow(
            label: 'UPCARD Antennas',
            child: EbsToggle(
              value: upcardAntennas,
              onChanged: (v) => ref.read(upcardAntennasProvider.notifier).state = v,
            ),
          ),
          SettingRow(
            label: 'Disable Muck',
            child: EbsToggle(
              value: disableMuck,
              onChanged: (v) => ref.read(disableMuckProvider.notifier).state = v,
            ),
          ),
          SettingRow(
            label: 'Disable Community',
            child: EbsToggle(
              value: disableCommunity,
              onChanged: (v) => ref.read(disableCommunityProvider.notifier).state = v,
            ),
          ),
          const SizedBox(height: EbsColors.spacingLg),

          // TABLE
          _SectionTitle('Table'),
          const SizedBox(height: 8),
          SettingRow(
            label: 'Table Name',
            child: _TextInput(value: 'Final Table', width: 130),
          ),
          SettingRow(
            label: 'Table Password',
            child: _TextInput(value: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022', width: 130),
          ),
          const SizedBox(height: EbsColors.spacingLg),

          // ACTION TRACKER
          _SectionTitle('Action Tracker'),
          const SizedBox(height: 8),
          SettingRow(
            label: 'Allow AT Access',
            child: EbsToggle(
              value: allowAt,
              onChanged: (v) => ref.read(allowAtAccessProvider.notifier).state = v,
            ),
          ),
          SettingRow(
            label: 'Predictive Bet',
            child: EbsToggle(
              value: predictiveBet,
              onChanged: (v) => ref.read(predictiveBetProvider.notifier).state = v,
            ),
          ),
          const SizedBox(height: EbsColors.spacingLg),

          // DIAGNOSTICS
          _SectionTitle('Diagnostics'),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: EbsButton(text: 'TABLE DIAGNOSTICS'),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: EbsButton(text: 'SYSTEM LOG'),
          ),
          const SizedBox(height: 6),
          SettingRow(
            label: 'Export Folder',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'C:\\EBS\\exports\\',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 11,
                    color: EbsColors.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 6),
                EbsButton(text: 'BROWSE', small: true),
              ],
            ),
          ),
          const SizedBox(height: EbsColors.spacingLg),

          // STARTUP
          _SectionTitle('Startup'),
          const SizedBox(height: 8),
          SettingRow(
            label: 'Auto Start',
            child: EbsToggle(
              value: autoStart,
              onChanged: (v) => ref.read(autoStartProvider.notifier).state = v,
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

class _TextInput extends StatelessWidget {
  final String value;
  final double width;
  const _TextInput({required this.value, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: EbsColors.glassBorder),
        borderRadius: BorderRadius.circular(EbsColors.borderRadiusSm),
      ),
      child: Text(
        value,
        style: const TextStyle(fontSize: 12, color: EbsColors.textPrimary),
      ),
    );
  }
}
