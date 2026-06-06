import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';
import '../../../models/auth_user_model.dart';
import '../../../widgets/app_section_header/app_section_header.dart';

class ProfileAccountCard extends StatelessWidget {
  final AuthUserModel? user;
  final bool isLoading;
  final VoidCallback onSignOut;

  const ProfileAccountCard({
    super.key,
    required this.user,
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.s16),
            decoration: BoxDecoration(
              color: AppColor.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColor.border),
            ),
            child: user != null
                ? _buildUserInfo(user!, context)
                : _buildEmptyState(context),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(AuthUserModel authUser, BuildContext context) {
    final initials = authUser.name.isNotEmpty
        ? authUser.name
            .trim()
            .split(' ')
            .map((w) => w.isNotEmpty ? w[0] : '')
            .take(2)
            .join()
            .toUpperCase()
        : '?';

    Widget buildFallbackAvatar() {
      return Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColor.bgDeep,
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            // Avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: authUser.avatarUrl != null && authUser.avatarUrl!.isNotEmpty
                    ? null
                    : AppColor.levelGradient,
                color: authUser.avatarUrl != null && authUser.avatarUrl!.isNotEmpty
                    ? AppColor.surface
                    : null,
              ),
              child: ClipOval(
                child: authUser.avatarUrl != null && authUser.avatarUrl!.isNotEmpty
                    ? Image.network(
                        authUser.avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => buildFallbackAvatar(),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColor.cyan),
                              ),
                            ),
                          );
                        },
                      )
                    : buildFallbackAvatar(),
              ),
            ),
            const SizedBox(width: AppSpacing.s12),

            // Name + Email
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authUser.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColor.fg,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    authUser.email,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColor.fgSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Provider badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s8,
                vertical: AppSpacing.s4,
              ),
              decoration: BoxDecoration(
                color: AppColor.surfaceHover,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    RemixIcons.google_line,
                    size: 12,
                    color: AppColor.fgSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    authUser.provider[0].toUpperCase() +
                        authUser.provider.substring(1),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColor.fgSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.s16),

        // Sign out button
        GestureDetector(
          onTap: isLoading ? null : onSignOut,
          child: Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColor.transparent,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: AppColor.errorBorder),
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.danger,
                      ),
                    )
                  : const Row(
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
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        const Icon(
          RemixIcons.user_3_line,
          size: 32,
          color: AppColor.fgMuted,
        ),
        const SizedBox(height: AppSpacing.s8),
        Text(
          context.l10n.profileAccountEmpty,
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.fgSecondary,
          ),
        ),
      ],
    );
  }
}
