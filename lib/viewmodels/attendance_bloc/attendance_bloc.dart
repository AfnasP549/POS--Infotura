import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pos/services/database_service.dart';
import 'package:pos/services/location_service.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final LocationService _locationService;
  final DatabaseService _databaseService;

  AttendanceBloc(this._locationService, this._databaseService)
    : super(AttendanceInitial()) {
    on<MarkAttendance>((event, emit) async {
      emit(AttendanceLoading());
      try {
        const double allowedLat = 11.1924394;
        const double allowedLon = 76.2355088;
        const double allowedRadius = 20;

        bool isWithinRange = await _locationService.isWithinRange(
          allowedLat,
          allowedLon,
          allowedRadius,
        );

        if (isWithinRange) {
          await _databaseService.markAttendance(DateTime.now());
          emit(AttendanceSuccess());
        } else {
          emit(AttendanceError('You are not within the allowed location.'));
        }
      } catch (e) {
        emit(AttendanceError('Attendance Bloc Error ${e.toString()}'));
      }
    });
  }
}
