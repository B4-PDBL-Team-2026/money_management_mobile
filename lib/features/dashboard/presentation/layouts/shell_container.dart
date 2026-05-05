import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ShellContainer extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const ShellContainer({super.key, required this.navigationShell});

  @override
  State<ShellContainer> createState() => _ShellContainerState();
}

class _ShellContainerState extends State<ShellContainer>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animController;
  late Animation<double> _fadeScaleAnim;
  late Animation<double> _rotateAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _fadeScaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );
    _rotateAnim = Tween<double>(begin: 0.0, end: 0.375).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    });
  }

  void _close() {
    if (_isExpanded) {
      setState(() => _isExpanded = false);
      _animController.reverse();
    }
  }

  void _onVoiceTap() {
    _close();
    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) context.push(AppRouter.voiceTransaction);
    });
  }

  void _onManualTap() {
    _close();
    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) context.push(AppRouter.addTransaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    final showFab = widget.navigationShell.currentIndex == 1;

    return Stack(
      children: [
        Scaffold(
          body: widget.navigationShell,
          bottomNavigationBar: SizedBox(
            height: 64,
            child: BottomNavigationBar(
              currentIndex: widget.navigationShell.currentIndex,
              onTap: (index) {
                _close();
                widget.navigationShell.goBranch(
                  index,
                  initialLocation: index == widget.navigationShell.currentIndex,
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
                  icon: PhosphorIcon(PhosphorIconsRegular.receipt),
                  activeIcon: PhosphorIcon(PhosphorIconsFill.receipt),
                  label: 'Riwayat',
                  tooltip: 'Riwayat transaksi',
                ),
                BottomNavigationBarItem(
                  icon: PhosphorIcon(PhosphorIconsRegular.house),
                  activeIcon: PhosphorIcon(PhosphorIconsFill.house),
                  label: 'Beranda',
                  tooltip: 'Beranda',
                ),
                BottomNavigationBarItem(
                  icon: PhosphorIcon(PhosphorIconsRegular.dotsThreeCircle),
                  activeIcon: PhosphorIcon(PhosphorIconsFill.dotsThreeCircle),
                  label: 'Lainnya',
                  tooltip: 'Profil dan pengaturan',
                ),
              ],
            ),
          ),
        ),

        // Scrim — tapping outside closes the menu
        if (_isExpanded)
          Positioned.fill(
            child: GestureDetector(
              onTap: _close,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.black.withOpacity(0.18)),
            ),
          ),

        // FAB + action items
        if (showFab)
          Positioned(
            right: 16,
            bottom: 64 + 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _FabMenuItem(
                  animation: _fadeScaleAnim,
                  delay: 0.0,
                  label: 'Tambah Manual',
                  icon: Icons.edit_outlined,
                  onTap: _onManualTap,
                ),
                const SizedBox(height: 12),

                // Scan Struk (disabled)
                // _FabMenuItem(
                //   animation: _fadeScaleAnim,
                //   delay: 0.15,
                //   label: 'Scan Struk',
                //   icon: Icons.crop_free_rounded,
                //   disabled: true,
                //   onTap: () {},
                // ),
                // const SizedBox(height: 12),

                // Voice Input
                _FabMenuItem(
                  animation: _fadeScaleAnim,
                  delay: 0.3,
                  label: 'Voice',
                  icon: Icons.mic_none_rounded,
                  onTap: _onVoiceTap,
                ),
                const SizedBox(height: 16),

                // Main FAB
                RotationTransition(
                  turns: _rotateAnim,
                  child: FloatingActionButton(
                    onPressed: _toggle,
                    backgroundColor: AppColors.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppSizes.radiusLg),
                      ),
                      side: BorderSide(color: AppColors.bulma, width: 1),
                    ),
                    child: Icon(
                      _isExpanded ? Icons.close : Icons.add,
                      color: AppColors.bulma,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _FabMenuItem extends StatelessWidget {
  final Animation<double> animation;
  final double delay;
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool disabled;

  const _FabMenuItem({
    required this.animation,
    required this.delay,
    required this.label,
    required this.icon,
    required this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    // Stagger each item using an Interval on the shared animation
    final delayedAnim = CurvedAnimation(
      parent: animation,
      curve: Interval(delay, 1.0, curve: Curves.easeOutBack),
    );

    return ScaleTransition(
      scale: delayedAnim,
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Interval(delay, 1.0, curve: Curves.easeIn),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: disabled ? Colors.white.withOpacity(0.7) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(disabled ? 0.04 : 0.10),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: disabled
                      ? const Color(0xFFB0B8C9)
                      : const Color(0xFF1A1A2E),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Icon circle
            GestureDetector(
              onTap: disabled ? null : onTap,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: disabled ? const Color(0xFFF0F0F0) : Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(disabled ? 0.04 : 0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: disabled
                      ? const Color(0xFFB0B8C9)
                      : const Color(0xFF1A3A6B),
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}