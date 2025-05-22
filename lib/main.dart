import 'package:flutter/material.dart';
import 'package:magic_ball/ball.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'dart:math';
import 'package:speech_to_text/speech_to_text.dart' as sst;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyBall(),
    );
  }
}

class MyBall extends StatefulWidget {
  const MyBall({super.key});

  @override
  State<MyBall> createState() => _MyBallState();
}

class _MyBallState extends State<MyBall> {
  int ballNumber = 3;

  sst.SpeechToText _speech = sst.SpeechToText();

  PermissionStatus? status;
  bool _speechEnabled = false;
  String _lastWords = '';
  String _finalResult = '';

  @override
  void initState() {
    super.initState();
    _checkMicrophonePermission();
    _initSpeech();
  }

  Future<bool> _checkMicrophonePermission() async {
    var result = await Permission.microphone.status;

    if (result.isGranted) {
      setState(() {
        status = result;
      });
    } else if (result.isDenied) {
      var result = await Permission.microphone.request();
      if (result.isGranted) {
        setState(() {
          status = result;
        });
      } else if (result.isPermanentlyDenied) {
        print('Mic permission denied or permanently denied');
        openAppSettings();
        return false;
      }
    }

    return true;
  }

  void _initSpeech() async {
    _speechEnabled = await _speech.initialize(
      onError: (error) => print('onError: $error'),
      onStatus: (status) {
        if (status == 'notListening') {
          setState(() {
            _finalResult = _lastWords;
          });
        }
      },
    );
    print('Speech initialized: $_speechEnabled');
    setState(() {});
  }

  void _startListening() async {
    await _speech.listen(
        onResult: _onSpeechResult, pauseFor: Duration(seconds: 5));
    setState(() {});
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult speechResult) {
    setState(() {
      _lastWords = speechResult.recognizedWords;
    });
  }

  void changeBall() {
    setState(() {
      ballNumber = Random().nextInt(5) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SafeArea(child: Text('My Ball')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              child: Text(
                  _speech.isListening
                      ? '$_lastWords'
                      : _finalResult.isNotEmpty
                          ? _finalResult
                          : _speechEnabled
                              ? 'Press the button to ask a question'
                              : 'Speech recognition not available',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  )),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Center(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
                onPressed: () {
                  if (_speechEnabled) {
                    _speech.isListening ? _stopListening() : _startListening();
                  } else {
                    print('Mic belom siap');
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Speech Recognition belom siap')));
                  }
                  _speech.isNotListening ? _startListening() : _stopListening();
                },
                child: Text(
                  'Ask Me',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
