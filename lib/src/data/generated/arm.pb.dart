///
//  Generated code. Do not modify.
//  source: arm.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Position extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Position', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'x', $pb.PbFieldType.O3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'y', $pb.PbFieldType.O3)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'z', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  Position._() : super();
  factory Position({
    $core.int? x,
    $core.int? y,
    $core.int? z,
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
  factory Position.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Position.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Position clone() => Position()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Position copyWith(void Function(Position) updates) => super.copyWith((message) => updates(message as Position)) as Position; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Position create() => Position._();
  Position createEmptyInstance() => create();
  static $pb.PbList<Position> createRepeated() => $pb.PbList<Position>();
  @$core.pragma('dart2js:noInline')
  static Position getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Position>(create);
  static Position? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get x => $_getIZ(0);
  @$pb.TagNumber(1)
  set x($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get y => $_getIZ(1);
  @$pb.TagNumber(2)
  set y($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get z => $_getIZ(2);
  @$pb.TagNumber(3)
  set z($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasZ() => $_has(2);
  @$pb.TagNumber(3)
  void clearZ() => clearField(3);
}

class ArmCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ArmCommand', createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stop')
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'moveSwivel', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'moveShoulder', $pb.PbFieldType.OF)
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'moveElbow', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  ArmCommand._() : super();
  factory ArmCommand({
    $core.bool? stop,
    $core.double? moveSwivel,
    $core.double? moveShoulder,
    $core.double? moveElbow,
  }) {
    final _result = create();
    if (stop != null) {
      _result.stop = stop;
    }
    if (moveSwivel != null) {
      _result.moveSwivel = moveSwivel;
    }
    if (moveShoulder != null) {
      _result.moveShoulder = moveShoulder;
    }
    if (moveElbow != null) {
      _result.moveElbow = moveElbow;
    }
    return _result;
  }
  factory ArmCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ArmCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ArmCommand clone() => ArmCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ArmCommand copyWith(void Function(ArmCommand) updates) => super.copyWith((message) => updates(message as ArmCommand)) as ArmCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ArmCommand create() => ArmCommand._();
  ArmCommand createEmptyInstance() => create();
  static $pb.PbList<ArmCommand> createRepeated() => $pb.PbList<ArmCommand>();
  @$core.pragma('dart2js:noInline')
  static ArmCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ArmCommand>(create);
  static ArmCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get stop => $_getBF(0);
  @$pb.TagNumber(1)
  set stop($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStop() => $_has(0);
  @$pb.TagNumber(1)
  void clearStop() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get moveSwivel => $_getN(1);
  @$pb.TagNumber(2)
  set moveSwivel($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMoveSwivel() => $_has(1);
  @$pb.TagNumber(2)
  void clearMoveSwivel() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get moveShoulder => $_getN(2);
  @$pb.TagNumber(3)
  set moveShoulder($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMoveShoulder() => $_has(2);
  @$pb.TagNumber(3)
  void clearMoveShoulder() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get moveElbow => $_getN(3);
  @$pb.TagNumber(4)
  set moveElbow($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMoveElbow() => $_has(3);
  @$pb.TagNumber(4)
  void clearMoveElbow() => clearField(4);
}

class MotorStatus extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MotorStatus', createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isMoving')
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'angle', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'temperature', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  MotorStatus._() : super();
  factory MotorStatus({
    $core.bool? isMoving,
    $core.double? angle,
    $core.double? temperature,
  }) {
    final _result = create();
    if (isMoving != null) {
      _result.isMoving = isMoving;
    }
    if (angle != null) {
      _result.angle = angle;
    }
    if (temperature != null) {
      _result.temperature = temperature;
    }
    return _result;
  }
  factory MotorStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MotorStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MotorStatus clone() => MotorStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MotorStatus copyWith(void Function(MotorStatus) updates) => super.copyWith((message) => updates(message as MotorStatus)) as MotorStatus; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MotorStatus create() => MotorStatus._();
  MotorStatus createEmptyInstance() => create();
  static $pb.PbList<MotorStatus> createRepeated() => $pb.PbList<MotorStatus>();
  @$core.pragma('dart2js:noInline')
  static MotorStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MotorStatus>(create);
  static MotorStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isMoving => $_getBF(0);
  @$pb.TagNumber(1)
  set isMoving($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIsMoving() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsMoving() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get angle => $_getN(1);
  @$pb.TagNumber(2)
  set angle($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAngle() => $_has(1);
  @$pb.TagNumber(2)
  void clearAngle() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get temperature => $_getN(2);
  @$pb.TagNumber(3)
  set temperature($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTemperature() => $_has(2);
  @$pb.TagNumber(3)
  void clearTemperature() => clearField(3);
}

class ArmData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ArmData', createEmptyInstance: create)
    ..aOM<Position>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'currentPosition', protoName: 'currentPosition', subBuilder: Position.create)
    ..aOM<Position>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'targetPosition', protoName: 'targetPosition', subBuilder: Position.create)
    ..aOM<MotorStatus>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'base', subBuilder: MotorStatus.create)
    ..aOM<MotorStatus>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'shoulder', subBuilder: MotorStatus.create)
    ..aOM<MotorStatus>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'elbow', subBuilder: MotorStatus.create)
    ..hasRequiredFields = false
  ;

  ArmData._() : super();
  factory ArmData({
    Position? currentPosition,
    Position? targetPosition,
    MotorStatus? base,
    MotorStatus? shoulder,
    MotorStatus? elbow,
  }) {
    final _result = create();
    if (currentPosition != null) {
      _result.currentPosition = currentPosition;
    }
    if (targetPosition != null) {
      _result.targetPosition = targetPosition;
    }
    if (base != null) {
      _result.base = base;
    }
    if (shoulder != null) {
      _result.shoulder = shoulder;
    }
    if (elbow != null) {
      _result.elbow = elbow;
    }
    return _result;
  }
  factory ArmData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ArmData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ArmData clone() => ArmData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ArmData copyWith(void Function(ArmData) updates) => super.copyWith((message) => updates(message as ArmData)) as ArmData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ArmData create() => ArmData._();
  ArmData createEmptyInstance() => create();
  static $pb.PbList<ArmData> createRepeated() => $pb.PbList<ArmData>();
  @$core.pragma('dart2js:noInline')
  static ArmData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ArmData>(create);
  static ArmData? _defaultInstance;

  @$pb.TagNumber(1)
  Position get currentPosition => $_getN(0);
  @$pb.TagNumber(1)
  set currentPosition(Position v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCurrentPosition() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentPosition() => clearField(1);
  @$pb.TagNumber(1)
  Position ensureCurrentPosition() => $_ensure(0);

  @$pb.TagNumber(2)
  Position get targetPosition => $_getN(1);
  @$pb.TagNumber(2)
  set targetPosition(Position v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasTargetPosition() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetPosition() => clearField(2);
  @$pb.TagNumber(2)
  Position ensureTargetPosition() => $_ensure(1);

  @$pb.TagNumber(3)
  MotorStatus get base => $_getN(2);
  @$pb.TagNumber(3)
  set base(MotorStatus v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasBase() => $_has(2);
  @$pb.TagNumber(3)
  void clearBase() => clearField(3);
  @$pb.TagNumber(3)
  MotorStatus ensureBase() => $_ensure(2);

  @$pb.TagNumber(4)
  MotorStatus get shoulder => $_getN(3);
  @$pb.TagNumber(4)
  set shoulder(MotorStatus v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasShoulder() => $_has(3);
  @$pb.TagNumber(4)
  void clearShoulder() => clearField(4);
  @$pb.TagNumber(4)
  MotorStatus ensureShoulder() => $_ensure(3);

  @$pb.TagNumber(5)
  MotorStatus get elbow => $_getN(4);
  @$pb.TagNumber(5)
  set elbow(MotorStatus v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasElbow() => $_has(4);
  @$pb.TagNumber(5)
  void clearElbow() => clearField(5);
  @$pb.TagNumber(5)
  MotorStatus ensureElbow() => $_ensure(4);
}

class GripperData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GripperData', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rotation', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'swivel', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pinch', $pb.PbFieldType.OF)
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'motorTemperature', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  GripperData._() : super();
  factory GripperData({
    $core.double? rotation,
    $core.double? swivel,
    $core.double? pinch,
    $core.double? motorTemperature,
  }) {
    final _result = create();
    if (rotation != null) {
      _result.rotation = rotation;
    }
    if (swivel != null) {
      _result.swivel = swivel;
    }
    if (pinch != null) {
      _result.pinch = pinch;
    }
    if (motorTemperature != null) {
      _result.motorTemperature = motorTemperature;
    }
    return _result;
  }
  factory GripperData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GripperData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GripperData clone() => GripperData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GripperData copyWith(void Function(GripperData) updates) => super.copyWith((message) => updates(message as GripperData)) as GripperData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GripperData create() => GripperData._();
  GripperData createEmptyInstance() => create();
  static $pb.PbList<GripperData> createRepeated() => $pb.PbList<GripperData>();
  @$core.pragma('dart2js:noInline')
  static GripperData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GripperData>(create);
  static GripperData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get rotation => $_getN(0);
  @$pb.TagNumber(1)
  set rotation($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRotation() => $_has(0);
  @$pb.TagNumber(1)
  void clearRotation() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get swivel => $_getN(1);
  @$pb.TagNumber(2)
  set swivel($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSwivel() => $_has(1);
  @$pb.TagNumber(2)
  void clearSwivel() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get pinch => $_getN(2);
  @$pb.TagNumber(3)
  set pinch($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPinch() => $_has(2);
  @$pb.TagNumber(3)
  void clearPinch() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get motorTemperature => $_getN(3);
  @$pb.TagNumber(4)
  set motorTemperature($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMotorTemperature() => $_has(3);
  @$pb.TagNumber(4)
  void clearMotorTemperature() => clearField(4);
}

class GripperCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GripperCommand', createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stop')
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'moveRotate', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'moveLift', $pb.PbFieldType.OF)
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'moveGripper', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  GripperCommand._() : super();
  factory GripperCommand({
    $core.bool? stop,
    $core.double? moveRotate,
    $core.double? moveLift,
    $core.double? moveGripper,
  }) {
    final _result = create();
    if (stop != null) {
      _result.stop = stop;
    }
    if (moveRotate != null) {
      _result.moveRotate = moveRotate;
    }
    if (moveLift != null) {
      _result.moveLift = moveLift;
    }
    if (moveGripper != null) {
      _result.moveGripper = moveGripper;
    }
    return _result;
  }
  factory GripperCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GripperCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GripperCommand clone() => GripperCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GripperCommand copyWith(void Function(GripperCommand) updates) => super.copyWith((message) => updates(message as GripperCommand)) as GripperCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GripperCommand create() => GripperCommand._();
  GripperCommand createEmptyInstance() => create();
  static $pb.PbList<GripperCommand> createRepeated() => $pb.PbList<GripperCommand>();
  @$core.pragma('dart2js:noInline')
  static GripperCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GripperCommand>(create);
  static GripperCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get stop => $_getBF(0);
  @$pb.TagNumber(1)
  set stop($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStop() => $_has(0);
  @$pb.TagNumber(1)
  void clearStop() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get moveRotate => $_getN(1);
  @$pb.TagNumber(2)
  set moveRotate($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMoveRotate() => $_has(1);
  @$pb.TagNumber(2)
  void clearMoveRotate() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get moveLift => $_getN(2);
  @$pb.TagNumber(3)
  set moveLift($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMoveLift() => $_has(2);
  @$pb.TagNumber(3)
  void clearMoveLift() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get moveGripper => $_getN(3);
  @$pb.TagNumber(4)
  set moveGripper($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMoveGripper() => $_has(3);
  @$pb.TagNumber(4)
  void clearMoveGripper() => clearField(4);
}

class HreiData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'HreiData', createEmptyInstance: create)
    ..aOM<ArmData>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'armData', subBuilder: ArmData.create)
    ..aOM<GripperData>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gripperData', subBuilder: GripperData.create)
    ..hasRequiredFields = false
  ;

  HreiData._() : super();
  factory HreiData({
    ArmData? armData,
    GripperData? gripperData,
  }) {
    final _result = create();
    if (armData != null) {
      _result.armData = armData;
    }
    if (gripperData != null) {
      _result.gripperData = gripperData;
    }
    return _result;
  }
  factory HreiData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HreiData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HreiData clone() => HreiData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HreiData copyWith(void Function(HreiData) updates) => super.copyWith((message) => updates(message as HreiData)) as HreiData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HreiData create() => HreiData._();
  HreiData createEmptyInstance() => create();
  static $pb.PbList<HreiData> createRepeated() => $pb.PbList<HreiData>();
  @$core.pragma('dart2js:noInline')
  static HreiData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HreiData>(create);
  static HreiData? _defaultInstance;

  @$pb.TagNumber(1)
  ArmData get armData => $_getN(0);
  @$pb.TagNumber(1)
  set armData(ArmData v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasArmData() => $_has(0);
  @$pb.TagNumber(1)
  void clearArmData() => clearField(1);
  @$pb.TagNumber(1)
  ArmData ensureArmData() => $_ensure(0);

  @$pb.TagNumber(2)
  GripperData get gripperData => $_getN(1);
  @$pb.TagNumber(2)
  set gripperData(GripperData v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasGripperData() => $_has(1);
  @$pb.TagNumber(2)
  void clearGripperData() => clearField(2);
  @$pb.TagNumber(2)
  GripperData ensureGripperData() => $_ensure(1);
}

class HreiCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'HreiCommand', createEmptyInstance: create)
    ..aOM<ArmCommand>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'armCommand', subBuilder: ArmCommand.create)
    ..aOM<GripperCommand>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gripperCommand', subBuilder: GripperCommand.create)
    ..hasRequiredFields = false
  ;

  HreiCommand._() : super();
  factory HreiCommand({
    ArmCommand? armCommand,
    GripperCommand? gripperCommand,
  }) {
    final _result = create();
    if (armCommand != null) {
      _result.armCommand = armCommand;
    }
    if (gripperCommand != null) {
      _result.gripperCommand = gripperCommand;
    }
    return _result;
  }
  factory HreiCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HreiCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HreiCommand clone() => HreiCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HreiCommand copyWith(void Function(HreiCommand) updates) => super.copyWith((message) => updates(message as HreiCommand)) as HreiCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HreiCommand create() => HreiCommand._();
  HreiCommand createEmptyInstance() => create();
  static $pb.PbList<HreiCommand> createRepeated() => $pb.PbList<HreiCommand>();
  @$core.pragma('dart2js:noInline')
  static HreiCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HreiCommand>(create);
  static HreiCommand? _defaultInstance;

  @$pb.TagNumber(1)
  ArmCommand get armCommand => $_getN(0);
  @$pb.TagNumber(1)
  set armCommand(ArmCommand v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasArmCommand() => $_has(0);
  @$pb.TagNumber(1)
  void clearArmCommand() => clearField(1);
  @$pb.TagNumber(1)
  ArmCommand ensureArmCommand() => $_ensure(0);

  @$pb.TagNumber(2)
  GripperCommand get gripperCommand => $_getN(1);
  @$pb.TagNumber(2)
  set gripperCommand(GripperCommand v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasGripperCommand() => $_has(1);
  @$pb.TagNumber(2)
  void clearGripperCommand() => clearField(2);
  @$pb.TagNumber(2)
  GripperCommand ensureGripperCommand() => $_ensure(1);
}

