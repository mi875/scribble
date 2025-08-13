// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'simple_notebook_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SimpleNotebookState {
  /// The current pages in the notebook
  List<SimpleNotebookPage> get pages => throw _privateConstructorUsedError;

  /// Index of the currently active page
  int get currentPageIndex => throw _privateConstructorUsedError;

  /// Which pointers are allowed for drawing and will be captured
  ScribblePointerMode get allowedPointersMode =>
      throw _privateConstructorUsedError;

  /// The ids of all supported pointers that are currently interacting
  List<int> get activePointerIds => throw _privateConstructorUsedError;

  /// The current position of the pointer
  Point? get pointerPosition => throw _privateConstructorUsedError;

  /// The color that is currently being drawn with
  int get selectedColor => throw _privateConstructorUsedError;

  /// The current width of the pen
  double get selectedWidth => throw _privateConstructorUsedError;

  /// How much the widget is scaled at the moment
  double get scaleFactor => throw _privateConstructorUsedError;

  /// The current tolerance of simplification, in pixels
  double get simplificationTolerance => throw _privateConstructorUsedError;

  /// The visual zoom level of the canvas (separate from scaleFactor)
  double get zoomLevel => throw _privateConstructorUsedError;

  /// The pan offset for the canvas when zoomed
  Offset get panOffset => throw _privateConstructorUsedError;
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
  }) =>
      throw _privateConstructorUsedError;
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
  }) =>
      throw _privateConstructorUsedError;
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
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SimpleNotebookDrawing value) drawing,
    required TResult Function(SimpleNotebookErasing value) erasing,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SimpleNotebookDrawing value)? drawing,
    TResult? Function(SimpleNotebookErasing value)? erasing,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SimpleNotebookDrawing value)? drawing,
    TResult Function(SimpleNotebookErasing value)? erasing,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of SimpleNotebookState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SimpleNotebookStateCopyWith<SimpleNotebookState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SimpleNotebookStateCopyWith<$Res> {
  factory $SimpleNotebookStateCopyWith(
          SimpleNotebookState value, $Res Function(SimpleNotebookState) then) =
      _$SimpleNotebookStateCopyWithImpl<$Res, SimpleNotebookState>;
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
class _$SimpleNotebookStateCopyWithImpl<$Res, $Val extends SimpleNotebookState>
    implements $SimpleNotebookStateCopyWith<$Res> {
  _$SimpleNotebookStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      pages: null == pages
          ? _value.pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<SimpleNotebookPage>,
      currentPageIndex: null == currentPageIndex
          ? _value.currentPageIndex
          : currentPageIndex // ignore: cast_nullable_to_non_nullable
              as int,
      allowedPointersMode: null == allowedPointersMode
          ? _value.allowedPointersMode
          : allowedPointersMode // ignore: cast_nullable_to_non_nullable
              as ScribblePointerMode,
      activePointerIds: null == activePointerIds
          ? _value.activePointerIds
          : activePointerIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      pointerPosition: freezed == pointerPosition
          ? _value.pointerPosition
          : pointerPosition // ignore: cast_nullable_to_non_nullable
              as Point?,
      selectedColor: null == selectedColor
          ? _value.selectedColor
          : selectedColor // ignore: cast_nullable_to_non_nullable
              as int,
      selectedWidth: null == selectedWidth
          ? _value.selectedWidth
          : selectedWidth // ignore: cast_nullable_to_non_nullable
              as double,
      scaleFactor: null == scaleFactor
          ? _value.scaleFactor
          : scaleFactor // ignore: cast_nullable_to_non_nullable
              as double,
      simplificationTolerance: null == simplificationTolerance
          ? _value.simplificationTolerance
          : simplificationTolerance // ignore: cast_nullable_to_non_nullable
              as double,
      zoomLevel: null == zoomLevel
          ? _value.zoomLevel
          : zoomLevel // ignore: cast_nullable_to_non_nullable
              as double,
      panOffset: null == panOffset
          ? _value.panOffset
          : panOffset // ignore: cast_nullable_to_non_nullable
              as Offset,
    ) as $Val);
  }

  /// Create a copy of SimpleNotebookState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PointCopyWith<$Res>? get pointerPosition {
    if (_value.pointerPosition == null) {
      return null;
    }

    return $PointCopyWith<$Res>(_value.pointerPosition!, (value) {
      return _then(_value.copyWith(pointerPosition: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SimpleNotebookDrawingImplCopyWith<$Res>
    implements $SimpleNotebookStateCopyWith<$Res> {
  factory _$$SimpleNotebookDrawingImplCopyWith(
          _$SimpleNotebookDrawingImpl value,
          $Res Function(_$SimpleNotebookDrawingImpl) then) =
      __$$SimpleNotebookDrawingImplCopyWithImpl<$Res>;
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
class __$$SimpleNotebookDrawingImplCopyWithImpl<$Res>
    extends _$SimpleNotebookStateCopyWithImpl<$Res, _$SimpleNotebookDrawingImpl>
    implements _$$SimpleNotebookDrawingImplCopyWith<$Res> {
  __$$SimpleNotebookDrawingImplCopyWithImpl(_$SimpleNotebookDrawingImpl _value,
      $Res Function(_$SimpleNotebookDrawingImpl) _then)
      : super(_value, _then);

  /// Create a copy of SimpleNotebookState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
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
    return _then(_$SimpleNotebookDrawingImpl(
      pages: null == pages
          ? _value._pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<SimpleNotebookPage>,
      currentPageIndex: null == currentPageIndex
          ? _value.currentPageIndex
          : currentPageIndex // ignore: cast_nullable_to_non_nullable
              as int,
      activeLine: freezed == activeLine
          ? _value.activeLine
          : activeLine // ignore: cast_nullable_to_non_nullable
              as SketchLine?,
      allowedPointersMode: null == allowedPointersMode
          ? _value.allowedPointersMode
          : allowedPointersMode // ignore: cast_nullable_to_non_nullable
              as ScribblePointerMode,
      activePointerIds: null == activePointerIds
          ? _value._activePointerIds
          : activePointerIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      pointerPosition: freezed == pointerPosition
          ? _value.pointerPosition
          : pointerPosition // ignore: cast_nullable_to_non_nullable
              as Point?,
      selectedColor: null == selectedColor
          ? _value.selectedColor
          : selectedColor // ignore: cast_nullable_to_non_nullable
              as int,
      selectedWidth: null == selectedWidth
          ? _value.selectedWidth
          : selectedWidth // ignore: cast_nullable_to_non_nullable
              as double,
      scaleFactor: null == scaleFactor
          ? _value.scaleFactor
          : scaleFactor // ignore: cast_nullable_to_non_nullable
              as double,
      simplificationTolerance: null == simplificationTolerance
          ? _value.simplificationTolerance
          : simplificationTolerance // ignore: cast_nullable_to_non_nullable
              as double,
      zoomLevel: null == zoomLevel
          ? _value.zoomLevel
          : zoomLevel // ignore: cast_nullable_to_non_nullable
              as double,
      panOffset: null == panOffset
          ? _value.panOffset
          : panOffset // ignore: cast_nullable_to_non_nullable
              as Offset,
    ));
  }

  /// Create a copy of SimpleNotebookState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SketchLineCopyWith<$Res>? get activeLine {
    if (_value.activeLine == null) {
      return null;
    }

    return $SketchLineCopyWith<$Res>(_value.activeLine!, (value) {
      return _then(_value.copyWith(activeLine: value));
    });
  }
}

/// @nodoc

class _$SimpleNotebookDrawingImpl extends SimpleNotebookDrawing {
  const _$SimpleNotebookDrawingImpl(
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
  @override
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

  @override
  String toString() {
    return 'SimpleNotebookState.drawing(pages: $pages, currentPageIndex: $currentPageIndex, activeLine: $activeLine, allowedPointersMode: $allowedPointersMode, activePointerIds: $activePointerIds, pointerPosition: $pointerPosition, selectedColor: $selectedColor, selectedWidth: $selectedWidth, scaleFactor: $scaleFactor, simplificationTolerance: $simplificationTolerance, zoomLevel: $zoomLevel, panOffset: $panOffset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SimpleNotebookDrawingImpl &&
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

  /// Create a copy of SimpleNotebookState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SimpleNotebookDrawingImplCopyWith<_$SimpleNotebookDrawingImpl>
      get copyWith => __$$SimpleNotebookDrawingImplCopyWithImpl<
          _$SimpleNotebookDrawingImpl>(this, _$identity);

  @override
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
    return drawing(
        pages,
        currentPageIndex,
        activeLine,
        allowedPointersMode,
        activePointerIds,
        pointerPosition,
        selectedColor,
        selectedWidth,
        scaleFactor,
        simplificationTolerance,
        zoomLevel,
        panOffset);
  }

  @override
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
    return drawing?.call(
        pages,
        currentPageIndex,
        activeLine,
        allowedPointersMode,
        activePointerIds,
        pointerPosition,
        selectedColor,
        selectedWidth,
        scaleFactor,
        simplificationTolerance,
        zoomLevel,
        panOffset);
  }

  @override
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
    if (drawing != null) {
      return drawing(
          pages,
          currentPageIndex,
          activeLine,
          allowedPointersMode,
          activePointerIds,
          pointerPosition,
          selectedColor,
          selectedWidth,
          scaleFactor,
          simplificationTolerance,
          zoomLevel,
          panOffset);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SimpleNotebookDrawing value) drawing,
    required TResult Function(SimpleNotebookErasing value) erasing,
  }) {
    return drawing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SimpleNotebookDrawing value)? drawing,
    TResult? Function(SimpleNotebookErasing value)? erasing,
  }) {
    return drawing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SimpleNotebookDrawing value)? drawing,
    TResult Function(SimpleNotebookErasing value)? erasing,
    required TResult orElse(),
  }) {
    if (drawing != null) {
      return drawing(this);
    }
    return orElse();
  }
}

