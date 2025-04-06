import 'package:animation_kit/animation_kit.dart';
import 'package:flutter/widgets.dart';

/// An enumeration that defines the modes of repetition for animations or actions.
///
/// This can be used to specify how an animation should repeat, such as looping
/// indefinitely or repeating a fixed number of times.
enum RepeatMode {
  /// A constant that represents a repeated animation behavior.
  ///
  /// This can be used to specify that an animation should loop or repeat
  /// continuously.
  repeat,

  /// A constant representing the reverse animation direction.
  /// This can be used to specify that an animation should play in reverse.
  reverse,

  /// A type of animation behavior where the animation alternates
  /// direction, playing forward and then reversing back to the start.
  /// This creates a "ping-pong" effect.
  pingPong,

  /// A playback mode where the animation alternates between forward and reverse,
  /// starting from the end and playing back to the start, then reversing direction
  /// again. This creates a "ping-pong" effect, but begins in the reverse direction.
  pingPongReverse,
}

/// A widget that builds an animation repeatedly using a builder function.
///
/// The [RepeatedAnimationBuilder] widget allows you to define an animation
/// that repeats itself and provides a builder function to customize the
/// appearance or behavior of the animation at each frame.
///
/// The generic type parameter [T] represents the type of the animation value
/// that will be passed to the builder function.
class RepeatedAnimationBuilder<T> extends StatefulWidget {
  /// The starting value of the animation.
  ///
  /// This represents the initial value from which the animation begins.
  final T start;

  /// The ending value of the animation sequence.
  ///
  /// This represents the final state or value that the animation
  /// will reach when it completes.
  final T end;

  /// The duration for which the animation will run.
  ///
  /// This defines the total time span of the animation cycle.
  final Duration duration;

  /// The duration for playing the animation in reverse.
  ///
  /// If provided, this duration will override the default duration
  /// when the animation is played in reverse. If null, the animation
  /// will use the same duration as the forward animation.
  final Duration? reverseDuration;

  /// The animation curve that defines the rate of change of the animation over time.
  ///
  /// This determines the timing and easing behavior of the animation, such as
  /// whether it starts slowly and speeds up, or starts quickly and slows down.
  /// Common examples include [Curves.linear], [Curves.easeIn], and [Curves.bounceOut].
  final Curve curve;

  /// The curve to use when running the animation in reverse.
  ///
  /// If this is null, the animation will use the default curve specified
  /// for the forward direction.
  final Curve? reverseCurve;

  /// The mode that determines how the animation should repeat.
  ///
  /// This can be used to specify whether the animation should loop,
  /// reverse, or follow another repeating behavior.
  final RepeatMode mode;

  /// A builder function that creates a widget based on the provided context,
  /// value of type `T`, and an optional child widget.
  ///
  /// The [context] parameter provides the build context in which the widget
  /// is being built.
  ///
  /// The [value] parameter is of type `T` and represents the data used to
  /// build the widget.
  ///
  /// The [child] parameter is an optional widget that can be included as part
  /// of the built widget tree.
  final Widget Function(BuildContext context, T value, Widget? child)? builder;
  final Widget Function(BuildContext context, Animation<T> animation)?
  /// A builder function that defines how the animation should be constructed.
  /// This is typically used to create custom animations by providing a widget
  /// that reacts to animation values.
  animationBuilder;

  /// The child widget to be displayed within this widget.
  ///
  /// This widget can be null, in which case no child will be rendered.
  final Widget? child;

  /// A function that interpolates between two values of type `T` (`a` and `b`)
  /// based on a given factor `t`.
  ///
  /// The parameter `t` is typically a value between 0.0 and 1.0, where:
  /// - `t == 0.0` corresponds to the value `a`.
  /// - `t == 1.0` corresponds to the value `b`.
  /// - Intermediate values of `t` produce interpolated results between `a` and `b`.
  ///
  /// This function is optional and can be used to customize the interpolation
  /// behavior for the specific type `T`.
  final T Function(T a, T b, double t)? lerp;

  /// A flag that determines whether the animation should play.
  ///
  /// When set to `true`, the animation will start or continue playing.
  /// When set to `false`, the animation will pause or stop.
  final bool play;

  /// A widget that builds its child repeatedly with an animation.
  ///
  /// The [RepeatedAnimationBuilder] allows you to define a custom animation
  /// that repeats over time and rebuilds its child widget on each animation
  /// frame. This is useful for creating looping animations or effects.
  ///
  /// The animation behavior and duration can be customized to suit your needs.
  const RepeatedAnimationBuilder({
    super.key,
    required this.start,
    required this.end,
    required this.duration,
    this.curve = Curves.linear,
    this.reverseCurve,
    this.mode = RepeatMode.repeat,
    required this.builder,
    this.child,
    this.lerp,
    this.play = true,
    this.reverseDuration,
  }) : animationBuilder = null;

