import 'package:flutter/material.dart';

class AnimatedCounter extends StatefulWidget {
  final int start;
  final int end;
  final Duration duration;
  final Curve curve;
  final TextStyle textStyle;

  const AnimatedCounter({
    Key? key,
    required this.start,
    required this.end,
    required this.duration,
    this.curve = Curves.linear,
    this.textStyle = const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
  }) : super(key: key);

  @override
  _AnimatedCounterState createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _counterAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _counterAnimation = IntTween(
      begin: widget.start,
      end: widget.end,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _counterAnimation,
      builder: (context, child) {
        return Text(
          _counterAnimation.value.toString(),
          style: widget.textStyle,
        );
      },
    );
  }
}
