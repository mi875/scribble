// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'simple_notebook_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SimpleNotebookState {
  /// The current pages in the notebook
  List<SimpleNotebookPage> get pages;

  /// Index of the currently active page
  int get currentPageIndex;

  /// Which pointers are allowed for drawing and will be captured
  ScribblePointerMode get allowedPointersMode;

  /// The ids of all supported pointers that are currently interacting
  List<int> get activePointerIds;

  /// The current position of the pointer
  Point? get pointerPosition;

  /// The color that is currently being drawn with
  int get selectedColor;

  /// The current width of the pen
  double get selectedWidth;

  /// How much the widget is scaled at the moment
  double get scaleFactor;

  /// The current tolerance of simplification, in pixels
  double get simplificationTolerance;

  /// The visual zoom level of the canvas (separate from scaleFactor)
  double get zoomLevel;

  /// The pan offset for the canvas when zoomed
  Offset get panOffset;

  /// Create a copy of SimpleNotebookState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SimpleNotebookStateCopyWith<SimpleNotebookState> get copyWith =>
      _$SimpleNotebookStateCopyWithImpl<SimpleNotebookState>(
          this as SimpleNotebookState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SimpleNotebookState &&
            const DeepCollectionEquality().equals(other.pages, pages) &&
            (identical(other.currentPageIndex, currentPageIndex) ||
                other.currentPageIndex == currentPageIndex) &&
            (identical(other.allowedPointersMode, allowedPointersMode) ||
                other.allowedPointersMode == allowedPointersMode) &&
            const DeepCollectionEquality()
                .equals(other.activePointerIds, activePointerIds) &&
            (identical(other.pointerPosition, pointerPosition) ||
                other.pointerPosition == pointerPosition) &&
            (identical(other.selectedColor, selectedColor) ||
                other.selectedColor == selectedColor) &&
            (identical(other.selectedWidth, selectedWidth) ||
                other.selectedWidth == selectedWidth) &&
            (identical(other.scaleFactor, scaleFactor) ||
                other.scaleFactor == scaleFactor) &&
            (identical(
                    other.simplificationTolerance, simplificationTolerance) ||
                other.simplificationTolerance == simplificationTolerance) &&
            (identical(other.zoomLevel, zoomLevel) ||
                other.zoomLevel == zoomLevel) &&
            (identical(other.panOffset, panOffset) ||
                other.panOffset == panOffset));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(pages),
      currentPageIndex,
      allowedPointersMode,
      const DeepCollectionEquality().hash(activePointerIds),
      pointerPosition,
      selectedColor,
      selectedWidth,
      scaleFactor,
      simplificationTolerance,
      zoomLevel,
      panOffset);

  @override
  String toString() {
    return 'SimpleNotebookState(pages: $pages, currentPageIndex: $currentPageIndex, allowedPointersMode: $allowedPointersMode, activePointerIds: $activePointerIds, pointerPosition: $pointerPosition, selectedColor: $selectedColor, selectedWidth: $selectedWidth, scaleFactor: $scaleFactor, simplificationTolerance: $simplificationTolerance, zoomLevel: $zoomLevel, panOffset: $panOffset)';
  }
}

/// @nodoc
abstract mixin class $SimpleNotebookStateCopyWith<$Res> {
  factory $SimpleNotebookStateCopyWith(
          SimpleNotebookState value, $Res Function(SimpleNotebookState) _then) =
      _$SimpleNotebookStateCopyWithImpl;
  @useResult
  $Res call(
      {List<SimpleNotebookPage> pages,
      int currentPageIndex,
      ScribblePointerMode allowedPointersMode,
      List<int> activePointerIds,
      Point? pointerPosition,
      int selectedColor,
      double selectedWidth,
      double scaleFactor,
      double simplificationTolerance,
      double zoomLevel,
      Offset panOffset});

  $PointCopyWith<$Res>? get pointerPosition;
}

