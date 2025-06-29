// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sketch_line.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SketchLine {
  /// The points that make up the line
  List<Point> get points;

  /// The color of the line in hexadecimal format (ARGB)
  int get color;

  /// The width of the line
  double get width;

  /// A cached image of the rendered line
  @JsonKey(includeFromJson: false, includeToJson: false)
  ui.Image? get cachedImage;

  /// Create a copy of SketchLine
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SketchLineCopyWith<SketchLine> get copyWith =>
      _$SketchLineCopyWithImpl<SketchLine>(this as SketchLine, _$identity);

  /// Serializes this SketchLine to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SketchLine &&
            const DeepCollectionEquality().equals(other.points, points) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.cachedImage, cachedImage) ||
                other.cachedImage == cachedImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(points), color, width, cachedImage);

  @override
  String toString() {
    return 'SketchLine(points: $points, color: $color, width: $width, cachedImage: $cachedImage)';
  }
}

/// @nodoc
abstract mixin class $SketchLineCopyWith<$Res> {
  factory $SketchLineCopyWith(
          SketchLine value, $Res Function(SketchLine) _then) =
      _$SketchLineCopyWithImpl;
  @useResult
  $Res call(
      {List<Point> points,
      int color,
      double width,
      @JsonKey(includeFromJson: false, includeToJson: false)
      ui.Image? cachedImage});
}

/// @nodoc
class _$SketchLineCopyWithImpl<$Res> implements $SketchLineCopyWith<$Res> {
  _$SketchLineCopyWithImpl(this._self, this._then);

  final SketchLine _self;
  final $Res Function(SketchLine) _then;

  /// Create a copy of SketchLine
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? points = null,
    Object? color = null,
    Object? width = null,
    Object? cachedImage = freezed,
  }) {
    return _then(_self.copyWith(
      points: null == points
          ? _self.points
          : points // ignore: cast_nullable_to_non_nullable
              as List<Point>,
      color: null == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      cachedImage: freezed == cachedImage
          ? _self.cachedImage
          : cachedImage // ignore: cast_nullable_to_non_nullable
              as ui.Image?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _SketchLine implements SketchLine {
  const _SketchLine(
      {required final List<Point> points,
      required this.color,
      required this.width,
      @JsonKey(includeFromJson: false, includeToJson: false) this.cachedImage})
      : _points = points;
  factory _SketchLine.fromJson(Map<String, dynamic> json) =>
      _$SketchLineFromJson(json);

  /// The points that make up the line
  final List<Point> _points;

  /// The points that make up the line
  @override
  List<Point> get points {
    if (_points is EqualUnmodifiableListView) return _points;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_points);
  }

  /// The color of the line in hexadecimal format (ARGB)
  @override
  final int color;

  /// The width of the line
  @override
  final double width;

  /// A cached image of the rendered line
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final ui.Image? cachedImage;

  /// Create a copy of SketchLine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SketchLineCopyWith<_SketchLine> get copyWith =>
      __$SketchLineCopyWithImpl<_SketchLine>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SketchLineToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SketchLine &&
            const DeepCollectionEquality().equals(other._points, _points) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.cachedImage, cachedImage) ||
                other.cachedImage == cachedImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_points), color, width, cachedImage);

  @override
  String toString() {
    return 'SketchLine(points: $points, color: $color, width: $width, cachedImage: $cachedImage)';
  }
}

/// @nodoc
abstract mixin class _$SketchLineCopyWith<$Res>
    implements $SketchLineCopyWith<$Res> {
  factory _$SketchLineCopyWith(
          _SketchLine value, $Res Function(_SketchLine) _then) =
      __$SketchLineCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<Point> points,
      int color,
      double width,
      @JsonKey(includeFromJson: false, includeToJson: false)
      ui.Image? cachedImage});
}

/// @nodoc
class __$SketchLineCopyWithImpl<$Res> implements _$SketchLineCopyWith<$Res> {
  __$SketchLineCopyWithImpl(this._self, this._then);

  final _SketchLine _self;
  final $Res Function(_SketchLine) _then;

  /// Create a copy of SketchLine
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? points = null,
    Object? color = null,
    Object? width = null,
    Object? cachedImage = freezed,
  }) {
    return _then(_SketchLine(
      points: null == points
          ? _self._points
          : points // ignore: cast_nullable_to_non_nullable
              as List<Point>,
      color: null == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
      width: null == width
          ? _self.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      cachedImage: freezed == cachedImage
          ? _self.cachedImage
          : cachedImage // ignore: cast_nullable_to_non_nullable
              as ui.Image?,
    ));
  }
}

// dart format on
