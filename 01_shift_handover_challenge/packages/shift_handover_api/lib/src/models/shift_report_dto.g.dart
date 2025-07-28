// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_report_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftReportDto _$ShiftReportDtoFromJson(Map<String, dynamic> json) =>
    ShiftReportDto(
      id: json['id'] as String,
      caregiverId: json['caregiverId'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String?,
      notes: (json['notes'] as List<dynamic>)
          .map((e) => HandoverNoteDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary: json['summary'] as String,
      isSubmitted: json['isSubmitted'] as bool,
    );

Map<String, dynamic> _$ShiftReportDtoToJson(ShiftReportDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'caregiverId': instance.caregiverId,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'notes': instance.notes,
      'summary': instance.summary,
      'isSubmitted': instance.isSubmitted,
    };
