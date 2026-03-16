import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/app_colors.dart';
import 'package:money_management_mobile/core/theme/app_sizes.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ShellContainer extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ShellContainer({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SizedBox(
        height: 64,
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: PhosphorIcon(PhosphorIconsRegular.receipt, size: 28),
              activeIcon: PhosphorIcon(PhosphorIconsFill.receipt, size: 28),
              label: 'Riwayat',
              tooltip: 'Riwayat transaksi',
            ),
            BottomNavigationBarItem(
              icon: PhosphorIcon(PhosphorIconsRegular.house, size: 28),
              activeIcon: PhosphorIcon(PhosphorIconsFill.house, size: 28),
              label: 'Beranda',
              tooltip: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: PhosphorIcon(
                PhosphorIconsRegular.dotsThreeCircle,
                size: 28,
              ),
              activeIcon: PhosphorIcon(
                PhosphorIconsFill.dotsThreeCircle,
                size: 28,
              ),
              label: 'Lainnya',
              tooltip: 'Profil dan pengaturan',
            ),
          ],
        ),
      ),
      floatingActionButton: navigationShell.currentIndex == 1
          ? FloatingActionButton(
              onPressed: () => context.push(AppRouter.addTransaction),
              backgroundColor: AppColors.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppSizes.radiusLg),
                ),
                side: BorderSide(color: AppColors.bulma, width: 1),
              ),
              child: Icon(Icons.add, color: AppColors.bulma),
            )
          : null,
    );
  }
}
