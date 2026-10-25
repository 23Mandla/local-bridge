// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'opportunities_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OpportunitiesEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpportunitiesEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OpportunitiesEvent()';
}


}

/// @nodoc
class $OpportunitiesEventCopyWith<$Res>  {
$OpportunitiesEventCopyWith(OpportunitiesEvent _, $Res Function(OpportunitiesEvent) __);
}


/// Adds pattern-matching-related methods to [OpportunitiesEvent].
extension OpportunitiesEventPatterns on OpportunitiesEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( GetOpportunities value)?  getOpportunities,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case GetOpportunities() when getOpportunities != null:
return getOpportunities(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( GetOpportunities value)  getOpportunities,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case GetOpportunities():
return getOpportunities(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( GetOpportunities value)?  getOpportunities,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case GetOpportunities() when getOpportunities != null:
return getOpportunities(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  getOpportunities,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case GetOpportunities() when getOpportunities != null:
return getOpportunities();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  getOpportunities,}) {final _that = this;
switch (_that) {
case _Started():
return started();case GetOpportunities():
return getOpportunities();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  getOpportunities,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case GetOpportunities() when getOpportunities != null:
return getOpportunities();case _:
  return null;

}
}

}

/// @nodoc


class _Started implements OpportunitiesEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OpportunitiesEvent.started()';
}


}




/// @nodoc


class GetOpportunities implements OpportunitiesEvent {
  const GetOpportunities();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetOpportunities);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OpportunitiesEvent.getOpportunities()';
}


}




/// @nodoc
mixin _$OpportunitiesState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpportunitiesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OpportunitiesState()';
}


}

/// @nodoc
class $OpportunitiesStateCopyWith<$Res>  {
$OpportunitiesStateCopyWith(OpportunitiesState _, $Res Function(OpportunitiesState) __);
}


/// Adds pattern-matching-related methods to [OpportunitiesState].
extension OpportunitiesStatePatterns on OpportunitiesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( OpportunitiesLoading value)?  loading,TResult Function( OpportunitiesLoaded value)?  loaded,TResult Function( OpportunitiesError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case OpportunitiesLoading() when loading != null:
return loading(_that);case OpportunitiesLoaded() when loaded != null:
return loaded(_that);case OpportunitiesError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( OpportunitiesLoading value)  loading,required TResult Function( OpportunitiesLoaded value)  loaded,required TResult Function( OpportunitiesError value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case OpportunitiesLoading():
return loading(_that);case OpportunitiesLoaded():
return loaded(_that);case OpportunitiesError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( OpportunitiesLoading value)?  loading,TResult? Function( OpportunitiesLoaded value)?  loaded,TResult? Function( OpportunitiesError value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case OpportunitiesLoading() when loading != null:
return loading(_that);case OpportunitiesLoaded() when loaded != null:
return loaded(_that);case OpportunitiesError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Opportunity> opportunities)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case OpportunitiesLoading() when loading != null:
return loading();case OpportunitiesLoaded() when loaded != null:
return loaded(_that.opportunities);case OpportunitiesError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Opportunity> opportunities)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case OpportunitiesLoading():
return loading();case OpportunitiesLoaded():
return loaded(_that.opportunities);case OpportunitiesError():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Opportunity> opportunities)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case OpportunitiesLoading() when loading != null:
return loading();case OpportunitiesLoaded() when loaded != null:
return loaded(_that.opportunities);case OpportunitiesError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements OpportunitiesState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OpportunitiesState.initial()';
}


}




/// @nodoc


class OpportunitiesLoading implements OpportunitiesState {
  const OpportunitiesLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpportunitiesLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OpportunitiesState.loading()';
}


}




/// @nodoc


class OpportunitiesLoaded implements OpportunitiesState {
  const OpportunitiesLoaded({required final  List<Opportunity> opportunities}): _opportunities = opportunities;
  

 final  List<Opportunity> _opportunities;
 List<Opportunity> get opportunities {
  if (_opportunities is EqualUnmodifiableListView) return _opportunities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_opportunities);
}


/// Create a copy of OpportunitiesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpportunitiesLoadedCopyWith<OpportunitiesLoaded> get copyWith => _$OpportunitiesLoadedCopyWithImpl<OpportunitiesLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpportunitiesLoaded&&const DeepCollectionEquality().equals(other._opportunities, _opportunities));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_opportunities));

@override
String toString() {
  return 'OpportunitiesState.loaded(opportunities: $opportunities)';
}


}

/// @nodoc
abstract mixin class $OpportunitiesLoadedCopyWith<$Res> implements $OpportunitiesStateCopyWith<$Res> {
  factory $OpportunitiesLoadedCopyWith(OpportunitiesLoaded value, $Res Function(OpportunitiesLoaded) _then) = _$OpportunitiesLoadedCopyWithImpl;
@useResult
$Res call({
 List<Opportunity> opportunities
});




}
/// @nodoc
class _$OpportunitiesLoadedCopyWithImpl<$Res>
    implements $OpportunitiesLoadedCopyWith<$Res> {
  _$OpportunitiesLoadedCopyWithImpl(this._self, this._then);

  final OpportunitiesLoaded _self;
  final $Res Function(OpportunitiesLoaded) _then;

/// Create a copy of OpportunitiesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? opportunities = null,}) {
  return _then(OpportunitiesLoaded(
opportunities: null == opportunities ? _self._opportunities : opportunities // ignore: cast_nullable_to_non_nullable
as List<Opportunity>,
  ));
}


}

/// @nodoc


class OpportunitiesError implements OpportunitiesState {
  const OpportunitiesError({required this.message});
  

 final  String message;

/// Create a copy of OpportunitiesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpportunitiesErrorCopyWith<OpportunitiesError> get copyWith => _$OpportunitiesErrorCopyWithImpl<OpportunitiesError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpportunitiesError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'OpportunitiesState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $OpportunitiesErrorCopyWith<$Res> implements $OpportunitiesStateCopyWith<$Res> {
  factory $OpportunitiesErrorCopyWith(OpportunitiesError value, $Res Function(OpportunitiesError) _then) = _$OpportunitiesErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$OpportunitiesErrorCopyWithImpl<$Res>
    implements $OpportunitiesErrorCopyWith<$Res> {
  _$OpportunitiesErrorCopyWithImpl(this._self, this._then);

  final OpportunitiesError _self;
  final $Res Function(OpportunitiesError) _then;

/// Create a copy of OpportunitiesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(OpportunitiesError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
