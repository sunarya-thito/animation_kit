import 'package:animation_kit/animation_kit.dart';
import 'package:flutter/widgets.dart';

/// A typedef for a builder function that creates an animated child widget.
///
/// The builder function takes a generic parameter [T] and is used to define
/// how the animated child widget should be constructed or updated based on
/// the provided value of type [T].
///
/// This is typically used in scenarios where you want to create custom
/// animations for child widgets with dynamic properties.
typedef AnimatedChildBuilder<T> =
    Widget Function(BuildContext context, T value, Widget? child);

/// A typedef for a function that builds a widget based on the current value
/// of an animation.
///
/// The generic type parameter `T` represents the type of the animation value.
/// This function is typically used to create widgets that respond to changes
/// in animation values.
typedef AnimationBuilder<T> =
    Widget Function(BuildContext context, Animation<T> animation);

/// A typedef for a builder function that creates a widget based on an animated value.
///
/// This function is typically used in conjunction with implicit animations to build
/// child widgets that respond to changes in an animated value.
///
/// The generic type parameter `T` represents the type of the animated value.
///
/// - [value]: The current value of the animation.
/// - [child]: An optional static child widget that does not change during the animation.
typedef AnimatedChildValueBuilder<T> =
    Widget Function(
      BuildContext context,
      T oldValue,
      T newValue,
      double t,
      Widget? child,
    );

/// A widget that rebuilds its child whenever the animated value changes.
///
/// This widget is a generic class that takes a type parameter [T], which
/// represents the type of the animated value. It is typically used to
/// create animations that depend on a value of type [T].
///
/// The [AnimatedValueBuilder] widget manages its own state and listens
/// to changes in the animated value, triggering a rebuild of its child
/// whenever the value updates.
///
/// Example usage:
/// ```dart
/// AnimatedValueBuilder<double>(
///   builder: (context, value, child) {
///     return Opacity(
///       opacity: value,
///       child: child,
///     );
///   },
///   value: animationValue,
///   child: Text('Animated Text'),
/// );
/// ```
///
/// This widget is useful for creating custom animations that depend on
/// a specific value and need to rebuild a widget tree dynamically.
class AnimatedValueBuilder<T> extends StatefulWidget {
  final T? initialValue;
  final T value;
  final Duration duration;
  final AnimatedChildBuilder<T>? builder;
  final AnimationBuilder<T>? animationBuilder;
  final AnimatedChildValueBuilder<T>? rawBuilder;
  final void Function(T value)? onEnd;
  final Curve curve;
  final T Function(T a, T b, double t)? lerp;
  final Widget? child;

  /// A widget that builds its child based on an animated value.
  ///
  /// The [AnimatedValueBuilder] widget listens to an animation and rebuilds
  /// its child whenever the animation's value changes. This is useful for
  /// creating custom implicit animations by providing a builder function
  /// that reacts to the animated value.
  ///
  /// The [builder] parameter must not be null.
  const AnimatedValueBuilder({
    super.key,
    this.initialValue,
    required this.value,
    required this.duration,
    required AnimatedChildBuilder<T> this.builder,
    this.onEnd,
    this.curve = Curves.linear,
    this.lerp,
    this.child,
  }) : animationBuilder = null,
       rawBuilder = null;

  /// Creates an animated widget builder that interpolates values over time.
  ///
  /// This constructor is used to define an animation that transitions between
  /// values, allowing you to build widgets that respond to changes in the
  /// animation's value.
  ///
  /// The animation is driven by a [AnimationController] or similar mechanism,
  /// and the builder function is called whenever the animation's value changes.
  ///
  /// Example usage:
  /// ```dart
  /// AnimatedValueBuilder.animation(
  ///   animation: myAnimation,
  ///   builder: (context, value, child) {
  ///     return Transform.scale(
  ///       scale: value,
  ///       child: child,
  ///     );
  ///   },
  ///   child: MyWidget(),
  /// );
  /// ```
  const AnimatedValueBuilder.animation({
    super.key,
    this.initialValue,
    required this.value,
    required this.duration,
    required AnimationBuilder<T> builder,
    this.onEnd,
    this.curve = Curves.linear,
    this.lerp,
  }) : builder = null,
       animationBuilder = builder,
       child = null,
       rawBuilder = null;

  /// Creates an instance of [AnimatedValueBuilder] with raw configuration.
  ///
  /// This constructor is typically used for advanced use cases where
  /// the raw configuration of the animated value builder is required.
  const AnimatedValueBuilder.raw({
    super.key,
    this.initialValue,
    required this.value,
    required this.duration,
    required AnimatedChildValueBuilder<T> builder,
    this.onEnd,
    this.curve = Curves.linear,
    this.child,
    this.lerp,
  }) : animationBuilder = null,
       rawBuilder = builder,
       builder = null;

  @override
  State<StatefulWidget> createState() {
    return _AnimatedValueBuilderState<T>();
  }
}

class _AnimatedValueBuilderState<T> extends State<AnimatedValueBuilder<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _curvedAnimation;
  late Animation<T> _animation;
  late T _currentValue;
  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue ?? widget.value;
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
    _curvedAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onEnd();
      }
    });
    _animation = _curvedAnimation.drive(
      AnimatableValue(
        start: widget.initialValue ?? widget.value,
        end: widget.value,
        lerp: lerpedValue,
      ),
    );
    if (widget.initialValue != null) {
      _controller.forward();
    }
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
  void didUpdateWidget(AnimatedValueBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    T currentValue = _animation.value;
    _currentValue = currentValue;
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
    if (widget.curve != oldWidget.curve) {
      _curvedAnimation.dispose();
      _curvedAnimation = CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      );
    }
    if (oldWidget.value != widget.value || oldWidget.lerp != widget.lerp) {
      _animation = _curvedAnimation.drive(
        AnimatableValue(
          start: currentValue,
          end: widget.value,
          lerp: lerpedValue,
        ),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnd() {
    if (widget.onEnd != null) {
      widget.onEnd!(widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animationBuilder != null) {
      return widget.animationBuilder!(context, _animation);
    }
    return AnimatedBuilder(
      animation: _animation,
      builder: _builder,
      child: widget.child,
    );
  }

  Widget _builder(BuildContext context, Widget? child) {
    if (widget.rawBuilder != null) {
      return widget.rawBuilder!(
        context,
        _currentValue,
        widget.value,
        _curvedAnimation.value,
        child,
      );
    }
    T newValue = _animation.value;
    return widget.builder!(context, newValue, child);
  }
}
