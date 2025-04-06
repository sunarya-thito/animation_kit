# Animation Kit

A Flutter package providing a collection of utilities and widgets for creating advanced animations with ease.

## Features

- Customizable animation builders.
- Repeated animations with various modes (e.g., repeat, reverse, ping-pong).
- Implicit animations for smooth transitions.
- Crossfade transitions between widgets.
- Interval-based animation curves.
- Utility functions for interpolating values like colors, offsets, and sizes.

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  animation_kit: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Repeated Animation

```dart
import 'package:animation_kit/animation_kit.dart';

RepeatedAnimationBuilder<double>(
  start: 0.0,
  end: 1.0,
  duration: Duration(seconds: 2),
  mode: RepeatMode.pingPong,
  builder: (context, value, child) {
    return Opacity(
      opacity: value,
      child: child,
    );
  },
  child: Text('Ping-Pong Animation'),
);
```

### Crossfade Transition

```dart
import 'package:animation_kit/animation_kit.dart';

CrossFadedTransition(
  child: Text('New Widget'),
  duration: Duration(milliseconds: 500),
);
```

### Custom Curve

```dart
import 'package:animation_kit/animation_kit.dart';

AnimationController controller = AnimationController(
  duration: const Duration(seconds: 2),
  vsync: this,
);

Animation<double> animation = CurvedAnimation(
  parent: controller,
  curve: IntervalDuration(
    start: Duration(milliseconds: 500),
    end: Duration(seconds: 1),
    duration: Duration(seconds: 2),
  ),
);
```

### Implicit Animation

```dart
import 'package:animation_kit/animation_kit.dart';

AnimatedValueBuilder<double>(
  value: 1.0,
  duration: Duration(seconds: 1),
  builder: (context, value, child) {
    return Transform.scale(
      scale: value,
      child: child,
    );
  },
  child: Icon(Icons.star, size: 50),
);
```

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bugfix.
3. Commit your changes with clear messages.
4. Submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
