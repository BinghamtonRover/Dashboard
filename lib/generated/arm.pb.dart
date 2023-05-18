///
//  Generated code. Do not modify.
//  source: arm.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'arm.pbenum.dart';

export 'arm.pbenum.dart';

class Coordinates extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Coordinates', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'x', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'y', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'z', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  Coordinates._() : super();
  factory Coordinates({
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
  factory Coordinates.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Coordinates.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Coordinates clone() => Coordinates()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Coordinates copyWith(void Function(Coordinates) updates) => super.copyWith((message) => updates(message as Coordinates)) as Coordinates; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Coordinates create() => Coordinates._();
  Coordinates createEmptyInstance() => create();
  static $pb.PbList<Coordinates> createRepeated() => $pb.PbList<Coordinates>();
  @$core.pragma('dart2js:noInline')
  static Coordinates getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Coordinates>(create);
  static Coordinates? _defaultInstance;

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

class MotorData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MotorData', createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isMoving')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isLimitSwitchPressed')
    ..e<MotorDirection>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'direction', $pb.PbFieldType.OE, defaultOrMaker: MotorDirection.MOTOR_DIRECTION_UNDEFINED, valueOf: MotorDirection.valueOf, enumValues: MotorDirection.values)
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'currentStep', $pb.PbFieldType.O3)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'targetStep', $pb.PbFieldType.O3)
    ..a<$core.double>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'angle', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  MotorData._() : super();
  factory MotorData({
    $core.bool? isMoving,
    $core.bool? isLimitSwitchPressed,
    MotorDirection? direction,
    $core.int? currentStep,
    $core.int? targetStep,
    $core.double? angle,
  }) {
    final _result = create();
    if (isMoving != null) {
      _result.isMoving = isMoving;
    }
    if (isLimitSwitchPressed != null) {
      _result.isLimitSwitchPressed = isLimitSwitchPressed;
    }
    if (direction != null) {
      _result.direction = direction;
    }
    if (currentStep != null) {
      _result.currentStep = currentStep;
    }
    if (targetStep != null) {
      _result.targetStep = targetStep;
    }
    if (angle != null) {
      _result.angle = angle;
    }
    return _result;
  }
  factory MotorData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MotorData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MotorData clone() => MotorData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MotorData copyWith(void Function(MotorData) updates) => super.copyWith((message) => updates(message as MotorData)) as MotorData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MotorData create() => MotorData._();
  MotorData createEmptyInstance() => create();
  static $pb.PbList<MotorData> createRepeated() => $pb.PbList<MotorData>();
  @$core.pragma('dart2js:noInline')
  static MotorData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MotorData>(create);
  static MotorData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isMoving => $_getBF(0);
  @$pb.TagNumber(1)
  set isMoving($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIsMoving() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsMoving() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isLimitSwitchPressed => $_getBF(1);
  @$pb.TagNumber(2)
  set isLimitSwitchPressed($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIsLimitSwitchPressed() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsLimitSwitchPressed() => clearField(2);

  @$pb.TagNumber(3)
  MotorDirection get direction => $_getN(2);
  @$pb.TagNumber(3)
  set direction(MotorDirection v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasDirection() => $_has(2);
  @$pb.TagNumber(3)
  void clearDirection() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get currentStep => $_getIZ(3);
  @$pb.TagNumber(4)
  set currentStep($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCurrentStep() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrentStep() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get targetStep => $_getIZ(4);
  @$pb.TagNumber(5)
  set targetStep($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTargetStep() => $_has(4);
  @$pb.TagNumber(5)
  void clearTargetStep() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get angle => $_getN(5);
  @$pb.TagNumber(6)
  set angle($core.double v) { $_setFloat(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasAngle() => $_has(5);
  @$pb.TagNumber(6)
  void clearAngle() => clearField(6);
}

class MotorCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'MotorCommand', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'moveSteps', $pb.PbFieldType.O3)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'moveRadians', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  MotorCommand._() : super();
  factory MotorCommand({
    $core.int? moveSteps,
    $core.double? moveRadians,
  }) {
    final _result = create();
    if (moveSteps != null) {
      _result.moveSteps = moveSteps;
    }
    if (moveRadians != null) {
      _result.moveRadians = moveRadians;
    }
    return _result;
  }
  factory MotorCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MotorCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MotorCommand clone() => MotorCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MotorCommand copyWith(void Function(MotorCommand) updates) => super.copyWith((message) => updates(message as MotorCommand)) as MotorCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static MotorCommand create() => MotorCommand._();
  MotorCommand createEmptyInstance() => create();
  static $pb.PbList<MotorCommand> createRepeated() => $pb.PbList<MotorCommand>();
  @$core.pragma('dart2js:noInline')
  static MotorCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MotorCommand>(create);
  static MotorCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get moveSteps => $_getIZ(0);
  @$pb.TagNumber(1)
  set moveSteps($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMoveSteps() => $_has(0);
  @$pb.TagNumber(1)
  void clearMoveSteps() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get moveRadians => $_getN(1);
  @$pb.TagNumber(2)
  set moveRadians($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMoveRadians() => $_has(1);
  @$pb.TagNumber(2)
  void clearMoveRadians() => clearField(2);
}

class ArmData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ArmData', createEmptyInstance: create)
    ..aOM<Coordinates>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'currentPosition', protoName: 'currentPosition', subBuilder: Coordinates.create)
    ..aOM<Coordinates>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'targetPosition', protoName: 'targetPosition', subBuilder: Coordinates.create)
    ..aOM<MotorData>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'base', subBuilder: MotorData.create)
    ..aOM<MotorData>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'shoulder', subBuilder: MotorData.create)
    ..aOM<MotorData>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'elbow', subBuilder: MotorData.create)
    ..hasRequiredFields = false
  ;

  ArmData._() : super();
  factory ArmData({
    Coordinates? currentPosition,
    Coordinates? targetPosition,
    MotorData? base,
    MotorData? shoulder,
    MotorData? elbow,
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
  Coordinates get currentPosition => $_getN(0);
  @$pb.TagNumber(1)
  set currentPosition(Coordinates v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCurrentPosition() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentPosition() => clearField(1);
  @$pb.TagNumber(1)
  Coordinates ensureCurrentPosition() => $_ensure(0);

  @$pb.TagNumber(2)
  Coordinates get targetPosition => $_getN(1);
  @$pb.TagNumber(2)
  set targetPosition(Coordinates v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasTargetPosition() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetPosition() => clearField(2);
  @$pb.TagNumber(2)
  Coordinates ensureTargetPosition() => $_ensure(1);

  @$pb.TagNumber(3)
  MotorData get base => $_getN(2);
  @$pb.TagNumber(3)
  set base(MotorData v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasBase() => $_has(2);
  @$pb.TagNumber(3)
  void clearBase() => clearField(3);
  @$pb.TagNumber(3)
  MotorData ensureBase() => $_ensure(2);

  @$pb.TagNumber(4)
  MotorData get shoulder => $_getN(3);
  @$pb.TagNumber(4)
  set shoulder(MotorData v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasShoulder() => $_has(3);
  @$pb.TagNumber(4)
  void clearShoulder() => clearField(4);
  @$pb.TagNumber(4)
  MotorData ensureShoulder() => $_ensure(3);

  @$pb.TagNumber(5)
  MotorData get elbow => $_getN(4);
  @$pb.TagNumber(5)
  set elbow(MotorData v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasElbow() => $_has(4);
  @$pb.TagNumber(5)
  void clearElbow() => clearField(5);
  @$pb.TagNumber(5)
  MotorData ensureElbow() => $_ensure(4);
}

class ArmCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ArmCommand', createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stop')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'calibrate')
    ..aOM<MotorCommand>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'swivel', subBuilder: MotorCommand.create)
    ..aOM<MotorCommand>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'shoulder', subBuilder: MotorCommand.create)
    ..aOM<MotorCommand>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'elbow', subBuilder: MotorCommand.create)
    ..aOM<MotorCommand>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gripperLift', subBuilder: MotorCommand.create)
    ..a<$core.double>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ikX', $pb.PbFieldType.OF)
    ..a<$core.double>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ikY', $pb.PbFieldType.OF)
    ..a<$core.double>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ikZ', $pb.PbFieldType.OF)
    ..aOB(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'jab')
    ..hasRequiredFields = false
  ;

  ArmCommand._() : super();
  factory ArmCommand({
    $core.bool? stop,
    $core.bool? calibrate,
    MotorCommand? swivel,
    MotorCommand? shoulder,
    MotorCommand? elbow,
    MotorCommand? gripperLift,
    $core.double? ikX,
    $core.double? ikY,
    $core.double? ikZ,
    $core.bool? jab,
  }) {
    final _result = create();
    if (stop != null) {
      _result.stop = stop;
    }
    if (calibrate != null) {
      _result.calibrate = calibrate;
    }
    if (swivel != null) {
      _result.swivel = swivel;
    }
    if (shoulder != null) {
      _result.shoulder = shoulder;
    }
    if (elbow != null) {
      _result.elbow = elbow;
    }
    if (gripperLift != null) {
      _result.gripperLift = gripperLift;
    }
    if (ikX != null) {
      _result.ikX = ikX;
    }
    if (ikY != null) {
      _result.ikY = ikY;
    }
    if (ikZ != null) {
      _result.ikZ = ikZ;
    }
    if (jab != null) {
      _result.jab = jab;
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
  $core.bool get calibrate => $_getBF(1);
  @$pb.TagNumber(2)
  set calibrate($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCalibrate() => $_has(1);
  @$pb.TagNumber(2)
  void clearCalibrate() => clearField(2);

  @$pb.TagNumber(3)
  MotorCommand get swivel => $_getN(2);
  @$pb.TagNumber(3)
  set swivel(MotorCommand v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSwivel() => $_has(2);
  @$pb.TagNumber(3)
  void clearSwivel() => clearField(3);
  @$pb.TagNumber(3)
  MotorCommand ensureSwivel() => $_ensure(2);

  @$pb.TagNumber(4)
  MotorCommand get shoulder => $_getN(3);
  @$pb.TagNumber(4)
  set shoulder(MotorCommand v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasShoulder() => $_has(3);
  @$pb.TagNumber(4)
  void clearShoulder() => clearField(4);
  @$pb.TagNumber(4)
  MotorCommand ensureShoulder() => $_ensure(3);

  @$pb.TagNumber(5)
  MotorCommand get elbow => $_getN(4);
  @$pb.TagNumber(5)
  set elbow(MotorCommand v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasElbow() => $_has(4);
  @$pb.TagNumber(5)
  void clearElbow() => clearField(5);
  @$pb.TagNumber(5)
  MotorCommand ensureElbow() => $_ensure(4);

  @$pb.TagNumber(6)
  MotorCommand get gripperLift => $_getN(5);
  @$pb.TagNumber(6)
  set gripperLift(MotorCommand v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasGripperLift() => $_has(5);
  @$pb.TagNumber(6)
  void clearGripperLift() => clearField(6);
  @$pb.TagNumber(6)
  MotorCommand ensureGripperLift() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.double get ikX => $_getN(6);
  @$pb.TagNumber(7)
  set ikX($core.double v) { $_setFloat(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasIkX() => $_has(6);
  @$pb.TagNumber(7)
  void clearIkX() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get ikY => $_getN(7);
  @$pb.TagNumber(8)
  set ikY($core.double v) { $_setFloat(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasIkY() => $_has(7);
  @$pb.TagNumber(8)
  void clearIkY() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get ikZ => $_getN(8);
  @$pb.TagNumber(9)
  set ikZ($core.double v) { $_setFloat(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasIkZ() => $_has(8);
  @$pb.TagNumber(9)
  void clearIkZ() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get jab => $_getBF(9);
  @$pb.TagNumber(10)
  set jab($core.bool v) { $_setBool(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasJab() => $_has(9);
  @$pb.TagNumber(10)
  void clearJab() => clearField(10);
}

class GripperData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GripperData', createEmptyInstance: create)
    ..aOM<MotorData>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lift', subBuilder: MotorData.create)
    ..aOM<MotorData>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rotate', subBuilder: MotorData.create)
    ..aOM<MotorData>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pinch', subBuilder: MotorData.create)
    ..hasRequiredFields = false
  ;

  GripperData._() : super();
  factory GripperData({
    MotorData? lift,
    MotorData? rotate,
    MotorData? pinch,
  }) {
    final _result = create();
    if (lift != null) {
      _result.lift = lift;
    }
    if (rotate != null) {
      _result.rotate = rotate;
    }
    if (pinch != null) {
      _result.pinch = pinch;
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
  MotorData get lift => $_getN(0);
  @$pb.TagNumber(1)
  set lift(MotorData v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasLift() => $_has(0);
  @$pb.TagNumber(1)
  void clearLift() => clearField(1);
  @$pb.TagNumber(1)
  MotorData ensureLift() => $_ensure(0);

  @$pb.TagNumber(2)
  MotorData get rotate => $_getN(1);
  @$pb.TagNumber(2)
  set rotate(MotorData v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRotate() => $_has(1);
  @$pb.TagNumber(2)
  void clearRotate() => clearField(2);
  @$pb.TagNumber(2)
  MotorData ensureRotate() => $_ensure(1);

  @$pb.TagNumber(3)
  MotorData get pinch => $_getN(2);
  @$pb.TagNumber(3)
  set pinch(MotorData v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPinch() => $_has(2);
  @$pb.TagNumber(3)
  void clearPinch() => clearField(3);
  @$pb.TagNumber(3)
  MotorData ensurePinch() => $_ensure(2);
}

class GripperCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GripperCommand', createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stop')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'calibrate')
    ..aOM<MotorCommand>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lift', subBuilder: MotorCommand.create)
    ..aOM<MotorCommand>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rotate', subBuilder: MotorCommand.create)
    ..aOM<MotorCommand>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pinch', subBuilder: MotorCommand.create)
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'open')
    ..aOB(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'close')
    ..aOB(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'spin')
    ..hasRequiredFields = false
  ;

  GripperCommand._() : super();
  factory GripperCommand({
    $core.bool? stop,
    $core.bool? calibrate,
    MotorCommand? lift,
    MotorCommand? rotate,
    MotorCommand? pinch,
    $core.bool? open,
    $core.bool? close,
    $core.bool? spin,
  }) {
    final _result = create();
    if (stop != null) {
      _result.stop = stop;
    }
    if (calibrate != null) {
      _result.calibrate = calibrate;
    }
    if (lift != null) {
      _result.lift = lift;
    }
    if (rotate != null) {
      _result.rotate = rotate;
    }
    if (pinch != null) {
      _result.pinch = pinch;
    }
    if (open != null) {
      _result.open = open;
    }
    if (close != null) {
      _result.close = close;
    }
    if (spin != null) {
      _result.spin = spin;
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
  $core.bool get calibrate => $_getBF(1);
  @$pb.TagNumber(2)
  set calibrate($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCalibrate() => $_has(1);
  @$pb.TagNumber(2)
  void clearCalibrate() => clearField(2);

  @$pb.TagNumber(3)
  MotorCommand get lift => $_getN(2);
  @$pb.TagNumber(3)
  set lift(MotorCommand v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasLift() => $_has(2);
  @$pb.TagNumber(3)
  void clearLift() => clearField(3);
  @$pb.TagNumber(3)
  MotorCommand ensureLift() => $_ensure(2);

  @$pb.TagNumber(4)
  MotorCommand get rotate => $_getN(3);
  @$pb.TagNumber(4)
  set rotate(MotorCommand v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasRotate() => $_has(3);
  @$pb.TagNumber(4)
  void clearRotate() => clearField(4);
  @$pb.TagNumber(4)
  MotorCommand ensureRotate() => $_ensure(3);

  @$pb.TagNumber(5)
  MotorCommand get pinch => $_getN(4);
  @$pb.TagNumber(5)
  set pinch(MotorCommand v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasPinch() => $_has(4);
  @$pb.TagNumber(5)
  void clearPinch() => clearField(5);
  @$pb.TagNumber(5)
  MotorCommand ensurePinch() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.bool get open => $_getBF(5);
  @$pb.TagNumber(6)
  set open($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasOpen() => $_has(5);
  @$pb.TagNumber(6)
  void clearOpen() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get close => $_getBF(6);
  @$pb.TagNumber(7)
  set close($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasClose() => $_has(6);
  @$pb.TagNumber(7)
  void clearClose() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get spin => $_getBF(7);
  @$pb.TagNumber(8)
  set spin($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasSpin() => $_has(7);
  @$pb.TagNumber(8)
  void clearSpin() => clearField(8);
}

