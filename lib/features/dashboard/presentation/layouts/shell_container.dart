import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_mobile/core/routes/app_router.dart';
import 'package:money_management_mobile/core/theme/theme.dart';
import 'package:picons/picons.dart';

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
      curve: Curves.easeIn,
    );
    _rotateAnim = Tween<double>(
      begin: 0.0,
      end: 0.375,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeIn));
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

  VoidCallback _onNavigate(VoidCallback callback) {
    return () {
      _close();
      Future.delayed(const Duration(milliseconds: 180), () {
        if (mounted) callback();
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    // 1. Mengambil tinggi Safe Area dari gesture bar/navigasi sistem
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    final showFab =
        widget.navigationShell.currentIndex == 0 ||
        widget.navigationShell.currentIndex == 2;

    return Stack(
      children: [
        Scaffold(
          body: widget.navigationShell,
          bottomNavigationBar: BottomNavigationBar(
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
            selectedFontSize: 12,
            unselectedFontSize: 12,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(PiconsRegular.house),
                activeIcon: Icon(PiconsFill.house),
                label: 'Beranda',
                tooltip: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(PiconsRegular.invoice),
                activeIcon: Icon(PiconsFill.invoice),
                label: 'Biaya',
                tooltip: 'Biaya tetap',
              ),
              BottomNavigationBarItem(
                icon: Icon(PiconsRegular.clockCounterClockwise),
                activeIcon: Icon(PiconsFill.clockCounterClockwise),
                label: 'Riwayat',
                tooltip: 'Riwayat transaksi',
              ),
              BottomNavigationBarItem(
                icon: Icon(PiconsRegular.userCircle),
                activeIcon: Icon(PiconsFill.userCircle),
                label: 'Profil',
                tooltip: 'Profil dan pengaturan',
              ),
            ],
          ),
        ),

        // Scrim â€” tapping outside closes the menu
        if (_isExpanded)
          Positioned.fill(
            child: GestureDetector(
              onTap: _close,
              behavior: HitTestBehavior.opaque,
              child: Container(color: AppColors.bulma.withValues(alpha: 0.18)),
            ),
          ),

        // FAB + action items
        if (showFab)
          Positioned(
            right: 16,
            // 2. PERBAIKAN: Posisi FAB kini dinamis menyesuaikan navigasi navbar + safe area
            bottom: kBottomNavigationBarHeight + 16 + bottomPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _FabMenuItem(
                  animation: _fadeScaleAnim,
                  delay: 0.0,
                  label: 'Tambah dalam Batch',
                  icon: PiconsRegular.stackPlus,
                  onTap: _onNavigate(
                    () => context.push(AppRouter.addBatchTransaction),
                  ),
                  disabled: false,
                ),
                const SizedBox(height: 12),

                _FabMenuItem(
                  animation: _fadeScaleAnim,
                  delay: 0.0,
                  label: 'Scan Struk',
                  icon: PiconsRegular.scan,
                  onTap: _onNavigate(
                    () => context.push(AppRouter.scanReceipt),
                  ),
                  disabled: false,
                ),
                const SizedBox(height: 12),

                _FabMenuItem(
                  animation: _fadeScaleAnim,
                  delay: 0.0,
                  label: 'Tambah Manual',
                  icon: PiconsRegular.pencilSimple,
                  onTap: _onNavigate(
                    () => context.push(AppRouter.addTransaction),
                  ),
                  disabled: false ,
                ),
                const SizedBox(height: 12),

                // Voice Input
                _FabMenuItem(
                  animation: _fadeScaleAnim,
                  delay: 0.3,
                  label: 'Voice',
                  icon: PiconsRegular.microphone,
                  onTap: _onNavigate(
                    () => context.push(AppRouter.voiceTransaction),
                  ),
                  disabled: false,
                ),
                const SizedBox(height: 16),

                // Main FAB
                RotationTransition(
                  turns: _rotateAnim,
                  child: FloatingActionButton(
                    onPressed: _toggle,
                    backgroundColor: AppColors.secondary,
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppSizes.radiusLg),
                      ),
                    ),
                    child: Icon(
                      _isExpanded ? Icons.close : Icons.add,
                      color: Colors.white,
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
    required this.disabled,
  });

  @override
  Widget build(BuildContext context) {
    // Stagger each item using an Interval on the shared animation
    final delayedAnim = CurvedAnimation(
      parent: animation,
      curve: Interval(delay, 1.0, curve: Curves.easeIn),
    );

    return ScaleTransition(
      scale: delayedAnim,
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Interval(delay, 1.0, curve: Curves.easeIn),
        ),
        child: GestureDetector(
          onTap: disabled ? null : onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: disabled
                  ? Colors.white.withValues(alpha: 0.7)
                  : Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.bulma.withValues(
                    alpha: disabled ? 0.04 : 0.12,
                  ),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: disabled
                        ? const Color(0xFFF3F6F9)
                        : AppColors.bulma.withValues(alpha: 0.06),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: disabled ? const Color(0xFFB0B8C9) : const Color(0xFF1A3A6B),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: disabled
                        ? const Color(0xFFB0B8C9)
                        : const Color(0xFF1A1A2E),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