/// @nodoc
class _$SimpleNotebookStateCopyWithImpl<$Res>
    implements $SimpleNotebookStateCopyWith<$Res> {
  _$SimpleNotebookStateCopyWithImpl(this._self, this._then);

  final SimpleNotebookState _self;
  final $Res Function(SimpleNotebookState) _then;

  /// Create a copy of SimpleNotebookState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pages = null,
    Object? currentPageIndex = null,
    Object? allowedPointersMode = null,
    Object? activePointerIds = null,
    Object? pointerPosition = freezed,
    Object? selectedColor = null,
    Object? selectedWidth = null,
    Object? scaleFactor = null,
    Object? simplificationTolerance = null,
    Object? zoomLevel = null,
    Object? panOffset = null,
  }) {
    return _then(_self.copyWith(
      pages: null == pages
          ? _self.pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<SimpleNotebookPage>,
      currentPageIndex: null == currentPageIndex
          ? _self.currentPageIndex
          : currentPageIndex // ignore: cast_nullable_to_non_nullable
              as int,
      allowedPointersMode: null == allowedPointersMode
          ? _self.allowedPointersMode
          : allowedPointersMode // ignore: cast_nullable_to_non_nullable
              as ScribblePointerMode,
      activePointerIds: null == activePointerIds
          ? _self.activePointerIds
          : activePointerIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      pointerPosition: freezed == pointerPosition
          ? _self.pointerPosition
          : pointerPosition // ignore: cast_nullable_to_non_nullable
              as Point?,
      selectedColor: null == selectedColor
          ? _self.selectedColor
          : selectedColor // ignore: cast_nullable_to_non_nullable
              as int,
      selectedWidth: null == selectedWidth
          ? _self.selectedWidth
          : selectedWidth // ignore: cast_nullable_to_non_nullable
              as double,
      scaleFactor: null == scaleFactor
          ? _self.scaleFactor
          : scaleFactor // ignore: cast_nullable_to_non_nullable
              as double,
      simplificationTolerance: null == simplificationTolerance
          ? _self.simplificationTolerance
          : simplificationTolerance // ignore: cast_nullable_to_non_nullable
              as double,
      zoomLevel: null == zoomLevel
          ? _self.zoomLevel
          : zoomLevel // ignore: cast_nullable_to_non_nullable
              as double,
      panOffset: null == panOffset
          ? _self.panOffset
          : panOffset // ignore: cast_nullable_to_non_nullable
              as Offset,
    ));
  }

  /// Create a copy of SimpleNotebookState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PointCopyWith<$Res>? get pointerPosition {
    if (_self.pointerPosition == null) {
      return null;
    }

    return $PointCopyWith<$Res>(_self.pointerPosition!, (value) {
      return _then(_self.copyWith(pointerPosition: value));
    });
  }
}

