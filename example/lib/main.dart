import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smartplayer_native_view/smartplayer.dart';
import 'package:smartplayer_native_view/smartplayer_plugin.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SmartPlayerController player;
  double aspectRatio = 4.0 / 3.0;

  @override
  void initState() {
    super.initState();
  }

  Widget smartPlayerView() {
    return SmartPlayerWidget(
      onSmartPlayerCreated: onSmartPlayerCreated,
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin SmartPlayer Demo'),
        ),
        body: Center(
          child: Container(
            width:300,
            color: Colors.blueAccent,
            child: AspectRatio(
              child: smartPlayerView(),
              aspectRatio: aspectRatio,
            ),
          ),
        ),
      ),
    );
  }

  void _eventCallback(int code, String param1, String param2) {
    if (code == EVENTID.EVENT_DANIULIVE_ERC_PLAYER_RESOLUTION_INFO) {
      // setState(() {
      //   aspectRatio = double.parse(param1) / double.parse(param2);
      //   print('change aspectRatio:$aspectRatio');
      // });
    }
  }

  void onSmartPlayerCreated(SmartPlayerController controller) async {
    player = controller;
    player.setEventCallback(_eventCallback);
    var ret = await player.setVideoDecoderMode(1);
    ret = await player.setBuffer(200);
    ret = await player.setMute(0);
    ret = await player.setFastStartup(1);
    ret = await player.setPlayerLowLatencyMode(0);
    ret = await player.setUrl('rtmp://live.hkstv.hk.lxdns.com/live/hks1');
    // ret = await player.setUrl('rtmp://coin.liveplay.9you.com/live/34876_1');
    
    ret = await player.startPlay();
  }
}