  /// Creates a repeated animation builder.
  ///
  /// This constructor is used to define an animation that repeats itself
  /// based on the provided configuration. It allows customization of the
  /// animation's behavior, such as duration, curve, and repetition settings.
  const RepeatedAnimationBuilder.animation({
    super.key,
    required this.start,
    required this.end,
    required this.duration,
    this.curve = Curves.linear,
    this.reverseCurve,
    this.mode = RepeatMode.repeat,
    required this.animationBuilder,
    this.child,
    this.lerp,
    this.play = true,
    this.reverseDuration,
  }) : builder = null;

  @override
  State<RepeatedAnimationBuilder<T>> createState() =>
      _RepeatedAnimationBuilderState<T>();
}

class _RepeatedAnimationBuilderState<T>
    extends State<RepeatedAnimationBuilder<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _curvedAnimation;
  late Animation<T> _animation;

  bool _reverse = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    if (widget.mode == RepeatMode.reverse ||
        widget.mode == RepeatMode.pingPongReverse) {
      _reverse = true;
      _controller.duration = widget.reverseDuration ?? widget.duration;
      _controller.reverseDuration = widget.duration;
      _curvedAnimation = CurvedAnimation(
        parent: _controller,
        curve: widget.reverseCurve ?? widget.curve,
        reverseCurve: widget.curve,
      );
      _animation = _curvedAnimation.drive(
        AnimatableValue(
          start: widget.end,
          end: widget.start,
          lerp: lerpedValue,
        ),
      );
    } else {
      _controller.duration = widget.duration;
      _controller.reverseDuration = widget.reverseDuration;
      _curvedAnimation = CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
        reverseCurve: widget.reverseCurve ?? widget.curve,
      );
      _animation = _curvedAnimation.drive(
        AnimatableValue(
          start: widget.start,
          end: widget.end,
          lerp: lerpedValue,
        ),
      );
    }
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (widget.mode == RepeatMode.pingPong ||
            widget.mode == RepeatMode.pingPongReverse) {
          _controller.reverse();
          _reverse = true;
        } else {
          _controller.reset();
          _controller.forward();
        }
      } else if (status == AnimationStatus.dismissed) {
        if (widget.mode == RepeatMode.pingPong ||
            widget.mode == RepeatMode.pingPongReverse) {
          _controller.forward();
          _reverse = false;
        } else {
          _controller.reset();
          _controller.forward();
        }
      }
    });
    if (widget.play) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant RepeatedAnimationBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {}
    if (oldWidget.start != widget.start ||
        oldWidget.end != widget.end ||
        oldWidget.duration != widget.duration ||
        oldWidget.reverseDuration != widget.reverseDuration ||
        oldWidget.curve != widget.curve ||
        oldWidget.reverseCurve != widget.reverseCurve ||
        oldWidget.mode != widget.mode ||
        oldWidget.play != widget.play) {
      if (widget.mode == RepeatMode.reverse ||
          widget.mode == RepeatMode.pingPongReverse) {
        _controller.duration = widget.reverseDuration ?? widget.duration;
        _controller.reverseDuration = widget.duration;
        _curvedAnimation.dispose();
        _curvedAnimation = CurvedAnimation(
          parent: _controller,
          curve: widget.reverseCurve ?? widget.curve,
          reverseCurve: widget.curve,
        );
        _animation = _curvedAnimation.drive(
          AnimatableValue(
            start: widget.end,
            end: widget.start,
            lerp: lerpedValue,
            // curve: widget.reverseCurve ?? widget.curve,
          ),
        );
      } else {
        _controller.duration = widget.duration;
        _controller.reverseDuration = widget.reverseDuration;
        _curvedAnimation.dispose();
        _curvedAnimation = CurvedAnimation(
          parent: _controller,
          curve: widget.curve,
          reverseCurve: widget.reverseCurve ?? widget.curve,
        );
        _animation = _curvedAnimation.drive(
          AnimatableValue(
            start: widget.start,
            end: widget.end,
            lerp: lerpedValue,
            // curve: widget.curve,
          ),
        );
      }
    }
    if (oldWidget.play != widget.play) {
      if (widget.play) {
        if (_reverse) {
          _controller.reverse();
        } else {
          _controller.forward();
        }
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _curvedAnimation.dispose();
    _controller.dispose();
    super.dispose();
  }

  T lerpedValue(T a, T b, double t) {
    if (widget.lerp != null) {
      return widget.lerp!(a, b, t);
    }
    try {
      return (a as dynamic) + ((b as dynamic) - (a as dynamic)) * t;
    } catch (e) {
      throw Exception(
        'Could not lerp $a and $b. You must provide a custom lerp function.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animationBuilder != null) {
      return widget.animationBuilder!(context, _animation);
    }
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        T value = _animation.value;
        return widget.builder!(context, value, widget.child);
      },
    );
  }
}