/// Adds pattern-matching-related methods to [SimpleNotebookState].
extension SimpleNotebookStatePatterns on SimpleNotebookState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SimpleNotebookDrawing value)? drawing,
    TResult Function(SimpleNotebookErasing value)? erasing,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case SimpleNotebookDrawing() when drawing != null:
        return drawing(_that);
      case SimpleNotebookErasing() when erasing != null:
        return erasing(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SimpleNotebookDrawing value) drawing,
    required TResult Function(SimpleNotebookErasing value) erasing,
  }) {
    final _that = this;
    switch (_that) {
      case SimpleNotebookDrawing():
        return drawing(_that);
      case SimpleNotebookErasing():
        return erasing(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SimpleNotebookDrawing value)? drawing,
    TResult? Function(SimpleNotebookErasing value)? erasing,
  }) {
    final _that = this;
    switch (_that) {
      case SimpleNotebookDrawing() when drawing != null:
        return drawing(_that);
      case SimpleNotebookErasing() when erasing != null:
        return erasing(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            List<SimpleNotebookPage> pages,
            int currentPageIndex,
            SketchLine? activeLine,
            ScribblePointerMode allowedPointersMode,
            List<int> activePointerIds,
            Point? pointerPosition,
            int selectedColor,
            double selectedWidth,
            double scaleFactor,
            double simplificationTolerance,
            double zoomLevel,
            Offset panOffset)?
        drawing,
    TResult Function(
            List<SimpleNotebookPage> pages,
            int currentPageIndex,
            ScribblePointerMode allowedPointersMode,
            List<int> activePointerIds,
            Point? pointerPosition,
            int selectedColor,
            double selectedWidth,
            double scaleFactor,
            double simplificationTolerance,
            double zoomLevel,
            Offset panOffset)?
        erasing,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case SimpleNotebookDrawing() when drawing != null:
        return drawing(
            _that.pages,
            _that.currentPageIndex,
            _that.activeLine,
            _that.allowedPointersMode,
            _that.activePointerIds,
            _that.pointerPosition,
            _that.selectedColor,
            _that.selectedWidth,
            _that.scaleFactor,
            _that.simplificationTolerance,
            _that.zoomLevel,
            _that.panOffset);
      case SimpleNotebookErasing() when erasing != null:
        return erasing(
            _that.pages,
            _that.currentPageIndex,
            _that.allowedPointersMode,
            _that.activePointerIds,
            _that.pointerPosition,
            _that.selectedColor,
            _that.selectedWidth,
            _that.scaleFactor,
            _that.simplificationTolerance,
            _that.zoomLevel,
            _that.panOffset);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            List<SimpleNotebookPage> pages,
            int currentPageIndex,
            SketchLine? activeLine,
            ScribblePointerMode allowedPointersMode,
            List<int> activePointerIds,
            Point? pointerPosition,
            int selectedColor,
            double selectedWidth,
            double scaleFactor,
            double simplificationTolerance,
            double zoomLevel,
            Offset panOffset)
        drawing,
    required TResult Function(
            List<SimpleNotebookPage> pages,
            int currentPageIndex,
            ScribblePointerMode allowedPointersMode,
            List<int> activePointerIds,
            Point? pointerPosition,
            int selectedColor,
            double selectedWidth,
            double scaleFactor,
            double simplificationTolerance,
            double zoomLevel,
            Offset panOffset)
        erasing,
  }) {
    final _that = this;
    switch (_that) {
      case SimpleNotebookDrawing():
        return drawing(
            _that.pages,
            _that.currentPageIndex,
            _that.activeLine,
            _that.allowedPointersMode,
            _that.activePointerIds,
            _that.pointerPosition,
            _that.selectedColor,
            _that.selectedWidth,
            _that.scaleFactor,
            _that.simplificationTolerance,
            _that.zoomLevel,
            _that.panOffset);
      case SimpleNotebookErasing():
        return erasing(
            _that.pages,
            _that.currentPageIndex,
            _that.allowedPointersMode,
            _that.activePointerIds,
            _that.pointerPosition,
            _that.selectedColor,
            _that.selectedWidth,
            _that.scaleFactor,
            _that.simplificationTolerance,
            _that.zoomLevel,
            _that.panOffset);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            List<SimpleNotebookPage> pages,
            int currentPageIndex,
            SketchLine? activeLine,
            ScribblePointerMode allowedPointersMode,
            List<int> activePointerIds,
            Point? pointerPosition,
            int selectedColor,
            double selectedWidth,
            double scaleFactor,
            double simplificationTolerance,
            double zoomLevel,
            Offset panOffset)?
        drawing,
    TResult? Function(
            List<SimpleNotebookPage> pages,
            int currentPageIndex,
            ScribblePointerMode allowedPointersMode,
            List<int> activePointerIds,
            Point? pointerPosition,
            int selectedColor,
            double selectedWidth,
            double scaleFactor,
            double simplificationTolerance,
            double zoomLevel,
            Offset panOffset)?
        erasing,
  }) {
    final _that = this;
    switch (_that) {
      case SimpleNotebookDrawing() when drawing != null:
        return drawing(
            _that.pages,
            _that.currentPageIndex,
            _that.activeLine,
            _that.allowedPointersMode,
            _that.activePointerIds,
            _that.pointerPosition,
            _that.selectedColor,
            _that.selectedWidth,
            _that.scaleFactor,
            _that.simplificationTolerance,
            _that.zoomLevel,
            _that.panOffset);
      case SimpleNotebookErasing() when erasing != null:
        return erasing(
            _that.pages,
            _that.currentPageIndex,
            _that.allowedPointersMode,
            _that.activePointerIds,
            _that.pointerPosition,
            _that.selectedColor,
            _that.selectedWidth,
            _that.scaleFactor,
            _that.simplificationTolerance,
            _that.zoomLevel,
            _that.panOffset);
      case _:
        return null;
    }
  }
}

/// @nodoc

