import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'package:flyinsky/theme/color/colors.dart';

class Compass extends StatefulWidget {
  const Compass({this.direction, this.speed});
  final int? direction, speed;

  @override
  State<Compass> createState() => _CompassState();
}

class _CompassState extends State<Compass> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _rotation;

  double _previousDirection = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _rotation = Tween<double>(begin: 0, end: 0).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant Compass oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newDirection = (widget.direction ?? 0).toDouble();
    _rotation = Tween<double>(
      begin: _previousDirection * math.pi / 180,
      end: newDirection * math.pi / 180,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward(from: 0);
    _previousDirection = newDirection;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorsPalette['card blue'],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(top: 8, child: Text('N', style: GoogleFonts.nunito(
                    color: colorsPalette['title'],
                    fontWeight: FontWeight.bold,
                  ))),
                  Positioned(bottom: 8, child: Text('S', style: GoogleFonts.nunito(
                    color: colorsPalette['title'],
                    fontWeight: FontWeight.bold,
                  ))),
                  Positioned(left: 8, child: Text('W', style: GoogleFonts.nunito(
                    color: colorsPalette['title'],
                    fontWeight: FontWeight.bold,
                  ))),
                  Positioned(right: 8, child: Text('E', style: GoogleFonts.nunito(
                    color: colorsPalette['title'],
                    fontWeight: FontWeight.bold,
                  ))),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _rotation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotation.value,
                  child: Icon(Icons.navigation, size: 48, color: colorsPalette['arrow blue']),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 7),
        Text(
          'Wind direction ${widget.direction ?? 0}°',
          style: GoogleFonts.nunito(
            color: colorsPalette['content'],
            fontWeight: FontWeight.bold,
          )
        ),
        Text(
          '${widget.speed ?? 0} KT',
          style: GoogleFonts.nunito(
            color: colorsPalette['title'],
            fontSize: 15,
            fontWeight: FontWeight.bold,
          )
        ),
      ],
    );
  }
}