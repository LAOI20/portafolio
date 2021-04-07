import 'dart:io';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:get/instance_manager.dart';

import 'package:portafolio/src/messagesApp/controllers/ad-drawerChatListC.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PageScanQrCode extends StatefulWidget {
  const PageScanQrCode({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PageScanQrCodeState();
}

class PageScanQrCodeState extends State<PageScanQrCode> {
  final getController = Get.find<MessageAppDrawerChatListController>();

  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  bool firstScan = true;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          
          _buildQrView(context),

          Positioned(
            bottom: 10.0,
            right: 10.0,

            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.flash_on_rounded), 
                  color: Colors.purple,
                  iconSize: 50.0,
                  onPressed: () async{
                    await controller?.toggleFlash();
                    setState(() {});
                  }
                ),

                  const SizedBox(width: 20.0),

                IconButton(
                  icon: Icon(Icons.flip_camera_ios_rounded), 
                  color: Colors.purple,
                  iconSize: 50.0,
                  onPressed: () async{
                    await controller?.flipCamera();
                    setState(() {});
                  }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) { 

      setState(() {
        result = scanData;
        backPage(scanData.code);
      });

    }); 
  }

  void backPage(String value){
    
    if(firstScan == true){
      getController.qrScanSeeProfile(value);
    }

    setState(() => firstScan = false);
  }

  @override
  void dispose() {
    controller?.dispose();

    super.dispose();
  }
}