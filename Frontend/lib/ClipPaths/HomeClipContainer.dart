// ignore_for_file: file_names, prefer_const_constructors
import 'package:google_fonts/google_fonts.dart';

import 'dart:math';
import 'package:flutter/material.dart';

import 'HomeClipPath.dart';

class HomeClipContainer extends StatefulWidget {
  final double height;
  final double width;
  final Color color1;
  final Color color2;

  const HomeClipContainer({Key? key, required this.height, required this.width, required this.color1, required this.color2}) : super(key: key);

  @override
  _HomeClipContainerState createState() => _HomeClipContainerState();
}

class _HomeClipContainerState extends State<HomeClipContainer> {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 4,
      child: ClipPath(
        clipper: HomeClipPath(),
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [widget.color1,widget.color2],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }
}
