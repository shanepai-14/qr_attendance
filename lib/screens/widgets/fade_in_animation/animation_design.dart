import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'animation_model.dart';
import 'splash_screen_controller.dart';

class TfadeAnimation extends StatelessWidget {
  TfadeAnimation(
      {Key? key,
      required this.durationInMs,
      this.animatePosition,
      required this.child})
      : super(key: key);

  final splashScreenController = Get.put(SplashScreenController());
  final int durationInMs;
  final TanimatePosition? animatePosition;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedPositioned(
          duration: const Duration(milliseconds: 1600),
          top: splashScreenController.animate.value
              ? animatePosition!.topAfter
              : animatePosition!.topBefore,
          left: splashScreenController.animate.value
              ? animatePosition!.leftAfter
              : animatePosition!.leftBefore,
          bottom: splashScreenController.animate.value
              ? animatePosition!.bottomAfter
              : animatePosition!.bottomBefore,
          right: splashScreenController.animate.value
              ? animatePosition!.rightAfter
              : animatePosition!.rightBefore,
          child: AnimatedOpacity(
              duration: Duration(milliseconds: 1600),
              opacity: splashScreenController.animate.value ? 1 : 0,
              child: child),
        ));
  }
}
