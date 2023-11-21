import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:screenshot/screenshot.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:modern_form_line_awesome_icons/modern_form_line_awesome_icons.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import '../../auth/controllers/user_controller.dart';

class ScannerScreen extends StatefulWidget {
  ScannerScreen({Key? key}) : super(key: key);

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

User? user = FirebaseAuth.instance.currentUser;
String? userEmail = user?.email;
final UserController userController = Get.find<UserController>();

String CurrentUserEmail = userController.user.value.email.toString();

class _ScannerScreenState extends State<ScannerScreen> {
  @protected
  late QrCode qrCode;

  @protected
  late QrImage qrImage;

  @protected
  late PrettyQrDecoration decoration;

  @override
  void initState() {
    super.initState();
    userController.loadUserData();
    qrCode = QrCode.fromData(
      data: CurrentUserEmail,
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );

    qrImage = QrImage(qrCode);

    decoration = const PrettyQrDecoration(
      shape: PrettyQrSmoothSymbol(
        color: Color(0xFF000000),
      ),
      image: _PrettyQrSettings.kDefaultPrettyQrDecorationImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {}, icon: const Icon(LineAwesomeIcons.heartbeat)),
        title: Text(
          "QR Code",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(LineAwesomeIcons.qrcode))
        ],
        centerTitle: true,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1024,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final safePadding = MediaQuery.of(context).padding;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (constraints.maxWidth >= 720)
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: safePadding.left + 24,
                          right: safePadding.right + 24,
                          bottom: 24,
                        ),
                        child: _PrettyQrAnimatedView(
                          qrImage: qrImage,
                          decoration: decoration,
                        ),
                      ),
                    ),
                  Flexible(
                    flex: 2,
                    child: Column(
                      children: [
                        if (constraints.maxWidth < 720)
                          Padding(
                            padding: safePadding.copyWith(
                              top: 0,
                              bottom: 0,
                            ),
                            child: _PrettyQrAnimatedView(
                              qrImage: qrImage,
                              decoration: decoration,
                            ),
                          ),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: safePadding.copyWith(top: 0),
                            child: _PrettyQrSettings(
                              decoration: decoration,
                              onChanged: (value) => setState(() {
                                decoration = value;
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PrettyQrAnimatedView extends StatefulWidget {
  @protected
  final QrImage qrImage;

  @protected
  final PrettyQrDecoration decoration;

  const _PrettyQrAnimatedView({
    required this.qrImage,
    required this.decoration,
  });

  @override
  State<_PrettyQrAnimatedView> createState() => _PrettyQrAnimatedViewState();
}

class _PrettyQrAnimatedViewState extends State<_PrettyQrAnimatedView> {
  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) async {
    try {
      if (capturedImage != null) {
        final result = await ImageGallerySaver.saveImage(
            capturedImage.buffer.asUint8List());
        print(result);
      }
      Get.snackbar("Successfully", "Downloaded the QR image",
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green.shade200,
          colorText: Colors.white);

      return showDialog(
        useSafeArea: false,
        context: context,
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text("Downloaded QR code"),
          ),
          body: Center(child: Image.memory(capturedImage)),
        ),
      );
    } catch (e) {
      Get.snackbar("Something went wrong", "Please try again",
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.redAccent.shade200,
          colorText: Colors.white);
    }
  }

  @protected
  late PrettyQrDecoration previosDecoration;
  ScreenshotController screenshotController = ScreenshotController();
  @override
  void initState() {
    super.initState();

    previosDecoration = widget.decoration;
  }

  @override
  void didUpdateWidget(
    covariant _PrettyQrAnimatedView oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (widget.decoration != oldWidget.decoration) {
      previosDecoration = oldWidget.decoration;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Screenshot(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TweenAnimationBuilder<PrettyQrDecoration>(
                  tween: PrettyQrDecorationTween(
                    begin: previosDecoration,
                    end: widget.decoration,
                  ),
                  curve: Curves.ease,
                  duration: const Duration(
                    milliseconds: 240,
                  ),
                  builder: (context, decoration, child) {
                    return PrettyQrView(
                      qrImage: widget.qrImage,
                      decoration: decoration,
                    );
                  },
                ),
              ),
            ),
            controller: screenshotController),
        ElevatedButton(
          onPressed: () {
            screenshotController
                .capture(delay: Duration(milliseconds: 10))
                .then((capturedImage) async {
              ShowCapturedWidget(context, capturedImage!);
            }).catchError((onError) {
              print(onError);
            });
          },
          child: Text('Download QR'),
        ),
      ],
    );
  }
}

class _PrettyQrSettings extends StatefulWidget {
  @protected
  final PrettyQrDecoration decoration;

  @protected
  final ValueChanged<PrettyQrDecoration>? onChanged;

  @visibleForTesting
  static const kDefaultPrettyQrDecorationImage = PrettyQrDecorationImage(
    image: AssetImage('assets/images/dvclogo.png'),
    position: PrettyQrDecorationImagePosition.embedded,
  );

