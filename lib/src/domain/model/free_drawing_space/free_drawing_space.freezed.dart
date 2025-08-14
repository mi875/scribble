// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'free_drawing_space.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FreeDrawingSpace _$FreeDrawingSpaceFromJson(Map<String, dynamic> json) {
  return _FreeDrawingSpace.fromJson(json);
}

/// @nodoc
mixin _$FreeDrawingSpace {
  /// The Y coordinate where the free drawing space starts.
  double get startY => throw _privateConstructorUsedError;

  /// The height of the free drawing space region.
  double get height => throw _privateConstructorUsedError;

  /// Optional identifier for the free drawing space.
  String? get id => throw _privateConstructorUsedError;

  /// Serializes this FreeDrawingSpace to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FreeDrawingSpace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FreeDrawingSpaceCopyWith<FreeDrawingSpace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FreeDrawingSpaceCopyWith<$Res> {
  factory $FreeDrawingSpaceCopyWith(
          FreeDrawingSpace value, $Res Function(FreeDrawingSpace) then) =
      _$FreeDrawingSpaceCopyWithImpl<$Res, FreeDrawingSpace>;
  @useResult
  $Res call({double startY, double height, String? id});
}

/// @nodoc
class _$FreeDrawingSpaceCopyWithImpl<$Res, $Val extends FreeDrawingSpace>
    implements $FreeDrawingSpaceCopyWith<$Res> {
  _$FreeDrawingSpaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FreeDrawingSpace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startY = null,
    Object? height = null,
    Object? id = freezed,
  }) {
    return _then(_value.copyWith(
      startY: null == startY
          ? _value.startY
          : startY // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FreeDrawingSpaceImplCopyWith<$Res>
    implements $FreeDrawingSpaceCopyWith<$Res> {
  factory _$$FreeDrawingSpaceImplCopyWith(_$FreeDrawingSpaceImpl value,
          $Res Function(_$FreeDrawingSpaceImpl) then) =
      __$$FreeDrawingSpaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double startY, double height, String? id});
}

/// @nodoc
class __$$FreeDrawingSpaceImplCopyWithImpl<$Res>
    extends _$FreeDrawingSpaceCopyWithImpl<$Res, _$FreeDrawingSpaceImpl>
    implements _$$FreeDrawingSpaceImplCopyWith<$Res> {
  __$$FreeDrawingSpaceImplCopyWithImpl(_$FreeDrawingSpaceImpl _value,
      $Res Function(_$FreeDrawingSpaceImpl) _then)
      : super(_value, _then);

  /// Create a copy of FreeDrawingSpace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startY = null,
    Object? height = null,
    Object? id = freezed,
  }) {
    return _then(_$FreeDrawingSpaceImpl(
      startY: null == startY
          ? _value.startY
          : startY // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FreeDrawingSpaceImpl extends _FreeDrawingSpace {
  const _$FreeDrawingSpaceImpl(
      {required this.startY, required this.height, this.id})
      : super._();

  factory _$FreeDrawingSpaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$FreeDrawingSpaceImplFromJson(json);

  /// The Y coordinate where the free drawing space starts.
  @override
  final double startY;

  /// The height of the free drawing space region.
  @override
  final double height;

  /// Optional identifier for the free drawing space.
  @override
  final String? id;

  @override
  String toString() {
    return 'FreeDrawingSpace(startY: $startY, height: $height, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FreeDrawingSpaceImpl &&
            (identical(other.startY, startY) || other.startY == startY) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, startY, height, id);

  /// Create a copy of FreeDrawingSpace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FreeDrawingSpaceImplCopyWith<_$FreeDrawingSpaceImpl> get copyWith =>
      __$$FreeDrawingSpaceImplCopyWithImpl<_$FreeDrawingSpaceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FreeDrawingSpaceImplToJson(
      this,
    );
  }
}

abstract class _FreeDrawingSpace extends FreeDrawingSpace {
  const factory _FreeDrawingSpace(
      {required final double startY,
      required final double height,
      final String? id}) = _$FreeDrawingSpaceImpl;
  const _FreeDrawingSpace._() : super._();

  factory _FreeDrawingSpace.fromJson(Map<String, dynamic> json) =
      _$FreeDrawingSpaceImpl.fromJson;

  /// The Y coordinate where the free drawing space starts.
  @override
  double get startY;

  /// The height of the free drawing space region.
  @override
  double get height;

  /// Optional identifier for the free drawing space.
  @override
  String? get id;

  /// Create a copy of FreeDrawingSpace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FreeDrawingSpaceImplCopyWith<_$FreeDrawingSpaceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
