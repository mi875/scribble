// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notebook_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NotebookState {
  /// The current notebook with multiple pages
  Notebook get notebook => throw _privateConstructorUsedError;

  /// Which pointers are allowed for drawing and will be captured
  ScribblePointerMode get allowedPointersMode =>
      throw _privateConstructorUsedError;

  /// The ids of all supported pointers that are currently interacting
  List<int> get activePointerIds => throw _privateConstructorUsedError;

  /// The current position of the pointer
  Point? get pointerPosition => throw _privateConstructorUsedError;

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
            Notebook notebook,
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
            Notebook notebook,
            ScribblePointerMode allowedPointersMode,
            List<int> activePointerIds,
            Point? pointerPosition,
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
            Notebook notebook,
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
            Notebook notebook,
            ScribblePointerMode allowedPointersMode,
            List<int> activePointerIds,
            Point? pointerPosition,
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
            Notebook notebook,
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
            Notebook notebook,
            ScribblePointerMode allowedPointersMode,
            List<int> activePointerIds,
            Point? pointerPosition,
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
    required TResult Function(NotebookDrawing value) drawing,
    required TResult Function(NotebookErasing value) erasing,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NotebookDrawing value)? drawing,
    TResult? Function(NotebookErasing value)? erasing,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NotebookDrawing value)? drawing,
    TResult Function(NotebookErasing value)? erasing,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of NotebookState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotebookStateCopyWith<NotebookState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotebookStateCopyWith<$Res> {
  factory $NotebookStateCopyWith(
          NotebookState value, $Res Function(NotebookState) then) =
      _$NotebookStateCopyWithImpl<$Res, NotebookState>;
  @useResult
  $Res call(
      {Notebook notebook,
      ScribblePointerMode allowedPointersMode,
      List<int> activePointerIds,
      Point? pointerPosition,
      double selectedWidth,
      double scaleFactor,
      double simplificationTolerance,
      double zoomLevel,
      Offset panOffset});

  $PointCopyWith<$Res>? get pointerPosition;
}

