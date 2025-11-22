import 'package:flutter/material.dart';
import 'package:m_hike_cross_app/ui/add_hike.dart';
import 'package:m_hike_cross_app/ui/show_all_hike.dart';
import 'package:audioplayers/audioplayers.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _tapCount = 0;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // Listen to player state changes
    player.onPlayerStateChanged.listen((state) {
      debugPrint('AudioPlayer state: $state');
    });
    // Listen for any errors
    player.onLog.listen((msg) {
      debugPrint('AudioPlayer log: $msg');
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _tapCount++;
      if (_tapCount == 5) {
        player.play(AssetSource('cat_sound.mp3'));
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/cat.gif'),
                  TextButton(
                    child: const Text('X'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
        );
        _tapCount = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('M-Hike'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _handleTap,
              child: const Text(
                'M-Hike',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddHikeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text('Add New Hike'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShowAllHikeScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text('View All Hikes'),
            ),
          ],
        ),
      ),
    );
  }
}
