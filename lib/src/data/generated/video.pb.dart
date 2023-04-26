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
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'resolutionWidth', $pb.PbFieldType.O3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'resolutionHeight', $pb.PbFieldType.O3)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'quality', $pb.PbFieldType.O3)
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'framerate', $pb.PbFieldType.OF)
    ..e<CameraStatus>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: CameraStatus.CAMERA_STATUS_UNDEFINED, valueOf: CameraStatus.valueOf, enumValues: CameraStatus.values)
    ..hasRequiredFields = false
  ;

  CameraDetails._() : super();
  factory CameraDetails({
    $core.int? resolutionWidth,
    $core.int? resolutionHeight,
    $core.int? quality,
    $core.double? framerate,
    CameraStatus? status,
  }) {
    final _result = create();
    if (resolutionWidth != null) {
      _result.resolutionWidth = resolutionWidth;
    }
    if (resolutionHeight != null) {
      _result.resolutionHeight = resolutionHeight;
    }
    if (quality != null) {
      _result.quality = quality;
    }
    if (framerate != null) {
      _result.framerate = framerate;
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
  $core.int get resolutionWidth => $_getIZ(0);
  @$pb.TagNumber(1)
  set resolutionWidth($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasResolutionWidth() => $_has(0);
  @$pb.TagNumber(1)
  void clearResolutionWidth() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get resolutionHeight => $_getIZ(1);
  @$pb.TagNumber(2)
  set resolutionHeight($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasResolutionHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearResolutionHeight() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get quality => $_getIZ(2);
  @$pb.TagNumber(3)
  set quality($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasQuality() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuality() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get framerate => $_getN(3);
  @$pb.TagNumber(4)
  set framerate($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasFramerate() => $_has(3);
  @$pb.TagNumber(4)
  void clearFramerate() => clearField(4);

  @$pb.TagNumber(5)
  CameraStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status(CameraStatus v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => clearField(5);
}

class VideoData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'VideoData', createEmptyInstance: create)
    ..e<CameraName>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name', $pb.PbFieldType.OE, defaultOrMaker: CameraName.CAMERA_NAME_UNDEFINED, valueOf: CameraName.valueOf, enumValues: CameraName.values)
    ..aOM<CameraDetails>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'details', subBuilder: CameraDetails.create)
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'frame', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  VideoData._() : super();
  factory VideoData({
    CameraName? name,
    CameraDetails? details,
    $core.List<$core.int>? frame,
  }) {
    final _result = create();
    if (name != null) {
      _result.name = name;
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
  CameraName get name => $_getN(0);
  @$pb.TagNumber(1)
  set name(CameraName v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

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
    ..e<CameraName>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name', $pb.PbFieldType.OE, defaultOrMaker: CameraName.CAMERA_NAME_UNDEFINED, valueOf: CameraName.valueOf, enumValues: CameraName.values)
    ..e<CameraName>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rename', $pb.PbFieldType.OE, defaultOrMaker: CameraName.CAMERA_NAME_UNDEFINED, valueOf: CameraName.valueOf, enumValues: CameraName.values)
    ..aOM<CameraDetails>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'details', subBuilder: CameraDetails.create)
    ..hasRequiredFields = false
  ;

  VideoCommand._() : super();
  factory VideoCommand({
    CameraName? name,
    CameraName? rename,
    CameraDetails? details,
  }) {
    final _result = create();
    if (name != null) {
      _result.name = name;
    }
    if (rename != null) {
      _result.rename = rename;
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
  CameraName get name => $_getN(0);
  @$pb.TagNumber(1)
  set name(CameraName v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  CameraName get rename => $_getN(1);
  @$pb.TagNumber(2)
  set rename(CameraName v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRename() => $_has(1);
  @$pb.TagNumber(2)
  void clearRename() => clearField(2);

  @$pb.TagNumber(3)
  CameraDetails get details => $_getN(2);
  @$pb.TagNumber(3)
  set details(CameraDetails v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasDetails() => $_has(2);
  @$pb.TagNumber(3)
  void clearDetails() => clearField(3);
  @$pb.TagNumber(3)
  CameraDetails ensureDetails() => $_ensure(2);
}

