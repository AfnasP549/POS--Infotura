part of 'attendance_bloc.dart';

@immutable
sealed class AttendanceEvent {}

class MarkAttendance extends AttendanceEvent {
}
