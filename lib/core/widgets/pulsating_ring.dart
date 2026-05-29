import 'package:flutter/material.dart';

class PulsatingRing extends StatefulWidget {
  final Widget child;
  final Color pulseColor;
  final double maxRadius;
  final int ringsCount;
  final Duration duration;

  const PulsatingRing({
    Key? key,
    required this.child,
    this.pulseColor = const Color(0xFFBA1A1A),
    this.maxRadius = 160.0,
    this.ringsCount = 3,
    this.duration = const Duration(milliseconds: 2400),
  }) : super(key: key);

  @override
  State<PulsatingRing> createState() => _PulsatingRingState();
}

class _PulsatingRingState extends State<PulsatingRing> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.ringsCount, (index) {
      final controller = AnimationController(
        vsync: this,
        duration: widget.duration,
      );
      
      // Stagger the ring animation start times
      Future.delayed(
        widget.duration * (index / widget.ringsCount),
        () {
          if (mounted) {
            controller.repeat();
          }
        },
      );
      
      return controller;
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ...List.generate(widget.ringsCount, (index) {
          final animation = Tween<double>(begin: 0.2, end: 1.0).animate(
            CurvedAnimation(
              parent: _controllers[index],
              curve: Curves.easeOut,
            ),
          );
          
          final opacityAnimation = Tween<double>(begin: 0.6, end: 0.0).animate(
            CurvedAnimation(
              parent: _controllers[index],
              curve: Curves.easeOut,
            ),
          );

          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final size = widget.maxRadius * animation.value;
              return Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.pulseColor.withOpacity(opacityAnimation.value),
                ),
              );
            },
          );
        }),
        widget.child,
      ],
    );
  }
}
