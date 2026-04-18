import '../../domain/entities/blocked_date.dart';
import '../../domain/entities/provider_availability.dart';

sealed class AvailabilityState {
  const AvailabilityState();
}

class AvailabilityInitial extends AvailabilityState {
  const AvailabilityInitial();
}

class AvailabilityLoading extends AvailabilityState {
  const AvailabilityLoading();
}

class AvailabilityLoaded extends AvailabilityState {
  /// Weekly entries grouped by dayOfWeek (1=Mon … 7=Sun)
  final Map<int, List<ProviderAvailability>> weeklyEntries;
  final List<BlockedDate> blockedDates;
  final String providerId;
  final bool isSaving;

  const AvailabilityLoaded({
    required this.weeklyEntries,
    required this.providerId,
    this.blockedDates = const [],
    this.isSaving = false,
  });

  AvailabilityLoaded copyWith({
    Map<int, List<ProviderAvailability>>? weeklyEntries,
    List<BlockedDate>? blockedDates,
    bool? isSaving,
  }) {
    return AvailabilityLoaded(
      weeklyEntries: weeklyEntries ?? this.weeklyEntries,
      blockedDates: blockedDates ?? this.blockedDates,
      providerId: providerId,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class AvailabilityError extends AvailabilityState {
  final String message;
  const AvailabilityError(this.message);
}
