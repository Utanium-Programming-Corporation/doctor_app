enum AppointmentStatus {
  scheduled,
  confirmed,
  checkedIn,
  inProgress,
  completed,
  cancelled,
  noShow;

  static const Map<AppointmentStatus, Set<AppointmentStatus>>
      _validTransitions = {
    AppointmentStatus.scheduled: {
      AppointmentStatus.confirmed,
      AppointmentStatus.cancelled,
      AppointmentStatus.noShow,
    },
    AppointmentStatus.confirmed: {
      AppointmentStatus.checkedIn,
      AppointmentStatus.cancelled,
    },
    AppointmentStatus.checkedIn: {
      AppointmentStatus.inProgress,
      AppointmentStatus.cancelled,
    },
    AppointmentStatus.inProgress: {
      AppointmentStatus.completed,
      AppointmentStatus.cancelled,
    },
    AppointmentStatus.completed: {},
    AppointmentStatus.cancelled: {},
    AppointmentStatus.noShow: {},
  };

  bool canTransitionTo(AppointmentStatus target) =>
      _validTransitions[this]?.contains(target) ?? false;

  static AppointmentStatus fromDbValue(String value) => switch (value) {
        'scheduled' => AppointmentStatus.scheduled,
        'confirmed' => AppointmentStatus.confirmed,
        'checked_in' => AppointmentStatus.checkedIn,
        'in_progress' => AppointmentStatus.inProgress,
        'completed' => AppointmentStatus.completed,
        'cancelled' => AppointmentStatus.cancelled,
        'no_show' => AppointmentStatus.noShow,
        _ => AppointmentStatus.scheduled,
      };

  String toDbValue() => switch (this) {
        AppointmentStatus.scheduled => 'scheduled',
        AppointmentStatus.confirmed => 'confirmed',
        AppointmentStatus.checkedIn => 'checked_in',
        AppointmentStatus.inProgress => 'in_progress',
        AppointmentStatus.completed => 'completed',
        AppointmentStatus.cancelled => 'cancelled',
        AppointmentStatus.noShow => 'no_show',
      };

  String get displayName => switch (this) {
        AppointmentStatus.scheduled => 'Scheduled',
        AppointmentStatus.confirmed => 'Confirmed',
        AppointmentStatus.checkedIn => 'Checked In',
        AppointmentStatus.inProgress => 'In Progress',
        AppointmentStatus.completed => 'Completed',
        AppointmentStatus.cancelled => 'Cancelled',
        AppointmentStatus.noShow => 'No-Show',
      };

  bool get isTerminal => switch (this) {
        AppointmentStatus.completed ||
        AppointmentStatus.cancelled ||
        AppointmentStatus.noShow =>
          true,
        _ => false,
      };
}
