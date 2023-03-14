import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'bottom_bar.dart';

class MusicApp extends StatefulWidget {
  @override
  _MusicAppState createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  bool playing = false; //  Au début on joue aucun morceau
  IconData playBtn = Icons.play_arrow; // Au débu le button sera play


  late AudioPlayer _player;


  Duration position = new Duration(); // la position du lecteur
  Duration musicLength = new Duration(); // la duréé de la musique

// le lecteur
  Widget slider() {
    return Container(
      width: 300.0,
      child: Slider.adaptive(
          activeColor: Colors.blue[800],
          inactiveColor: Colors.grey[350],
          value: position.inSeconds.toDouble(),
          max: musicLength.inSeconds.toDouble(),
          onChanged: (value) {
            musicToSec(value.toInt());
          }),
    );
  }

  //Pour naviguer dans une partie spécéfique du morceau
  void musicToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    _player.seek(newPos);
  }

  //Initialisation du lecteur
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _player = AudioPlayer();

    _player.onDurationChanged.listen((length) {
      setState(() {
        musicLength = length;
      });
    });

    _player.onPositionChanged.listen((p) {
      setState(() {
        position = p;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.deepOrange,
                Colors.blueAccent,
              ]),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 48.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Let's add some text title
              const Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Center(
                    child: Text(
                      "Sound Vibe",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 38.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
              const SizedBox(
                height: 7.0,
              ),

              const SizedBox(
                height: 40.0,
              ),
              //Let's add the music cover
              Center(
                  child: ClipRRect(
                borderRadius: BorderRadius.circular(20), // Image border
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(100), // Image radius
                  child: Image.asset('assets/min.jpeg', fit: BoxFit.cover),
                ),
              )),

              const SizedBox(
                height: 30.0,
              ),
              const Center(
                child: Text(
                  "Mons - Vibe",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),

              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Let's start by adding the controller
                    //let's add the time indicator text

                    SizedBox(
                      width: 500.0,
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${position.inMinutes}:${position.inSeconds.remainder(60)}",
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          slider(),
                          Text(
                            "${musicLength.inMinutes}:${musicLength.inSeconds.remainder(60)}",
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 45.0,
                          color: Colors.blue[800],
                          onPressed: () {},
                          icon: const Icon(
                            Icons.skip_previous,
                          ),
                        ),
                        IconButton(
                          iconSize: 62.0,
                          color: Colors.blue[800],
                          onPressed: () {
                            // lorsque on click  sur play
                            if (!playing) { // on verifie d'abord si on a pas deja cliqué

                              _player.play(AssetSource("audio/theme_01.mp3")); // on lance le morceau theme pour tester
                              setState(() {
                                playBtn = Icons.pause; // le bouton play va devenir pause
                                playing = true;
                              });
                            } else { // si le morceau est déja lancé
                              _player.pause(); // on arrête ce morceau
                              setState(() {
                                playBtn = Icons.play_arrow; // on change le button en play
                                playing = false;
                              });
                            }
                          },
                          icon: Icon(
                            playBtn,
                          ),
                        ),
                        IconButton(
                          iconSize: 45.0,
                          color: Colors.blue[800],
                          onPressed: () {},
                          icon: const Icon(
                            Icons.skip_next,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}
