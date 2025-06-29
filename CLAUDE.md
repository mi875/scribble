# Scribble - Flutter Drawing Library

## Project Overview

Scribble is a lightweight Flutter library for freehand drawing that supports pressure-sensitive input, variable line width, and advanced drawing features. It's designed as a reusable package that can be integrated into Flutter applications to provide drawing capabilities.

**Key Features:**
- Variable line width with pressure sensitivity
- Multi-pointer support (touch, pen, mouse)
- Line simplification for optimized file sizes
- Undo/redo functionality using value_notifier_tools
- Export to PNG images
- JSON serialization of sketches
- Eraser functionality
- Performance optimization through line caching

## Project Structure

This is a **Flutter package** organized as a monorepo using Melos for workspace management.

### Core Architecture

```
lib/
├── scribble.dart                    # Main library export file
└── src/
    ├── domain/                      # Business logic and models
    │   ├── model/
    │   │   ├── point/              # Point data model (x, y, pressure)
    │   │   ├── sketch/             # Sketch container model
    │   │   └── sketch_line/        # Individual line model
    │   └── iterable_removed_x.dart # Utility extensions
    └── view/                        # UI layer and drawing logic
        ├── notifier/               # State management
        ├── painting/               # Custom painters and rendering
        ├── simplification/         # Line simplification algorithms
        ├── state/                  # State models using Freezed
        ├── scribble.dart          # Main drawing widget
        ├── scribble_sketch.dart   # Display-only sketch widget
        └── pan_gesture_catcher.dart # Gesture handling
```

### Key Components

1. **Scribble Widget**: Main drawing canvas that handles user input
2. **ScribbleNotifier**: State management using ValueNotifier with history support
3. **ScribbleState**: Immutable state using Freezed (Drawing/Erasing modes)
4. **Sketch/SketchLine Models**: Data models with JSON serialization
5. **Custom Painters**: Rendering logic with performance optimizations

## Technology Stack

- **Framework**: Flutter (>=3.10.0)
- **Language**: Dart (>=3.0.0)
- **State Management**: ValueNotifier with HistoryValueNotifierMixin
- **Serialization**: Freezed + json_annotation for code generation
- **Drawing Engine**: perfect_freehand for smooth line rendering
- **Line Simplification**: Visvalingam-Whyatt simplification algorithm
- **Testing**: flutter_test + mocktail package for mocking

### Key Dependencies

```yaml
dependencies:
  flutter: sdk
  freezed_annotation: ^3.0.0
  json_annotation: 4.9.0
  perfect_freehand: ^2.3.2
  simplify: ^0.1.1
  value_notifier_tools: ^0.1.2

dev_dependencies:
  build_runner: ^2.4.9
  freezed: ^2.4.7
  json_serializable: ^6.7.1
  melos: ">=5.2.1 <7.0.0"
  mocktail: ^1.0.3  # Dart mocking library
  lint_intervention: ^0.1.1
```

## Development Workflow

### Setup & Installation

```bash
# Install dependencies for all packages
melos bootstrap

# Run code generation (Freezed/JSON)
melos run build_runner
```

### Available Melos Scripts

```bash
# Analysis
melos run analyze                 # Run dart analyze on all packages

# Testing
melos run test                   # Run all tests
melos run test:select           # Run tests for selected packages
melos run coverage              # Generate coverage reports

# Code Generation
melos run build_runner          # Run build_runner for code generation

# Code Fixing
melos run fix                   # Run dart fix --apply
```

### Testing

- **Unit Tests**: Located in `test/` with mirrored structure to `lib/`
- **Testing Strategy**: Uses mocktail package for mocking, focuses on business logic
- **Coverage**: Coverage reports available via `melos run coverage`

### Code Generation

The project uses code generation for:
- **Freezed**: Immutable data classes with copyWith, equality, toString
- **JSON Serialization**: toJson/fromJson methods for data persistence

Run `melos run build_runner` after modifying:
- Models annotated with `@freezed`
- Classes with `@JsonSerializable()`

## Key Architectural Patterns

### 1. State Management Pattern
Uses ValueNotifier with history support for undo/redo:
```dart
class ScribbleNotifier extends ScribbleNotifierBase 
    with HistoryValueNotifierMixin<ScribbleState>
```

### 2. Union Types with Freezed
State is modeled as union type (Drawing | Erasing):
```dart
@freezed
sealed class ScribbleState with _$ScribbleState {
  const factory ScribbleState.drawing(...) = Drawing;
  const factory ScribbleState.erasing(...) = Erasing;
}
```

### 3. Performance Optimizations
- **Line Caching**: Complex lines are rasterized and cached as images
- **Simplification**: Uses Visvalingam-Whyatt algorithm to reduce point count
- **RepaintBoundary**: Optimizes repainting during drawing

### 4. Custom Painting
- **ScribblePainter**: Renders the complete sketch
- **ScribbleEditingPainter**: Handles current drawing state and cursors

## Example Usage

Basic integration:
```dart
class DrawingPage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    final notifier = ScribbleNotifier();
    
    return Scaffold(
      body: Scribble(
        notifier: notifier,
        drawPen: true,
        simulatePressure: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: notifier.clear,
        child: Icon(Icons.clear),
      ),
    );
  }
}
```

## Build & Release

### Package Publishing
```bash
# Update version in pubspec.yaml file
# Update CHANGELOG.md
dart pub publish --dry-run
dart pub publish
```

### Example App
The `example/` directory contains a complete demo app showing all features.

To run the example:
```bash
cd example
flutter run
```

## Testing & Quality

- **Linting**: Uses lint_intervention package for strict analysis
- **Testing**: Comprehensive unit tests with mocking
- **Coverage**: Generates SVG badges for coverage reporting
- **CI/CD**: Uses GitHub Actions (based on Mason template)

## Important Notes for Development

1. **Code Generation**: Always run build_runner after model changes
2. **Performance**: Be mindful of line caching behavior in ScribbleNotifier
3. **State Updates**: Use `value =` for history, `temporaryValue =` for non-history updates
4. **Testing**: Mock the SketchSimplifier for predictable test behavior
5. **Memory Management**: Cached images are properly disposed to prevent leaks

## Current Branch Context

You are working on the `enhanced_with_ai` branch, which appears to have recent enhancements to caching and rendering functionality based on recent commits.

Recent changes include:
- Enhanced ScribbleNotifier with caching improvements
- Updated notifier architecture
- Improved rendering performance