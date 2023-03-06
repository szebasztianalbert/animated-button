import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final Duration debouncingTimer;
  final Color backgroundColor;
  final Color disabledBackgroundColor;
  final Color debouncingAnimationColor;
  final Color circularProgressIndicatorColor;
  final Color foregroundColor;
  final double height;
  final double? width;
  final double circularProgressIndicatorStrokeWidth;
  final double borderRadius;
  final String buttonText;
  final bool enabled;
  final EdgeInsetsGeometry padding;

  const AnimatedButton({
    super.key,
    this.debouncingTimer = const Duration(seconds: 3),
    this.backgroundColor = Colors.yellow,
    this.disabledBackgroundColor = Colors.grey,
    this.debouncingAnimationColor = Colors.green,
    this.circularProgressIndicatorColor = Colors.yellow,
    this.foregroundColor = Colors.white,
    this.width,
    this.height = 70,
    this.circularProgressIndicatorStrokeWidth = 4,
    this.borderRadius = 15,
    this.buttonText = '',
    this.enabled = true,
    this.padding = const EdgeInsets.all(0),
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
      duration: widget.debouncingTimer,
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
    final circularProgressSize = widget.height - 16;
    const circularProgressPadding = 15.0;

    return SizedBox(
      width: double.infinity,
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: circularProgressSize + circularProgressPadding,
            ),
            GestureDetector(
              onTapDown: (_) {
                if (widget.enabled) {
                  controller.forward();
                  loadingAnimationTimer = Timer(widget.debouncingTimer, onLongPress);
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
                          backgroundColor: widget.enabled ? widget.backgroundColor : widget.disabledBackgroundColor,
                          valueColor: AlwaysStoppedAnimation(widget.debouncingAnimationColor),
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            // padding: widget.padding,
                            child: Text(
                              widget.buttonText,
                              style: TextStyle(
                                // fontSize: 16,
                                color: widget.foregroundColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: circularProgressPadding),
            Visibility(
                child: pressed
                    ? SizedBox(
                        width: circularProgressSize,
                        height: circularProgressSize,
                        child: CircularProgressIndicator(
                          strokeWidth: widget.circularProgressIndicatorStrokeWidth,
                          color: widget.circularProgressIndicatorColor,
                        ),
                      )
                    : SizedBox(
                        width: circularProgressSize,
                        height: circularProgressSize,
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
