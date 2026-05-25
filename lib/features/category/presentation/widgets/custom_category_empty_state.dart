import 'package:flutter/material.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:money_management_mobile/core/widgets/widgets.dart';
import 'package:picons/picons.dart';

class CustomCategoryEmptyState extends StatelessWidget {
  final VoidCallback onAddPressed;

  const CustomCategoryEmptyState({super.key, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon Illustration
            Container(
              padding: const EdgeInsets.all(AppSizes.spacing6),
              decoration: const BoxDecoration(
                color: AppColors.lightPrimary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                PiconsRegular.tag,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSizes.spacing6),

            // Main Label
            Text(
              'Kategori Kustom Kosong',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.bulma,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spacing2),

            // Description
            Text(
              'Anda belum menambahkan kategori kustom apa pun. Tambahkan kategori baru untuk melacak pengeluaran dan pemasukan sesuai kebutuhan unik Anda.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.trunks),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spacing8),

            // Call to Action button
            SizedBox(
              width: 200,
              child: AppButton(
                text: 'Tambah Kategori',
                onPressed: onAddPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
