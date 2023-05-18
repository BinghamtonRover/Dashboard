///
//  Generated code. Do not modify.
//  source: autonomy.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'gps.pb.dart' as $0;

import 'autonomy.pbenum.dart';

export 'autonomy.pbenum.dart';

class AutonomyData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AutonomyData', createEmptyInstance: create)
    ..e<AutonomyState>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: AutonomyState.AUTONOMY_STATE_UNDEFINED, valueOf: AutonomyState.valueOf, enumValues: AutonomyState.values)
    ..aOM<$0.GpsCoordinates>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'destination', subBuilder: $0.GpsCoordinates.create)
    ..pc<$0.GpsCoordinates>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'obstacles', $pb.PbFieldType.PM, subBuilder: $0.GpsCoordinates.create)
    ..pc<$0.GpsCoordinates>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'path', $pb.PbFieldType.PM, subBuilder: $0.GpsCoordinates.create)
    ..e<AutonomyTask>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'task', $pb.PbFieldType.OE, defaultOrMaker: AutonomyTask.AUTONOMY_TASK_UNDEFINED, valueOf: AutonomyTask.valueOf, enumValues: AutonomyTask.values)
    ..hasRequiredFields = false
  ;

  AutonomyData._() : super();
  factory AutonomyData({
    AutonomyState? state,
    $0.GpsCoordinates? destination,
    $core.Iterable<$0.GpsCoordinates>? obstacles,
    $core.Iterable<$0.GpsCoordinates>? path,
    AutonomyTask? task,
  }) {
    final _result = create();
    if (state != null) {
      _result.state = state;
    }
    if (destination != null) {
      _result.destination = destination;
    }
    if (obstacles != null) {
      _result.obstacles.addAll(obstacles);
    }
    if (path != null) {
      _result.path.addAll(path);
    }
    if (task != null) {
      _result.task = task;
    }
    return _result;
  }
  factory AutonomyData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AutonomyData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AutonomyData clone() => AutonomyData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AutonomyData copyWith(void Function(AutonomyData) updates) => super.copyWith((message) => updates(message as AutonomyData)) as AutonomyData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AutonomyData create() => AutonomyData._();
  AutonomyData createEmptyInstance() => create();
  static $pb.PbList<AutonomyData> createRepeated() => $pb.PbList<AutonomyData>();
  @$core.pragma('dart2js:noInline')
  static AutonomyData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AutonomyData>(create);
  static AutonomyData? _defaultInstance;

  @$pb.TagNumber(1)
  AutonomyState get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(AutonomyState v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => clearField(1);

  @$pb.TagNumber(2)
  $0.GpsCoordinates get destination => $_getN(1);
  @$pb.TagNumber(2)
  set destination($0.GpsCoordinates v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasDestination() => $_has(1);
  @$pb.TagNumber(2)
  void clearDestination() => clearField(2);
  @$pb.TagNumber(2)
  $0.GpsCoordinates ensureDestination() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.List<$0.GpsCoordinates> get obstacles => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<$0.GpsCoordinates> get path => $_getList(3);

  @$pb.TagNumber(5)
  AutonomyTask get task => $_getN(4);
  @$pb.TagNumber(5)
  set task(AutonomyTask v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasTask() => $_has(4);
  @$pb.TagNumber(5)
  void clearTask() => clearField(5);
}

class AutonomyCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AutonomyCommand', createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'enable')
    ..aOM<$0.GpsCoordinates>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'destination', subBuilder: $0.GpsCoordinates.create)
    ..e<AutonomyTask>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'task', $pb.PbFieldType.OE, defaultOrMaker: AutonomyTask.AUTONOMY_TASK_UNDEFINED, valueOf: AutonomyTask.valueOf, enumValues: AutonomyTask.values)
    ..hasRequiredFields = false
  ;

  AutonomyCommand._() : super();
  factory AutonomyCommand({
    $core.bool? enable,
    $0.GpsCoordinates? destination,
    AutonomyTask? task,
  }) {
    final _result = create();
    if (enable != null) {
      _result.enable = enable;
    }
    if (destination != null) {
      _result.destination = destination;
    }
    if (task != null) {
      _result.task = task;
    }
    return _result;
  }
  factory AutonomyCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AutonomyCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AutonomyCommand clone() => AutonomyCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AutonomyCommand copyWith(void Function(AutonomyCommand) updates) => super.copyWith((message) => updates(message as AutonomyCommand)) as AutonomyCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AutonomyCommand create() => AutonomyCommand._();
  AutonomyCommand createEmptyInstance() => create();
  static $pb.PbList<AutonomyCommand> createRepeated() => $pb.PbList<AutonomyCommand>();
  @$core.pragma('dart2js:noInline')
  static AutonomyCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AutonomyCommand>(create);
  static AutonomyCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get enable => $_getBF(0);
  @$pb.TagNumber(1)
  set enable($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEnable() => $_has(0);
  @$pb.TagNumber(1)
  void clearEnable() => clearField(1);

  @$pb.TagNumber(2)
  $0.GpsCoordinates get destination => $_getN(1);
  @$pb.TagNumber(2)
  set destination($0.GpsCoordinates v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasDestination() => $_has(1);
  @$pb.TagNumber(2)
  void clearDestination() => clearField(2);
  @$pb.TagNumber(2)
  $0.GpsCoordinates ensureDestination() => $_ensure(1);

  @$pb.TagNumber(3)
  AutonomyTask get task => $_getN(2);
  @$pb.TagNumber(3)
  set task(AutonomyTask v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasTask() => $_has(2);
  @$pb.TagNumber(3)
  void clearTask() => clearField(3);
}

