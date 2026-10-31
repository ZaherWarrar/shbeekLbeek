import 'package:app/core/constant/app_images.dart';
import 'package:flutter/material.dart';

class StartupSplash extends StatefulWidget {
  const StartupSplash({super.key, required this.child});

  final Widget child;

  @override
  State<StartupSplash> createState() => _StartupSplashState();
}

class _StartupSplashState extends State<StartupSplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _showOverlay = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..forward().whenComplete(() {
        if (mounted) setState(() => _showOverlay = false);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (_showOverlay)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final t = _controller.value;
              final enter = Curves.easeOutCubic.transform(
                (t / 0.42).clamp(0.0, 1.0),
              );
              final glow = Curves.easeOut.transform(
                ((t - 0.08) / 0.5).clamp(0.0, 1.0),
              );
              final leave = Curves.easeInCubic.transform(
                ((t - 0.62) / 0.38).clamp(0.0, 1.0),
              );

              return Opacity(
                opacity: 1 - leave,
                child: ColoredBox(
                  color: Colors.white,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: (0.9 * glow * (1 - leave)).clamp(0.0, 1.0),
                        child: Transform.scale(
                          scale: 0.7 + (0.55 * glow),
                          child: child,
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, -18 * leave),
                        child: Opacity(
                          opacity: enter,
                          child: Transform.scale(
                            scale: 0.84 + (0.16 * enter) + (0.05 * leave),
                            child: const _SplashMark(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: const _SplashGlow(),
          ),
      ],
    );
  }
}

class _SplashGlow extends StatelessWidget {
  const _SplashGlow();

  @override
  Widget build(BuildContext context) {
    final shortest = MediaQuery.sizeOf(context).shortestSide;
    final size = (shortest * 0.78).clamp(240.0, 380.0);

    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Color(0x55FFC107),
              Color(0x225C2A86),
              Color(0x00FFFFFF),
            ],
            stops: [0.15, 0.48, 1],
          ),
        ),
      ),
    );
  }
}

class _SplashMark extends StatelessWidget {
  const _SplashMark();

  @override
  Widget build(BuildContext context) {
    final shortest = MediaQuery.sizeOf(context).shortestSide;
    final logoSize = (shortest * 0.74).clamp(230.0, 360.0);

    return Image.asset(
      Assets.imagesLogoSplash,
      width: logoSize,
      height: logoSize,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
    );
  }
}
