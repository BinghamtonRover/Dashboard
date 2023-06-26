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
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'crash')
    ..hasRequiredFields = false
  ;

  AutonomyData._() : super();
  factory AutonomyData({
    AutonomyState? state,
    $0.GpsCoordinates? destination,
    $core.Iterable<$0.GpsCoordinates>? obstacles,
    $core.Iterable<$0.GpsCoordinates>? path,
    AutonomyTask? task,
    $core.bool? crash,
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
    if (crash != null) {
      _result.crash = crash;
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

  @$pb.TagNumber(6)
  $core.bool get crash => $_getBF(5);
  @$pb.TagNumber(6)
  set crash($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCrash() => $_has(5);
  @$pb.TagNumber(6)
  void clearCrash() => clearField(6);
}

class AutonomyCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AutonomyCommand', createEmptyInstance: create)
    ..aOM<$0.GpsCoordinates>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'destination', subBuilder: $0.GpsCoordinates.create)
    ..e<AutonomyTask>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'task', $pb.PbFieldType.OE, defaultOrMaker: AutonomyTask.AUTONOMY_TASK_UNDEFINED, valueOf: AutonomyTask.valueOf, enumValues: AutonomyTask.values)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'arucoId', $pb.PbFieldType.O3)
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'abort')
    ..hasRequiredFields = false
  ;

  AutonomyCommand._() : super();
  factory AutonomyCommand({
    $0.GpsCoordinates? destination,
    AutonomyTask? task,
    $core.int? arucoId,
    $core.bool? abort,
  }) {
    final _result = create();
    if (destination != null) {
      _result.destination = destination;
    }
    if (task != null) {
      _result.task = task;
    }
    if (arucoId != null) {
      _result.arucoId = arucoId;
    }
    if (abort != null) {
      _result.abort = abort;
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
  $0.GpsCoordinates get destination => $_getN(0);
  @$pb.TagNumber(1)
  set destination($0.GpsCoordinates v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDestination() => $_has(0);
  @$pb.TagNumber(1)
  void clearDestination() => clearField(1);
  @$pb.TagNumber(1)
  $0.GpsCoordinates ensureDestination() => $_ensure(0);

  @$pb.TagNumber(2)
  AutonomyTask get task => $_getN(1);
  @$pb.TagNumber(2)
  set task(AutonomyTask v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasTask() => $_has(1);
  @$pb.TagNumber(2)
  void clearTask() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get arucoId => $_getIZ(2);
  @$pb.TagNumber(3)
  set arucoId($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasArucoId() => $_has(2);
  @$pb.TagNumber(3)
  void clearArucoId() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get abort => $_getBF(3);
  @$pb.TagNumber(4)
  set abort($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAbort() => $_has(3);
  @$pb.TagNumber(4)
  void clearAbort() => clearField(4);
}

