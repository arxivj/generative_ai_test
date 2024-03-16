import 'package:flutter/material.dart';
import 'birb.dart';

class BirbHero extends StatelessWidget {
  const BirbHero({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(''),
      ),
      body: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: 'birbHero',
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.transparent,
              child: Birb(),
            ),
          ),
        ],
      ),
    );
  }
}
