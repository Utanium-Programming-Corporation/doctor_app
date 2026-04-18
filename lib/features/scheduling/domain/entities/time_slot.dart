import 'package:equatable/equatable.dart';

class TimeSlot extends Equatable {
  final DateTime startTime;
  final DateTime endTime;

  const TimeSlot({
    required this.startTime,
    required this.endTime,
  });

  int get durationMinutes => endTime.difference(startTime).inMinutes;

  String get formattedTimeRange {
    final start = _formatTime(startTime);
    final end = _formatTime(endTime);
    return '$start – $end';
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  List<Object?> get props => [startTime, endTime];
}
