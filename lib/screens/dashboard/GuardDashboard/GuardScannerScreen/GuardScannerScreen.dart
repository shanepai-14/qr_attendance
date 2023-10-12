import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:fk_toggle/fk_toggle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../repository/authentication_repository/authetication_repository.dart';

class GuardScannerScreen extends StatefulWidget {
  const GuardScannerScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GuardScannerScreenState();
}

bool checkin = true;

class _GuardScannerScreenState extends State<GuardScannerScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  bool canToggle = true;

  // Initialize with the default value (0 or 1)
  final OnSelected selected = ((int index, instance) {
    // Get.snackbar('Select $index', "toggle ${instance.labels[index]}",
    //     snackPosition: SnackPosition.TOP,
    //     backgroundColor: Colors.green.shade200,
    //     colorText: Colors.white);
    someFunctions(index);
  });

  static void someFunctions(int index) {
    if (index == 0) {
      print(index);
      checkin = true;
    } else {
      checkin = false;
    }
  }

  bool isCheckInSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text('Scanning: ${result!.code}')
                  else
                    const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text('Flash: ${snapshot.data}');
                              },
                            )),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      'Camera facing ${describeEnum(snapshot.data!)}');
                                } else {
                                  return const Text('loading');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.all(8),
                          child: FkToggle(
                            width: 120,
                            height: 50,
                            labels: const ['Check In', 'Check Out'],
                            selectedColor: Colors.lightBlueAccent,
                            backgroundColor: Colors.white,
                            onSelected: selected,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 350.0
        : 600.0;
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
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  final player = AudioPlayer();
  playScanSound() {
    player.play(AssetSource('sounds/scannerbeep.mp3'));
  }

  bool canScan = true;
  void _onQRViewCreated(
    QRViewController controller,
  ) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      if (canScan) {
        setState(() {
          playScanSound();
          result = scanData;
          String email = '${result!.code}'.trim();

          try {
            AuthenticationRepository().fetchAndUploadAttendance(email, checkin);
          } catch (e) {
            print(
                'Error Scanning : Try again: $e' + email + scanData.toString());
          }
        });

        // Disable scanning for a short duration
        canScan = false;
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            canScan = true;
          });
        });
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