class SimpleNotebookDrawing extends SimpleNotebookState {
  const SimpleNotebookDrawing(
      {final List<SimpleNotebookPage> pages = const [],
      this.currentPageIndex = 0,
      this.activeLine,
      this.allowedPointersMode = ScribblePointerMode.all,
      final List<int> activePointerIds = const [],
      this.pointerPosition,
      this.selectedColor = 0xFF000000,
      this.selectedWidth = 5,
      this.scaleFactor = 1,
      this.simplificationTolerance = 0,
      this.zoomLevel = 1,
      this.panOffset = Offset.zero})
      : _pages = pages,
        _activePointerIds = activePointerIds,
        super._();

  /// The current pages in the notebook
  final List<SimpleNotebookPage> _pages;

  /// The current pages in the notebook
  @override
  @JsonKey()
  List<SimpleNotebookPage> get pages {
    if (_pages is EqualUnmodifiableListView) return _pages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pages);
  }

  /// Index of the currently active page
  @override
  @JsonKey()
  final int currentPageIndex;

  /// The line that is currently being drawn
  final SketchLine? activeLine;

  /// Which pointers are allowed for drawing and will be captured
  @override
  @JsonKey()
  final ScribblePointerMode allowedPointersMode;

  /// The ids of all supported pointers that are currently interacting
  final List<int> _activePointerIds;

  /// The ids of all supported pointers that are currently interacting
  @override
  @JsonKey()
  List<int> get activePointerIds {
    if (_activePointerIds is EqualUnmodifiableListView)
      return _activePointerIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activePointerIds);
  }

  /// The current position of the pointer
  @override
  final Point? pointerPosition;

  /// The color that is currently being drawn with
  @override
  @JsonKey()
  final int selectedColor;

  /// The current width of the pen
  @override
  @JsonKey()
  final double selectedWidth;

  /// How much the widget is scaled at the moment
  @override
  @JsonKey()
  final double scaleFactor;

  /// The current tolerance of simplification, in pixels
  @override
  @JsonKey()
  final double simplificationTolerance;

  /// The visual zoom level of the canvas (separate from scaleFactor)
  @override
  @JsonKey()
  final double zoomLevel;

  /// The pan offset for the canvas when zoomed
  @override
  @JsonKey()
  final Offset panOffset;

  /// Create a copy of SimpleNotebookState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SimpleNotebookDrawingCopyWith<SimpleNotebookDrawing> get copyWith =>
      _$SimpleNotebookDrawingCopyWithImpl<SimpleNotebookDrawing>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SimpleNotebookDrawing &&
            const DeepCollectionEquality().equals(other._pages, _pages) &&
            (identical(other.currentPageIndex, currentPageIndex) ||
                other.currentPageIndex == currentPageIndex) &&
            (identical(other.activeLine, activeLine) ||
                other.activeLine == activeLine) &&
            (identical(other.allowedPointersMode, allowedPointersMode) ||
                other.allowedPointersMode == allowedPointersMode) &&
            const DeepCollectionEquality()
                .equals(other._activePointerIds, _activePointerIds) &&
            (identical(other.pointerPosition, pointerPosition) ||
                other.pointerPosition == pointerPosition) &&
            (identical(other.selectedColor, selectedColor) ||
                other.selectedColor == selectedColor) &&
            (identical(other.selectedWidth, selectedWidth) ||
                other.selectedWidth == selectedWidth) &&
            (identical(other.scaleFactor, scaleFactor) ||
                other.scaleFactor == scaleFactor) &&
            (identical(
                    other.simplificationTolerance, simplificationTolerance) ||
                other.simplificationTolerance == simplificationTolerance) &&
            (identical(other.zoomLevel, zoomLevel) ||
                other.zoomLevel == zoomLevel) &&
            (identical(other.panOffset, panOffset) ||
                other.panOffset == panOffset));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_pages),
      currentPageIndex,
      activeLine,
      allowedPointersMode,
      const DeepCollectionEquality().hash(_activePointerIds),
      pointerPosition,
      selectedColor,
      selectedWidth,
      scaleFactor,
      simplificationTolerance,
      zoomLevel,
      panOffset);

  @override
  String toString() {
    return 'SimpleNotebookState.drawing(pages: $pages, currentPageIndex: $currentPageIndex, activeLine: $activeLine, allowedPointersMode: $allowedPointersMode, activePointerIds: $activePointerIds, pointerPosition: $pointerPosition, selectedColor: $selectedColor, selectedWidth: $selectedWidth, scaleFactor: $scaleFactor, simplificationTolerance: $simplificationTolerance, zoomLevel: $zoomLevel, panOffset: $panOffset)';
  }
}

