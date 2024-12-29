import 'package:flutter/material.dart';
import '../utils/size_config.dart';

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
      bottom:
          SizeConfig.blockSizeVertical * 6.5, // Adjusted for better positioning
      left: SizeConfig.blockSizeHorizontal * 10,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 4,
                  vertical: SizeConfig.blockSizeVertical * 1,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(204),
                  borderRadius:
                      BorderRadius.circular(SizeConfig.blockSizeHorizontal * 5),
                ),
                child: Text(
                  'Tap',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.blockSizeHorizontal * 3.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
              Icon(
                Icons.arrow_forward,
                color: Colors.black,
                size: SizeConfig.blockSizeHorizontal * 4.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
