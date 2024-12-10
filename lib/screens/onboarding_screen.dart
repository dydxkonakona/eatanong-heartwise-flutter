import 'package:final_eatanong_flutter/screens/calendar_screen.dart';
import 'package:final_eatanong_flutter/screens/initial_page.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart'; // Import the provider package
import 'package:final_eatanong_flutter/providers/person_provider.dart'; // Import the PersonProvider

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false; // To track if the video is playing
  double _currentPosition = 0.0; // To track the current position of the video
  double _videoDuration = 0.0; // To track the video duration

  @override
  void initState() {
    super.initState();
    // Initialize the video player controller
    _controller = VideoPlayerController.asset('assets/tutorial_video.mp4')
      ..initialize().then((_) {
        setState(() {
          _videoDuration = _controller.value.duration.inSeconds.toDouble();
          _controller.play();
          _isPlaying = true;
        });
      });

    // Listen for video position updates
    _controller.addListener(() {
      setState(() {
        _currentPosition = _controller.value.position.inSeconds.toDouble();
      });
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  void _rewind() {
    final newPosition = _controller.value.position.inSeconds - 10;
    _controller.seekTo(Duration(seconds: newPosition < 0 ? 0 : newPosition));
  }

  void _fastForward() {
    final newPosition = _controller.value.position.inSeconds + 10;
    _controller.seekTo(Duration(seconds: newPosition > _videoDuration ? _videoDuration.toInt() : newPosition));
  }

  @override
  Widget build(BuildContext context) {
    // Access the PersonProvider using the provider package
    final personProvider = Provider.of<PersonProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorial', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 255, 198, 198),
        elevation: 0,
      ),
      body: SingleChildScrollView( // This ensures the screen is scrollable if content overflows
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Add some padding for better spacing
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Video player widget
                _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : const CircularProgressIndicator(), // Show a loading spinner until the video is ready

                const SizedBox(height: 20),

                // Playback Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.replay_10),
                      onPressed: _rewind,
                    ),
                    IconButton(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      onPressed: _togglePlayPause,
                    ),
                    IconButton(
                      icon: const Icon(Icons.forward_10),
                      onPressed: _fastForward,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Video Progress Slider (Seek Bar)
                Slider(
                  min: 0.0,
                  max: _videoDuration,
                  value: _currentPosition,
                  onChanged: (value) {
                    setState(() {
                      _currentPosition = value;
                      _controller.seekTo(Duration(seconds: value.toInt()));
                    });
                  },
                ),

                const SizedBox(height: 20),

                // "Done" button
                ElevatedButton(
                  onPressed: () {
                    // Check if the person list is empty or not
                    if (personProvider.persons.isNotEmpty) {
                      // Navigate to the DietLogScreen if persons list is not empty
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const DietLogScreen()),
                      );
                    } else {
                      // Navigate to the Initial Page if persons list is empty
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => InitialPage()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    backgroundColor: const Color(0xFFFF6363),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 5,
                    side: const BorderSide(
                      color: Color(0xFFFF6363),
                      width: 2,
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
