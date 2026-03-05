import 'package:flutter/material.dart';
import '../../theme/ebs_colors.dart';

class EbsButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool small;

  const EbsButton({
    super.key,
    required this.text,
    this.onPressed,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(EbsColors.borderRadiusSm),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(EbsColors.borderRadiusSm),
        hoverColor: Colors.white.withValues(alpha: 0.12),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: small ? 10 : 14,
            vertical: small ? 4 : 6,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: EbsColors.glassBorder),
            borderRadius: BorderRadius.circular(EbsColors.borderRadiusSm),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: small ? 11 : 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.24,
              color: EbsColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
