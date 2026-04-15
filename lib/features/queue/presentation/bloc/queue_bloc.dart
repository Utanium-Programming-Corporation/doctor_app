import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/my_queue_usecases.dart';
import '../../domain/usecases/queue_management_usecases.dart';
import 'queue_event.dart';
import 'queue_state.dart';

class QueueBloc extends Bloc<QueueEvent, QueueState> {
  final GetQueueForClinic _getQueueForClinic;
  final CallNextPatient _callNextPatient;
  final SkipQueueToken _skipQueueToken;
  final MarkNoShow _markNoShow;
  final StartConsultation _startConsultation;
  final CompleteQueueToken _completeQueueToken;

  QueueBloc({
    required GetQueueForClinic getQueueForClinic,
    required CallNextPatient callNextPatient,
    required SkipQueueToken skipQueueToken,
    required MarkNoShow markNoShow,
    required StartConsultation startConsultation,
    required CompleteQueueToken completeQueueToken,
  })  : _getQueueForClinic = getQueueForClinic,
        _callNextPatient = callNextPatient,
        _skipQueueToken = skipQueueToken,
        _markNoShow = markNoShow,
        _startConsultation = startConsultation,
        _completeQueueToken = completeQueueToken,
        super(const QueueInitial()) {
    on<QueueSubscriptionRequested>(_onSubscriptionRequested);
    on<QueueCallNextRequested>(_onCallNextRequested);
    on<QueueSkipRequested>(_onSkipRequested);
    on<QueueMarkNoShowRequested>(_onMarkNoShowRequested);
    on<QueueStartConsultationRequested>(_onStartConsultationRequested);
    on<QueueCompleteRequested>(_onCompleteRequested);
  }

  Future<void> _onSubscriptionRequested(
    QueueSubscriptionRequested event,
    Emitter<QueueState> emit,
  ) async {
    emit(const QueueLoading());
    await emit.forEach(
      _getQueueForClinic(event.clinicId),
      onData: (either) => either.fold(
        (failure) => QueueError(failure.message),
        (tokens) => QueueLoaded(tokens: tokens),
      ),
      onError: (_, _) => const QueueError('Realtime connection error'),
    );
  }

  Future<void> _onCallNextRequested(
    QueueCallNextRequested event,
    Emitter<QueueState> emit,
  ) async {
    final current = state;
    if (current is! QueueLoaded) return;
    emit(current.copyWith(isActioning: true));
    final result = await _callNextPatient(
      CallNextPatientParams(
        clinicId: event.clinicId,
        providerId: event.providerId,
      ),
    );
    result.fold(
      (failure) => emit(current.copyWith(
        isActioning: false,
        actionError: failure.message,
      )),
      (_) => emit(current.copyWith(isActioning: false)),
    );
  }

  Future<void> _onSkipRequested(
    QueueSkipRequested event,
    Emitter<QueueState> emit,
  ) async {
    final current = state;
    if (current is! QueueLoaded) return;
    emit(current.copyWith(isActioning: true));
    final result = await _skipQueueToken(event.tokenId);
    result.fold(
      (failure) => emit(current.copyWith(
        isActioning: false,
        actionError: failure.message,
      )),
      (_) => emit(current.copyWith(isActioning: false)),
    );
  }

  Future<void> _onMarkNoShowRequested(
    QueueMarkNoShowRequested event,
    Emitter<QueueState> emit,
  ) async {
    final current = state;
    if (current is! QueueLoaded) return;
    emit(current.copyWith(isActioning: true));
    final result = await _markNoShow(event.tokenId);
    result.fold(
      (failure) => emit(current.copyWith(
        isActioning: false,
        actionError: failure.message,
      )),
      (_) => emit(current.copyWith(isActioning: false)),
    );
  }

  Future<void> _onStartConsultationRequested(
    QueueStartConsultationRequested event,
    Emitter<QueueState> emit,
  ) async {
    final current = state;
    if (current is! QueueLoaded) return;
    emit(current.copyWith(isActioning: true));
    final result = await _startConsultation(event.tokenId);
    result.fold(
      (failure) => emit(current.copyWith(
        isActioning: false,
        actionError: failure.message,
      )),
      (_) => emit(current.copyWith(isActioning: false)),
    );
  }

  Future<void> _onCompleteRequested(
    QueueCompleteRequested event,
    Emitter<QueueState> emit,
  ) async {
    final current = state;
    if (current is! QueueLoaded) return;
    emit(current.copyWith(isActioning: true));
    final result = await _completeQueueToken(event.tokenId);
    result.fold(
      (failure) => emit(current.copyWith(
        isActioning: false,
        actionError: failure.message,
      )),
      (_) => emit(current.copyWith(isActioning: false)),
    );
  }
}