/// @nodoc
abstract mixin class $SimpleNotebookDrawingCopyWith<$Res>
    implements $SimpleNotebookStateCopyWith<$Res> {
  factory $SimpleNotebookDrawingCopyWith(SimpleNotebookDrawing value,
          $Res Function(SimpleNotebookDrawing) _then) =
      _$SimpleNotebookDrawingCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<SimpleNotebookPage> pages,
      int currentPageIndex,
      SketchLine? activeLine,
      ScribblePointerMode allowedPointersMode,
      List<int> activePointerIds,
      Point? pointerPosition,
      int selectedColor,
      double selectedWidth,
      double scaleFactor,
      double simplificationTolerance,
      double zoomLevel,
      Offset panOffset});

  $SketchLineCopyWith<$Res>? get activeLine;
  @override
  $PointCopyWith<$Res>? get pointerPosition;
}

/// @nodoc
class _$SimpleNotebookDrawingCopyWithImpl<$Res>
    implements $SimpleNotebookDrawingCopyWith<$Res> {
  _$SimpleNotebookDrawingCopyWithImpl(this._self, this._then);

  final SimpleNotebookDrawing _self;
  final $Res Function(SimpleNotebookDrawing) _then;

  /// Create a copy of SimpleNotebookState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? pages = null,
    Object? currentPageIndex = null,
    Object? activeLine = freezed,
    Object? allowedPointersMode = null,
    Object? activePointerIds = null,
    Object? pointerPosition = freezed,
    Object? selectedColor = null,
    Object? selectedWidth = null,
    Object? scaleFactor = null,
    Object? simplificationTolerance = null,
    Object? zoomLevel = null,
    Object? panOffset = null,
  }) {
    return _then(SimpleNotebookDrawing(
      pages: null == pages
          ? _self._pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<SimpleNotebookPage>,
      currentPageIndex: null == currentPageIndex
          ? _self.currentPageIndex
          : currentPageIndex // ignore: cast_nullable_to_non_nullable
              as int,
      activeLine: freezed == activeLine
          ? _self.activeLine
          : activeLine // ignore: cast_nullable_to_non_nullable
              as SketchLine?,
      allowedPointersMode: null == allowedPointersMode
          ? _self.allowedPointersMode
          : allowedPointersMode // ignore: cast_nullable_to_non_nullable
              as ScribblePointerMode,
      activePointerIds: null == activePointerIds
          ? _self._activePointerIds
          : activePointerIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      pointerPosition: freezed == pointerPosition
          ? _self.pointerPosition
          : pointerPosition // ignore: cast_nullable_to_non_nullable
              as Point?,
      selectedColor: null == selectedColor
          ? _self.selectedColor
          : selectedColor // ignore: cast_nullable_to_non_nullable
              as int,
      selectedWidth: null == selectedWidth
          ? _self.selectedWidth
          : selectedWidth // ignore: cast_nullable_to_non_nullable
              as double,
      scaleFactor: null == scaleFactor
          ? _self.scaleFactor
          : scaleFactor // ignore: cast_nullable_to_non_nullable
              as double,
      simplificationTolerance: null == simplificationTolerance
          ? _self.simplificationTolerance
          : simplificationTolerance // ignore: cast_nullable_to_non_nullable
              as double,
      zoomLevel: null == zoomLevel
          ? _self.zoomLevel
          : zoomLevel // ignore: cast_nullable_to_non_nullable
              as double,
      panOffset: null == panOffset
          ? _self.panOffset
          : panOffset // ignore: cast_nullable_to_non_nullable
              as Offset,
    ));
  }

  /// Create a copy of SimpleNotebookState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SketchLineCopyWith<$Res>? get activeLine {
    if (_self.activeLine == null) {
      return null;
    }

    return $SketchLineCopyWith<$Res>(_self.activeLine!, (value) {
      return _then(_self.copyWith(activeLine: value));
    });
  }

  /// Create a copy of SimpleNotebookState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PointCopyWith<$Res>? get pointerPosition {
    if (_self.pointerPosition == null) {
      return null;
    }

    return $PointCopyWith<$Res>(_self.pointerPosition!, (value) {
      return _then(_self.copyWith(pointerPosition: value));
    });
  }
}

