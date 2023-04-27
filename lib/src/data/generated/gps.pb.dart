///
//  Generated code. Do not modify.
//  source: gps.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class GpsCoordinates extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GpsCoordinates', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'latitude', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'longitude', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'altitude', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  GpsCoordinates._() : super();
  factory GpsCoordinates({
    $core.double? latitude,
    $core.double? longitude,
    $core.double? altitude,
  }) {
    final _result = create();
    if (latitude != null) {
      _result.latitude = latitude;
    }
    if (longitude != null) {
      _result.longitude = longitude;
    }
    if (altitude != null) {
      _result.altitude = altitude;
    }
    return _result;
  }
  factory GpsCoordinates.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GpsCoordinates.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GpsCoordinates clone() => GpsCoordinates()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GpsCoordinates copyWith(void Function(GpsCoordinates) updates) => super.copyWith((message) => updates(message as GpsCoordinates)) as GpsCoordinates; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GpsCoordinates create() => GpsCoordinates._();
  GpsCoordinates createEmptyInstance() => create();
  static $pb.PbList<GpsCoordinates> createRepeated() => $pb.PbList<GpsCoordinates>();
  @$core.pragma('dart2js:noInline')
  static GpsCoordinates getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GpsCoordinates>(create);
  static GpsCoordinates? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get latitude => $_getN(0);
  @$pb.TagNumber(1)
  set latitude($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLatitude() => $_has(0);
  @$pb.TagNumber(1)
  void clearLatitude() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get longitude => $_getN(1);
  @$pb.TagNumber(2)
  set longitude($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLongitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearLongitude() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get altitude => $_getN(2);
  @$pb.TagNumber(3)
  set altitude($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAltitude() => $_has(2);
  @$pb.TagNumber(3)
  void clearAltitude() => clearField(3);
}

class Orientation extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Orientation', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'x', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'y', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'z', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  Orientation._() : super();
  factory Orientation({
    $core.double? x,
    $core.double? y,
    $core.double? z,
  }) {
    final _result = create();
    if (x != null) {
      _result.x = x;
    }
    if (y != null) {
      _result.y = y;
    }
    if (z != null) {
      _result.z = z;
    }
    return _result;
  }
  factory Orientation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Orientation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Orientation clone() => Orientation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Orientation copyWith(void Function(Orientation) updates) => super.copyWith((message) => updates(message as Orientation)) as Orientation; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Orientation create() => Orientation._();
  Orientation createEmptyInstance() => create();
  static $pb.PbList<Orientation> createRepeated() => $pb.PbList<Orientation>();
  @$core.pragma('dart2js:noInline')
  static Orientation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Orientation>(create);
  static Orientation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get z => $_getN(2);
  @$pb.TagNumber(3)
  set z($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasZ() => $_has(2);
  @$pb.TagNumber(3)
  void clearZ() => clearField(3);
}

class RoverPosition extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RoverPosition', createEmptyInstance: create)
    ..aOM<GpsCoordinates>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gps', subBuilder: GpsCoordinates.create)
    ..aOM<Orientation>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'orientation', subBuilder: Orientation.create)
    ..hasRequiredFields = false
  ;

  RoverPosition._() : super();
  factory RoverPosition({
    GpsCoordinates? gps,
    Orientation? orientation,
  }) {
    final _result = create();
    if (gps != null) {
      _result.gps = gps;
    }
    if (orientation != null) {
      _result.orientation = orientation;
    }
    return _result;
  }
  factory RoverPosition.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RoverPosition.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RoverPosition clone() => RoverPosition()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RoverPosition copyWith(void Function(RoverPosition) updates) => super.copyWith((message) => updates(message as RoverPosition)) as RoverPosition; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RoverPosition create() => RoverPosition._();
  RoverPosition createEmptyInstance() => create();
  static $pb.PbList<RoverPosition> createRepeated() => $pb.PbList<RoverPosition>();
  @$core.pragma('dart2js:noInline')
  static RoverPosition getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoverPosition>(create);
  static RoverPosition? _defaultInstance;

  @$pb.TagNumber(1)
  GpsCoordinates get gps => $_getN(0);
  @$pb.TagNumber(1)
  set gps(GpsCoordinates v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasGps() => $_has(0);
  @$pb.TagNumber(1)
  void clearGps() => clearField(1);
  @$pb.TagNumber(1)
  GpsCoordinates ensureGps() => $_ensure(0);

  @$pb.TagNumber(2)
  Orientation get orientation => $_getN(1);
  @$pb.TagNumber(2)
  set orientation(Orientation v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasOrientation() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrientation() => clearField(2);
  @$pb.TagNumber(2)
  Orientation ensureOrientation() => $_ensure(1);
}

