import 'dart:async';
import 'dart:ui';

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
  sst.SpeechToText _speech = sst.SpeechToText();
  int ballNumber = 3;
  PermissionStatus? status;
  bool _speechEnabled = false;
  bool _isListening = false;
  String _lastWords = '';
  String _finalResult = '';
  bool _randomizing = false;

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
        print('onStatus: $status');
        if (status == 'notListening') {
          setState(() {
            _isListening = false;
          });
        } else if (status == 'listening') {
          setState(() {
            _isListening = true;
          });
        }
      },
    );
    print('Speech initialized: $_speechEnabled');
    setState(() {});
  }

  void _startListening() async {
    await _speech.listen(
      onResult: _onSpeechResult,
      listenFor: Duration(minutes: 1),
      pauseFor: Duration(seconds: 5),
    );
    setState(() {
      _isListening = true;
      _lastWords = '';
    });
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() {
      _isListening = false;
      _finalResult = _lastWords;
      print('Final result: $_finalResult');
      Future.delayed(Duration(seconds: 1), () {
        changeBall();
      });
    });
  }

  void _onSpeechResult(SpeechRecognitionResult speechResult) {
    setState(() {
      _lastWords = speechResult.recognizedWords;
    });
  }

  void changeBall() {
    if (_randomizing) return;
    _randomizing = true;

    const randomizeDuration = Duration(seconds: 1);
    const interval = Duration(milliseconds: 100);
    final doneRandomizing = DateTime.now().add(randomizeDuration);

    Timer.periodic(interval, (timer) {
      setState(() {
        ballNumber = Random().nextInt(5) + 1;
      });

      if (DateTime.now().isAfter(doneRandomizing)) {
        timer.cancel();
        _randomizing = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: SafeArea(child: Text('My Ball')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: _isListening ? 5.0 : 0.0,
                  sigmaY: _isListening ? 5.0 : 0.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Ball(ballNumber: ballNumber),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.identity()..scale(_isListening ? 1.05 : 1.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Text(
                  _speech.isListening
                      ? '$_lastWords'
                      : _finalResult.isNotEmpty
                          ? _finalResult
                          : !_isListening
                              ? 'Press the button to ask a question'
                              : 'Speech recognition not available',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.identity()..scale(_isListening ? 1.05 : 1.0),
            child: Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  ),
                  onPressed: _speechEnabled
                      ? () {
                          if (_isListening) {
                            _stopListening();
                          } else {
                            _startListening();
                          }
                        }
                      : null,
                  child: Text(
                    _isListening ? "Stop" : 'Ask Me',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
