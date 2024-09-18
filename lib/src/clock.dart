import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AnimatedClock extends StatefulWidget {
  const AnimatedClock({super.key});

  @override
  State<AnimatedClock> createState() => _AnimatedClockState();
}

class _AnimatedClockState extends State<AnimatedClock>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late DateTime _startTime;
  late DateTime _now;
  @override
  void initState() {
    super.initState();
    _startTime = _now = DateTime.now();
    _ticker = createTicker((elapsed) {
      final newTime = _startTime.add(elapsed);
      if (_now.second != newTime.second) {
        setState(() => _now = newTime);
      }
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ClockRenderer(
      dateTime: _now,
    );
  }
}

class _ClockRenderer extends StatelessWidget {
  const _ClockRenderer({
    Key? key,
    required this.dateTime,
  }) : super(key: key);

  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      height: 210,
      decoration: BoxDecoration(
        border: Border.all(width: 3, color: Colors.black),
        borderRadius: BorderRadius.circular(210),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 105,
            left: 100,
            child: Transform(
              alignment: Alignment.topCenter,
              transform: Matrix4.rotationZ(pi + pi / 24 * 2 * dateTime.hour),
              child: Container(height: 90, width: 5, color: Colors.black),
            ),
          ),
          Positioned(
            top: 105,
            left: 100,
            child: Transform(
              alignment: Alignment.topCenter,
              transform: Matrix4.rotationZ(pi + pi / 60 * 2 * dateTime.minute),
              child: Container(height: 50, width: 5, color: Colors.grey),
            ),
          ),
          Positioned(
            top: 105,
            left: 101.5,
            child: Transform(
              alignment: Alignment.topCenter,
              transform: Matrix4.rotationZ(pi + pi / 60 * 2 * dateTime.second),
              child: Container(height: 90, width: 2, color: Colors.red),
            ),
          ),
          Center(
            child: Text(dateTime.toString()),
          )
        ],
      ),
    );
  }
}

class ClockApp extends StatelessWidget {
  const ClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: true,
      home: const AnimatedClockApp(),
      routes: {
        '/whatever': (c) => Scaffold(
              appBar: AppBar(title: const Text('Whatever')),
              body: Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(c),
                  child: const Text('Return to previous page'),
                ),
              ),
            )
      },
    );
  }
}

class AnimatedClockApp extends StatelessWidget {
  const AnimatedClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: AnimatedClock()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/whatever');
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
