import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class VehicleDemo extends StatefulWidget {
  const VehicleDemo({super.key});

  @override
  State<VehicleDemo> createState() => _VehicleDemoState();
}

class _VehicleDemoState extends State<VehicleDemo> {
  SMITrigger? _bump;
  String? message = 'curves';
  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'bumpy',
      onStateChange: _onStateChange,
    );
    artboard.addController(controller!);
    _bump = controller.findInput<bool>('bump') as SMITrigger;
  }

  void _onStateChange(
    String stateMachineName,
    String stateName,
  ) =>
      setState(() {
        message = 'State Changed in $stateMachineName to $stateName';
      });

  void _hitBump() => _bump?.fire();
  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFFefcb7d);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Simple Animation'),
        ),
        body: Stack(
          children: [
            Center(
              child: GestureDetector(
                onTap: _hitBump,
                child: RiveAnimation.asset(
                  'assets/vehicles.riv',
                  fit: BoxFit.cover,
                  onInit: _onRiveInit,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                'State: $message',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