abstract class SimpleNotebookDrawing extends SimpleNotebookState {
  const factory SimpleNotebookDrawing(
      {final List<SimpleNotebookPage> pages,
      final int currentPageIndex,
      final SketchLine? activeLine,
      final ScribblePointerMode allowedPointersMode,
      final List<int> activePointerIds,
      final Point? pointerPosition,
      final int selectedColor,
      final double selectedWidth,
      final double scaleFactor,
      final double simplificationTolerance,
      final double zoomLevel,
      final Offset panOffset}) = _$SimpleNotebookDrawingImpl;
  const SimpleNotebookDrawing._() : super._();

  /// The current pages in the notebook
  @override
  List<SimpleNotebookPage> get pages;

  /// Index of the currently active page
  @override
  int get currentPageIndex;

  /// The line that is currently being drawn
  SketchLine? get activeLine;

  /// Which pointers are allowed for drawing and will be captured
  @override
  ScribblePointerMode get allowedPointersMode;

  /// The ids of all supported pointers that are currently interacting
  @override
  List<int> get activePointerIds;

  /// The current position of the pointer
  @override
  Point? get pointerPosition;

  /// The color that is currently being drawn with
  @override
  int get selectedColor;

  /// The current width of the pen
  @override
  double get selectedWidth;

  /// How much the widget is scaled at the moment
  @override
  double get scaleFactor;

