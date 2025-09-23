// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'row_highlight.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RowHighlight {
  /// The 1-based line number to highlight (1, 2, 3, etc.).
  ///
  /// Line numbers correspond to what users see displayed on the UI.
  /// Free drawing spaces and image rows are skipped when counting line numbers.
  int get index;

  /// The color to use for highlighting this specific row.
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color get color;

  /// Create a copy of RowHighlight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RowHighlightCopyWith<RowHighlight> get copyWith =>
      _$RowHighlightCopyWithImpl<RowHighlight>(
          this as RowHighlight, _$identity);

  /// Serializes this RowHighlight to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RowHighlight &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, index, color);

  @override
  String toString() {
    return 'RowHighlight(index: $index, color: $color)';
  }
}

/// @nodoc
abstract mixin class $RowHighlightCopyWith<$Res> {
  factory $RowHighlightCopyWith(
          RowHighlight value, $Res Function(RowHighlight) _then) =
      _$RowHighlightCopyWithImpl;
  @useResult
  $Res call(
      {int index,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) Color color});
}

/// @nodoc
class _$RowHighlightCopyWithImpl<$Res> implements $RowHighlightCopyWith<$Res> {
  _$RowHighlightCopyWithImpl(this._self, this._then);

  final RowHighlight _self;
  final $Res Function(RowHighlight) _then;

  /// Create a copy of RowHighlight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? color = null,
  }) {
    return _then(_self.copyWith(
      index: null == index
          ? _self.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      color: null == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
    ));
  }
}

/// Adds pattern-matching-related methods to [RowHighlight].
extension RowHighlightPatterns on RowHighlight {
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
    TResult Function(_RowHighlight value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RowHighlight() when $default != null:
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
    TResult Function(_RowHighlight value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RowHighlight():
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
    TResult? Function(_RowHighlight value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RowHighlight() when $default != null:
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
            int index,
            @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
            Color color)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RowHighlight() when $default != null:
        return $default(_that.index, _that.color);
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
            int index,
            @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
            Color color)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RowHighlight():
        return $default(_that.index, _that.color);
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
            int index,
            @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
            Color color)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RowHighlight() when $default != null:
        return $default(_that.index, _that.color);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RowHighlight implements RowHighlight {
  const _RowHighlight(
      {required this.index,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
      required this.color});
  factory _RowHighlight.fromJson(Map<String, dynamic> json) =>
      _$RowHighlightFromJson(json);

  /// The 1-based line number to highlight (1, 2, 3, etc.).
  ///
  /// Line numbers correspond to what users see displayed on the UI.
  /// Free drawing spaces and image rows are skipped when counting line numbers.
  @override
  final int index;

  /// The color to use for highlighting this specific row.
  @override
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  final Color color;

  /// Create a copy of RowHighlight
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RowHighlightCopyWith<_RowHighlight> get copyWith =>
      __$RowHighlightCopyWithImpl<_RowHighlight>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RowHighlightToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RowHighlight &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, index, color);

  @override
  String toString() {
    return 'RowHighlight(index: $index, color: $color)';
  }
}

/// @nodoc
abstract mixin class _$RowHighlightCopyWith<$Res>
    implements $RowHighlightCopyWith<$Res> {
  factory _$RowHighlightCopyWith(
          _RowHighlight value, $Res Function(_RowHighlight) _then) =
      __$RowHighlightCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int index,
      @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) Color color});
}

/// @nodoc
class __$RowHighlightCopyWithImpl<$Res>
    implements _$RowHighlightCopyWith<$Res> {
  __$RowHighlightCopyWithImpl(this._self, this._then);

  final _RowHighlight _self;
  final $Res Function(_RowHighlight) _then;

  /// Create a copy of RowHighlight
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? index = null,
    Object? color = null,
  }) {
    return _then(_RowHighlight(
      index: null == index
          ? _self.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      color: null == color
          ? _self.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
    ));
  }
}

// dart format on
