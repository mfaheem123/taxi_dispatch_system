import 'package:flutter/material.dart';

class WallboardScreen extends StatefulWidget {
  const WallboardScreen({super.key});

  @override
  State<WallboardScreen> createState() => _WallboardScreenState();
}

class _WallboardScreenState extends State<WallboardScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView();
  }
}
