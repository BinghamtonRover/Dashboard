///
//  Generated code. Do not modify.
//  source: video.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AdjustCamera extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AdjustCamera', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isEnabled')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'resolution', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  AdjustCamera._() : super();
  factory AdjustCamera({
    $core.int? id,
    $core.bool? isEnabled,
    $core.int? resolution,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (isEnabled != null) {
      _result.isEnabled = isEnabled;
    }
    if (resolution != null) {
      _result.resolution = resolution;
    }
    return _result;
  }
  factory AdjustCamera.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AdjustCamera.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AdjustCamera clone() => AdjustCamera()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AdjustCamera copyWith(void Function(AdjustCamera) updates) => super.copyWith((message) => updates(message as AdjustCamera)) as AdjustCamera; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AdjustCamera create() => AdjustCamera._();
  AdjustCamera createEmptyInstance() => create();
  static $pb.PbList<AdjustCamera> createRepeated() => $pb.PbList<AdjustCamera>();
  @$core.pragma('dart2js:noInline')
  static AdjustCamera getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AdjustCamera>(create);
  static AdjustCamera? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isEnabled => $_getBF(1);
  @$pb.TagNumber(2)
  set isEnabled($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIsEnabled() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsEnabled() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get resolution => $_getIZ(2);
  @$pb.TagNumber(3)
  set resolution($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasResolution() => $_has(2);
  @$pb.TagNumber(3)
  void clearResolution() => clearField(3);
}

class CameraStatus extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CameraStatus', createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isEnabled')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'resolution', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  CameraStatus._() : super();
  factory CameraStatus({
    $core.int? id,
    $core.bool? isEnabled,
    $core.int? resolution,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (isEnabled != null) {
      _result.isEnabled = isEnabled;
    }
    if (resolution != null) {
      _result.resolution = resolution;
    }
    return _result;
  }
  factory CameraStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CameraStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CameraStatus clone() => CameraStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CameraStatus copyWith(void Function(CameraStatus) updates) => super.copyWith((message) => updates(message as CameraStatus)) as CameraStatus; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CameraStatus create() => CameraStatus._();
  CameraStatus createEmptyInstance() => create();
  static $pb.PbList<CameraStatus> createRepeated() => $pb.PbList<CameraStatus>();
  @$core.pragma('dart2js:noInline')
  static CameraStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CameraStatus>(create);
  static CameraStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isEnabled => $_getBF(1);
  @$pb.TagNumber(2)
  set isEnabled($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIsEnabled() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsEnabled() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get resolution => $_getIZ(2);
  @$pb.TagNumber(3)
  set resolution($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasResolution() => $_has(2);
  @$pb.TagNumber(3)
  void clearResolution() => clearField(3);
}

class VideoData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'VideoData', createEmptyInstance: create)
    ..pc<CameraStatus>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cameras', $pb.PbFieldType.PM, subBuilder: CameraStatus.create)
    ..hasRequiredFields = false
  ;

  VideoData._() : super();
  factory VideoData({
    $core.Iterable<CameraStatus>? cameras,
  }) {
    final _result = create();
    if (cameras != null) {
      _result.cameras.addAll(cameras);
    }
    return _result;
  }
  factory VideoData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VideoData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VideoData clone() => VideoData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VideoData copyWith(void Function(VideoData) updates) => super.copyWith((message) => updates(message as VideoData)) as VideoData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static VideoData create() => VideoData._();
  VideoData createEmptyInstance() => create();
  static $pb.PbList<VideoData> createRepeated() => $pb.PbList<VideoData>();
  @$core.pragma('dart2js:noInline')
  static VideoData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VideoData>(create);
  static VideoData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<CameraStatus> get cameras => $_getList(0);
}
