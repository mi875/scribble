// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'row_range_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RowRangeContent {
  /// The starting Y coordinate of the row range.
  double get startY;

  /// The ending Y coordinate of the row range.
  double get endY;

  /// Sketch lines within the row range.
  List<SketchLine> get sketchLines;

  /// Free drawing spaces within the row range.
  List<FreeDrawingSpace> get freeDrawingSpaces;

  /// Image rows within the row range.
  List<ImageRow> get imageRows;

  /// Create a copy of RowRangeContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RowRangeContentCopyWith<RowRangeContent> get copyWith =>
      _$RowRangeContentCopyWithImpl<RowRangeContent>(
          this as RowRangeContent, _$identity);

  /// Serializes this RowRangeContent to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RowRangeContent &&
            (identical(other.startY, startY) || other.startY == startY) &&
            (identical(other.endY, endY) || other.endY == endY) &&
            const DeepCollectionEquality()
                .equals(other.sketchLines, sketchLines) &&
            const DeepCollectionEquality()
                .equals(other.freeDrawingSpaces, freeDrawingSpaces) &&
            const DeepCollectionEquality().equals(other.imageRows, imageRows));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      startY,
      endY,
      const DeepCollectionEquality().hash(sketchLines),
      const DeepCollectionEquality().hash(freeDrawingSpaces),
      const DeepCollectionEquality().hash(imageRows));

  @override
  String toString() {
    return 'RowRangeContent(startY: $startY, endY: $endY, sketchLines: $sketchLines, freeDrawingSpaces: $freeDrawingSpaces, imageRows: $imageRows)';
  }
}

/// @nodoc
abstract mixin class $RowRangeContentCopyWith<$Res> {
  factory $RowRangeContentCopyWith(
          RowRangeContent value, $Res Function(RowRangeContent) _then) =
      _$RowRangeContentCopyWithImpl;
  @useResult
  $Res call(
      {double startY,
      double endY,
      List<SketchLine> sketchLines,
      List<FreeDrawingSpace> freeDrawingSpaces,
      List<ImageRow> imageRows});
}

/// @nodoc
class _$RowRangeContentCopyWithImpl<$Res>
    implements $RowRangeContentCopyWith<$Res> {
  _$RowRangeContentCopyWithImpl(this._self, this._then);

  final RowRangeContent _self;
  final $Res Function(RowRangeContent) _then;

  /// Create a copy of RowRangeContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startY = null,
    Object? endY = null,
    Object? sketchLines = null,
    Object? freeDrawingSpaces = null,
    Object? imageRows = null,
  }) {
    return _then(_self.copyWith(
      startY: null == startY
          ? _self.startY
          : startY // ignore: cast_nullable_to_non_nullable
              as double,
      endY: null == endY
          ? _self.endY
          : endY // ignore: cast_nullable_to_non_nullable
              as double,
      sketchLines: null == sketchLines
          ? _self.sketchLines
          : sketchLines // ignore: cast_nullable_to_non_nullable
              as List<SketchLine>,
      freeDrawingSpaces: null == freeDrawingSpaces
          ? _self.freeDrawingSpaces
          : freeDrawingSpaces // ignore: cast_nullable_to_non_nullable
              as List<FreeDrawingSpace>,
      imageRows: null == imageRows
          ? _self.imageRows
          : imageRows // ignore: cast_nullable_to_non_nullable
              as List<ImageRow>,
    ));
  }
}

