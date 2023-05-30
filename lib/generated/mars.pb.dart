///
//  Generated code. Do not modify.
//  source: mars.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'gps.pb.dart' as $0;

import 'mars.pbenum.dart';

export 'mars.pbenum.dart';

class MarsCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MarsCommand', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'swivel', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tilt', $pb.PbFieldType.OF)
    ..aOM<$0.GpsCoordinates>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rover', subBuilder: $0.GpsCoordinates.create)
    ..aOM<$0.GpsCoordinates>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'baseStationOverride', protoName: 'baseStationOverride', subBuilder: $0.GpsCoordinates.create)
    ..hasRequiredFields = false
  ;

  MarsCommand._() : super();
  factory MarsCommand({
    $core.double? swivel,
    $core.double? tilt,
    $0.GpsCoordinates? rover,
    $0.GpsCoordinates? baseStationOverride,
  }) {
    final _result = create();
    if (swivel != null) {
      _result.swivel = swivel;
    }
    if (tilt != null) {
      _result.tilt = tilt;
    }
    if (rover != null) {
      _result.rover = rover;
    }
    if (baseStationOverride != null) {
      _result.baseStationOverride = baseStationOverride;
    }
    return _result;
  }
  factory MarsCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MarsCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MarsCommand clone() => MarsCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MarsCommand copyWith(void Function(MarsCommand) updates) => super.copyWith((message) => updates(message as MarsCommand)) as MarsCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MarsCommand create() => MarsCommand._();
  MarsCommand createEmptyInstance() => create();
  static $pb.PbList<MarsCommand> createRepeated() => $pb.PbList<MarsCommand>();
  @$core.pragma('dart2js:noInline')
  static MarsCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MarsCommand>(create);
  static MarsCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get swivel => $_getN(0);
  @$pb.TagNumber(1)
  set swivel($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSwivel() => $_has(0);
  @$pb.TagNumber(1)
  void clearSwivel() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get tilt => $_getN(1);
  @$pb.TagNumber(2)
  set tilt($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTilt() => $_has(1);
  @$pb.TagNumber(2)
  void clearTilt() => clearField(2);

  @$pb.TagNumber(3)
  $0.GpsCoordinates get rover => $_getN(2);
  @$pb.TagNumber(3)
  set rover($0.GpsCoordinates v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasRover() => $_has(2);
  @$pb.TagNumber(3)
  void clearRover() => clearField(3);
  @$pb.TagNumber(3)
  $0.GpsCoordinates ensureRover() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.GpsCoordinates get baseStationOverride => $_getN(3);
  @$pb.TagNumber(4)
  set baseStationOverride($0.GpsCoordinates v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasBaseStationOverride() => $_has(3);
  @$pb.TagNumber(4)
  void clearBaseStationOverride() => clearField(4);
  @$pb.TagNumber(4)
  $0.GpsCoordinates ensureBaseStationOverride() => $_ensure(3);
}

class MarsData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MarsData', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'swivel', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tilt', $pb.PbFieldType.OF)
    ..aOM<$0.GpsCoordinates>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coordinates', subBuilder: $0.GpsCoordinates.create)
    ..e<MarsStatus>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: MarsStatus.MARS_STATUS_UNDEFINED, valueOf: MarsStatus.valueOf, enumValues: MarsStatus.values)
    ..hasRequiredFields = false
  ;

  MarsData._() : super();
  factory MarsData({
    $core.double? swivel,
    $core.double? tilt,
    $0.GpsCoordinates? coordinates,
    MarsStatus? status,
  }) {
    final _result = create();
    if (swivel != null) {
      _result.swivel = swivel;
    }
    if (tilt != null) {
      _result.tilt = tilt;
    }
    if (coordinates != null) {
      _result.coordinates = coordinates;
    }
    if (status != null) {
      _result.status = status;
    }
    return _result;
  }
  factory MarsData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MarsData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MarsData clone() => MarsData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MarsData copyWith(void Function(MarsData) updates) => super.copyWith((message) => updates(message as MarsData)) as MarsData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MarsData create() => MarsData._();
  MarsData createEmptyInstance() => create();
  static $pb.PbList<MarsData> createRepeated() => $pb.PbList<MarsData>();
  @$core.pragma('dart2js:noInline')
  static MarsData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MarsData>(create);
  static MarsData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get swivel => $_getN(0);
  @$pb.TagNumber(1)
  set swivel($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSwivel() => $_has(0);
  @$pb.TagNumber(1)
  void clearSwivel() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get tilt => $_getN(1);
  @$pb.TagNumber(2)
  set tilt($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTilt() => $_has(1);
  @$pb.TagNumber(2)
  void clearTilt() => clearField(2);

  @$pb.TagNumber(3)
  $0.GpsCoordinates get coordinates => $_getN(2);
  @$pb.TagNumber(3)
  set coordinates($0.GpsCoordinates v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCoordinates() => $_has(2);
  @$pb.TagNumber(3)
  void clearCoordinates() => clearField(3);
  @$pb.TagNumber(3)
  $0.GpsCoordinates ensureCoordinates() => $_ensure(2);

  @$pb.TagNumber(4)
  MarsStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status(MarsStatus v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => clearField(4);
}

