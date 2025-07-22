import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewmodels/attendance_bloc/attendance_bloc.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mark Attendance')),
      body: BlocListener<AttendanceBloc, AttendanceState>(
        listener: (context, state) {
          if (state is AttendanceSuccess) {
            //Scaffold shows user marked attendance
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                backgroundColor: Colors.black,
                content: Row(
                  children: [
                    Icon(Icons.check_box_rounded, color: Colors.green),
                    Text('Attendance marked successfully'),
                  ],
                ),
              ),
            );
          } else if (state is AttendanceError) {
            //Scaffold shows user not in the range
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                backgroundColor: Colors.black,
                content: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    Text(state.message),
                  ],
                ),
              ),
            );
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            //Button for marking attendance
            child: ElevatedButton(
              onPressed: () {
                context.read<AttendanceBloc>().add(MarkAttendance());
              },
              child: const Text('Mark Attendance'),
            ),
          ),
        ),
      ),
    );
  }
}
