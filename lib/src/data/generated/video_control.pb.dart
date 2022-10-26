///
//  Generated code. Do not modify.
//  source: video_control.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Quality extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Quality', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'video'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'jpegQuality', $pb.PbFieldType.OU3)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'grayscale')
    ..hasRequiredFields = false
  ;

  Quality._() : super();
  factory Quality({
    $core.int? jpegQuality,
    $core.bool? grayscale,
  }) {
    final _result = create();
    if (jpegQuality != null) {
      _result.jpegQuality = jpegQuality;
    }
    if (grayscale != null) {
      _result.grayscale = grayscale;
    }
    return _result;
  }
  factory Quality.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Quality.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Quality clone() => Quality()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Quality copyWith(void Function(Quality) updates) => super.copyWith((message) => updates(message as Quality)) as Quality; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Quality create() => Quality._();
  Quality createEmptyInstance() => create();
  static $pb.PbList<Quality> createRepeated() => $pb.PbList<Quality>();
  @$core.pragma('dart2js:noInline')
  static Quality getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Quality>(create);
  static Quality? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get jpegQuality => $_getIZ(0);
  @$pb.TagNumber(1)
  set jpegQuality($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasJpegQuality() => $_has(0);
  @$pb.TagNumber(1)
  void clearJpegQuality() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get grayscale => $_getBF(1);
  @$pb.TagNumber(2)
  set grayscale($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGrayscale() => $_has(1);
  @$pb.TagNumber(2)
  void clearGrayscale() => clearField(2);
}

class Switch extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Switch', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'video'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stream', $pb.PbFieldType.OU3)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'enabled')
    ..hasRequiredFields = false
  ;

  Switch._() : super();
  factory Switch({
    $core.int? stream,
    $core.bool? enabled,
  }) {
    final _result = create();
    if (stream != null) {
      _result.stream = stream;
    }
    if (enabled != null) {
      _result.enabled = enabled;
    }
    return _result;
  }
  factory Switch.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Switch.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Switch clone() => Switch()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Switch copyWith(void Function(Switch) updates) => super.copyWith((message) => updates(message as Switch)) as Switch; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Switch create() => Switch._();
  Switch createEmptyInstance() => create();
  static $pb.PbList<Switch> createRepeated() => $pb.PbList<Switch>();
  @$core.pragma('dart2js:noInline')
  static Switch getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Switch>(create);
  static Switch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get stream => $_getIZ(0);
  @$pb.TagNumber(1)
  set stream($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStream() => $_has(0);
  @$pb.TagNumber(1)
  void clearStream() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get enabled => $_getBF(1);
  @$pb.TagNumber(2)
  set enabled($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEnabled() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnabled() => clearField(2);
}

