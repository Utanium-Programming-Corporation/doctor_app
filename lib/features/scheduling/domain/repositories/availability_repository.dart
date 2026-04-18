import '../../../../core/usecase/usecase.dart';
import '../entities/appointment_type.dart';
import '../entities/blocked_date.dart';
import '../entities/provider_availability.dart';
import '../entities/time_slot.dart';
import 'availability_params.dart';

abstract interface class AvailabilityRepository {
  FutureResult<List<AppointmentType>> getAppointmentTypes(String clinicId);
  FutureResult<AppointmentType> createAppointmentType(
    CreateAppointmentTypeParams params,
  );
  FutureResult<AppointmentType> updateAppointmentType(
    UpdateAppointmentTypeParams params,
  );
  FutureResult<List<ProviderAvailability>> getProviderAvailability(
    GetProviderAvailabilityParams params,
  );
  FutureResult<List<ProviderAvailability>> setProviderAvailability(
    SetProviderAvailabilityParams params,
  );
  FutureResult<List<BlockedDate>> getBlockedDates(
    GetProviderAvailabilityParams params,
  );
  FutureResult<BlockedDate> addBlockedDate(AddBlockedDateParams params);
  FutureResult<void> removeBlockedDate(String id);
  FutureResult<List<TimeSlot>> getAvailableSlots(
    GetAvailableSlotsParams params,
  );
}