  /// The current tolerance of simplification, in pixels
  @override
  double get simplificationTolerance;

  /// The visual zoom level of the canvas (separate from scaleFactor)
  @override
  double get zoomLevel;

  /// The pan offset for the canvas when zoomed
  @override
  Offset get panOffset;

  /// Create a copy of SimpleNotebookState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SimpleNotebookDrawingImplCopyWith<_$SimpleNotebookDrawingImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SimpleNotebookErasingImplCopyWith<$Res>
    implements $SimpleNotebookStateCopyWith<$Res> {
  factory _$$SimpleNotebookErasingImplCopyWith(
          _$SimpleNotebookErasingImpl value,
          $Res Function(_$SimpleNotebookErasingImpl) then) =
      __$$SimpleNotebookErasingImplCopyWithImpl<$Res>;
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
class __$$SimpleNotebookErasingImplCopyWithImpl<$Res>
    extends _$SimpleNotebookStateCopyWithImpl<$Res, _$SimpleNotebookErasingImpl>
    implements _$$SimpleNotebookErasingImplCopyWith<$Res> {
  __$$SimpleNotebookErasingImplCopyWithImpl(_$SimpleNotebookErasingImpl _value,
      $Res Function(_$SimpleNotebookErasingImpl) _then)
      : super(_value, _then);

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
    return _then(_$SimpleNotebookErasingImpl(
      pages: null == pages
          ? _value._pages
          : pages // ignore: cast_nullable_to_non_nullable
              as List<SimpleNotebookPage>,
      currentPageIndex: null == currentPageIndex
          ? _value.currentPageIndex
          : currentPageIndex // ignore: cast_nullable_to_non_nullable
              as int,
      allowedPointersMode: null == allowedPointersMode
          ? _value.allowedPointersMode
          : allowedPointersMode // ignore: cast_nullable_to_non_nullable
              as ScribblePointerMode,
      activePointerIds: null == activePointerIds
          ? _value._activePointerIds
          : activePointerIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      pointerPosition: freezed == pointerPosition
          ? _value.pointerPosition
          : pointerPosition // ignore: cast_nullable_to_non_nullable
              as Point?,
      selectedColor: null == selectedColor
          ? _value.selectedColor
          : selectedColor // ignore: cast_nullable_to_non_nullable
              as int,
      selectedWidth: null == selectedWidth
          ? _value.selectedWidth
          : selectedWidth // ignore: cast_nullable_to_non_nullable
              as double,
      scaleFactor: null == scaleFactor
          ? _value.scaleFactor
          : scaleFactor // ignore: cast_nullable_to_non_nullable
              as double,
      simplificationTolerance: null == simplificationTolerance
          ? _value.simplificationTolerance
          : simplificationTolerance // ignore: cast_nullable_to_non_nullable
              as double,
      zoomLevel: null == zoomLevel
          ? _value.zoomLevel
          : zoomLevel // ignore: cast_nullable_to_non_nullable
              as double,
      panOffset: null == panOffset
          ? _value.panOffset
          : panOffset // ignore: cast_nullable_to_non_nullable
              as Offset,
    ));
  }
}

/// @nodoc

class _$SimpleNotebookErasingImpl extends SimpleNotebookErasing {
  const _$SimpleNotebookErasingImpl(
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

  @override
  String toString() {
    return 'SimpleNotebookState.erasing(pages: $pages, currentPageIndex: $currentPageIndex, allowedPointersMode: $allowedPointersMode, activePointerIds: $activePointerIds, pointerPosition: $pointerPosition, selectedColor: $selectedColor, selectedWidth: $selectedWidth, scaleFactor: $scaleFactor, simplificationTolerance: $simplificationTolerance, zoomLevel: $zoomLevel, panOffset: $panOffset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SimpleNotebookErasingImpl &&
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

  /// Create a copy of SimpleNotebookState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SimpleNotebookErasingImplCopyWith<_$SimpleNotebookErasingImpl>
      get copyWith => __$$SimpleNotebookErasingImplCopyWithImpl<
          _$SimpleNotebookErasingImpl>(this, _$identity);

  @override
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
    return erasing(
        pages,
        currentPageIndex,
        allowedPointersMode,
        activePointerIds,
        pointerPosition,
        selectedColor,
        selectedWidth,
        scaleFactor,
        simplificationTolerance,
        zoomLevel,
        panOffset);
  }

  @override
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
    return erasing?.call(
        pages,
        currentPageIndex,
        allowedPointersMode,
        activePointerIds,
        pointerPosition,
        selectedColor,
        selectedWidth,
        scaleFactor,
        simplificationTolerance,
        zoomLevel,
        panOffset);
  }

