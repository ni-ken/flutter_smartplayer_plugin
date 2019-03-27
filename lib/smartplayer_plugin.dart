import 'dart:async';
import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'smartplayer.dart';

typedef void SmartPlayerCreatedCallback(SmartPlayerController controller);

class SmartPlayerWidget extends StatefulWidget {
  final SmartPlayerCreatedCallback onSmartPlayerCreated;

  SmartPlayerWidget({
    Key key,
    @required this.onSmartPlayerCreated,
  });

  @override
  State<StatefulWidget> createState() => _SmartPlayerWidgetState();
}

class _SmartPlayerWidgetState extends State<SmartPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'smartPlayerView',
        onPlatformViewCreated: onPlatformViewCreated,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'smartPlayerView',
        onPlatformViewCreated: onPlatformViewCreated,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }

    return new Text(
        '$defaultTargetPlatform is not yet supported by this plugin');
  }

  Future<void> onPlatformViewCreated(id) async {
    if (widget.onSmartPlayerCreated == null) {
      return;
    }
    SmartPlayerController controller = SmartPlayerController();
    controller.init(id);
    widget.onSmartPlayerCreated(controller);
  }
}
