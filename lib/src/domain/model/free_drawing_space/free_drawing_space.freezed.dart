// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'free_drawing_space.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FreeDrawingSpace {
  /// The Y coordinate where the free drawing space starts.
  double get startY;

  /// The height of the free drawing space region.
  double get height;

  /// Optional identifier for the free drawing space.
  String? get id;

  /// Create a copy of FreeDrawingSpace
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FreeDrawingSpaceCopyWith<FreeDrawingSpace> get copyWith =>
      _$FreeDrawingSpaceCopyWithImpl<FreeDrawingSpace>(
          this as FreeDrawingSpace, _$identity);

  /// Serializes this FreeDrawingSpace to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FreeDrawingSpace &&
            (identical(other.startY, startY) || other.startY == startY) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, startY, height, id);

  @override
  String toString() {
    return 'FreeDrawingSpace(startY: $startY, height: $height, id: $id)';
  }
}

/// @nodoc
abstract mixin class $FreeDrawingSpaceCopyWith<$Res> {
  factory $FreeDrawingSpaceCopyWith(
          FreeDrawingSpace value, $Res Function(FreeDrawingSpace) _then) =
      _$FreeDrawingSpaceCopyWithImpl;
  @useResult
  $Res call({double startY, double height, String? id});
}

/// @nodoc
class _$FreeDrawingSpaceCopyWithImpl<$Res>
    implements $FreeDrawingSpaceCopyWith<$Res> {
  _$FreeDrawingSpaceCopyWithImpl(this._self, this._then);

  final FreeDrawingSpace _self;
  final $Res Function(FreeDrawingSpace) _then;

  /// Create a copy of FreeDrawingSpace
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startY = null,
    Object? height = null,
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
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [FreeDrawingSpace].
extension FreeDrawingSpacePatterns on FreeDrawingSpace {
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
    TResult Function(_FreeDrawingSpace value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FreeDrawingSpace() when $default != null:
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
    TResult Function(_FreeDrawingSpace value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FreeDrawingSpace():
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
    TResult? Function(_FreeDrawingSpace value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FreeDrawingSpace() when $default != null:
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
    TResult Function(double startY, double height, String? id)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FreeDrawingSpace() when $default != null:
        return $default(_that.startY, _that.height, _that.id);
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
    TResult Function(double startY, double height, String? id) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FreeDrawingSpace():
        return $default(_that.startY, _that.height, _that.id);
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
    TResult? Function(double startY, double height, String? id)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FreeDrawingSpace() when $default != null:
        return $default(_that.startY, _that.height, _that.id);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _FreeDrawingSpace extends FreeDrawingSpace {
  const _FreeDrawingSpace({required this.startY, required this.height, this.id})
      : super._();
  factory _FreeDrawingSpace.fromJson(Map<String, dynamic> json) =>
      _$FreeDrawingSpaceFromJson(json);

  /// The Y coordinate where the free drawing space starts.
  @override
  final double startY;

  /// The height of the free drawing space region.
  @override
  final double height;

  /// Optional identifier for the free drawing space.
  @override
  final String? id;

  /// Create a copy of FreeDrawingSpace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FreeDrawingSpaceCopyWith<_FreeDrawingSpace> get copyWith =>
      __$FreeDrawingSpaceCopyWithImpl<_FreeDrawingSpace>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FreeDrawingSpaceToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FreeDrawingSpace &&
            (identical(other.startY, startY) || other.startY == startY) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, startY, height, id);

  @override
  String toString() {
    return 'FreeDrawingSpace(startY: $startY, height: $height, id: $id)';
  }
}

/// @nodoc
abstract mixin class _$FreeDrawingSpaceCopyWith<$Res>
    implements $FreeDrawingSpaceCopyWith<$Res> {
  factory _$FreeDrawingSpaceCopyWith(
          _FreeDrawingSpace value, $Res Function(_FreeDrawingSpace) _then) =
      __$FreeDrawingSpaceCopyWithImpl;
  @override
  @useResult
  $Res call({double startY, double height, String? id});
}

/// @nodoc
class __$FreeDrawingSpaceCopyWithImpl<$Res>
    implements _$FreeDrawingSpaceCopyWith<$Res> {
  __$FreeDrawingSpaceCopyWithImpl(this._self, this._then);

  final _FreeDrawingSpace _self;
  final $Res Function(_FreeDrawingSpace) _then;

  /// Create a copy of FreeDrawingSpace
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? startY = null,
    Object? height = null,
    Object? id = freezed,
  }) {
    return _then(_FreeDrawingSpace(
      startY: null == startY
          ? _self.startY
          : startY // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _self.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
