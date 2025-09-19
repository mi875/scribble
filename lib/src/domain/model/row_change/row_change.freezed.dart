// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'row_change.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RowChangeInfo {
  /// The rows that were affected by the change.
  /// Uses renderer indices for physical positioning.
  Set<int> get affectedRendererIndices;

  /// The normal indices (user-visible line numbers) that were affected.
  /// Only includes rows with normal indices (text rows).
  Set<int> get affectedNormalIndices;

  /// The type of change that occurred.
  RowChangeType get changeType;

  /// Optional Y-coordinate range that was affected.
  double? get minY;
  double? get maxY;

  /// Number of lines added or removed (for content changes).
  int get lineDelta;

  /// Whether this change affects row structure (not just content).
  bool get structuralChange;

  /// Whether this change info was generated from a checkpoint comparison.
  bool get isCheckpointComparison;

  /// Timestamp of the checkpoint used for comparison (if applicable).
  DateTime? get checkpointTimestamp;

  /// Create a copy of RowChangeInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RowChangeInfoCopyWith<RowChangeInfo> get copyWith =>
      _$RowChangeInfoCopyWithImpl<RowChangeInfo>(
          this as RowChangeInfo, _$identity);

  /// Serializes this RowChangeInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RowChangeInfo &&
            const DeepCollectionEquality().equals(
                other.affectedRendererIndices, affectedRendererIndices) &&
            const DeepCollectionEquality()
                .equals(other.affectedNormalIndices, affectedNormalIndices) &&
            (identical(other.changeType, changeType) ||
                other.changeType == changeType) &&
            (identical(other.minY, minY) || other.minY == minY) &&
            (identical(other.maxY, maxY) || other.maxY == maxY) &&
            (identical(other.lineDelta, lineDelta) ||
                other.lineDelta == lineDelta) &&
            (identical(other.structuralChange, structuralChange) ||
                other.structuralChange == structuralChange) &&
            (identical(other.isCheckpointComparison, isCheckpointComparison) ||
                other.isCheckpointComparison == isCheckpointComparison) &&
            (identical(other.checkpointTimestamp, checkpointTimestamp) ||
                other.checkpointTimestamp == checkpointTimestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(affectedRendererIndices),
      const DeepCollectionEquality().hash(affectedNormalIndices),
      changeType,
      minY,
      maxY,
      lineDelta,
      structuralChange,
      isCheckpointComparison,
      checkpointTimestamp);

  @override
  String toString() {
    return 'RowChangeInfo(affectedRendererIndices: $affectedRendererIndices, affectedNormalIndices: $affectedNormalIndices, changeType: $changeType, minY: $minY, maxY: $maxY, lineDelta: $lineDelta, structuralChange: $structuralChange, isCheckpointComparison: $isCheckpointComparison, checkpointTimestamp: $checkpointTimestamp)';
  }
}

/// @nodoc
abstract mixin class $RowChangeInfoCopyWith<$Res> {
  factory $RowChangeInfoCopyWith(
          RowChangeInfo value, $Res Function(RowChangeInfo) _then) =
      _$RowChangeInfoCopyWithImpl;
  @useResult
  $Res call(
      {Set<int> affectedRendererIndices,
      Set<int> affectedNormalIndices,
      RowChangeType changeType,
      double? minY,
      double? maxY,
      int lineDelta,
      bool structuralChange,
      bool isCheckpointComparison,
      DateTime? checkpointTimestamp});
}