/// @nodoc

class SimpleNotebookErasing extends SimpleNotebookState {
  const SimpleNotebookErasing(
      {final List<SimpleNotebookPage> pages = const [],
      this.currentPageIndex = 0,
      this.allowedPointersMode = ScribblePointerMode.all,
      final List<int> activePointerIds = const [],
      this.pointerPosition,
      this.selectedColor = 0xFF000000,
      this.selectedWidth = 5,
      this.scaleFactor = 1,
      this.simplificationTolerance = 0,
      this.zoomLevel = 1,
      this.panOffset = Offset.zero})
      : _pages = pages,
        _activePointerIds = activePointerIds,
        super._();

  /// The current pages in the notebook
  final List<SimpleNotebookPage> _pages;

  /// The current pages in the notebook
  @override
  @JsonKey()
  List<SimpleNotebookPage> get pages {
    if (_pages is EqualUnmodifiableListView) return _pages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pages);
  }

  /// Index of the currently active page
  @override
  @JsonKey()
  final int currentPageIndex;

  /// Which pointers are allowed for drawing and will be captured
  @override
  @JsonKey()
  final ScribblePointerMode allowedPointersMode;

  /// The ids of all supported pointers that are currently interacting
  final List<int> _activePointerIds;

  /// The ids of all supported pointers that are currently interacting
  @override
  @JsonKey()
  List<int> get activePointerIds {
    if (_activePointerIds is EqualUnmodifiableListView)
      return _activePointerIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activePointerIds);
  }

  /// The current position of the pointer
  @override
  final Point? pointerPosition;

  /// The color that is currently being drawn with
  @override
  @JsonKey()
  final int selectedColor;

  /// The current width of the pen
  @override
  @JsonKey()
  final double selectedWidth;

  /// How much the widget is scaled at the moment
  @override
  @JsonKey()
  final double scaleFactor;

  /// The current tolerance of simplification, in pixels
  @override
  @JsonKey()
  final double simplificationTolerance;

  /// The visual zoom level of the canvas (separate from scaleFactor)
  @override
  @JsonKey()
  final double zoomLevel;

  /// The pan offset for the canvas when zoomed
  @override
  @JsonKey()
  final Offset panOffset;

  /// Create a copy of SimpleNotebookState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SimpleNotebookErasingCopyWith<SimpleNotebookErasing> get copyWith =>
      _$SimpleNotebookErasingCopyWithImpl<SimpleNotebookErasing>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SimpleNotebookErasing &&
            const DeepCollectionEquality().equals(other._pages, _pages) &&
            (identical(other.currentPageIndex, currentPageIndex) ||
                other.currentPageIndex == currentPageIndex) &&
            (identical(other.allowedPointersMode, allowedPointersMode) ||
                other.allowedPointersMode == allowedPointersMode) &&
            const DeepCollectionEquality()
                .equals(other._activePointerIds, _activePointerIds) &&
            (identical(other.pointerPosition, pointerPosition) ||
                other.pointerPosition == pointerPosition) &&
            (identical(other.selectedColor, selectedColor) ||
                other.selectedColor == selectedColor) &&
            (identical(other.selectedWidth, selectedWidth) ||
                other.selectedWidth == selectedWidth) &&
            (identical(other.scaleFactor, scaleFactor) ||
                other.scaleFactor == scaleFactor) &&
            (identical(
                    other.simplificationTolerance, simplificationTolerance) ||
                other.simplificationTolerance == simplificationTolerance) &&
            (identical(other.zoomLevel, zoomLevel) ||
                other.zoomLevel == zoomLevel) &&
            (identical(other.panOffset, panOffset) ||
                other.panOffset == panOffset));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_pages),
      currentPageIndex,
      allowedPointersMode,
      const DeepCollectionEquality().hash(_activePointerIds),
      pointerPosition,
      selectedColor,
      selectedWidth,
      scaleFactor,
      simplificationTolerance,
      zoomLevel,
      panOffset);

  @override
  String toString() {
    return 'SimpleNotebookState.erasing(pages: $pages, currentPageIndex: $currentPageIndex, allowedPointersMode: $allowedPointersMode, activePointerIds: $activePointerIds, pointerPosition: $pointerPosition, selectedColor: $selectedColor, selectedWidth: $selectedWidth, scaleFactor: $scaleFactor, simplificationTolerance: $simplificationTolerance, zoomLevel: $zoomLevel, panOffset: $panOffset)';
  }
}

