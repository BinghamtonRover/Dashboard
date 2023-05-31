///
//  Generated code. Do not modify.
//  source: video.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'video.pbenum.dart';

export 'video.pbenum.dart';

class CameraDetails extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CameraDetails', createEmptyInstance: create)
    ..e<CameraName>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name', $pb.PbFieldType.OE, defaultOrMaker: CameraName.CAMERA_NAME_UNDEFINED, valueOf: CameraName.valueOf, enumValues: CameraName.values)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'resolutionWidth', $pb.PbFieldType.O3)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'resolutionHeight', $pb.PbFieldType.O3)
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'quality', $pb.PbFieldType.O3)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fps', $pb.PbFieldType.O3)
    ..e<CameraStatus>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: CameraStatus.CAMERA_STATUS_UNDEFINED, valueOf: CameraStatus.valueOf, enumValues: CameraStatus.values)
    ..hasRequiredFields = false
  ;

  CameraDetails._() : super();
  factory CameraDetails({
    CameraName? name,
    $core.int? resolutionWidth,
    $core.int? resolutionHeight,
    $core.int? quality,
    $core.int? fps,
    CameraStatus? status,
  }) {
    final _result = create();
    if (name != null) {
      _result.name = name;
    }
    if (resolutionWidth != null) {
      _result.resolutionWidth = resolutionWidth;
    }
    if (resolutionHeight != null) {
      _result.resolutionHeight = resolutionHeight;
    }
    if (quality != null) {
      _result.quality = quality;
    }
    if (fps != null) {
      _result.fps = fps;
    }
    if (status != null) {
      _result.status = status;
    }
    return _result;
  }
  factory CameraDetails.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CameraDetails.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CameraDetails clone() => CameraDetails()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CameraDetails copyWith(void Function(CameraDetails) updates) => super.copyWith((message) => updates(message as CameraDetails)) as CameraDetails; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CameraDetails create() => CameraDetails._();
  CameraDetails createEmptyInstance() => create();
  static $pb.PbList<CameraDetails> createRepeated() => $pb.PbList<CameraDetails>();
  @$core.pragma('dart2js:noInline')
  static CameraDetails getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CameraDetails>(create);
  static CameraDetails? _defaultInstance;

  @$pb.TagNumber(1)
  CameraName get name => $_getN(0);
  @$pb.TagNumber(1)
  set name(CameraName v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get resolutionWidth => $_getIZ(1);
  @$pb.TagNumber(2)
  set resolutionWidth($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasResolutionWidth() => $_has(1);
  @$pb.TagNumber(2)
  void clearResolutionWidth() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get resolutionHeight => $_getIZ(2);
  @$pb.TagNumber(3)
  set resolutionHeight($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasResolutionHeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearResolutionHeight() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get quality => $_getIZ(3);
  @$pb.TagNumber(4)
  set quality($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasQuality() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuality() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get fps => $_getIZ(4);
  @$pb.TagNumber(5)
  set fps($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasFps() => $_has(4);
  @$pb.TagNumber(5)
  void clearFps() => clearField(5);

  @$pb.TagNumber(6)
  CameraStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(CameraStatus v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => clearField(6);
}

class VideoData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'VideoData', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOM<CameraDetails>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'details', subBuilder: CameraDetails.create)
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'frame', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  VideoData._() : super();
  factory VideoData({
    $core.String? id,
    CameraDetails? details,
    $core.List<$core.int>? frame,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (details != null) {
      _result.details = details;
    }
    if (frame != null) {
      _result.frame = frame;
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
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  CameraDetails get details => $_getN(1);
  @$pb.TagNumber(2)
  set details(CameraDetails v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasDetails() => $_has(1);
  @$pb.TagNumber(2)
  void clearDetails() => clearField(2);
  @$pb.TagNumber(2)
  CameraDetails ensureDetails() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.List<$core.int> get frame => $_getN(2);
  @$pb.TagNumber(3)
  set frame($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFrame() => $_has(2);
  @$pb.TagNumber(3)
  void clearFrame() => clearField(3);
}

class VideoCommand extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'VideoCommand', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOM<CameraDetails>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'details', subBuilder: CameraDetails.create)
    ..hasRequiredFields = false
  ;

  VideoCommand._() : super();
  factory VideoCommand({
    $core.String? id,
    CameraDetails? details,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (details != null) {
      _result.details = details;
    }
    return _result;
  }
  factory VideoCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VideoCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VideoCommand clone() => VideoCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VideoCommand copyWith(void Function(VideoCommand) updates) => super.copyWith((message) => updates(message as VideoCommand)) as VideoCommand; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static VideoCommand create() => VideoCommand._();
  VideoCommand createEmptyInstance() => create();
  static $pb.PbList<VideoCommand> createRepeated() => $pb.PbList<VideoCommand>();
  @$core.pragma('dart2js:noInline')
  static VideoCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VideoCommand>(create);
  static VideoCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  CameraDetails get details => $_getN(1);
  @$pb.TagNumber(2)
  set details(CameraDetails v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasDetails() => $_has(1);
  @$pb.TagNumber(2)
  void clearDetails() => clearField(2);
  @$pb.TagNumber(2)
  CameraDetails ensureDetails() => $_ensure(1);
}