/// Adds pattern-matching-related methods to [RowRangeContent].
extension RowRangeContentPatterns on RowRangeContent {
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
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_RowRangeContent value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RowRangeContent() when $default != null:
        return $default(_that);
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
  TResult map<TResult extends Object?>(
    TResult Function(_RowRangeContent value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RowRangeContent():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
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
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_RowRangeContent value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RowRangeContent() when $default != null:
        return $default(_that);
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
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(double startY, double endY, List<SketchLine> sketchLines,
            List<FreeDrawingSpace> freeDrawingSpaces, List<ImageRow> imageRows)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RowRangeContent() when $default != null:
        return $default(_that.startY, _that.endY, _that.sketchLines,
            _that.freeDrawingSpaces, _that.imageRows);
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
  TResult when<TResult extends Object?>(
    TResult Function(double startY, double endY, List<SketchLine> sketchLines,
            List<FreeDrawingSpace> freeDrawingSpaces, List<ImageRow> imageRows)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RowRangeContent():
        return $default(_that.startY, _that.endY, _that.sketchLines,
            _that.freeDrawingSpaces, _that.imageRows);
      case _:
        throw StateError('Unexpected subclass');
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
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(double startY, double endY, List<SketchLine> sketchLines,
            List<FreeDrawingSpace> freeDrawingSpaces, List<ImageRow> imageRows)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RowRangeContent() when $default != null:
        return $default(_that.startY, _that.endY, _that.sketchLines,
            _that.freeDrawingSpaces, _that.imageRows);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RowRangeContent implements RowRangeContent {
  const _RowRangeContent(
      {required this.startY,
      required this.endY,
      required final List<SketchLine> sketchLines,
      required final List<FreeDrawingSpace> freeDrawingSpaces,
      required final List<ImageRow> imageRows})
      : _sketchLines = sketchLines,
        _freeDrawingSpaces = freeDrawingSpaces,
        _imageRows = imageRows;
  factory _RowRangeContent.fromJson(Map<String, dynamic> json) =>
      _$RowRangeContentFromJson(json);

  /// The starting Y coordinate of the row range.
  @override
  final double startY;

  /// The ending Y coordinate of the row range.
  @override
  final double endY;

  /// Sketch lines within the row range.
  final List<SketchLine> _sketchLines;

  /// Sketch lines within the row range.
  @override
  List<SketchLine> get sketchLines {
    if (_sketchLines is EqualUnmodifiableListView) return _sketchLines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sketchLines);
  }

  /// Free drawing spaces within the row range.
  final List<FreeDrawingSpace> _freeDrawingSpaces;

  /// Free drawing spaces within the row range.
  @override
  List<FreeDrawingSpace> get freeDrawingSpaces {
    if (_freeDrawingSpaces is EqualUnmodifiableListView)
      return _freeDrawingSpaces;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_freeDrawingSpaces);
  }

  /// Image rows within the row range.
  final List<ImageRow> _imageRows;

  /// Image rows within the row range.
  @override
  List<ImageRow> get imageRows {
    if (_imageRows is EqualUnmodifiableListView) return _imageRows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageRows);
  }

  /// Create a copy of RowRangeContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RowRangeContentCopyWith<_RowRangeContent> get copyWith =>
      __$RowRangeContentCopyWithImpl<_RowRangeContent>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RowRangeContentToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RowRangeContent &&
            (identical(other.startY, startY) || other.startY == startY) &&
            (identical(other.endY, endY) || other.endY == endY) &&
            const DeepCollectionEquality()
                .equals(other._sketchLines, _sketchLines) &&
            const DeepCollectionEquality()
                .equals(other._freeDrawingSpaces, _freeDrawingSpaces) &&
            const DeepCollectionEquality()
                .equals(other._imageRows, _imageRows));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      startY,
      endY,
      const DeepCollectionEquality().hash(_sketchLines),
      const DeepCollectionEquality().hash(_freeDrawingSpaces),
      const DeepCollectionEquality().hash(_imageRows));

  @override
  String toString() {
    return 'RowRangeContent(startY: $startY, endY: $endY, sketchLines: $sketchLines, freeDrawingSpaces: $freeDrawingSpaces, imageRows: $imageRows)';
  }
}

/// @nodoc
abstract mixin class _$RowRangeContentCopyWith<$Res>
    implements $RowRangeContentCopyWith<$Res> {
  factory _$RowRangeContentCopyWith(
          _RowRangeContent value, $Res Function(_RowRangeContent) _then) =
      __$RowRangeContentCopyWithImpl;
  @override
  @useResult
  $Res call(
      {double startY,
      double endY,
      List<SketchLine> sketchLines,
      List<FreeDrawingSpace> freeDrawingSpaces,
      List<ImageRow> imageRows});
}

/// @nodoc
class __$RowRangeContentCopyWithImpl<$Res>
    implements _$RowRangeContentCopyWith<$Res> {
  __$RowRangeContentCopyWithImpl(this._self, this._then);

  final _RowRangeContent _self;
  final $Res Function(_RowRangeContent) _then;

  /// Create a copy of RowRangeContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? startY = null,
    Object? endY = null,
    Object? sketchLines = null,
    Object? freeDrawingSpaces = null,
    Object? imageRows = null,
  }) {
    return _then(_RowRangeContent(
      startY: null == startY
          ? _self.startY
          : startY // ignore: cast_nullable_to_non_nullable
              as double,
      endY: null == endY
          ? _self.endY
          : endY // ignore: cast_nullable_to_non_nullable
              as double,
      sketchLines: null == sketchLines
          ? _self._sketchLines
          : sketchLines // ignore: cast_nullable_to_non_nullable
              as List<SketchLine>,
      freeDrawingSpaces: null == freeDrawingSpaces
          ? _self._freeDrawingSpaces
          : freeDrawingSpaces // ignore: cast_nullable_to_non_nullable
              as List<FreeDrawingSpace>,
      imageRows: null == imageRows
          ? _self._imageRows
          : imageRows // ignore: cast_nullable_to_non_nullable
              as List<ImageRow>,
    ));
  }
}

// dart format on
