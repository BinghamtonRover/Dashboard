///
//  Generated code. Do not modify.
//  source: drive_control.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'drive_control.pbenum.dart';

export 'drive_control.pbenum.dart';

class Velocity extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Velocity', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'drive'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'speed', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'angle', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  Velocity._() : super();
  factory Velocity({
    $core.double? speed,
    $core.double? angle,
  }) {
    final _result = create();
    if (speed != null) {
      _result.speed = speed;
    }
    if (angle != null) {
      _result.angle = angle;
    }
    return _result;
  }
  factory Velocity.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Velocity.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Velocity clone() => Velocity()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Velocity copyWith(void Function(Velocity) updates) => super.copyWith((message) => updates(message as Velocity)) as Velocity; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Velocity create() => Velocity._();
  Velocity createEmptyInstance() => create();
  static $pb.PbList<Velocity> createRepeated() => $pb.PbList<Velocity>();
  @$core.pragma('dart2js:noInline')
  static Velocity getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Velocity>(create);
  static Velocity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get speed => $_getN(0);
  @$pb.TagNumber(1)
  set speed($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSpeed() => $_has(0);
  @$pb.TagNumber(1)
  void clearSpeed() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get angle => $_getN(1);
  @$pb.TagNumber(2)
  set angle($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAngle() => $_has(1);
  @$pb.TagNumber(2)
  void clearAngle() => clearField(2);
}

class ActualSpeed extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ActualSpeed', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'drive'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'left', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'right', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  ActualSpeed._() : super();
  factory ActualSpeed({
    $core.double? left,
    $core.double? right,
  }) {
    final _result = create();
    if (left != null) {
      _result.left = left;
    }
    if (right != null) {
      _result.right = right;
    }
    return _result;
  }
  factory ActualSpeed.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ActualSpeed.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ActualSpeed clone() => ActualSpeed()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ActualSpeed copyWith(void Function(ActualSpeed) updates) => super.copyWith((message) => updates(message as ActualSpeed)) as ActualSpeed; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ActualSpeed create() => ActualSpeed._();
  ActualSpeed createEmptyInstance() => create();
  static $pb.PbList<ActualSpeed> createRepeated() => $pb.PbList<ActualSpeed>();
  @$core.pragma('dart2js:noInline')
  static ActualSpeed getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ActualSpeed>(create);
  static ActualSpeed? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get left => $_getN(0);
  @$pb.TagNumber(1)
  set left($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLeft() => $_has(0);
  @$pb.TagNumber(1)
  void clearLeft() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get right => $_getN(1);
  @$pb.TagNumber(2)
  set right($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRight() => $_has(1);
  @$pb.TagNumber(2)
  void clearRight() => clearField(2);
}

class Halt extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Halt', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'drive'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'halt')
    ..hasRequiredFields = false
  ;

  Halt._() : super();
  factory Halt({
    $core.bool? halt,
  }) {
    final _result = create();
    if (halt != null) {
      _result.halt = halt;
    }
    return _result;
  }
  factory Halt.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Halt.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Halt clone() => Halt()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Halt copyWith(void Function(Halt) updates) => super.copyWith((message) => updates(message as Halt)) as Halt; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Halt create() => Halt._();
  Halt createEmptyInstance() => create();
  static $pb.PbList<Halt> createRepeated() => $pb.PbList<Halt>();
  @$core.pragma('dart2js:noInline')
  static Halt getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Halt>(create);
  static Halt? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get halt => $_getBF(0);
  @$pb.TagNumber(1)
  set halt($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHalt() => $_has(0);
  @$pb.TagNumber(1)
  void clearHalt() => clearField(1);
}

class DriveMode extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DriveMode', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'drive'), createEmptyInstance: create)
    ..e<DriveMode_Mode>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mode', $pb.PbFieldType.OE, defaultOrMaker: DriveMode_Mode.NEUTRAL, valueOf: DriveMode_Mode.valueOf, enumValues: DriveMode_Mode.values)
    ..hasRequiredFields = false
  ;

  DriveMode._() : super();
  factory DriveMode({
    DriveMode_Mode? mode,
  }) {
    final _result = create();
    if (mode != null) {
      _result.mode = mode;
    }
    return _result;
  }
  factory DriveMode.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DriveMode.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DriveMode clone() => DriveMode()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DriveMode copyWith(void Function(DriveMode) updates) => super.copyWith((message) => updates(message as DriveMode)) as DriveMode; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DriveMode create() => DriveMode._();
  DriveMode createEmptyInstance() => create();
  static $pb.PbList<DriveMode> createRepeated() => $pb.PbList<DriveMode>();
  @$core.pragma('dart2js:noInline')
  static DriveMode getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DriveMode>(create);
  static DriveMode? _defaultInstance;

  @$pb.TagNumber(1)
  DriveMode_Mode get mode => $_getN(0);
  @$pb.TagNumber(1)
  set mode(DriveMode_Mode v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasMode() => $_has(0);
  @$pb.TagNumber(1)
  void clearMode() => clearField(1);
}