  const _PrettyQrSettings({
    required this.decoration,
    this.onChanged,
  });

  @override
  State<_PrettyQrSettings> createState() => _PrettyQrSettingsState();
}

class _PrettyQrSettingsState extends State<_PrettyQrSettings> {
  @protected
  Color get shapeColor {
    var shape = widget.decoration.shape;
    if (shape is PrettyQrSmoothSymbol) return shape.color;
    if (shape is PrettyQrRoundedSymbol) return shape.color;
    return Colors.black;
  }

  @protected
  bool get isRoundedBorders {
    var shape = widget.decoration.shape;
    if (shape is PrettyQrSmoothSymbol) {
      return shape.roundFactor > 0;
    } else if (shape is PrettyQrRoundedSymbol) {
      return shape.borderRadius != BorderRadius.zero;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return PopupMenuButton(
              onSelected: changeShape,
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
              ),
              initialValue: widget.decoration.shape.runtimeType,
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: PrettyQrSmoothSymbol,
                    child: Text('Smooth'),
                  ),
                  const PopupMenuItem(
                    value: PrettyQrRoundedSymbol,
                    child: Text('Rounded rectangle'),
                  ),
                ];
              },
              child: ListTile(
                leading: const Icon(Icons.format_paint_outlined),
                title: const Text('Style'),
                trailing: Text(
                  widget.decoration.shape is PrettyQrSmoothSymbol
                      ? 'Smooth'
                      : 'Rounded rectangle',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            );
          },
        ),
        SwitchListTile.adaptive(
          value: shapeColor != Colors.black,
          onChanged: (value) => toggleColor(),
          secondary: const Icon(Icons.color_lens_outlined),
          title: const Text('Colored'),
        ),
        SwitchListTile.adaptive(
          value: isRoundedBorders,
          onChanged: (value) => toggleRoundedCorners(),
          secondary: const Icon(Icons.rounded_corner),
          title: const Text('Rounded corners'),
        ),
        const Divider(),
        // SwitchListTile.adaptive(
        //   value: widget.decoration.image != null,
        //   onChanged: (value) => toggleImage(),
        //   secondary: Icon(
        //     widget.decoration.image != null
        //         ? Icons.image_outlined
        //         : Icons.hide_image_outlined,
        //   ),
        //   title: const Text('Image'),
        // ),
        // if (widget.decoration.image != null)
        //   ListTile(
        //     enabled: widget.decoration.image != null,
        //     leading: const Icon(Icons.layers_outlined),
        //     title: const Text('Image position'),
        //     trailing: PopupMenuButton(
        //       onSelected: changeImagePosition,
        //       initialValue: widget.decoration.image?.position,
        //       itemBuilder: (context) {
        //         return [
        //           const PopupMenuItem(
        //             value: PrettyQrDecorationImagePosition.embedded,
        //             child: Text('Embedded'),
        //           ),
        //           const PopupMenuItem(
        //             value: PrettyQrDecorationImagePosition.foreground,
        //             child: Text('Foreground'),
        //           ),
        //           const PopupMenuItem(
        //             value: PrettyQrDecorationImagePosition.background,
        //             child: Text('Background'),
        //           ),
        //         ];
        //       },
        //     ),
        //   ),
      ],
    );
  }

  @protected
  void changeShape(
    final Type type,
  ) {
    var shape = widget.decoration.shape;
    if (shape.runtimeType == type) return;

    if (shape is PrettyQrSmoothSymbol) {
      shape = PrettyQrRoundedSymbol(color: shapeColor);
    } else if (shape is PrettyQrRoundedSymbol) {
      shape = PrettyQrSmoothSymbol(color: shapeColor);
    }

    widget.onChanged?.call(widget.decoration.copyWith(shape: shape));
  }

  @protected
  void toggleColor() {
    var shape = widget.decoration.shape;
    var color = shapeColor != Colors.black
        ? Colors.black
        : Theme.of(context).colorScheme.secondary;

    if (shape is PrettyQrSmoothSymbol) {
      shape = PrettyQrSmoothSymbol(
        color: color,
        roundFactor: shape.roundFactor,
      );
    } else if (shape is PrettyQrRoundedSymbol) {
      shape = PrettyQrRoundedSymbol(
        color: color,
        borderRadius: shape.borderRadius,
      );
    }

    widget.onChanged?.call(widget.decoration.copyWith(shape: shape));
  }

  @protected
  void toggleRoundedCorners() {
    var shape = widget.decoration.shape;

    if (shape is PrettyQrSmoothSymbol) {
      shape = PrettyQrSmoothSymbol(
        color: shape.color,
        roundFactor: isRoundedBorders ? 0 : 1,
      );
    } else if (shape is PrettyQrRoundedSymbol) {
      shape = PrettyQrRoundedSymbol(
        color: shape.color,
        borderRadius: isRoundedBorders
            ? BorderRadius.zero
            : const BorderRadius.all(Radius.circular(10)),
      );
    }

    widget.onChanged?.call(widget.decoration.copyWith(shape: shape));
  }
}
