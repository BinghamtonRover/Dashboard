///
//  Generated code. Do not modify.
//  source: mars.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'gps.pb.dart' as $0;

class MarsCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MarsCommand', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'swivel', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tilt', $pb.PbFieldType.OF)
    ..aOM<$0.RoverPosition>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'position', subBuilder: $0.RoverPosition.create)
    ..hasRequiredFields = false
  ;

  MarsCommand._() : super();
  factory MarsCommand({
    $core.double? swivel,
    $core.double? tilt,
    $0.RoverPosition? position,
  }) {
    final _result = create();
    if (swivel != null) {
      _result.swivel = swivel;
    }
    if (tilt != null) {
      _result.tilt = tilt;
    }
    if (position != null) {
      _result.position = position;
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
  $0.RoverPosition get position => $_getN(2);
  @$pb.TagNumber(3)
  set position($0.RoverPosition v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPosition() => $_has(2);
  @$pb.TagNumber(3)
  void clearPosition() => clearField(3);
  @$pb.TagNumber(3)
  $0.RoverPosition ensurePosition() => $_ensure(2);
}

class MarsData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MarsData', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'swivel', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tilt', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  MarsData._() : super();
  factory MarsData({
    $core.double? swivel,
    $core.double? tilt,
  }) {
    final _result = create();
    if (swivel != null) {
      _result.swivel = swivel;
    }
    if (tilt != null) {
      _result.tilt = tilt;
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
}

