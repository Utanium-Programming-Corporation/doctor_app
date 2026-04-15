import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/route_names.dart';
import '../bloc/queue_bloc.dart';
import '../bloc/queue_event.dart';
import '../bloc/queue_state.dart';
import 'widgets/queue_action_buttons.dart';
import 'widgets/queue_token_tile.dart';

class QueueListPage extends StatelessWidget {
  final String clinicId;
  final String providerId;

  const QueueListPage({
    super.key,
    required this.clinicId,
    required this.providerId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<QueueBloc>()..add(QueueSubscriptionRequested(clinicId)),
      child: _QueueListView(clinicId: clinicId, providerId: providerId),
    );
  }
}

class _QueueListView extends StatelessWidget {
  final String clinicId;
  final String providerId;

  const _QueueListView({required this.clinicId, required this.providerId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<QueueBloc, QueueState>(
      listener: (context, state) {
        if (state is QueueLoaded && state.actionError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.actionError!)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Queue'),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () => context.pushNamed(RouteNames.queueCheckIn),
            ),
          ],
        ),
        body: BlocBuilder<QueueBloc, QueueState>(
          builder: (context, state) {
            if (state is QueueLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is QueueError) {
              return Center(child: Text(state.message));
            }
            if (state is QueueLoaded) {
              if (state.tokens.isEmpty) {
                return const Center(
                    child: Text('No patients in queue today'));
              }
              final bloc = context.read<QueueBloc>();
              return ListView.builder(
                itemCount: state.tokens.length,
                itemBuilder: (context, index) {
                  final token = state.tokens[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      QueueTokenTile(token: token),
                      QueueActionButtons(
                        token: token,
                        clinicId: clinicId,
                        providerId: providerId,
                        bloc: bloc,
                      ),
                    ],
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
