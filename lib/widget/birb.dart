import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Birb extends StatefulWidget {
  const Birb({super.key});

  @override
  State<Birb> createState() => _BirbState();
}

class _BirbState extends State<Birb> {

  late StateMachineController _birbController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RiveAnimation.asset("assets/images/birb.riv",
      ),
    );
  }
}
