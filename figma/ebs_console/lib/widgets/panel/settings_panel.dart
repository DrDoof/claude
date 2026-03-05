import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/ebs_colors.dart';
import '../../providers/app_providers.dart';
import 'sources_tab.dart';
import 'outputs_tab.dart';
import 'gfx_tab.dart';
import 'system_tab.dart';

class SettingsPanel extends ConsumerWidget {
  const SettingsPanel({super.key});

  static const _tabLabels = ['Sources', 'Outputs', 'GFX', 'System'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(activeTabProvider);

    return Container(
      width: EbsColors.panelWidth,
      decoration: const BoxDecoration(
        color: EbsColors.bgTertiary,
        border: Border(left: BorderSide(color: EbsColors.glassBorder)),
      ),
      child: Column(
        children: [
          // Tab bar
          Container(
            decoration: const BoxDecoration(
              color: EbsColors.bgSecondary,
              border: Border(bottom: BorderSide(color: EbsColors.glassBorder)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: EbsColors.spacingMd),
            child: Row(
              children: [
                for (int i = 0; i < _tabLabels.length; i++)
                  GestureDetector(
                    onTap: () => ref.read(activeTabProvider.notifier).state = i,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 7),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 2,
                            color: i == activeTab
                                ? EbsColors.accentGold
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      child: Text(
                        _tabLabels[i],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: i == activeTab
                              ? EbsColors.accentGold
                              : EbsColors.textMuted,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Tab content
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _buildTab(activeTab),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int index) {
    switch (index) {
      case 0:
        return const SourcesTab(key: ValueKey('sources'));
      case 1:
        return const OutputsTab(key: ValueKey('outputs'));
      case 2:
        return const GfxTab(key: ValueKey('gfx'));
      case 3:
        return const SystemTab(key: ValueKey('system'));
      default:
        return const SizedBox.shrink();
    }
  }
}
