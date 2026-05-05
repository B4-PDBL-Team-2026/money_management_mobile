import 'dart:math';
import 'package:flutter/material.dart';

class VoiceWaveformWidget extends StatefulWidget {
  const VoiceWaveformWidget({super.key});

  @override
  State<VoiceWaveformWidget> createState() => _VoiceWaveformWidgetState();
}

class _VoiceWaveformWidgetState extends State<VoiceWaveformWidget>
    with TickerProviderStateMixin {
  final int _barCount = 9;
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;
  final _rng = Random();

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_barCount, (i) {
      final duration = Duration(milliseconds: 400 + _rng.nextInt(400));
      return AnimationController(vsync: this, duration: duration)
        ..repeat(reverse: true);
    });

    _animations = List.generate(_barCount, (i) {
      final minH = 0.15 + _rng.nextDouble() * 0.1;
      final maxH = 0.5 + _rng.nextDouble() * 0.5;
      return Tween<double>(begin: minH, end: maxH).animate(
        CurvedAnimation(parent: _controllers[i], curve: Curves.easeInOut),
      );
    });

    // Stagger start times
    for (int i = 0; i < _barCount; i++) {
      Future.delayed(Duration(milliseconds: i * 60), () {
        if (mounted) _controllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Color _barColor(int index) {
    // Center bars: orange/accent, outer bars: blue/muted
    final center = _barCount ~/ 2;
    final dist = (index - center).abs();
    if (dist == 0) return const Color(0xFFF5A623);
    if (dist == 1) return const Color(0xFF4A6FE3);
    return const Color(0xFFB0C4DE);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 80,
      child: AnimatedBuilder(
        animation: Listenable.merge(_controllers),
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(_barCount, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AnimatedContainer(
                  duration: Duration.zero,
                  width: 6,
                  height: 80 * _animations[i].value,
                  decoration: BoxDecoration(
                    color: _barColor(i),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}