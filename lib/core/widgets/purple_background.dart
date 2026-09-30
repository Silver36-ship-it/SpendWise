import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PurpleBackground extends StatelessWidget {
  final Widget child;

  const PurpleBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.purple,
                AppColors.purpleMid,
                AppColors.darkPurple,
              ],
            ),
          ),
        ),

        Positioned(
          top: -100,
          right: -80,
          child: _GlowCircle(
            size: 280,
          ),
        ),

        Positioned(
          top: 280,
          left: -150,
          child: _GlowCircle(
            size: 300,
          ),
        ),

        Positioned(
          bottom: -120,
          right: -100,
          child: _GlowCircle(
            size: 300,
          ),
        ),

        SafeArea(
          child: child,
        ),
      ],
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;

  const _GlowCircle({
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: 45,
        sigmaY: 45,
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.purpleAccent.withOpacity(0.45),
        ),
      ),
    );
  }
}