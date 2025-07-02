# Stroke Storage and Restoration in Scribble

The Scribble library already provides comprehensive stroke storage and restoration capabilities through its built-in JSON serialization features. This document explains how to effectively use these features.

## Key Features

### ✅ Already Implemented

1. **JSON Serialization**: All strokes can be converted to/from JSON format
2. **Complete Data Preservation**: Points, colors, stroke widths, and pressure data
3. **Sketch Management**: Load/save entire sketches or individual strokes
4. **Undo/Redo System**: Built-in history management with configurable depth
5. **Programmatic Creation**: Create strokes and sketches from code

## Core APIs

### ScribbleNotifier Methods

```dart
// Get current sketch
Sketch currentSketch = notifier.currentSketch;

// Save/load sketch
notifier.setSketch(sketch: loadedSketch, addToUndoHistory: true);

// Clear all strokes
notifier.clear();

// Undo/Redo operations
notifier.undo();
notifier.redo();
bool canUndo = notifier.canUndo;
bool canRedo = notifier.canRedo;
```

### Sketch Serialization

```dart
// Convert sketch to JSON
Map<String, dynamic> json = sketch.toJson();
String jsonString = jsonEncode(sketch.toJson());

// Create sketch from JSON
Sketch sketch = Sketch.fromJson(jsonMap);
```

### Programmatic Stroke Creation

```dart
// Create individual strokes
final stroke = SketchLine(
  points: [
    Point(100, 100, pressure: 0.8),
    Point(200, 150, pressure: 0.6),
    Point(300, 100, pressure: 0.9),
  ],
  color: Colors.red.value,
  width: 5.0,
);

// Create complete sketches
final sketch = Sketch(lines: [stroke1, stroke2, stroke3]);
```

## Storage Options

### 1. Local File Storage

```dart
// Save to file
final file = File(path);
final jsonString = jsonEncode(sketch.toJson());
await file.writeAsString(jsonString);

// Load from file
final jsonString = await file.readAsString();
final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
final sketch = Sketch.fromJson(jsonMap);
```

### 2. Cloud Storage

```dart
// Upload to cloud (Firebase, AWS, etc.)
final jsonString = jsonEncode(sketch.toJson());
await cloudService.upload(jsonString);

// Download from cloud
final jsonString = await cloudService.download();
final sketch = Sketch.fromJson(jsonDecode(jsonString));
```

### 3. Database Storage

```dart
// Store in SQLite/Hive/etc.
final jsonString = jsonEncode(sketch.toJson());
await database.insert('sketches', {'data': jsonString});

// Retrieve from database
final result = await database.query('sketches');
final sketch = Sketch.fromJson(jsonDecode(result['data']));
```

### 4. SharedPreferences (Small Sketches)

```dart
// Save to preferences
final prefs = await SharedPreferences.getInstance();
final jsonString = jsonEncode(sketch.toJson());
await prefs.setString('sketch', jsonString);

// Load from preferences
final jsonString = prefs.getString('sketch');
if (jsonString != null) {
  final sketch = Sketch.fromJson(jsonDecode(jsonString));
}
```

## Advanced Features

### History Management

```dart
// Configure undo history depth
final notifier = ScribbleNotifier(maxHistoryLength: 50);

// Check history state
if (notifier.canUndo) notifier.undo();
if (notifier.canRedo) notifier.redo();
```

### Sketch Simplification

```dart
// Configure simplification for smaller storage
final notifier = ScribbleNotifier(
  simplificationTolerance: 2.0, // Reduce points for storage efficiency
);

// Manual simplification
notifier.simplify(addToUndoHistory: true);
```

### Background Image Support

```dart
final notifier = ScribbleNotifier(
  backgroundImage: AssetImage('background.png'),
  backgroundImageSize: Size(800, 600),
  backgroundImageOffset: Offset.zero,
);
```

## Data Structure

### JSON Format

The serialized sketch follows this structure:

```json
{
  "lines": [
    {
      "points": [
        {"x": 100.0, "y": 100.0, "pressure": 0.5},
        {"x": 200.0, "y": 150.0, "pressure": 0.8}
      ],
      "color": 4294901760,
      "width": 5.0
    }
  ]
}
```

### Point Data

Each point contains:
- `x`: X-coordinate (double)
- `y`: Y-coordinate (double)  
- `pressure`: Pressure value 0.0-1.0 (double)

### Stroke Data

Each stroke contains:
- `points`: Array of Point objects
- `color`: ARGB color value (int)
- `width`: Stroke width (double)

## Best Practices

### 1. Storage Efficiency

```dart
// Use simplification to reduce file size
notifier.setSimplificationTolerance(2.0);
notifier.simplify();

// Compress JSON for network transfer
import 'dart:io';
final compressed = gzip.encode(utf8.encode(jsonString));
```

### 2. Error Handling

```dart
try {
  final sketch = Sketch.fromJson(jsonMap);
  notifier.setSketch(sketch: sketch);
} catch (e) {
  print('Failed to load sketch: $e');
  // Handle corrupted data gracefully
}
```

### 3. Version Compatibility

```dart
// Add version metadata for future compatibility
final metadata = {
  'version': '1.0',
  'timestamp': DateTime.now().toIso8601String(),
  'sketch': sketch.toJson(),
};
```

### 4. Performance Optimization

```dart
// Batch operations for better performance
final sketches = <Sketch>[];
for (final jsonData in sketchDataList) {
  sketches.add(Sketch.fromJson(jsonData));
}

// Use background isolates for large sketches
compute(parseSketchJson, jsonString);
```

## Example Implementation

See `example_stroke_storage.dart` for a complete working example that demonstrates:

- Save/load sketches to memory
- Export/import JSON data
- Create sketches programmatically
- Undo/redo functionality
- Error handling

## Integration Notes

The Scribble library is designed to work seamlessly with:

- **State Management**: Works with Provider, Riverpod, Bloc, etc.
- **Storage Solutions**: Compatible with any storage backend
- **Cloud Services**: Easy integration with Firebase, Supabase, etc.
- **Offline-First**: Full offline support with sync capabilities

## Conclusion

The Scribble library provides a robust foundation for stroke storage and restoration. The built-in JSON serialization covers all use cases from simple local storage to complex cloud-based collaborative drawing applications.
