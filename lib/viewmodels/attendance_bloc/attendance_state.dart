part of 'attendance_bloc.dart';

@immutable
sealed class AttendanceState {}

final class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceSuccess extends AttendanceState{}

class AttendanceError extends AttendanceState{
  final String message;
  AttendanceError(this.message);
}