  @override
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
    if (erasing != null) {
      return erasing(
          pages,
          currentPageIndex,
          allowedPointersMode,
          activePointerIds,
          pointerPosition,
          selectedColor,
          selectedWidth,
          scaleFactor,
          simplificationTolerance,
          zoomLevel,
          panOffset);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SimpleNotebookDrawing value) drawing,
    required TResult Function(SimpleNotebookErasing value) erasing,
  }) {
    return erasing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SimpleNotebookDrawing value)? drawing,
    TResult? Function(SimpleNotebookErasing value)? erasing,
  }) {
    return erasing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SimpleNotebookDrawing value)? drawing,
    TResult Function(SimpleNotebookErasing value)? erasing,
    required TResult orElse(),
  }) {
    if (erasing != null) {
      return erasing(this);
    }
    return orElse();
  }
}

abstract class SimpleNotebookErasing extends SimpleNotebookState {
  const factory SimpleNotebookErasing(
      {final List<SimpleNotebookPage> pages,
      final int currentPageIndex,
      final ScribblePointerMode allowedPointersMode,
      final List<int> activePointerIds,
      final Point? pointerPosition,
      final int selectedColor,
      final double selectedWidth,
      final double scaleFactor,
      final double simplificationTolerance,
      final double zoomLevel,
      final Offset panOffset}) = _$SimpleNotebookErasingImpl;
  const SimpleNotebookErasing._() : super._();

  /// The current pages in the notebook
  @override
  List<SimpleNotebookPage> get pages;

  /// Index of the currently active page
  @override
  int get currentPageIndex;

  /// Which pointers are allowed for drawing and will be captured
  @override
  ScribblePointerMode get allowedPointersMode;

  /// The ids of all supported pointers that are currently interacting
  @override
  List<int> get activePointerIds;

  /// The current position of the pointer
  @override
  Point? get pointerPosition;

  /// The color that is currently being drawn with
  @override
  int get selectedColor;

  /// The current width of the pen
  @override
  double get selectedWidth;

  /// How much the widget is scaled at the moment
  @override
  double get scaleFactor;

  /// The current tolerance of simplification, in pixels
  @override
  double get simplificationTolerance;

  /// The visual zoom level of the canvas (separate from scaleFactor)
  @override
  double get zoomLevel;

  /// The pan offset for the canvas when zoomed
  @override
  Offset get panOffset;

  /// Create a copy of SimpleNotebookState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SimpleNotebookErasingImplCopyWith<_$SimpleNotebookErasingImpl>
      get copyWith => throw _privateConstructorUsedError;
}
