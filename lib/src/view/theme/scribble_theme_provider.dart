import 'package:flutter/material.dart';
import 'package:scribble/src/view/theme/scribble_theme.dart';

/// A widget that provides theme data to its descendants.
///
/// This is a simple theme provider that allows switching between light
/// and dark themes, as well as custom themes.
class ScribbleThemeProvider extends InheritedWidget {
  /// Creates a theme provider.
  const ScribbleThemeProvider({
    required this.theme,
    required super.child,
    super.key,
  });

  /// The current theme data.
  final ScribbleTheme theme;

  /// Gets the current theme from the widget tree.
  static ScribbleTheme? of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ScribbleThemeProvider>();
    return provider?.theme;
  }

  /// Gets theme or resolves one from context when not provided.
  static ScribbleTheme resolve(BuildContext context) {
    return of(context) ?? ScribbleTheme.fromContext(context);
  }

  @override
  bool updateShouldNotify(ScribbleThemeProvider oldWidget) {
    return oldWidget.theme != theme;
  }
}

/// A controller for managing theme state and switching between themes.
class ScribbleThemeController extends ChangeNotifier {
  /// Creates a theme controller with the initial theme.
  ScribbleThemeController({
    ScribbleTheme? initialTheme,
    this.followSystemTheme = true,
  }) : _theme = initialTheme ?? ScribbleTheme.light;

  ScribbleTheme _theme;

  /// Whether the controller should automatically follow system theme changes.
  bool followSystemTheme;

  /// The current theme.
  ScribbleTheme get theme => _theme;

  /// Whether the controller should automatically follow system theme changes.
  bool get isFollowingSystemTheme => followSystemTheme;

  /// Sets a custom theme.
  void setTheme(ScribbleTheme theme) {
    if (_theme == theme) return;
    _theme = theme;
    followSystemTheme = false;
    notifyListeners();
  }

  /// Switches to light theme.
  void setLightTheme() {
    setTheme(ScribbleTheme.light);
  }

  /// Switches to dark theme.
  void setDarkTheme() {
    setTheme(ScribbleTheme.dark);
  }

  /// Toggles between light and dark theme.
  void toggleTheme() {
    if (_theme == ScribbleTheme.light) {
      setDarkTheme();
    } else {
      setLightTheme();
    }
  }

  /// Enables automatic theme following based on system brightness.
  void followSystem(BuildContext context) {
    followSystemTheme = true;
    _updateThemeFromSystem(context);
    notifyListeners();
  }

  /// Updates the theme based on system brightness.
  void updateSystemTheme(BuildContext context) {
    if (followSystemTheme) {
      _updateThemeFromSystem(context);
    }
  }

  void _updateThemeFromSystem(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final newTheme = brightness == Brightness.dark
        ? ScribbleTheme.dark
        : ScribbleTheme.light;

    if (_theme != newTheme) {
      _theme = newTheme;
      notifyListeners();
    }
  }
}

/// A widget that combines theme provider with theme controller.
class ScribbleThemeBuilder extends StatefulWidget {
  /// Creates a theme builder.
  const ScribbleThemeBuilder({
    required this.builder,
    this.controller,
    this.initialTheme,
    this.followSystemTheme = true,
    super.key,
  });

  /// Builder function that receives the current theme.
  final Widget Function(BuildContext context, ScribbleTheme theme) builder;

  /// Optional theme controller. If not provided, creates one internally.
  final ScribbleThemeController? controller;

  /// Initial theme if no controller is provided.
  final ScribbleTheme? initialTheme;

  /// Whether to follow system theme changes.
  final bool followSystemTheme;

  @override
  State<ScribbleThemeBuilder> createState() => _ScribbleThemeBuilderState();
}

class _ScribbleThemeBuilderState extends State<ScribbleThemeBuilder>
    with WidgetsBindingObserver {
  late ScribbleThemeController _controller;
  bool _isInternalController = false;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = ScribbleThemeController(
        initialTheme: widget.initialTheme,
        followSystemTheme: widget.followSystemTheme,
      );
      _isInternalController = true;
    }

    _controller.addListener(_onThemeChanged);

    if (_controller.followSystemTheme) {
      WidgetsBinding.instance.addObserver(this);
      // Update theme from system after first frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.updateSystemTheme(context);
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onThemeChanged);
    if (_controller.followSystemTheme) {
      WidgetsBinding.instance.removeObserver(this);
    }
    if (_isInternalController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (mounted) {
      _controller.updateSystemTheme(context);
    }
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScribbleThemeProvider(
      theme: _controller.theme,
      child: widget.builder(context, _controller.theme),
    );
  }
}
