
import 'dart:io' as IO;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'musicPlayer.dart';
import 'bottom_bar.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:microphone/microphone.dart';
import '../services/authservice.dart';
import 'package:path_provider/path_provider.dart';
import 'package:assets_audio_player/assets_audio_player.dart';


class Introduction extends StatefulWidget {

  @override
  Intro createState() => Intro();

}

class Intro extends State<Introduction> {

  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;
  final recordingPlayer = AssetsAudioPlayer();
  final player = FlutterSoundPlayer();


  Future record() async {

    //final String tempDir = (await getTemporaryDirectory()).path;
    //final String filePath = '$tempDir/recording.wav';

    print(' debut record ?????');

    if(!isRecorderReady){
      return;
    }
    await recorder.startRecorder(toFile: 'audio');
    print(' vrai start');
  }

  Future stop() async {
    if(!isRecorderReady){
      return;
    }

    final filePath = await recorder.stopRecorder();
    final file = File(filePath!);
    print('recorder in file : $file');
    // Create a Dio instance
    final dio = Dio();

    // Create a FormData object to send the file
    final formData = FormData.fromMap({
      'audio': await MultipartFile.fromFile(filePath),
    });

    // Send the HTTP request
    try {
      final response = await dio.post(
        'http://10.0.2.2:3000/audiosend',
        data: formData,
        options: Options(
          headers: { HttpHeaders.contentTypeHeader: 'multipart/form-data' },
        ),
      );
      print(response.statusCode);
    } catch (e) {
      print(e);
    }


    /**
    AuthService().sendAudio(path!).then((val) {
      print(val.data['success']);
    });

     **/
    //playFunc(path);


  }

  Future<void> playFunc() async {

    await Permission.audio.request();
    await Permission.storage.request();

    final String tempDir = (await getTemporaryDirectory()).path;
    final String filePath = '$tempDir/recording.wav';

    try {
      await player.openPlayer();
      await player.startPlayer(fromURI: 'audio');
    } catch (err) {
      print('Error playing audio: $err');
    }


  }

  Future<void> stopAudio() async {


    await player.stopPlayer();

  }

  @override
  void initState(){
    super.initState();
    print("init en premier  ");
    initRecorder();


  }

  @override
  void dispose(){
    recorder.closeRecorder();
    player.closePlayer();
    super.dispose();
  }

  Future initRecorder() async{
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted){
      throw 'Microphone non fonctionnel';
    }

    print("bah oui la ");
    await recorder.openRecorder();

    isRecorderReady = true;
    await recorder.setSubscriptionDuration( const Duration( milliseconds: 500),);

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "dkj",
        home: Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: const Text(
              "Sound Vibe",
            ),
            elevation: 10,
            backgroundColor: Colors.redAccent,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder<RecordingDisposition>(
                      stream: recorder.onProgress,
                        builder: (context,snapshot) {
                          final duration = snapshot.hasData
                              ? snapshot.data!.duration
                              :Duration.zero;
                          return Text('${duration.inSeconds} s');
                        },
                    ),
                    const SizedBox( height: 32,),
                    ElevatedButton(
                      child: Icon(
                        recorder.isRecording ? Icons.stop : Icons.mic,
                        size: 90.0,
                        color: Colors.redAccent,
                      ),
                      onPressed: () async{
                        print("appuie btn");
                        if(recorder.isRecording){
                          await stop();
                        } else {
                          await record();
                        }

                        setState(() {

                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: playFunc,
                      child: Text('Play Audio'),
                    ),
                    ElevatedButton(
                      onPressed: stopAudio,
                      child: Text('Stop Audio'),
                    ),
                  ],
                ),
          ),

          bottomNavigationBar: BottomBar(),
        )
    );
  }
}

