import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';

/// A high-performance, silky-smooth animated ambient background with floating glowing orbs
class SAnimatedAmbientBackground extends StatefulWidget {
  const SAnimatedAmbientBackground({
    super.key,
    required this.child,
    this.showBlur = true,
  });

  final Widget child;
  final bool showBlur;

  @override
  State<SAnimatedAmbientBackground> createState() => _SAnimatedAmbientBackgroundState();
}

class _SAnimatedAmbientBackgroundState extends State<SAnimatedAmbientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = SHelperFunctions.isDarkMode(context);
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: dark ? SColors.dark : SColors.light,
      body: Stack(
        children: [
          /// Moving Ambient Glowing Mesh Orbs
          AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              final progress = _animation.value;
              return Stack(
                children: [
                  /// Top-left primary indigo orb
                  Positioned(
                    top: -60 + (progress * 50),
                    left: -50 + (progress * 40),
                    child: Container(
                      width: size.width * 0.75,
                      height: size.width * 0.75,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            SColors.primary.withValues(alpha: dark ? 0.28 : 0.18),
                            SColors.primary.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// Bottom-right violet / indigo orb
                  Positioned(
                    bottom: -80 + ((1 - progress) * 60),
                    right: -60 + ((1 - progress) * 50),
                    child: Container(
                      width: size.width * 0.85,
                      height: size.width * 0.85,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF6366F1).withValues(alpha: dark ? 0.25 : 0.15),
                            const Color(0xFF6366F1).withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// Middle-right accent warm amber gold orb
                  Positioned(
                    top: size.height * 0.35 + (progress * 40),
                    right: -80 + (progress * 30),
                    child: Container(
                      width: size.width * 0.6,
                      height: size.width * 0.6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            SColors.secondary.withValues(alpha: dark ? 0.12 : 0.10),
                            SColors.secondary.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// Center subtle highlight glow
                  Positioned(
                    top: size.height * 0.2 + ((1 - progress) * 30),
                    left: size.width * 0.2,
                    child: Container(
                      width: size.width * 0.5,
                      height: size.width * 0.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            SColors.primary.withValues(alpha: dark ? 0.10 : 0.08),
                            SColors.primary.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          /// Glassmorphic Blur Overlay for liquid smooth ambient lighting
          if (widget.showBlur)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
                child: const SizedBox.expand(),
              ),
            ),

          /// Foreground Screen Content
          SafeArea(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
