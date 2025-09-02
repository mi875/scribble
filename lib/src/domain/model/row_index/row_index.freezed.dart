// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'row_index.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RowIndex {
  /// The index value.
  int get value;

  /// The type of index this represents.
  RowIndexType get type;

  /// Create a copy of RowIndex
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RowIndexCopyWith<RowIndex> get copyWith =>
      _$RowIndexCopyWithImpl<RowIndex>(this as RowIndex, _$identity);

  /// Serializes this RowIndex to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RowIndex &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, value, type);
}

/// @nodoc
abstract mixin class $RowIndexCopyWith<$Res> {
  factory $RowIndexCopyWith(RowIndex value, $Res Function(RowIndex) _then) =
      _$RowIndexCopyWithImpl;
  @useResult
  $Res call({int value, RowIndexType type});
}

/// @nodoc
class _$RowIndexCopyWithImpl<$Res> implements $RowIndexCopyWith<$Res> {
  _$RowIndexCopyWithImpl(this._self, this._then);

  final RowIndex _self;
  final $Res Function(RowIndex) _then;

  /// Create a copy of RowIndex
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
    Object? type = null,
  }) {
    return _then(_self.copyWith(
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as RowIndexType,
    ));
  }
}

/// Adds pattern-matching-related methods to [RowIndex].
extension RowIndexPatterns on RowIndex {
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
    TResult Function(_RowIndex value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RowIndex() when $default != null:
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
    TResult Function(_RowIndex value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RowIndex():
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
    TResult? Function(_RowIndex value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RowIndex() when $default != null:
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
    TResult Function(int value, RowIndexType type)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RowIndex() when $default != null:
        return $default(_that.value, _that.type);
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
    TResult Function(int value, RowIndexType type) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RowIndex():
        return $default(_that.value, _that.type);
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
    TResult? Function(int value, RowIndexType type)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RowIndex() when $default != null:
        return $default(_that.value, _that.type);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RowIndex extends RowIndex {
  const _RowIndex({required this.value, required this.type}) : super._();
  factory _RowIndex.fromJson(Map<String, dynamic> json) =>
      _$RowIndexFromJson(json);

  /// The index value.
  @override
  final int value;

  /// The type of index this represents.
  @override
  final RowIndexType type;

  /// Create a copy of RowIndex
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RowIndexCopyWith<_RowIndex> get copyWith =>
      __$RowIndexCopyWithImpl<_RowIndex>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RowIndexToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RowIndex &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, value, type);
}

/// @nodoc
abstract mixin class _$RowIndexCopyWith<$Res>
    implements $RowIndexCopyWith<$Res> {
  factory _$RowIndexCopyWith(_RowIndex value, $Res Function(_RowIndex) _then) =
      __$RowIndexCopyWithImpl;
  @override
  @useResult
  $Res call({int value, RowIndexType type});
}

/// @nodoc
class __$RowIndexCopyWithImpl<$Res> implements _$RowIndexCopyWith<$Res> {
  __$RowIndexCopyWithImpl(this._self, this._then);

  final _RowIndex _self;
  final $Res Function(_RowIndex) _then;

  /// Create a copy of RowIndex
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? value = null,
    Object? type = null,
  }) {
    return _then(_RowIndex(
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as RowIndexType,
    ));
  }
}

// dart format on
