import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../clinic/presentation/cubit/clinic_cubit.dart';
import '../../../clinic/presentation/cubit/clinic_state.dart';
import '../cubit/book_appointment_cubit.dart';
import '../cubit/book_appointment_state.dart';
import 'widgets/booking_confirmation_step.dart';
import 'widgets/patient_selector_step.dart';
import 'widgets/slot_selector_step.dart';
import 'widgets/type_selector_step.dart';

class BookAppointmentPage extends StatelessWidget {
  const BookAppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final clinicState = context.read<ClinicCubit>().state;
    final clinicId = clinicState is ClinicLoaded
        ? (clinicState.selectedClinicId ?? '')
        : '';

    return BlocProvider(
      create: (_) {
        final cubit = sl<BookAppointmentCubit>();
        cubit.startBooking();
        if (clinicId.isNotEmpty) {
          cubit.loadAppointmentTypes(clinicId);
        }
        return cubit;
      },
      child: _BookAppointmentView(clinicId: clinicId),
    );
  }
}

class _BookAppointmentView extends StatelessWidget {
  final String clinicId;

  const _BookAppointmentView({required this.clinicId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookAppointmentCubit, BookAppointmentState>(
      listener: (context, state) {
        if (state is BookAppointmentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Appointment booked successfully!')),
          );
          Navigator.of(context).pop();
        } else if (state is BookAppointmentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Book Appointment'),
          leading: BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
            builder: (context, state) {
              final step = state is BookAppointmentInProgress
                  ? state.currentStep
                  : 0;
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: step > 0
                    ? () =>
                        context.read<BookAppointmentCubit>().goBack()
                    : () => Navigator.of(context).pop(),
              );
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<BookAppointmentCubit, BookAppointmentState>(
              builder: (context, state) {
                if (state is! BookAppointmentInProgress) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StepIndicator(currentStep: state.currentStep),
                    const SizedBox(height: 24),
                    _buildStep(context, state.currentStep),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, int step) {
    switch (step) {
      case 0:
        return PatientSelectorStep(clinicId: clinicId);
      case 1:
        return const TypeSelectorStep();
      case 2:
        return SlotSelectorStep(clinicId: clinicId);
      case 3:
        return BookingConfirmationStep(clinicId: clinicId);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;

  const _StepIndicator({required this.currentStep});

  static const _steps = ['Patient', 'Type', 'Slot', 'Confirm'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_steps.length, (index) {
        final isActive = index == currentStep;
        final isDone = index < currentStep;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: isDone
                          ? Colors.green
                          : isActive
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade300,
                      child: isDone
                          ? const Icon(Icons.check,
                              size: 14, color: Colors.white)
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isActive || isDone
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                            ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _steps[index],
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: isActive
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
              if (index < _steps.length - 1)
                Expanded(
                  child: Divider(
                    color: isDone ? Colors.green : Colors.grey.shade300,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
