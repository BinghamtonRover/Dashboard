///
//  Generated code. Do not modify.
//  source: core.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'core.pbenum.dart';

export 'core.pbenum.dart';

class Connect extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Connect', createEmptyInstance: create)
    ..e<Device>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sender', $pb.PbFieldType.OE, defaultOrMaker: Device.DEVICE_UNDEFINED, valueOf: Device.valueOf, enumValues: Device.values)
    ..e<Device>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'receiver', $pb.PbFieldType.OE, defaultOrMaker: Device.DEVICE_UNDEFINED, valueOf: Device.valueOf, enumValues: Device.values)
    ..hasRequiredFields = false
  ;

  Connect._() : super();
  factory Connect({
    Device? sender,
    Device? receiver,
  }) {
    final _result = create();
    if (sender != null) {
      _result.sender = sender;
    }
    if (receiver != null) {
      _result.receiver = receiver;
    }
    return _result;
  }
  factory Connect.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Connect.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Connect clone() => Connect()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Connect copyWith(void Function(Connect) updates) => super.copyWith((message) => updates(message as Connect)) as Connect; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Connect create() => Connect._();
  Connect createEmptyInstance() => create();
  static $pb.PbList<Connect> createRepeated() => $pb.PbList<Connect>();
  @$core.pragma('dart2js:noInline')
  static Connect getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Connect>(create);
  static Connect? _defaultInstance;

  @$pb.TagNumber(1)
  Device get sender => $_getN(0);
  @$pb.TagNumber(1)
  set sender(Device v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSender() => $_has(0);
  @$pb.TagNumber(1)
  void clearSender() => clearField(1);

  @$pb.TagNumber(2)
  Device get receiver => $_getN(1);
  @$pb.TagNumber(2)
  set receiver(Device v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasReceiver() => $_has(1);
  @$pb.TagNumber(2)
  void clearReceiver() => clearField(2);
}

class Disconnect extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Disconnect', createEmptyInstance: create)
    ..e<Device>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sender', $pb.PbFieldType.OE, defaultOrMaker: Device.DEVICE_UNDEFINED, valueOf: Device.valueOf, enumValues: Device.values)
    ..hasRequiredFields = false
  ;

  Disconnect._() : super();
  factory Disconnect({
    Device? sender,
  }) {
    final _result = create();
    if (sender != null) {
      _result.sender = sender;
    }
    return _result;
  }
  factory Disconnect.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Disconnect.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Disconnect clone() => Disconnect()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Disconnect copyWith(void Function(Disconnect) updates) => super.copyWith((message) => updates(message as Disconnect)) as Disconnect; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Disconnect create() => Disconnect._();
  Disconnect createEmptyInstance() => create();
  static $pb.PbList<Disconnect> createRepeated() => $pb.PbList<Disconnect>();
  @$core.pragma('dart2js:noInline')
  static Disconnect getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Disconnect>(create);
  static Disconnect? _defaultInstance;

  @$pb.TagNumber(1)
  Device get sender => $_getN(0);
  @$pb.TagNumber(1)
  set sender(Device v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSender() => $_has(0);
  @$pb.TagNumber(1)
  void clearSender() => clearField(1);
}

class UpdateSetting extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateSetting', createEmptyInstance: create)
    ..e<RoverStatus>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: RoverStatus.DISCONNECTED, valueOf: RoverStatus.valueOf, enumValues: RoverStatus.values)
    ..hasRequiredFields = false
  ;

  UpdateSetting._() : super();
  factory UpdateSetting({
    RoverStatus? status,
  }) {
    final _result = create();
    if (status != null) {
      _result.status = status;
    }
    return _result;
  }
  factory UpdateSetting.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateSetting.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateSetting clone() => UpdateSetting()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateSetting copyWith(void Function(UpdateSetting) updates) => super.copyWith((message) => updates(message as UpdateSetting)) as UpdateSetting; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateSetting create() => UpdateSetting._();
  UpdateSetting createEmptyInstance() => create();
  static $pb.PbList<UpdateSetting> createRepeated() => $pb.PbList<UpdateSetting>();
  @$core.pragma('dart2js:noInline')
  static UpdateSetting getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateSetting>(create);
  static UpdateSetting? _defaultInstance;

  @$pb.TagNumber(1)
  RoverStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(RoverStatus v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);
}