/// @nodoc
abstract mixin class $SimpleNotebookErasingCopyWith<$Res>
    implements $SimpleNotebookStateCopyWith<$Res> {
  factory $SimpleNotebookErasingCopyWith(SimpleNotebookErasing value,
          $Res Function(SimpleNotebookErasing) _then) =
      _$SimpleNotebookErasingCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<SimpleNotebookPage> pages,
      int currentPageIndex,
      ScribblePointerMode allowedPointersMode,
      List<int> activePointerIds,
      Point? pointerPosition,
      int selectedColor,
      double selectedWidth,
      double scaleFactor,
      double simplificationTolerance,
      double zoomLevel,
      Offset panOffset});

  @override
  $PointCopyWith<$Res>? get pointerPosition;
}

/// @nodoc
class _$SimpleNotebookErasingCopyWithImpl<$Res>
    implements $SimpleNotebookErasingCopyWith<$Res> {
  _$SimpleNotebookErasingCopyWithImpl(this._self, this._then);

  final SimpleNotebookErasing _self;
  final $Res Function(SimpleNotebookErasing) _then;

  /// Create a copy of SimpleNotebookState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? pages = null,
    Object? currentPageIndex = null,
    Object? allowedPointersMode = null,
    Object? activePointerIds = null,
    Object? pointerPosition = freezed,
    Object? selectedColor = null,
    Object? selectedWidth = null,
    Object? scaleFactor = null,
    Object? simplificationTolerance = null,
    Object? zoomLevel = null,
    Object? panOffset = null,
  }) {
    return _then(SimpleNotebookErasing(
      pages: null == pages
          ? _self._pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<SimpleNotebookPage>,
      currentPageIndex: null == currentPageIndex
          ? _self.currentPageIndex
          : currentPageIndex // ignore: cast_nullable_to_non_nullable
              as int,
      allowedPointersMode: null == allowedPointersMode
          ? _self.allowedPointersMode
          : allowedPointersMode // ignore: cast_nullable_to_non_nullable
              as ScribblePointerMode,
      activePointerIds: null == activePointerIds
          ? _self._activePointerIds
          : activePointerIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      pointerPosition: freezed == pointerPosition
          ? _self.pointerPosition
          : pointerPosition // ignore: cast_nullable_to_non_nullable
              as Point?,
      selectedColor: null == selectedColor
          ? _self.selectedColor
          : selectedColor // ignore: cast_nullable_to_non_nullable
              as int,
      selectedWidth: null == selectedWidth
          ? _self.selectedWidth
          : selectedWidth // ignore: cast_nullable_to_non_nullable
              as double,
      scaleFactor: null == scaleFactor
          ? _self.scaleFactor
          : scaleFactor // ignore: cast_nullable_to_non_nullable
              as double,
      simplificationTolerance: null == simplificationTolerance
          ? _self.simplificationTolerance
          : simplificationTolerance // ignore: cast_nullable_to_non_nullable
              as double,
      zoomLevel: null == zoomLevel
          ? _self.zoomLevel
          : zoomLevel // ignore: cast_nullable_to_non_nullable
              as double,
      panOffset: null == panOffset
          ? _self.panOffset
          : panOffset // ignore: cast_nullable_to_non_nullable
              as Offset,
    ));
  }

  /// Create a copy of SimpleNotebookState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PointCopyWith<$Res>? get pointerPosition {
    if (_self.pointerPosition == null) {
      return null;
    }

    return $PointCopyWith<$Res>(_self.pointerPosition!, (value) {
      return _then(_self.copyWith(pointerPosition: value));
    });
  }
}

// dart format on
