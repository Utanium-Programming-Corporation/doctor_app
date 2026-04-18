enum QueueTokenStatus {
  waiting,
  called,
  inProgress,
  completed,
  noShow,
  skipped;

  static const Map<QueueTokenStatus, Set<QueueTokenStatus>>
      _validTransitions = {
    QueueTokenStatus.waiting: {
      QueueTokenStatus.called,
      QueueTokenStatus.skipped,
    },
    QueueTokenStatus.called: {
      QueueTokenStatus.inProgress,
      QueueTokenStatus.noShow,
      QueueTokenStatus.skipped,
    },
    QueueTokenStatus.inProgress: {
      QueueTokenStatus.completed,
    },
    QueueTokenStatus.completed: {},
    QueueTokenStatus.noShow: {},
    QueueTokenStatus.skipped: {
      QueueTokenStatus.waiting,
    },
  };

  bool isValidTransition(QueueTokenStatus next) =>
      _validTransitions[this]?.contains(next) ?? false;

  Set<QueueTokenStatus> get validNextStatuses =>
      _validTransitions[this] ?? {};

  static QueueTokenStatus fromDbValue(String value) => switch (value) {
        'waiting' => QueueTokenStatus.waiting,
        'called' => QueueTokenStatus.called,
        'in_progress' => QueueTokenStatus.inProgress,
        'completed' => QueueTokenStatus.completed,
        'no_show' => QueueTokenStatus.noShow,
        'skipped' => QueueTokenStatus.skipped,
        _ => QueueTokenStatus.waiting,
      };

  String toDbValue() => switch (this) {
        QueueTokenStatus.waiting => 'waiting',
        QueueTokenStatus.called => 'called',
        QueueTokenStatus.inProgress => 'in_progress',
        QueueTokenStatus.completed => 'completed',
        QueueTokenStatus.noShow => 'no_show',
        QueueTokenStatus.skipped => 'skipped',
      };

  String get displayName => switch (this) {
        QueueTokenStatus.waiting => 'Waiting',
        QueueTokenStatus.called => 'Called',
        QueueTokenStatus.inProgress => 'In Progress',
        QueueTokenStatus.completed => 'Completed',
        QueueTokenStatus.noShow => 'No-Show',
        QueueTokenStatus.skipped => 'Skipped',
      };

  bool get isTerminal => switch (this) {
        QueueTokenStatus.completed || QueueTokenStatus.noShow => true,
        _ => false,
      };
}