/// @nodoc
class _$RowChangeInfoCopyWithImpl<$Res>
    implements $RowChangeInfoCopyWith<$Res> {
  _$RowChangeInfoCopyWithImpl(this._self, this._then);

  final RowChangeInfo _self;
  final $Res Function(RowChangeInfo) _then;

  /// Create a copy of RowChangeInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? affectedRendererIndices = null,
    Object? affectedNormalIndices = null,
    Object? changeType = null,
    Object? minY = freezed,
    Object? maxY = freezed,
    Object? lineDelta = null,
    Object? structuralChange = null,
    Object? isCheckpointComparison = null,
    Object? checkpointTimestamp = freezed,
  }) {
    return _then(_self.copyWith(
      affectedRendererIndices: null == affectedRendererIndices
          ? _self.affectedRendererIndices
          : affectedRendererIndices // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      affectedNormalIndices: null == affectedNormalIndices
          ? _self.affectedNormalIndices
          : affectedNormalIndices // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      changeType: null == changeType
          ? _self.changeType
          : changeType // ignore: cast_nullable_to_non_nullable
              as RowChangeType,
      minY: freezed == minY
          ? _self.minY
          : minY // ignore: cast_nullable_to_non_nullable
              as double?,
      maxY: freezed == maxY
          ? _self.maxY
          : maxY // ignore: cast_nullable_to_non_nullable
              as double?,
      lineDelta: null == lineDelta
          ? _self.lineDelta
          : lineDelta // ignore: cast_nullable_to_non_nullable
              as int,
      structuralChange: null == structuralChange
          ? _self.structuralChange
          : structuralChange // ignore: cast_nullable_to_non_nullable
              as bool,
      isCheckpointComparison: null == isCheckpointComparison
          ? _self.isCheckpointComparison
          : isCheckpointComparison // ignore: cast_nullable_to_non_nullable
              as bool,
      checkpointTimestamp: freezed == checkpointTimestamp
          ? _self.checkpointTimestamp
          : checkpointTimestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [RowChangeInfo].
extension RowChangeInfoPatterns on RowChangeInfo {
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
    TResult Function(_RowChangeInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RowChangeInfo() when $default != null:
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
    TResult Function(_RowChangeInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RowChangeInfo():
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
    TResult? Function(_RowChangeInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RowChangeInfo() when $default != null:
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
            Set<int> affectedRendererIndices,
            Set<int> affectedNormalIndices,
            RowChangeType changeType,
            double? minY,
            double? maxY,
            int lineDelta,
            bool structuralChange,
            bool isCheckpointComparison,
            DateTime? checkpointTimestamp)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RowChangeInfo() when $default != null:
        return $default(
            _that.affectedRendererIndices,
            _that.affectedNormalIndices,
            _that.changeType,
            _that.minY,
            _that.maxY,
            _that.lineDelta,
            _that.structuralChange,
            _that.isCheckpointComparison,
            _that.checkpointTimestamp);
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
            Set<int> affectedRendererIndices,
            Set<int> affectedNormalIndices,
            RowChangeType changeType,
            double? minY,
            double? maxY,
            int lineDelta,
            bool structuralChange,
            bool isCheckpointComparison,
            DateTime? checkpointTimestamp)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RowChangeInfo():
        return $default(
            _that.affectedRendererIndices,
            _that.affectedNormalIndices,
            _that.changeType,
            _that.minY,
            _that.maxY,
            _that.lineDelta,
            _that.structuralChange,
            _that.isCheckpointComparison,
            _that.checkpointTimestamp);
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
            Set<int> affectedRendererIndices,
            Set<int> affectedNormalIndices,
            RowChangeType changeType,
            double? minY,
            double? maxY,
            int lineDelta,
            bool structuralChange,
            bool isCheckpointComparison,
            DateTime? checkpointTimestamp)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RowChangeInfo() when $default != null:
        return $default(
            _that.affectedRendererIndices,
            _that.affectedNormalIndices,
            _that.changeType,
            _that.minY,
            _that.maxY,
            _that.lineDelta,
            _that.structuralChange,
            _that.isCheckpointComparison,
            _that.checkpointTimestamp);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RowChangeInfo extends RowChangeInfo {
  const _RowChangeInfo(
      {required final Set<int> affectedRendererIndices,
      required final Set<int> affectedNormalIndices,
      required this.changeType,
      this.minY,
      this.maxY,
      this.lineDelta = 0,
      this.structuralChange = false,
      this.isCheckpointComparison = false,
      this.checkpointTimestamp})
      : _affectedRendererIndices = affectedRendererIndices,
        _affectedNormalIndices = affectedNormalIndices,
        super._();
  factory _RowChangeInfo.fromJson(Map<String, dynamic> json) =>
      _$RowChangeInfoFromJson(json);

  /// The rows that were affected by the change.
  /// Uses renderer indices for physical positioning.
  final Set<int> _affectedRendererIndices;

  /// The rows that were affected by the change.
  /// Uses renderer indices for physical positioning.
  @override
  Set<int> get affectedRendererIndices {
    if (_affectedRendererIndices is EqualUnmodifiableSetView)
      return _affectedRendererIndices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_affectedRendererIndices);
  }

  /// The normal indices (user-visible line numbers) that were affected.
  /// Only includes rows with normal indices (text rows).
  final Set<int> _affectedNormalIndices;

  /// The normal indices (user-visible line numbers) that were affected.
  /// Only includes rows with normal indices (text rows).
  @override
  Set<int> get affectedNormalIndices {
    if (_affectedNormalIndices is EqualUnmodifiableSetView)
      return _affectedNormalIndices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_affectedNormalIndices);
  }

  /// The type of change that occurred.
  @override
  final RowChangeType changeType;

  /// Optional Y-coordinate range that was affected.
  @override
  final double? minY;
  @override
  final double? maxY;

  /// Number of lines added or removed (for content changes).
  @override
  @JsonKey()
  final int lineDelta;

  /// Whether this change affects row structure (not just content).
  @override
  @JsonKey()
  final bool structuralChange;

  /// Whether this change info was generated from a checkpoint comparison.
  @override
  @JsonKey()
  final bool isCheckpointComparison;

  /// Timestamp of the checkpoint used for comparison (if applicable).
  @override
  final DateTime? checkpointTimestamp;

  /// Create a copy of RowChangeInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RowChangeInfoCopyWith<_RowChangeInfo> get copyWith =>
      __$RowChangeInfoCopyWithImpl<_RowChangeInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RowChangeInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RowChangeInfo &&
            const DeepCollectionEquality().equals(
                other._affectedRendererIndices, _affectedRendererIndices) &&
            const DeepCollectionEquality()
                .equals(other._affectedNormalIndices, _affectedNormalIndices) &&
            (identical(other.changeType, changeType) ||
                other.changeType == changeType) &&
            (identical(other.minY, minY) || other.minY == minY) &&
            (identical(other.maxY, maxY) || other.maxY == maxY) &&
            (identical(other.lineDelta, lineDelta) ||
                other.lineDelta == lineDelta) &&
            (identical(other.structuralChange, structuralChange) ||
                other.structuralChange == structuralChange) &&
            (identical(other.isCheckpointComparison, isCheckpointComparison) ||
                other.isCheckpointComparison == isCheckpointComparison) &&
            (identical(other.checkpointTimestamp, checkpointTimestamp) ||
                other.checkpointTimestamp == checkpointTimestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_affectedRendererIndices),
      const DeepCollectionEquality().hash(_affectedNormalIndices),
      changeType,
      minY,
      maxY,
      lineDelta,
      structuralChange,
      isCheckpointComparison,
      checkpointTimestamp);

  @override
  String toString() {
    return 'RowChangeInfo(affectedRendererIndices: $affectedRendererIndices, affectedNormalIndices: $affectedNormalIndices, changeType: $changeType, minY: $minY, maxY: $maxY, lineDelta: $lineDelta, structuralChange: $structuralChange, isCheckpointComparison: $isCheckpointComparison, checkpointTimestamp: $checkpointTimestamp)';
  }
}

/// @nodoc
abstract mixin class _$RowChangeInfoCopyWith<$Res>
    implements $RowChangeInfoCopyWith<$Res> {
  factory _$RowChangeInfoCopyWith(
          _RowChangeInfo value, $Res Function(_RowChangeInfo) _then) =
      __$RowChangeInfoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Set<int> affectedRendererIndices,
      Set<int> affectedNormalIndices,
      RowChangeType changeType,
      double? minY,
      double? maxY,
      int lineDelta,
      bool structuralChange,
      bool isCheckpointComparison,
      DateTime? checkpointTimestamp});
}

