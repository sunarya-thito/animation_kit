import 'package:animation_kit/animation_kit.dart';
import 'package:flutter/widgets.dart';

/// A widget that provides a cross-fade transition between two child widgets.
///
/// This widget is a [StatefulWidget] that manages the animation state and
/// allows for smooth transitions between two widgets. It is useful for
/// scenarios where you want to visually transition between two different
/// UI elements with a fade effect.
class CrossFadedTransition extends StatefulWidget {
  /// Linearly interpolates the opacity of a widget between two values.
  ///
  /// This method is typically used in animations to create a smooth transition
  /// effect by blending the opacity of a widget over time.
  ///
  /// Returns a [Widget] with the interpolated opacity.
  static Widget lerpOpacity(
    Widget a,
    Widget b,
    double t, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    if (t == 0) {
      return a;
    } else if (t == 1) {
      return b;
    }
    double startOpacity = 1 - (t.clamp(0, 0.5) * 2);
    double endOpacity = t.clamp(0.5, 1) * 2 - 1;
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: startOpacity,
            child: Align(alignment: alignment, child: a),
          ),
        ),
        Opacity(opacity: endOpacity, child: b),
      ],
    );
  }

  /// Creates a widget that interpolates between two widgets in a stepwise manner.
  ///
  /// This method is typically used to create a crossfade effect where the transition
  /// between two widgets occurs in discrete steps rather than a smooth animation.
  ///
  /// The interpolation logic and the specific behavior of the step transition
  /// should be defined within the implementation of this method.
  static Widget lerpStep(
    Widget a,
    Widget b,
    double t, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    if (t == 0) {
      return a;
    } else if (t == 1) {
      return b;
    }
    return Stack(fit: StackFit.passthrough, children: [a, b]);
  }

  /// The widget to be displayed as the child of this widget.
  ///
  /// This is the primary content that will be rendered and can be
  /// dynamically updated to achieve crossfade or other animation effects.
  final Widget child;

  /// The duration of the crossfade animation.
  ///
  /// This defines how long the animation should take to transition
  /// between states.
  final Duration duration;

  /// The alignment of the child within the parent widget.
  ///
  /// This property determines how the child widget is aligned within its
  /// parent. For example, you can use [Alignment.center] to center the child,
  /// or [Alignment.topLeft] to align it to the top-left corner.
  ///
  /// Defaults to [Alignment.center] if not specified.
  final AlignmentGeometry alignment;

  /// A builder function that returns a [Widget].
  ///
  /// This function is typically used to create a widget dynamically
  /// based on certain conditions or input parameters.
  final Widget Function(
    Widget a,
    Widget b,
    double t, {
    AlignmentGeometry alignment,
  })
  lerp;

  /// Creates a cross-faded transition widget.
  ///
  /// This widget allows for a smooth transition between two child widgets
  /// by cross-fading them over a specified duration. It is commonly used
  /// to animate changes in the UI where one widget replaces another.
  ///
  /// The transition can be customized by providing parameters such as
  /// animation duration, curve, and alignment.
  const CrossFadedTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.alignment = Alignment.center,
    this.lerp = lerpOpacity,
  });

  @override
  State<CrossFadedTransition> createState() => _CrossFadedTransitionState();
}

class _CrossFadedTransitionState extends State<CrossFadedTransition> {
  late Widget newChild;

  @override
  void initState() {
    super.initState();
    newChild = widget.child;
  }

  @override
  void didUpdateWidget(covariant CrossFadedTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child &&
        oldWidget.child.key != widget.child.key) {
      newChild = widget.child;
    }
  }

  Widget _lerpWidget(Widget a, Widget b, double t) {
    return widget.lerp(a, b, t, alignment: widget.alignment);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      alignment: widget.alignment,
      duration: widget.duration,
      child: AnimatedValueBuilder(
        value: newChild,
        lerp: _lerpWidget,
        duration: widget.duration,
        builder: _builder,
      ),
    );
  }

  Widget _builder(BuildContext context, Widget value, Widget? child) {
    return value;
  }
}
