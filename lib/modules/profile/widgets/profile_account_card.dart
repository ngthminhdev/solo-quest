import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';
import '../../../widgets/app_section_header/app_section_header.dart';

class ProfileAccountCard extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSignOut;

  const ProfileAccountCard({
    super.key,
    required this.isLoading,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(title: context.l10n.profileAccount),
          const SizedBox(height: AppSpacing.s12),
          GestureDetector(
            onTap: isLoading ? null : onSignOut,
            child: Container(
              height: 44,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.transparent,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: AppColor.errorBorder),
              ),
              child: Center(
                child: isLoading
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColor.danger,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            RemixIcons.logout_box_line,
                            size: 16,
                            color: AppColor.danger,
                          ),
                          SizedBox(width: AppSpacing.s8),
                          Text(
                            'Đăng xuất',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColor.danger,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
