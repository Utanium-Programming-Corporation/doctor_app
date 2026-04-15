import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../clinic/presentation/cubit/clinic_cubit.dart';
import '../../../clinic/presentation/cubit/clinic_state.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/router/route_names.dart';
import '../../domain/entities/queue_token_status.dart';
import '../bloc/my_queue_bloc.dart';
import '../bloc/my_queue_event.dart';
import '../bloc/my_queue_state.dart';
import '../cubit/triage_cubit.dart';
import '../cubit/triage_state.dart';
import 'widgets/queue_token_tile.dart';

class MyQueuePage extends StatelessWidget {
  const MyQueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    final clinicState = context.read<ClinicCubit>().state;
    final clinicId =
        clinicState is ClinicLoaded ? (clinicState.selectedClinicId ?? '') : '';
    final providerId =
        Supabase.instance.client.auth.currentUser?.id ?? '';

    return BlocProvider(
      create: (_) => sl<MyQueueBloc>()
        ..add(MyQueueSubscriptionRequested(
          clinicId: clinicId,
          providerId: providerId,
        )),
      child: _MyQueueView(
        clinicId: clinicId,
        providerId: providerId,
      ),
    );
  }
}

class _MyQueueView extends StatelessWidget {
  final String clinicId;
  final String providerId;

  const _MyQueueView({required this.clinicId, required this.providerId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyQueueBloc, MyQueueState>(
      listener: (context, state) {
        if (state is MyQueueLoaded && state.actionError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.actionError!)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Queue'),
          actions: [
            BlocBuilder<MyQueueBloc, MyQueueState>(
              builder: (context, state) {
                final hasWaiting = state is MyQueueLoaded &&
                    state.tokens
                        .any((t) => t.status == QueueTokenStatus.waiting);
                if (!hasWaiting) return const SizedBox.shrink();
                return IconButton(
                  icon: const Icon(Icons.call_missed),
                  tooltip: 'Call Next',
                  onPressed: () {
                    context.read<MyQueueBloc>().add(MyQueueCallNextRequested(
                          clinicId: clinicId,
                          providerId: providerId,
                        ));
                  },
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<MyQueueBloc, MyQueueState>(
          builder: (context, state) {
            if (state is MyQueueLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MyQueueError) {
              return Center(child: Text(state.message));
            }
            if (state is MyQueueLoaded) {
              if (state.tokens.isEmpty) {
                return const Center(child: Text('Your queue is empty today'));
              }
              return ListView.builder(
                itemCount: state.tokens.length,
                itemBuilder: (context, index) {
                  final token = state.tokens[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TokenWithTriageTile(
                        token: token,
                        onTap: token.status == QueueTokenStatus.called ||
                                token.status == QueueTokenStatus.inProgress
                            ? () => context.pushNamed(
                                  RouteNames.queueTriage,
                                  pathParameters: {'tokenId': token.id},
                                )
                            : null,
                      ),
                      _ActionRow(token: token),
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

class _TokenWithTriageTile extends StatelessWidget {
  final dynamic token;
  final VoidCallback? onTap;

  const _TokenWithTriageTile({required this.token, this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TriageCubit>()..loadTriage(token.id),
      child: BlocBuilder<TriageCubit, TriageState>(
        builder: (context, triageState) {
          final triage =
              triageState is TriageLoaded ? triageState.assessment : null;
          return QueueTokenTile(token: token, triage: triage, onTap: onTap);
        },
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final dynamic token;

  const _ActionRow({required this.token});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Wrap(
        spacing: 8,
        children: [
          if (token.status == QueueTokenStatus.called)
            OutlinedButton.icon(
              icon: const Icon(Icons.play_arrow, size: 16, color: Colors.green),
              label: const Text('Start',
                  style: TextStyle(color: Colors.green, fontSize: 12)),
              onPressed: () => context
                  .read<MyQueueBloc>()
                  .add(MyQueueStartConsultationRequested(token.id)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.green),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          if (token.status == QueueTokenStatus.inProgress)
            OutlinedButton.icon(
              icon: const Icon(Icons.check_circle, size: 16, color: Colors.teal),
              label: const Text('Complete',
                  style: TextStyle(color: Colors.teal, fontSize: 12)),
              onPressed: () => context
                  .read<MyQueueBloc>()
                  .add(MyQueueCompleteRequested(token.id)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.teal),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
        ],
      ),
    );
  }
}