/// @nodoc
class __$RowChangeInfoCopyWithImpl<$Res>
    implements _$RowChangeInfoCopyWith<$Res> {
  __$RowChangeInfoCopyWithImpl(this._self, this._then);

  final _RowChangeInfo _self;
  final $Res Function(_RowChangeInfo) _then;

  /// Create a copy of RowChangeInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? affectedRendererIndices = null,
    Object? affectedNormalIndices = null,
    Object? changeType = null,
    Object? minY = freezed,
    Object? maxY = freezed,
    Object? lineDelta = null,
    Object? structuralChange = null,
    Object? isCheckpointComparison = null,
    Object? checkpointTimestamp = freezed,
  }) {
    return _then(_RowChangeInfo(
      affectedRendererIndices: null == affectedRendererIndices
          ? _self._affectedRendererIndices
          : affectedRendererIndices // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      affectedNormalIndices: null == affectedNormalIndices
          ? _self._affectedNormalIndices
          : affectedNormalIndices // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      changeType: null == changeType
          ? _self.changeType
          : changeType // ignore: cast_nullable_to_non_nullable
              as RowChangeType,
      minY: freezed == minY
          ? _self.minY
          : minY // ignore: cast_nullable_to_non_nullable
              as double?,
      maxY: freezed == maxY
          ? _self.maxY
          : maxY // ignore: cast_nullable_to_non_nullable
              as double?,
      lineDelta: null == lineDelta
          ? _self.lineDelta
          : lineDelta // ignore: cast_nullable_to_non_nullable
              as int,
      structuralChange: null == structuralChange
          ? _self.structuralChange
          : structuralChange // ignore: cast_nullable_to_non_nullable
              as bool,
      isCheckpointComparison: null == isCheckpointComparison
          ? _self.isCheckpointComparison
          : isCheckpointComparison // ignore: cast_nullable_to_non_nullable
              as bool,
      checkpointTimestamp: freezed == checkpointTimestamp
          ? _self.checkpointTimestamp
          : checkpointTimestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$RowContentChange {
  /// The row that changed.
  NotebookRow get row;

  /// Number of sketch lines in the old state.
  int get oldLineCount;

  /// Number of sketch lines in the new state.
  int get newLineCount;

  /// Whether the content actually changed.
  bool get hasChanged;

  /// Y-coordinate bounds of old content.
  double? get oldMinY;
  double? get oldMaxY;

  /// Y-coordinate bounds of new content.
  double? get newMinY;
  double? get newMaxY;

  /// Create a copy of RowContentChange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RowContentChangeCopyWith<RowContentChange> get copyWith =>
      _$RowContentChangeCopyWithImpl<RowContentChange>(
          this as RowContentChange, _$identity);

  /// Serializes this RowContentChange to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RowContentChange &&
            (identical(other.row, row) || other.row == row) &&
            (identical(other.oldLineCount, oldLineCount) ||
                other.oldLineCount == oldLineCount) &&
            (identical(other.newLineCount, newLineCount) ||
                other.newLineCount == newLineCount) &&
            (identical(other.hasChanged, hasChanged) ||
                other.hasChanged == hasChanged) &&
            (identical(other.oldMinY, oldMinY) || other.oldMinY == oldMinY) &&
            (identical(other.oldMaxY, oldMaxY) || other.oldMaxY == oldMaxY) &&
            (identical(other.newMinY, newMinY) || other.newMinY == newMinY) &&
            (identical(other.newMaxY, newMaxY) || other.newMaxY == newMaxY));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, row, oldLineCount, newLineCount,
      hasChanged, oldMinY, oldMaxY, newMinY, newMaxY);

  @override
  String toString() {
    return 'RowContentChange(row: $row, oldLineCount: $oldLineCount, newLineCount: $newLineCount, hasChanged: $hasChanged, oldMinY: $oldMinY, oldMaxY: $oldMaxY, newMinY: $newMinY, newMaxY: $newMaxY)';
  }
}

/// @nodoc
abstract mixin class $RowContentChangeCopyWith<$Res> {
  factory $RowContentChangeCopyWith(
          RowContentChange value, $Res Function(RowContentChange) _then) =
      _$RowContentChangeCopyWithImpl;
  @useResult
  $Res call(
      {NotebookRow row,
      int oldLineCount,
      int newLineCount,
      bool hasChanged,
      double? oldMinY,
      double? oldMaxY,
      double? newMinY,
      double? newMaxY});

  $NotebookRowCopyWith<$Res> get row;
}

/// @nodoc
class _$RowContentChangeCopyWithImpl<$Res>
    implements $RowContentChangeCopyWith<$Res> {
  _$RowContentChangeCopyWithImpl(this._self, this._then);

  final RowContentChange _self;
  final $Res Function(RowContentChange) _then;

  /// Create a copy of RowContentChange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? row = null,
    Object? oldLineCount = null,
    Object? newLineCount = null,
    Object? hasChanged = null,
    Object? oldMinY = freezed,
    Object? oldMaxY = freezed,
    Object? newMinY = freezed,
    Object? newMaxY = freezed,
  }) {
    return _then(_self.copyWith(
      row: null == row
          ? _self.row
          : row // ignore: cast_nullable_to_non_nullable
              as NotebookRow,
      oldLineCount: null == oldLineCount
          ? _self.oldLineCount
          : oldLineCount // ignore: cast_nullable_to_non_nullable
              as int,
      newLineCount: null == newLineCount
          ? _self.newLineCount
          : newLineCount // ignore: cast_nullable_to_non_nullable
              as int,
      hasChanged: null == hasChanged
          ? _self.hasChanged
          : hasChanged // ignore: cast_nullable_to_non_nullable
              as bool,
      oldMinY: freezed == oldMinY
          ? _self.oldMinY
          : oldMinY // ignore: cast_nullable_to_non_nullable
              as double?,
      oldMaxY: freezed == oldMaxY
          ? _self.oldMaxY
          : oldMaxY // ignore: cast_nullable_to_non_nullable
              as double?,
      newMinY: freezed == newMinY
          ? _self.newMinY
          : newMinY // ignore: cast_nullable_to_non_nullable
              as double?,
      newMaxY: freezed == newMaxY
          ? _self.newMaxY
          : newMaxY // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }

  /// Create a copy of RowContentChange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NotebookRowCopyWith<$Res> get row {
    return $NotebookRowCopyWith<$Res>(_self.row, (value) {
      return _then(_self.copyWith(row: value));
    });
  }
}

/// Adds pattern-matching-related methods to [RowContentChange].
extension RowContentChangePatterns on RowContentChange {
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
    TResult Function(_RowContentChange value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RowContentChange() when $default != null:
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
    TResult Function(_RowContentChange value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RowContentChange():
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
    TResult? Function(_RowContentChange value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RowContentChange() when $default != null:
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
            NotebookRow row,
            int oldLineCount,
            int newLineCount,
            bool hasChanged,
            double? oldMinY,
            double? oldMaxY,
            double? newMinY,
            double? newMaxY)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RowContentChange() when $default != null:
        return $default(
            _that.row,
            _that.oldLineCount,
            _that.newLineCount,
            _that.hasChanged,
            _that.oldMinY,
            _that.oldMaxY,
            _that.newMinY,
            _that.newMaxY);
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
            NotebookRow row,
            int oldLineCount,
            int newLineCount,
            bool hasChanged,
            double? oldMinY,
            double? oldMaxY,
            double? newMinY,
            double? newMaxY)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RowContentChange():
        return $default(
            _that.row,
            _that.oldLineCount,
            _that.newLineCount,
            _that.hasChanged,
            _that.oldMinY,
            _that.oldMaxY,
            _that.newMinY,
            _that.newMaxY);
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
            NotebookRow row,
            int oldLineCount,
            int newLineCount,
            bool hasChanged,
            double? oldMinY,
            double? oldMaxY,
            double? newMinY,
            double? newMaxY)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RowContentChange() when $default != null:
        return $default(
            _that.row,
            _that.oldLineCount,
            _that.newLineCount,
            _that.hasChanged,
            _that.oldMinY,
            _that.oldMaxY,
            _that.newMinY,
            _that.newMaxY);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RowContentChange extends RowContentChange {
  const _RowContentChange(
      {required this.row,
      required this.oldLineCount,
      required this.newLineCount,
      required this.hasChanged,
      this.oldMinY,
      this.oldMaxY,
      this.newMinY,
      this.newMaxY})
      : super._();
  factory _RowContentChange.fromJson(Map<String, dynamic> json) =>
      _$RowContentChangeFromJson(json);

  /// The row that changed.
  @override
  final NotebookRow row;

  /// Number of sketch lines in the old state.
  @override
  final int oldLineCount;

  /// Number of sketch lines in the new state.
  @override
  final int newLineCount;

  /// Whether the content actually changed.
  @override
  final bool hasChanged;

  /// Y-coordinate bounds of old content.
  @override
  final double? oldMinY;
  @override
  final double? oldMaxY;

  /// Y-coordinate bounds of new content.
  @override
  final double? newMinY;
  @override
  final double? newMaxY;

  /// Create a copy of RowContentChange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RowContentChangeCopyWith<_RowContentChange> get copyWith =>
      __$RowContentChangeCopyWithImpl<_RowContentChange>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RowContentChangeToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RowContentChange &&
            (identical(other.row, row) || other.row == row) &&
            (identical(other.oldLineCount, oldLineCount) ||
                other.oldLineCount == oldLineCount) &&
            (identical(other.newLineCount, newLineCount) ||
                other.newLineCount == newLineCount) &&
            (identical(other.hasChanged, hasChanged) ||
                other.hasChanged == hasChanged) &&
            (identical(other.oldMinY, oldMinY) || other.oldMinY == oldMinY) &&
            (identical(other.oldMaxY, oldMaxY) || other.oldMaxY == oldMaxY) &&
            (identical(other.newMinY, newMinY) || other.newMinY == newMinY) &&
            (identical(other.newMaxY, newMaxY) || other.newMaxY == newMaxY));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, row, oldLineCount, newLineCount,
      hasChanged, oldMinY, oldMaxY, newMinY, newMaxY);

  @override
  String toString() {
    return 'RowContentChange(row: $row, oldLineCount: $oldLineCount, newLineCount: $newLineCount, hasChanged: $hasChanged, oldMinY: $oldMinY, oldMaxY: $oldMaxY, newMinY: $newMinY, newMaxY: $newMaxY)';
  }
}

