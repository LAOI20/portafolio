import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:portafolio/src/services/APImodel.dart';
import 'package:portafolio/src/services/myInfo.dart';

import 'package:portafolio/src/widgets/alertMessage.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'dart:async';
import 'package:flutter/material.dart';

const AGORA_APP_ID = 'd04ce9553fe3416aac0e345a66dcf3b9';


class PageVideoCall extends StatefulWidget {

  final String friendToken;
  final String channelName;
  final ClientRole role;
  final String token;
  final bool iInitCall;

  const PageVideoCall({Key key, this.channelName, this.token, this.iInitCall, this.role, this.friendToken}) : super(key: key);

  @override
  _PageVideoCallState createState() => _PageVideoCallState();
}

class _PageVideoCallState extends State<PageVideoCall> {

  final _users = <int>[];

  bool muted = false;
  RtcEngine _engine;

  @override
  void dispose() {
    print('EVEEEENTT DIPOSE VIDE CALL PAGE');
    _users.clear();
    _engine.leaveChannel();
    _engine.destroy();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // initialize agora sdk
    initialize();

    timerCallWithoutResponse();
  }

  void timerCallWithoutResponse(){
    Timer(Duration(seconds: 15), (){
      if(widget.iInitCall == true &&
          _getRenderViews().length < 2
      ){
        Navigator.pop(context);
        AlertMessage().alertaMensaje('Sin respuesta');
      }
    });
  }

  Future<void> initialize() async {
    
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();

    // ignore: deprecated_member_use
    await _engine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(1920, 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(widget.token, widget.channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.createWithConfig(RtcEngineConfig(AGORA_APP_ID));
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
  }


  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      
    }, leaveChannel: (stats) {
      setState(() {
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        _users.remove(uid);
      });
    }));
  }


  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (widget.role == ClientRole.Broadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:        
        return Container(
            child: Column(
          children: <Widget>[
            _videoView(views[0])
          ],
        ));
      case 2:
        return Container(
            child: Stack(
          children: <Widget>[
            //CONTAINER FULL SCREEN
            Container(
              child: views[1]
            ),

            SafeArea(
              child: Align(
                alignment: Alignment.topRight,

                child: Container(
                  height: 150.0,
                  width: 100.0,
                  margin: EdgeInsets.only(
                    top: 6.0,
                    right: 6.0
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    
                    child: views[0]
                  ),
                )
              ),
            ),
          ],
        )); 
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    if (widget.role == ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 28.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }


  void _onCallEnd(BuildContext context) {
    if(_getRenderViews().length == 2){
      APImodel().notificationsAPI(
        to: widget.friendToken,
        title: "Llamada finalizada",
        body: "${MyInfo.myName} finalizo la llamada",
        data: {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          'type': 'userEndedCall',
        }
      );
    }

    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),

      child: Scaffold(
        backgroundColor: Colors.black,

        body: Center(
          child: Stack(
            children: <Widget>[
              _viewRows(),
              _toolbar(),

              _getRenderViews().length == 1 ?
                Center(
                  child: Teexts().label(
                    'Esperando respuesta...', 
                    18.0, 
                    Colors.white,
                    fontWeight: FontWeight.w800
                  ),
                )
                :
                SizedBox(height: 0.0)
            ],
          ),
        ),
      ),
    );
  }
}