/// @nodoc
class _$NotebookStateCopyWithImpl<$Res, $Val extends NotebookState>
    implements $NotebookStateCopyWith<$Res> {
  _$NotebookStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotebookState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notebook = null,
    Object? allowedPointersMode = null,
    Object? activePointerIds = null,
    Object? pointerPosition = freezed,
    Object? selectedWidth = null,
    Object? scaleFactor = null,
    Object? simplificationTolerance = null,
    Object? zoomLevel = null,
    Object? panOffset = null,
  }) {
    return _then(_value.copyWith(
      notebook: null == notebook
          ? _value.notebook
          : notebook // ignore: cast_nullable_to_non_nullable
              as Notebook,
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

  /// Create a copy of NotebookState
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
abstract class _$$NotebookDrawingImplCopyWith<$Res>
    implements $NotebookStateCopyWith<$Res> {
  factory _$$NotebookDrawingImplCopyWith(_$NotebookDrawingImpl value,
          $Res Function(_$NotebookDrawingImpl) then) =
      __$$NotebookDrawingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Notebook notebook,
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
class __$$NotebookDrawingImplCopyWithImpl<$Res>
    extends _$NotebookStateCopyWithImpl<$Res, _$NotebookDrawingImpl>
    implements _$$NotebookDrawingImplCopyWith<$Res> {
  __$$NotebookDrawingImplCopyWithImpl(
      _$NotebookDrawingImpl _value, $Res Function(_$NotebookDrawingImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotebookState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notebook = null,
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
    return _then(_$NotebookDrawingImpl(
      notebook: null == notebook
          ? _value.notebook
          : notebook // ignore: cast_nullable_to_non_nullable
              as Notebook,
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

  /// Create a copy of NotebookState
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

class _$NotebookDrawingImpl extends NotebookDrawing {
  const _$NotebookDrawingImpl(
      {required this.notebook,
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
      : _activePointerIds = activePointerIds,
        super._();

  /// The current notebook with multiple pages
  @override
  final Notebook notebook;

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
    return 'NotebookState.drawing(notebook: $notebook, activeLine: $activeLine, allowedPointersMode: $allowedPointersMode, activePointerIds: $activePointerIds, pointerPosition: $pointerPosition, selectedColor: $selectedColor, selectedWidth: $selectedWidth, scaleFactor: $scaleFactor, simplificationTolerance: $simplificationTolerance, zoomLevel: $zoomLevel, panOffset: $panOffset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotebookDrawingImpl &&
            (identical(other.notebook, notebook) ||
                other.notebook == notebook) &&
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
      notebook,
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

  /// Create a copy of NotebookState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotebookDrawingImplCopyWith<_$NotebookDrawingImpl> get copyWith =>
      __$$NotebookDrawingImplCopyWithImpl<_$NotebookDrawingImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            Notebook notebook,
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
            Notebook notebook,
            ScribblePointerMode allowedPointersMode,
            List<int> activePointerIds,
            Point? pointerPosition,
            double selectedWidth,
            double scaleFactor,
            double simplificationTolerance,
            double zoomLevel,
            Offset panOffset)
        erasing,
  }) {
    return drawing(
        notebook,
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
            Notebook notebook,
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
            Notebook notebook,
            ScribblePointerMode allowedPointersMode,
            List<int> activePointerIds,
            Point? pointerPosition,
            double selectedWidth,
            double scaleFactor,
            double simplificationTolerance,
            double zoomLevel,
            Offset panOffset)?
        erasing,
  }) {
    return drawing?.call(
        notebook,
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
            Notebook notebook,
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
            Notebook notebook,
            ScribblePointerMode allowedPointersMode,
            List<int> activePointerIds,
            Point? pointerPosition,
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
          notebook,
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
    required TResult Function(NotebookDrawing value) drawing,
    required TResult Function(NotebookErasing value) erasing,
  }) {
    return drawing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NotebookDrawing value)? drawing,
    TResult? Function(NotebookErasing value)? erasing,
  }) {
    return drawing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NotebookDrawing value)? drawing,
    TResult Function(NotebookErasing value)? erasing,
    required TResult orElse(),
  }) {
    if (drawing != null) {
      return drawing(this);
    }
    return orElse();
  }
}

abstract class NotebookDrawing extends NotebookState {
  const factory NotebookDrawing(
      {required final Notebook notebook,
      final SketchLine? activeLine,
      final ScribblePointerMode allowedPointersMode,
      final List<int> activePointerIds,
      final Point? pointerPosition,
      final int selectedColor,
      final double selectedWidth,
      final double scaleFactor,
      final double simplificationTolerance,
      final double zoomLevel,
      final Offset panOffset}) = _$NotebookDrawingImpl;
  const NotebookDrawing._() : super._();

  /// The current notebook with multiple pages
  @override
  Notebook get notebook;

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

  /// Create a copy of NotebookState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotebookDrawingImplCopyWith<_$NotebookDrawingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NotebookErasingImplCopyWith<$Res>
    implements $NotebookStateCopyWith<$Res> {
  factory _$$NotebookErasingImplCopyWith(_$NotebookErasingImpl value,
          $Res Function(_$NotebookErasingImpl) then) =
      __$$NotebookErasingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Notebook notebook,
      ScribblePointerMode allowedPointersMode,
      List<int> activePointerIds,
      Point? pointerPosition,
      double selectedWidth,
      double scaleFactor,
      double simplificationTolerance,
      double zoomLevel,
      Offset panOffset});

  @override
  $PointCopyWith<$Res>? get pointerPosition;
}

/// @nodoc
class __$$NotebookErasingImplCopyWithImpl<$Res>
    extends _$NotebookStateCopyWithImpl<$Res, _$NotebookErasingImpl>
    implements _$$NotebookErasingImplCopyWith<$Res> {
  __$$NotebookErasingImplCopyWithImpl(
      _$NotebookErasingImpl _value, $Res Function(_$NotebookErasingImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotebookState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notebook = null,
    Object? allowedPointersMode = null,
    Object? activePointerIds = null,
    Object? pointerPosition = freezed,
    Object? selectedWidth = null,
    Object? scaleFactor = null,
    Object? simplificationTolerance = null,
    Object? zoomLevel = null,
    Object? panOffset = null,
  }) {
    return _then(_$NotebookErasingImpl(
      notebook: null == notebook
          ? _value.notebook
          : notebook // ignore: cast_nullable_to_non_nullable
              as Notebook,
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

class _$NotebookErasingImpl extends NotebookErasing {
  const _$NotebookErasingImpl(
      {required this.notebook,
      this.allowedPointersMode = ScribblePointerMode.all,
      final List<int> activePointerIds = const [],
      this.pointerPosition,
      this.selectedWidth = 5,
      this.scaleFactor = 1,
      this.simplificationTolerance = 0,
      this.zoomLevel = 1,
      this.panOffset = Offset.zero})
      : _activePointerIds = activePointerIds,
        super._();

  /// The current notebook with multiple pages
  @override
  final Notebook notebook;

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
    return 'NotebookState.erasing(notebook: $notebook, allowedPointersMode: $allowedPointersMode, activePointerIds: $activePointerIds, pointerPosition: $pointerPosition, selectedWidth: $selectedWidth, scaleFactor: $scaleFactor, simplificationTolerance: $simplificationTolerance, zoomLevel: $zoomLevel, panOffset: $panOffset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotebookErasingImpl &&
            (identical(other.notebook, notebook) ||
                other.notebook == notebook) &&
            (identical(other.allowedPointersMode, allowedPointersMode) ||
                other.allowedPointersMode == allowedPointersMode) &&
            const DeepCollectionEquality()
                .equals(other._activePointerIds, _activePointerIds) &&
            (identical(other.pointerPosition, pointerPosition) ||
                other.pointerPosition == pointerPosition) &&
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
      notebook,
      allowedPointersMode,
      const DeepCollectionEquality().hash(_activePointerIds),
      pointerPosition,
      selectedWidth,
      scaleFactor,
      simplificationTolerance,
      zoomLevel,
      panOffset);

  /// Create a copy of NotebookState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotebookErasingImplCopyWith<_$NotebookErasingImpl> get copyWith =>
      __$$NotebookErasingImplCopyWithImpl<_$NotebookErasingImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            Notebook notebook,
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
            Notebook notebook,
            ScribblePointerMode allowedPointersMode,
            List<int> activePointerIds,
            Point? pointerPosition,
            double selectedWidth,
            double scaleFactor,
            double simplificationTolerance,
            double zoomLevel,
            Offset panOffset)
        erasing,
  }) {
    return erasing(
        notebook,
        allowedPointersMode,
        activePointerIds,
        pointerPosition,
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
            Notebook notebook,
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
            Notebook notebook,
            ScribblePointerMode allowedPointersMode,
            List<int> activePointerIds,
            Point? pointerPosition,
            double selectedWidth,
            double scaleFactor,
            double simplificationTolerance,
            double zoomLevel,
            Offset panOffset)?
        erasing,
  }) {
    return erasing?.call(
        notebook,
        allowedPointersMode,
        activePointerIds,
        pointerPosition,
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
            Notebook notebook,
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
            Notebook notebook,
            ScribblePointerMode allowedPointersMode,
            List<int> activePointerIds,
            Point? pointerPosition,
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
          notebook,
          allowedPointersMode,
          activePointerIds,
          pointerPosition,
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
    required TResult Function(NotebookDrawing value) drawing,
    required TResult Function(NotebookErasing value) erasing,
  }) {
    return erasing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NotebookDrawing value)? drawing,
    TResult? Function(NotebookErasing value)? erasing,
  }) {
    return erasing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NotebookDrawing value)? drawing,
    TResult Function(NotebookErasing value)? erasing,
    required TResult orElse(),
  }) {
    if (erasing != null) {
      return erasing(this);
    }
    return orElse();
  }
}

abstract class NotebookErasing extends NotebookState {
  const factory NotebookErasing(
      {required final Notebook notebook,
      final ScribblePointerMode allowedPointersMode,
      final List<int> activePointerIds,
      final Point? pointerPosition,
      final double selectedWidth,
      final double scaleFactor,
      final double simplificationTolerance,
      final double zoomLevel,
      final Offset panOffset}) = _$NotebookErasingImpl;
  const NotebookErasing._() : super._();

  /// The current notebook with multiple pages
  @override
  Notebook get notebook;

  /// Which pointers are allowed for drawing and will be captured
  @override
  ScribblePointerMode get allowedPointersMode;

  /// The ids of all supported pointers that are currently interacting
  @override
  List<int> get activePointerIds;

  /// The current position of the pointer
  @override
  Point? get pointerPosition;

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

  /// Create a copy of NotebookState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotebookErasingImplCopyWith<_$NotebookErasingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
