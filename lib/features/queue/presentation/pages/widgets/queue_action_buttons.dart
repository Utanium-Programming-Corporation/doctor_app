import 'package:flutter/material.dart';

import '../../../domain/entities/queue_token.dart';
import '../../../domain/entities/queue_token_status.dart';
import '../../bloc/queue_bloc.dart';
import '../../bloc/queue_event.dart';

class QueueActionButtons extends StatelessWidget {
  final QueueToken token;
  final String clinicId;
  final String providerId;
  final QueueBloc bloc;

  const QueueActionButtons({
    super.key,
    required this.token,
    required this.clinicId,
    required this.providerId,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Wrap(
        spacing: 8,
        children: [
          if (token.status == QueueTokenStatus.waiting)
            _btn('Call Next', Icons.call, () {
              bloc.add(QueueCallNextRequested(
                clinicId: clinicId,
                providerId: providerId,
              ));
            }, Colors.blue),
          if (token.status == QueueTokenStatus.called)
            _btn('Start', Icons.play_arrow, () {
              bloc.add(QueueStartConsultationRequested(token.id));
            }, Colors.green),
          if (token.status == QueueTokenStatus.inProgress)
            _btn('Complete', Icons.check_circle, () {
              bloc.add(QueueCompleteRequested(token.id));
            }, Colors.teal),
          if (token.status == QueueTokenStatus.waiting ||
              token.status == QueueTokenStatus.called)
            _btn('Skip', Icons.skip_next, () {
              bloc.add(QueueSkipRequested(token.id));
            }, Colors.amber.shade700),
          if (token.status == QueueTokenStatus.called)
            _btn('No-Show', Icons.person_off, () {
              bloc.add(QueueMarkNoShowRequested(token.id));
            }, Colors.red),
        ],
      ),
    );
  }

  Widget _btn(String label, IconData icon, VoidCallback onPressed, Color color) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: color),
      label: Text(label, style: TextStyle(color: color, fontSize: 12)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