/// @nodoc
abstract mixin class _$RowContentChangeCopyWith<$Res>
    implements $RowContentChangeCopyWith<$Res> {
  factory _$RowContentChangeCopyWith(
          _RowContentChange value, $Res Function(_RowContentChange) _then) =
      __$RowContentChangeCopyWithImpl;
  @override
  @useResult
  $Res call(
      {NotebookRow row,
      int oldLineCount,
      int newLineCount,
      bool hasChanged,
      double? oldMinY,
      double? oldMaxY,
      double? newMinY,
      double? newMaxY});

  @override
  $NotebookRowCopyWith<$Res> get row;
}

/// @nodoc
class __$RowContentChangeCopyWithImpl<$Res>
    implements _$RowContentChangeCopyWith<$Res> {
  __$RowContentChangeCopyWithImpl(this._self, this._then);

  final _RowContentChange _self;
  final $Res Function(_RowContentChange) _then;

  /// Create a copy of RowContentChange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? row = null,
    Object? oldLineCount = null,
    Object? newLineCount = null,
    Object? hasChanged = null,
    Object? oldMinY = freezed,
    Object? oldMaxY = freezed,
    Object? newMinY = freezed,
    Object? newMaxY = freezed,
  }) {
    return _then(_RowContentChange(
      row: null == row
          ? _self.row
          : row // ignore: cast_nullable_to_non_nullable
              as NotebookRow,
      oldLineCount: null == oldLineCount
          ? _self.oldLineCount
          : oldLineCount // ignore: cast_nullable_to_non_nullable
              as int,
      newLineCount: null == newLineCount
          ? _self.newLineCount
          : newLineCount // ignore: cast_nullable_to_non_nullable
              as int,
      hasChanged: null == hasChanged
          ? _self.hasChanged
          : hasChanged // ignore: cast_nullable_to_non_nullable
              as bool,
      oldMinY: freezed == oldMinY
          ? _self.oldMinY
          : oldMinY // ignore: cast_nullable_to_non_nullable
              as double?,
      oldMaxY: freezed == oldMaxY
          ? _self.oldMaxY
          : oldMaxY // ignore: cast_nullable_to_non_nullable
              as double?,
      newMinY: freezed == newMinY
          ? _self.newMinY
          : newMinY // ignore: cast_nullable_to_non_nullable
              as double?,
      newMaxY: freezed == newMaxY
          ? _self.newMaxY
          : newMaxY // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }

  /// Create a copy of RowContentChange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NotebookRowCopyWith<$Res> get row {
    return $NotebookRowCopyWith<$Res>(_self.row, (value) {
      return _then(_self.copyWith(row: value));
    });
  }
}

// dart format on
