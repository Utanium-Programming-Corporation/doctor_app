import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/my_queue_usecases.dart';
import '../../domain/usecases/queue_management_usecases.dart';
import 'my_queue_event.dart';
import 'my_queue_state.dart';

class MyQueueBloc extends Bloc<MyQueueEvent, MyQueueState> {
  final GetMyQueue _getMyQueue;
  final CallNextPatient _callNextPatient;
  final StartConsultation _startConsultation;
  final CompleteQueueToken _completeQueueToken;

  MyQueueBloc({
    required GetMyQueue getMyQueue,
    required CallNextPatient callNextPatient,
    required StartConsultation startConsultation,
    required CompleteQueueToken completeQueueToken,
  })  : _getMyQueue = getMyQueue,
        _callNextPatient = callNextPatient,
        _startConsultation = startConsultation,
        _completeQueueToken = completeQueueToken,
        super(const MyQueueInitial()) {
    on<MyQueueSubscriptionRequested>(_onSubscriptionRequested);
    on<MyQueueCallNextRequested>(_onCallNextRequested);
    on<MyQueueStartConsultationRequested>(_onStartConsultationRequested);
    on<MyQueueCompleteRequested>(_onCompleteRequested);
  }

  Future<void> _onSubscriptionRequested(
    MyQueueSubscriptionRequested event,
    Emitter<MyQueueState> emit,
  ) async {
    emit(const MyQueueLoading());
    await emit.forEach(
      _getMyQueue(
        GetMyQueueParams(
          clinicId: event.clinicId,
          providerId: event.providerId,
        ),
      ),
      onData: (either) => either.fold(
        (failure) => MyQueueError(failure.message),
        (tokens) => MyQueueLoaded(tokens: tokens),
      ),
      onError: (_, _) => const MyQueueError('Realtime connection error'),
    );
  }

  Future<void> _onCallNextRequested(
    MyQueueCallNextRequested event,
    Emitter<MyQueueState> emit,
  ) async {
    final current = state;
    if (current is! MyQueueLoaded) return;
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

  Future<void> _onStartConsultationRequested(
    MyQueueStartConsultationRequested event,
    Emitter<MyQueueState> emit,
  ) async {
    final current = state;
    if (current is! MyQueueLoaded) return;
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
    MyQueueCompleteRequested event,
    Emitter<MyQueueState> emit,
  ) async {
    final current = state;
    if (current is! MyQueueLoaded) return;
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
