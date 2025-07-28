import 'package:json_annotation/json_annotation.dart';
import 'handover_note_dto.dart';

part 'shift_report_dto.g.dart';

@JsonSerializable()
class ShiftReportDto {
  final String id;
  final String caregiverId;
  final String startTime;
  final String? endTime;
  final List<HandoverNoteDto> notes;
  final String summary;
  final bool isSubmitted;

  const ShiftReportDto({
    required this.id,
    required this.caregiverId,
    required this.startTime,
    this.endTime,
    required this.notes,
    required this.summary,
    required this.isSubmitted,
  });

  factory ShiftReportDto.fromJson(Map<String, dynamic> json) =>
      _$ShiftReportDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftReportDtoToJson(this);
}