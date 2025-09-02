// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'row.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotebookRow {
  /// The Y coordinate where the row line is positioned.
  double get startY;

  /// The renderer index - physical array position (0-based) for canvas operations.
  /// This maps directly to the position in the _rows array.
  int get rendererIndex;

  /// The normal index - user-visible line number (1-based).
  /// This is null for rows that contain image rows or free drawing spaces,
  /// since they don't have user-visible line numbers.
  int? get normalIndex;

  /// The height/spacing of this row (distance to next row).
  /// Defaults to the standard row line spacing.
  double get height;

  /// Optional identifier for the row.
  String? get id;

  /// Create a copy of NotebookRow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotebookRowCopyWith<NotebookRow> get copyWith =>
      _$NotebookRowCopyWithImpl<NotebookRow>(this as NotebookRow, _$identity);

  /// Serializes this NotebookRow to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotebookRow &&
            (identical(other.startY, startY) || other.startY == startY) &&
            (identical(other.rendererIndex, rendererIndex) ||
                other.rendererIndex == rendererIndex) &&
            (identical(other.normalIndex, normalIndex) ||
                other.normalIndex == normalIndex) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, startY, rendererIndex, normalIndex, height, id);
}

/// @nodoc
abstract mixin class $NotebookRowCopyWith<$Res> {
  factory $NotebookRowCopyWith(
          NotebookRow value, $Res Function(NotebookRow) _then) =
      _$NotebookRowCopyWithImpl;
  @useResult
  $Res call(
      {double startY,
      int rendererIndex,
      int? normalIndex,
      double height,
      String? id});
}

/// @nodoc
class _$NotebookRowCopyWithImpl<$Res> implements $NotebookRowCopyWith<$Res> {
  _$NotebookRowCopyWithImpl(this._self, this._then);

  final NotebookRow _self;
  final $Res Function(NotebookRow) _then;

  /// Create a copy of NotebookRow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startY = null,
    Object? rendererIndex = null,
    Object? normalIndex = freezed,
    Object? height = null,
    Object? id = freezed,
  }) {
    return _then(_self.copyWith(
      startY: null == startY
          ? _self.startY
          : startY // ignore: cast_nullable_to_non_nullable
              as double,
      rendererIndex: null == rendererIndex
          ? _self.rendererIndex
          : rendererIndex // ignore: cast_nullable_to_non_nullable
              as int,
      normalIndex: freezed == normalIndex
          ? _self.normalIndex
          : normalIndex // ignore: cast_nullable_to_non_nullable
              as int?,
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

/// Adds pattern-matching-related methods to [NotebookRow].
extension NotebookRowPatterns on NotebookRow {
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
    TResult Function(_NotebookRow value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotebookRow() when $default != null:
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
    TResult Function(_NotebookRow value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotebookRow():
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
    TResult? Function(_NotebookRow value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotebookRow() when $default != null:
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
    TResult Function(double startY, int rendererIndex, int? normalIndex,
            double height, String? id)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotebookRow() when $default != null:
        return $default(_that.startY, _that.rendererIndex, _that.normalIndex,
            _that.height, _that.id);
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
    TResult Function(double startY, int rendererIndex, int? normalIndex,
            double height, String? id)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotebookRow():
        return $default(_that.startY, _that.rendererIndex, _that.normalIndex,
            _that.height, _that.id);
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
    TResult? Function(double startY, int rendererIndex, int? normalIndex,
            double height, String? id)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotebookRow() when $default != null:
        return $default(_that.startY, _that.rendererIndex, _that.normalIndex,
            _that.height, _that.id);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _NotebookRow extends NotebookRow {
  const _NotebookRow(
      {required this.startY,
      required this.rendererIndex,
      this.normalIndex,
      this.height = 24.0,
      this.id})
      : super._();
  factory _NotebookRow.fromJson(Map<String, dynamic> json) =>
      _$NotebookRowFromJson(json);

  /// The Y coordinate where the row line is positioned.
  @override
  final double startY;

  /// The renderer index - physical array position (0-based) for canvas operations.
  /// This maps directly to the position in the _rows array.
  @override
  final int rendererIndex;

  /// The normal index - user-visible line number (1-based).
  /// This is null for rows that contain image rows or free drawing spaces,
  /// since they don't have user-visible line numbers.
  @override
  final int? normalIndex;

  /// The height/spacing of this row (distance to next row).
  /// Defaults to the standard row line spacing.
  @override
  @JsonKey()
  final double height;

  /// Optional identifier for the row.
  @override
  final String? id;

  /// Create a copy of NotebookRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NotebookRowCopyWith<_NotebookRow> get copyWith =>
      __$NotebookRowCopyWithImpl<_NotebookRow>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NotebookRowToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NotebookRow &&
            (identical(other.startY, startY) || other.startY == startY) &&
            (identical(other.rendererIndex, rendererIndex) ||
                other.rendererIndex == rendererIndex) &&
            (identical(other.normalIndex, normalIndex) ||
                other.normalIndex == normalIndex) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, startY, rendererIndex, normalIndex, height, id);
}

/// @nodoc
abstract mixin class _$NotebookRowCopyWith<$Res>
    implements $NotebookRowCopyWith<$Res> {
  factory _$NotebookRowCopyWith(
          _NotebookRow value, $Res Function(_NotebookRow) _then) =
      __$NotebookRowCopyWithImpl;
  @override
  @useResult
  $Res call(
      {double startY,
      int rendererIndex,
      int? normalIndex,
      double height,
      String? id});
}

/// @nodoc
class __$NotebookRowCopyWithImpl<$Res> implements _$NotebookRowCopyWith<$Res> {
  __$NotebookRowCopyWithImpl(this._self, this._then);

  final _NotebookRow _self;
  final $Res Function(_NotebookRow) _then;

  /// Create a copy of NotebookRow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? startY = null,
    Object? rendererIndex = null,
    Object? normalIndex = freezed,
    Object? height = null,
    Object? id = freezed,
  }) {
    return _then(_NotebookRow(
      startY: null == startY
          ? _self.startY
          : startY // ignore: cast_nullable_to_non_nullable
              as double,
      rendererIndex: null == rendererIndex
          ? _self.rendererIndex
          : rendererIndex // ignore: cast_nullable_to_non_nullable
              as int,
      normalIndex: freezed == normalIndex
          ? _self.normalIndex
          : normalIndex // ignore: cast_nullable_to_non_nullable
              as int?,
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
