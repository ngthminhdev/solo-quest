import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../routes/routes_config.dart';
import '../../../extensions/localization_extension.dart';

class LogEmptyView extends StatelessWidget {
  const LogEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s32,
          vertical: AppSpacing.s40,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.surface,
                border: Border.all(color: AppColor.border),
              ),
              child: Icon(
                RemixIcons.file_text_line,
                size: 28,
                color: AppColor.fgMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.s20),
            Text(
              context.l10n.logsEmptyTitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColor.fgSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              context.l10n.logsEmptyMessage,
              style: TextStyle(
                fontSize: 13,
                color: AppColor.fgMuted,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s24),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(RoutesConfig.home);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s20,
                  vertical: AppSpacing.s12,
                ),
                decoration: BoxDecoration(
                  color: AppColor.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColor.border),
                ),
                child: Text(
                  context.l10n.logsHomeButton,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColor.cyan,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
