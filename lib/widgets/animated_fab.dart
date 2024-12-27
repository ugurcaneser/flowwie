import 'package:flutter/material.dart';
import '../screens/add_transaction_screen.dart';

class AnimatedFab extends StatefulWidget {
  const AnimatedFab({super.key});

  @override
  State<AnimatedFab> createState() => _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  late AnimationController _animationController;
  late Animation<double> _animateIcon;
  late Animation<double> _translateButton;
  late Animation<double> _opacity;
  final Curve _curve = Curves.easeOut;
  final double _fabHeight = 56.0;

  @override
  initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {});
      });

    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));

    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget _buildIncomeButton(BuildContext context) {
    return Transform(
      transform: Matrix4.translationValues(
        0.0,
        _translateButton.value * 2,
        0.0,
      ),
      child: Opacity(
        opacity: _opacity.value,
        child: FloatingActionButton.extended(
          heroTag: 'income',
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () {
            animate();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddTransactionScreen(isIncome: true),
              ),
            );
          },
          label: const Text(
            'Income',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          icon: const Icon(Icons.add, color: Colors.white, size: 22),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }

  Widget _buildExpenseButton(BuildContext context) {
    return Transform(
      transform: Matrix4.translationValues(
        0.0,
        _translateButton.value,
        0.0,
      ),
      child: Opacity(
        opacity: _opacity.value,
        child: FloatingActionButton.extended(
          heroTag: 'expense',
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () {
            animate();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddTransactionScreen(isIncome: false),
              ),
            );
          },
          label: const Text(
            'Expense',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          icon: const Icon(Icons.remove, color: Colors.white, size: 22),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }

  Widget _buildToggleButton() {
    return FloatingActionButton(
      backgroundColor: Colors.transparent,
      elevation: 0,
      onPressed: animate,
      child: Image.asset(
        'lib/assets/icons/capital_18281996.png',
        width: 48,
        height: 48,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_opacity.value > 0) _buildIncomeButton(context),
          if (_opacity.value > 0) _buildExpenseButton(context),
          _buildToggleButton(),
        ],
      ),
    );
  }
}
