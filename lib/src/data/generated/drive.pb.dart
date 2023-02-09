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
    ..hasRequiredFields = false
  ;

  DriveCommand._() : super();
  factory DriveCommand({
    $core.double? throttle,
    $core.double? left,
    $core.double? right,
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
}

class DriveData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DriveData', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'throttle', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'left', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'right', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  DriveData._() : super();
  factory DriveData({
    $core.double? throttle,
    $core.double? left,
    $core.double? right,
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
}

