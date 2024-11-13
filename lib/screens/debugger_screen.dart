import 'package:flutter/material.dart';

class DebuggerScreen extends StatefulWidget {
  const DebuggerScreen({super.key});

  @override
  State<DebuggerScreen> createState() => _DebuggerScreenState();
}

class _DebuggerScreenState extends State<DebuggerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Debugger'), backgroundColor: Color.fromARGB(255, 255, 198, 198),),
    );
  }
}