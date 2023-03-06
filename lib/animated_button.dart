import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final Duration loadingAnimationDuration;
  final Color enabledButtonBackgroundColor;
  final Color disabledButtonBackgroundColor;
  final Color loadingAnimationColor;
  final Color circularProgressIndicatorColor;
  final Color textColor;
  final Color inactiveTextColor;
  final double height;
  final double? width;
  final double circularProgressIndicatorStrokeWidth;
  final double borderRadius;
  final String buttonText;
  final bool enabled;

  const AnimatedButton({
    super.key,
    this.loadingAnimationDuration = const Duration(seconds: 3),
    this.enabledButtonBackgroundColor = Colors.yellow,
    this.disabledButtonBackgroundColor = Colors.grey,
    this.loadingAnimationColor = Colors.green,
    this.circularProgressIndicatorColor = Colors.yellow,
    this.textColor = Colors.white,
    this.inactiveTextColor = Colors.black38,
    this.width,
    this.height = 50,
    this.circularProgressIndicatorStrokeWidth = 4,
    this.borderRadius = 15,
    this.buttonText = '',
    this.enabled = true,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with TickerProviderStateMixin {
  late AnimationController controller;
  bool pressed = false;
  late Timer loadingAnimationTimer;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: widget.loadingAnimationDuration,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: widget.height + constraints.maxWidth / 20,
            ),
            GestureDetector(
              onTapDown: (_) {
                if (widget.enabled) {
                  controller.forward();
                  loadingAnimationTimer = Timer(widget.loadingAnimationDuration, onLongPress);
                }
              },
              onTapUp: (_) {
                if (widget.enabled) {
                  controller.reset();
                  loadingAnimationTimer.cancel();
                  onLongPressCancel();
                }
              },
              onTapCancel: () {
                if (widget.enabled) {
                  controller.reset();
                  loadingAnimationTimer.cancel();
                  onLongPressCancel();
                }
              },
              child: Material(
                elevation: widget.enabled ? 2 : 0,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: widget.width ?? constraints.maxWidth / 2,
                        height: widget.height,
                        child: LinearProgressIndicator(
                          value: controller.value,
                          backgroundColor: widget.enabled
                              ? widget.enabledButtonBackgroundColor
                              : widget.disabledButtonBackgroundColor,
                          valueColor: AlwaysStoppedAnimation(widget.loadingAnimationColor),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            widget.buttonText,
                            style: TextStyle(
                              color: widget.enabled ? widget.textColor : widget.inactiveTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: constraints.maxWidth / 20),
            Visibility(
                child: pressed
                    ? SizedBox(
                        width: widget.height,
                        height: widget.height,
                        child: CircularProgressIndicator(
                          strokeWidth: widget.circularProgressIndicatorStrokeWidth,
                          color: widget.circularProgressIndicatorColor,
                        ),
                      )
                    : SizedBox(
                        width: widget.height,
                        height: widget.height,
                      )),
          ],
        );
      }),
    );
  }

  void onLongPress() {
    setState(() {
      pressed = true;
    });
  }

  void onLongPressCancel() {
    setState(() {
      pressed = false;
    });
  }
}
