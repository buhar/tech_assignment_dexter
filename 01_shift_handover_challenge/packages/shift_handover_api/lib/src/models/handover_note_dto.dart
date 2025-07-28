import 'package:json_annotation/json_annotation.dart';

part 'handover_note_dto.g.dart';

@JsonSerializable()
class HandoverNoteDto {
  final String id;
  final String text;
  final String type;
  final String timestamp;
  final String authorId;
  final List<String> taggedResidentIds;
  final bool isAcknowledged;

  const HandoverNoteDto({
    required this.id,
    required this.text,
    required this.type,
    required this.timestamp,
    required this.authorId,
    required this.taggedResidentIds,
    required this.isAcknowledged,
  });

  factory HandoverNoteDto.fromJson(Map<String, dynamic> json) =>
      _$HandoverNoteDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HandoverNoteDtoToJson(this);
}