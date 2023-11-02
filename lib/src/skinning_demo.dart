import 'package:flutter/material.dart';
import 'package:flutter_module_umbrella/src/injection.dart';
import 'package:rive/rive.dart';

/// Basic skinning example. The skinning states is set in the Rive editor and
/// triggers are used to change the value.
class SkinningDemo extends StatefulWidget {
  const SkinningDemo({Key? key}) : super(key: key);

  @override
  State<SkinningDemo> createState() => _SkinningDemoState();
}

class _SkinningDemoState extends State<SkinningDemo>
    with WidgetsBindingObserver {
  static const _skinMapping = {
    "Skin_0": "Plain",
    "Skin_1": "Summer",
    "Skin_2": "Elvis",
    "Skin_3": "Superhero",
    "Skin_4": "Astronaut"
  };

  String _currentState = 'Plain';

  SMITrigger? _skin;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    logger.d(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'Motion',
      onStateChange: _onStateChange,
    );

    artboard.addController(controller!);
    _skin = controller.findInput<bool>('Skin') as SMITrigger;
  }

  void _onStateChange(String stateMachineName, String stateName) {
    if (stateName.contains("Skin_")) {
      setState(() {
        _currentState = _skinMapping[stateName] ?? 'Plain';
      });
    }
  }

  void _swapSkin() {
    _skin?.fire();
  }

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFFefcb7d);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Skinning Demo'),
        ),
        body: Stack(
          children: [
            Center(
              child: RiveAnimation.asset(
                'assets/skins_demo.riv',
                fit: BoxFit.cover,
                onInit: _onRiveInit,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                      'Choose an Avatar',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: _swapSkin,
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Color(0xFF7d99ef)),
                    ),
                    child: const Text('Swap Skin'),
                  ),
                  const Spacer(),
                  Text(
                    'Skin: $_currentState',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 48)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
