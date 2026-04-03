import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_cubit.dart';
import 'package:money_management_mobile/features/auth/presentation/cubit/session_state.dart';

class OtherProfileCard extends StatelessWidget {
  const OtherProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing5,
        vertical: AppSizes.spacing6,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSizes.radiusNm),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.lightPrimary,
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 54,
                  color: AppColors.mediumPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacing4),
          BlocBuilder<SessionCubit, SessionState>(
            builder: (context, state) {
              if (state is! SessionAuthenticated) {
                return const SizedBox.shrink();
              }

              final isEmailVerified = state.user.emailVerifiedAt != null;

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          state.user.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: AppColors.gohan,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      if (isEmailVerified) ...[
                        const SizedBox(width: AppSizes.spacing2),
                        Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.success100,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 14,
                            color: AppColors.gohan,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSizes.spacing1),
                  Text(
                    state.user.email,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.gohan),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
