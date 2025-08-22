// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_row.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImageRow {
  /// The Y coordinate where the image row starts.
  double get startY;

  /// The height of the image row region.
  double get height;

  /// The image data as bytes (excluded from JSON serialization).
  @JsonKey(includeFromJson: false, includeToJson: false)
  @Uint8ListConverter()
  Uint8List? get imageBytes;

  /// Optional identifier for the image row.
  String? get id;

  /// Create a copy of ImageRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ImageRowCopyWith<ImageRow> get copyWith =>
      _$ImageRowCopyWithImpl<ImageRow>(this as ImageRow, _$identity);

  /// Serializes this ImageRow to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ImageRow &&
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

  @override
  String toString() {
    return 'ImageRow(startY: $startY, height: $height, imageBytes: $imageBytes, id: $id)';
  }
}

/// @nodoc
abstract mixin class $ImageRowCopyWith<$Res> {
  factory $ImageRowCopyWith(ImageRow value, $Res Function(ImageRow) _then) =
      _$ImageRowCopyWithImpl;
  @useResult
  $Res call(
      {double startY,
      double height,
      @JsonKey(includeFromJson: false, includeToJson: false)
      @Uint8ListConverter()
      Uint8List? imageBytes,
      String? id});
}

/// @nodoc
class _$ImageRowCopyWithImpl<$Res> implements $ImageRowCopyWith<$Res> {
  _$ImageRowCopyWithImpl(this._self, this._then);

  final ImageRow _self;
  final $Res Function(ImageRow) _then;

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
    return _then(_self.copyWith(
      startY: null == startY
          ? _self.startY
          : startY // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      imageBytes: freezed == imageBytes
          ? _self.imageBytes
          : imageBytes // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ImageRow].
extension ImageRowPatterns on ImageRow {
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
    TResult Function(_ImageRow value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ImageRow() when $default != null:
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
    TResult Function(_ImageRow value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ImageRow():
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
    TResult? Function(_ImageRow value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ImageRow() when $default != null:
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
    TResult Function(
            double startY,
            double height,
            @JsonKey(includeFromJson: false, includeToJson: false)
            @Uint8ListConverter()
            Uint8List? imageBytes,
            String? id)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ImageRow() when $default != null:
        return $default(_that.startY, _that.height, _that.imageBytes, _that.id);
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
    TResult Function(
            double startY,
            double height,
            @JsonKey(includeFromJson: false, includeToJson: false)
            @Uint8ListConverter()
            Uint8List? imageBytes,
            String? id)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ImageRow():
        return $default(_that.startY, _that.height, _that.imageBytes, _that.id);
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
    TResult? Function(
            double startY,
            double height,
            @JsonKey(includeFromJson: false, includeToJson: false)
            @Uint8ListConverter()
            Uint8List? imageBytes,
            String? id)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ImageRow() when $default != null:
        return $default(_that.startY, _that.height, _that.imageBytes, _that.id);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ImageRow extends ImageRow {
  const _ImageRow(
      {required this.startY,
      required this.height,
      @JsonKey(includeFromJson: false, includeToJson: false)
      @Uint8ListConverter()
      this.imageBytes,
      this.id})
      : super._();
  factory _ImageRow.fromJson(Map<String, dynamic> json) =>
      _$ImageRowFromJson(json);

  /// The Y coordinate where the image row starts.
  @override
  final double startY;

  /// The height of the image row region.
  @override
  final double height;

  /// The image data as bytes (excluded from JSON serialization).
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @Uint8ListConverter()
  final Uint8List? imageBytes;

  /// Optional identifier for the image row.
  @override
  final String? id;

  /// Create a copy of ImageRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ImageRowCopyWith<_ImageRow> get copyWith =>
      __$ImageRowCopyWithImpl<_ImageRow>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ImageRowToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ImageRow &&
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

  @override
  String toString() {
    return 'ImageRow(startY: $startY, height: $height, imageBytes: $imageBytes, id: $id)';
  }
}

/// @nodoc
abstract mixin class _$ImageRowCopyWith<$Res>
    implements $ImageRowCopyWith<$Res> {
  factory _$ImageRowCopyWith(_ImageRow value, $Res Function(_ImageRow) _then) =
      __$ImageRowCopyWithImpl;
  @override
  @useResult
  $Res call(
      {double startY,
      double height,
      @JsonKey(includeFromJson: false, includeToJson: false)
      @Uint8ListConverter()
      Uint8List? imageBytes,
      String? id});
}

/// @nodoc
class __$ImageRowCopyWithImpl<$Res> implements _$ImageRowCopyWith<$Res> {
  __$ImageRowCopyWithImpl(this._self, this._then);

  final _ImageRow _self;
  final $Res Function(_ImageRow) _then;

  /// Create a copy of ImageRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? startY = null,
    Object? height = null,
    Object? imageBytes = freezed,
    Object? id = freezed,
  }) {
    return _then(_ImageRow(
      startY: null == startY
          ? _self.startY
          : startY // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      imageBytes: freezed == imageBytes
          ? _self.imageBytes
          : imageBytes // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
