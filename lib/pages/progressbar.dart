import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomProgressBar extends StatelessWidget {
  const CustomProgressBar({super.key,required this.width,required this.height,required this.progress});
  final double width, height, progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Container(
            width: width*progress,
            height: height,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              '${(progress*100).toInt()}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}