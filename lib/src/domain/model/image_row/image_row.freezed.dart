// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_row.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ImageRow _$ImageRowFromJson(Map<String, dynamic> json) {
  return _ImageRow.fromJson(json);
}

/// @nodoc
mixin _$ImageRow {
  /// The Y coordinate where the image row starts.
  double get startY => throw _privateConstructorUsedError;

  /// The height of the image row region.
  double get height => throw _privateConstructorUsedError;

  /// The image data as bytes (for JSON serialization).
  @Uint8ListConverter()
  Uint8List? get imageBytes => throw _privateConstructorUsedError;

  /// Optional identifier for the image row.
  String? get id => throw _privateConstructorUsedError;

  /// Serializes this ImageRow to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ImageRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImageRowCopyWith<ImageRow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageRowCopyWith<$Res> {
  factory $ImageRowCopyWith(ImageRow value, $Res Function(ImageRow) then) =
      _$ImageRowCopyWithImpl<$Res, ImageRow>;
  @useResult
  $Res call(
      {double startY,
      double height,
      @Uint8ListConverter() Uint8List? imageBytes,
      String? id});
}

/// @nodoc
class _$ImageRowCopyWithImpl<$Res, $Val extends ImageRow>
    implements $ImageRowCopyWith<$Res> {
  _$ImageRowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImageRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startY = null,
    Object? height = null,
    Object? imageBytes = freezed,
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
      imageBytes: freezed == imageBytes
          ? _value.imageBytes
          : imageBytes // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ImageRowImplCopyWith<$Res>
    implements $ImageRowCopyWith<$Res> {
  factory _$$ImageRowImplCopyWith(
          _$ImageRowImpl value, $Res Function(_$ImageRowImpl) then) =
      __$$ImageRowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double startY,
      double height,
      @Uint8ListConverter() Uint8List? imageBytes,
      String? id});
}

/// @nodoc
class __$$ImageRowImplCopyWithImpl<$Res>
    extends _$ImageRowCopyWithImpl<$Res, _$ImageRowImpl>
    implements _$$ImageRowImplCopyWith<$Res> {
  __$$ImageRowImplCopyWithImpl(
      _$ImageRowImpl _value, $Res Function(_$ImageRowImpl) _then)
      : super(_value, _then);

  /// Create a copy of ImageRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startY = null,
    Object? height = null,
    Object? imageBytes = freezed,
    Object? id = freezed,
  }) {
    return _then(_$ImageRowImpl(
      startY: null == startY
          ? _value.startY
          : startY // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      imageBytes: freezed == imageBytes
          ? _value.imageBytes
          : imageBytes // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ImageRowImpl extends _ImageRow {
  const _$ImageRowImpl(
      {required this.startY,
      required this.height,
      @Uint8ListConverter() this.imageBytes,
      this.id})
      : super._();

  factory _$ImageRowImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImageRowImplFromJson(json);

  /// The Y coordinate where the image row starts.
  @override
  final double startY;

  /// The height of the image row region.
  @override
  final double height;

  /// The image data as bytes (for JSON serialization).
  @override
  @Uint8ListConverter()
  final Uint8List? imageBytes;

  /// Optional identifier for the image row.
  @override
  final String? id;

  @override
  String toString() {
    return 'ImageRow(startY: $startY, height: $height, imageBytes: $imageBytes, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageRowImpl &&
            (identical(other.startY, startY) || other.startY == startY) &&
            (identical(other.height, height) || other.height == height) &&
            const DeepCollectionEquality()
                .equals(other.imageBytes, imageBytes) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, startY, height,
      const DeepCollectionEquality().hash(imageBytes), id);

  /// Create a copy of ImageRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageRowImplCopyWith<_$ImageRowImpl> get copyWith =>
      __$$ImageRowImplCopyWithImpl<_$ImageRowImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImageRowImplToJson(
      this,
    );
  }
}

abstract class _ImageRow extends ImageRow {
  const factory _ImageRow(
      {required final double startY,
      required final double height,
      @Uint8ListConverter() final Uint8List? imageBytes,
      final String? id}) = _$ImageRowImpl;
  const _ImageRow._() : super._();

  factory _ImageRow.fromJson(Map<String, dynamic> json) =
      _$ImageRowImpl.fromJson;

  /// The Y coordinate where the image row starts.
  @override
  double get startY;

  /// The height of the image row region.
  @override
  double get height;

  /// The image data as bytes (for JSON serialization).
  @override
  @Uint8ListConverter()
  Uint8List? get imageBytes;

  /// Optional identifier for the image row.
  @override
  String? get id;

  /// Create a copy of ImageRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImageRowImplCopyWith<_$ImageRowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
