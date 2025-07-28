// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handover_note_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandoverNoteDto _$HandoverNoteDtoFromJson(Map<String, dynamic> json) =>
    HandoverNoteDto(
      id: json['id'] as String,
      text: json['text'] as String,
      type: json['type'] as String,
      timestamp: json['timestamp'] as String,
      authorId: json['authorId'] as String,
      taggedResidentIds: (json['taggedResidentIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isAcknowledged: json['isAcknowledged'] as bool,
    );

Map<String, dynamic> _$HandoverNoteDtoToJson(HandoverNoteDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'type': instance.type,
      'timestamp': instance.timestamp,
      'authorId': instance.authorId,
      'taggedResidentIds': instance.taggedResidentIds,
      'isAcknowledged': instance.isAcknowledged,
    };
