# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Scribble is a Flutter package providing a lightweight library for freehand drawing with pressure-sensitive lines, variable line width, and advanced drawing features. This is a **package** (not an app) that gets published to pub.dev for other Flutter developers to use.

## Development Commands

### Code Generation
```bash
# Run code generation for freezed/json_serializable (required after model changes)
melos run build_runner
```

### Testing
```bash
# Run all tests
melos run test

# Run tests with coverage
melos run coverage

# Run tests for specific packages only
melos run test:select
```

### Code Quality
```bash
# Run static analysis
melos run analyze

# Apply automatic fixes
melos run fix
```

### Flutter Development
- **Do not run `flutter run` or `flutter build` commands**
- This is a package, not an app - use the example/ directory for testing

## Architecture

### Domain-Driven Design Structure
```
lib/src/
├── domain/          # Business logic and immutable data models
│   └── model/       # Sketch, SketchLine, Point, etc.
└── view/           # UI layer with state management and painting
    ├── notifier/    # ScribbleNotifier, NotebookNotifier (ValueNotifier pattern)
    ├── painting/    # Custom painters for rendering
    ├── state/       # Immutable state classes
    └── controls/    # UI controls
```

### State Management
- Uses **ValueNotifier pattern** with custom notifiers extending `ValueNotifier<T>`
- All state classes are **immutable** using Freezed
- **ScribbleNotifier**: Core drawing functionality and state
- **NotebookNotifier**: Multi-page notebook with scrolling support
- Undo/redo support via `value_notifier_tools` package

### Data Models
All models use **Freezed** for:
- Immutable data classes with `@freezed` annotation
- JSON serialization with `@JsonSerializable()`
- Copy-with functionality and union types
- **Important**: After changing any model, run `melos run build_runner`

Key models:
- `Sketch`: Contains list of `SketchLine`s, fully serializable
- `SketchLine`: Individual drawing stroke with points, color, width
- `Point`: Coordinates with pressure information for touch/pen input
- `NotebookState`/`ScribbleState`: UI state management

### Custom Painting Architecture
- **ScribblePainter**: Renders static sketch content
- **ScribbleEditingPainter**: Handles current line being drawn
- Uses **RepaintBoundary** for performance and PNG export
- Integrates with **perfect_freehand** library for pressure-sensitive drawing

## Key Features & Capabilities

- Pressure-sensitive drawing with variable line width
- Multi-device support (touch, pen, mouse with different behaviors)
- Line eraser functionality
- Full undo/redo support
- JSON serialization for sketch persistence
- PNG export functionality
- Multi-page notebook with scrolling
- Line simplification to reduce file sizes

## Development Workflow

1. **Code Generation Required**: Run `melos run build_runner` after any model changes
2. **Testing**: Comprehensive test suite with unit and widget tests
3. **Linting**: Uses `lintervention` package for strict code quality
4. **Melos Workspace**: Monorepo management with workspace commands

## Important Dependencies

- **perfect_freehand**: Core drawing algorithm for smooth, pressure-sensitive lines
- **freezed + json_serializable**: Code generation for data models
- **value_notifier_tools**: Undo/redo functionality
- **melos**: Monorepo workspace management
- **mocktail**: Testing framework for mocking