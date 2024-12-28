import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TapIndicator extends StatefulWidget {
  final VoidCallback? onDismiss;
  const TapIndicator({super.key, this.onDismiss});

  @override
  State<TapIndicator> createState() => _TapIndicatorState();
}

class _TapIndicatorState extends State<TapIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.2, 0),
      end: const Offset(0.2, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Auto-hide after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && widget.onDismiss != null) {
        widget.onDismiss!();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 55,
      left: 40,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(204),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Tap',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const FaIcon(
                FontAwesomeIcons.arrowRight,
                color: Colors.black,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
