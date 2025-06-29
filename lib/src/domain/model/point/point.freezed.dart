// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Point {
  double get x;
  double get y;
  double get pressure;

  /// Create a copy of Point
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PointCopyWith<Point> get copyWith =>
      _$PointCopyWithImpl<Point>(this as Point, _$identity);

  /// Serializes this Point to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Point &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.pressure, pressure) ||
                other.pressure == pressure));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, x, y, pressure);

  @override
  String toString() {
    return 'Point(x: $x, y: $y, pressure: $pressure)';
  }
}

/// @nodoc
abstract mixin class $PointCopyWith<$Res> {
  factory $PointCopyWith(Point value, $Res Function(Point) _then) =
      _$PointCopyWithImpl;
  @useResult
  $Res call({double x, double y, double pressure});
}

/// @nodoc
class _$PointCopyWithImpl<$Res> implements $PointCopyWith<$Res> {
  _$PointCopyWithImpl(this._self, this._then);

  final Point _self;
  final $Res Function(Point) _then;

  /// Create a copy of Point
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
    Object? pressure = null,
  }) {
    return _then(_self.copyWith(
      x: null == x
          ? _self.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _self.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      pressure: null == pressure
          ? _self.pressure
          : pressure // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Point extends Point {
  const _Point(this.x, this.y, {this.pressure = 0.5}) : super._();
  factory _Point.fromJson(Map<String, dynamic> json) => _$PointFromJson(json);

  @override
  final double x;
  @override
  final double y;
  @override
  @JsonKey()
  final double pressure;

  /// Create a copy of Point
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PointCopyWith<_Point> get copyWith =>
      __$PointCopyWithImpl<_Point>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PointToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Point &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.pressure, pressure) ||
                other.pressure == pressure));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, x, y, pressure);

  @override
  String toString() {
    return 'Point(x: $x, y: $y, pressure: $pressure)';
  }
}

/// @nodoc
abstract mixin class _$PointCopyWith<$Res> implements $PointCopyWith<$Res> {
  factory _$PointCopyWith(_Point value, $Res Function(_Point) _then) =
      __$PointCopyWithImpl;
  @override
  @useResult
  $Res call({double x, double y, double pressure});
}

/// @nodoc
class __$PointCopyWithImpl<$Res> implements _$PointCopyWith<$Res> {
  __$PointCopyWithImpl(this._self, this._then);

  final _Point _self;
  final $Res Function(_Point) _then;

  /// Create a copy of Point
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? x = null,
    Object? y = null,
    Object? pressure = null,
  }) {
    return _then(_Point(
      null == x
          ? _self.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      null == y
          ? _self.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      pressure: null == pressure
          ? _self.pressure
          : pressure // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
