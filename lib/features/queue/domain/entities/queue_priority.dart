enum QueuePriority {
  normal,
  urgent;

  static QueuePriority fromDbValue(String value) => switch (value) {
        'urgent' => QueuePriority.urgent,
        _ => QueuePriority.normal,
      };

  String toDbValue() => switch (this) {
        QueuePriority.normal => 'normal',
        QueuePriority.urgent => 'urgent',
      };

  String get displayName => switch (this) {
        QueuePriority.normal => 'Normal',
        QueuePriority.urgent => 'Urgent',
      };
}
