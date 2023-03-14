import 'package:flutter/material.dart';
import 'package:jjaudioplayer/acceuil.dart';

import 'musicPlayer.dart';


class BottomBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BottomBar();
  }
}

class _BottomBar extends State<BottomBar> with SingleTickerProviderStateMixin {
  bool connecte = false;
  var role;

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      color: Colors.transparent,
      elevation: 9.0,
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 50.0,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0)),
            color: Colors.white
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.home),
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Introduction()));
                    },
                  ),
                  if (connecte == false)
                    IconButton(
                      icon: const Icon(Icons.person),
                      color: const Color(0xFF676E79),
                      onPressed: () {

                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.music_note),
                    color: const Color(0xFF676E79),
                    onPressed: () async {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => MusicApp()));
                    },
                  ),


                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
