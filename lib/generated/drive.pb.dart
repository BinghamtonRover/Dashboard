///
//  Generated code. Do not modify.
//  source: drive.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class DriveCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DriveCommand', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'throttle', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'left', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'right', $pb.PbFieldType.OF)
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'setLeft')
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'setRight')
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'setThrottle')
    ..a<$core.double>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'frontSwivel', $pb.PbFieldType.OF)
    ..a<$core.double>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'frontTilt', $pb.PbFieldType.OF)
    ..a<$core.double>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rearSwivel', $pb.PbFieldType.OF)
    ..a<$core.double>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rearTilt', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  DriveCommand._() : super();
  factory DriveCommand({
    $core.double? throttle,
    $core.double? left,
    $core.double? right,
    $core.bool? setLeft,
    $core.bool? setRight,
    $core.bool? setThrottle,
    $core.double? frontSwivel,
    $core.double? frontTilt,
    $core.double? rearSwivel,
    $core.double? rearTilt,
  }) {
    final _result = create();
    if (throttle != null) {
      _result.throttle = throttle;
    }
    if (left != null) {
      _result.left = left;
    }
    if (right != null) {
      _result.right = right;
    }
    if (setLeft != null) {
      _result.setLeft = setLeft;
    }
    if (setRight != null) {
      _result.setRight = setRight;
    }
    if (setThrottle != null) {
      _result.setThrottle = setThrottle;
    }
    if (frontSwivel != null) {
      _result.frontSwivel = frontSwivel;
    }
    if (frontTilt != null) {
      _result.frontTilt = frontTilt;
    }
    if (rearSwivel != null) {
      _result.rearSwivel = rearSwivel;
    }
    if (rearTilt != null) {
      _result.rearTilt = rearTilt;
    }
    return _result;
  }
  factory DriveCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DriveCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DriveCommand clone() => DriveCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DriveCommand copyWith(void Function(DriveCommand) updates) => super.copyWith((message) => updates(message as DriveCommand)) as DriveCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DriveCommand create() => DriveCommand._();
  DriveCommand createEmptyInstance() => create();
  static $pb.PbList<DriveCommand> createRepeated() => $pb.PbList<DriveCommand>();
  @$core.pragma('dart2js:noInline')
  static DriveCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DriveCommand>(create);
  static DriveCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get throttle => $_getN(0);
  @$pb.TagNumber(1)
  set throttle($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasThrottle() => $_has(0);
  @$pb.TagNumber(1)
  void clearThrottle() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get left => $_getN(1);
  @$pb.TagNumber(2)
  set left($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLeft() => $_has(1);
  @$pb.TagNumber(2)
  void clearLeft() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get right => $_getN(2);
  @$pb.TagNumber(3)
  set right($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRight() => $_has(2);
  @$pb.TagNumber(3)
  void clearRight() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get setLeft => $_getBF(3);
  @$pb.TagNumber(4)
  set setLeft($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSetLeft() => $_has(3);
  @$pb.TagNumber(4)
  void clearSetLeft() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get setRight => $_getBF(4);
  @$pb.TagNumber(5)
  set setRight($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSetRight() => $_has(4);
  @$pb.TagNumber(5)
  void clearSetRight() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get setThrottle => $_getBF(5);
  @$pb.TagNumber(6)
  set setThrottle($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSetThrottle() => $_has(5);
  @$pb.TagNumber(6)
  void clearSetThrottle() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get frontSwivel => $_getN(6);
  @$pb.TagNumber(7)
  set frontSwivel($core.double v) { $_setFloat(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasFrontSwivel() => $_has(6);
  @$pb.TagNumber(7)
  void clearFrontSwivel() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get frontTilt => $_getN(7);
  @$pb.TagNumber(8)
  set frontTilt($core.double v) { $_setFloat(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasFrontTilt() => $_has(7);
  @$pb.TagNumber(8)
  void clearFrontTilt() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get rearSwivel => $_getN(8);
  @$pb.TagNumber(9)
  set rearSwivel($core.double v) { $_setFloat(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasRearSwivel() => $_has(8);
  @$pb.TagNumber(9)
  void clearRearSwivel() => clearField(9);

  @$pb.TagNumber(10)
  $core.double get rearTilt => $_getN(9);
  @$pb.TagNumber(10)
  set rearTilt($core.double v) { $_setFloat(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasRearTilt() => $_has(9);
  @$pb.TagNumber(10)
  void clearRearTilt() => clearField(10);
}

class DriveData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DriveData', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'throttle', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'left', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'right', $pb.PbFieldType.OF)
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'setLeft')
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'setRight')
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'setThrottle')
    ..a<$core.double>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'frontSwivel', $pb.PbFieldType.OF)
    ..a<$core.double>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'frontTilt', $pb.PbFieldType.OF)
    ..a<$core.double>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rearSwivel', $pb.PbFieldType.OF)
    ..a<$core.double>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rearTilt', $pb.PbFieldType.OF)
    ..a<$core.double>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'leftSensorValue', $pb.PbFieldType.OF, protoName: 'leftSensorValue')
    ..a<$core.double>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rightSensorValue', $pb.PbFieldType.OF, protoName: 'rightSensorValue')
    ..hasRequiredFields = false
  ;

  DriveData._() : super();
  factory DriveData({
    $core.double? throttle,
    $core.double? left,
    $core.double? right,
    $core.bool? setLeft,
    $core.bool? setRight,
    $core.bool? setThrottle,
    $core.double? frontSwivel,
    $core.double? frontTilt,
    $core.double? rearSwivel,
    $core.double? rearTilt,
    $core.double? leftSensorValue,
    $core.double? rightSensorValue,
  }) {
    final _result = create();
    if (throttle != null) {
      _result.throttle = throttle;
    }
    if (left != null) {
      _result.left = left;
    }
    if (right != null) {
      _result.right = right;
    }
    if (setLeft != null) {
      _result.setLeft = setLeft;
    }
    if (setRight != null) {
      _result.setRight = setRight;
    }
    if (setThrottle != null) {
      _result.setThrottle = setThrottle;
    }
    if (frontSwivel != null) {
      _result.frontSwivel = frontSwivel;
    }
    if (frontTilt != null) {
      _result.frontTilt = frontTilt;
    }
    if (rearSwivel != null) {
      _result.rearSwivel = rearSwivel;
    }
    if (rearTilt != null) {
      _result.rearTilt = rearTilt;
    }
    if (leftSensorValue != null) {
      _result.leftSensorValue = leftSensorValue;
    }
    if (rightSensorValue != null) {
      _result.rightSensorValue = rightSensorValue;
    }
    return _result;
  }
  factory DriveData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DriveData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DriveData clone() => DriveData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DriveData copyWith(void Function(DriveData) updates) => super.copyWith((message) => updates(message as DriveData)) as DriveData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DriveData create() => DriveData._();
  DriveData createEmptyInstance() => create();
  static $pb.PbList<DriveData> createRepeated() => $pb.PbList<DriveData>();
  @$core.pragma('dart2js:noInline')
  static DriveData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DriveData>(create);
  static DriveData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get throttle => $_getN(0);
  @$pb.TagNumber(1)
  set throttle($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasThrottle() => $_has(0);
  @$pb.TagNumber(1)
  void clearThrottle() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get left => $_getN(1);
  @$pb.TagNumber(2)
  set left($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLeft() => $_has(1);
  @$pb.TagNumber(2)
  void clearLeft() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get right => $_getN(2);
  @$pb.TagNumber(3)
  set right($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRight() => $_has(2);
  @$pb.TagNumber(3)
  void clearRight() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get setLeft => $_getBF(3);
  @$pb.TagNumber(4)
  set setLeft($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSetLeft() => $_has(3);
  @$pb.TagNumber(4)
  void clearSetLeft() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get setRight => $_getBF(4);
  @$pb.TagNumber(5)
  set setRight($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSetRight() => $_has(4);
  @$pb.TagNumber(5)
  void clearSetRight() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get setThrottle => $_getBF(5);
  @$pb.TagNumber(6)
  set setThrottle($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSetThrottle() => $_has(5);
  @$pb.TagNumber(6)
  void clearSetThrottle() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get frontSwivel => $_getN(6);
  @$pb.TagNumber(7)
  set frontSwivel($core.double v) { $_setFloat(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasFrontSwivel() => $_has(6);
  @$pb.TagNumber(7)
  void clearFrontSwivel() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get frontTilt => $_getN(7);
  @$pb.TagNumber(8)
  set frontTilt($core.double v) { $_setFloat(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasFrontTilt() => $_has(7);
  @$pb.TagNumber(8)
  void clearFrontTilt() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get rearSwivel => $_getN(8);
  @$pb.TagNumber(9)
  set rearSwivel($core.double v) { $_setFloat(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasRearSwivel() => $_has(8);
  @$pb.TagNumber(9)
  void clearRearSwivel() => clearField(9);

  @$pb.TagNumber(10)
  $core.double get rearTilt => $_getN(9);
  @$pb.TagNumber(10)
  set rearTilt($core.double v) { $_setFloat(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasRearTilt() => $_has(9);
  @$pb.TagNumber(10)
  void clearRearTilt() => clearField(10);

  @$pb.TagNumber(11)
  $core.double get leftSensorValue => $_getN(10);
  @$pb.TagNumber(11)
  set leftSensorValue($core.double v) { $_setFloat(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasLeftSensorValue() => $_has(10);
  @$pb.TagNumber(11)
  void clearLeftSensorValue() => clearField(11);

  @$pb.TagNumber(12)
  $core.double get rightSensorValue => $_getN(11);
  @$pb.TagNumber(12)
  set rightSensorValue($core.double v) { $_setFloat(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasRightSensorValue() => $_has(11);
  @$pb.TagNumber(12)
  void clearRightSensorValue() => clearField(12);
}

