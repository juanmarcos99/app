import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../diary/diary.dart';
import '../../../../../core/core.dart';

class MedicationBloc extends Bloc<MedicationEvent, MedicationState> {
  final AddMedication addMedication;
  final UpdateMedication updateMedication;
  final DeleteMedication deleteMedication;
  final GetMedicationsByUser getMedicationsByUser;

  MedicationBloc({
    required this.addMedication,
    required this.updateMedication,
    required this.deleteMedication,
    required this.getMedicationsByUser,
  }) : super(MedicationInitial()) {
    // -------------------------------------------------------------
    //  Cargar medicaciones
    // -------------------------------------------------------------
    on<LoadMedicationsEvent>((event, emit) async {
      emit(MedicationLoading());

      try {
        final meds = await getMedicationsByUser(event.userId);

        emit(MedicationLoaded(meds));
      } catch (e) {
        emit(MedicationError("Error al cargar medicaciones"));
      }
    });

    // -------------------------------------------------------------
    // Añadir medicación
    // -------------------------------------------------------------
    on<AddMedicationEvent>((event, emit) async {
      emit(MedicationLoading());

      try {
        final notificationService = NotificationService();

        // 1. Programar notificaciones si el usuario lo pidió
        if (event.shouldScheduleNotifications) {
          for (final schedule in event.medication.schedules!) {
            await notificationService.addDailyAlert(
              notificationId: schedule.notificationId!, 
              time: schedule.time!, // ← corregido
              title: "Recordatorio de medicación",
              body: "Es hora de tomar ${event.medication.name}",
            );
          }
        }

        // 2. Guardar la medicación
        await addMedication(event.medication);

        emit(MedicationAdded(event.medication));
      } catch (e) {
        debugPrint("Error en MedicationBloc - AddMedicationEvent: $e");
        emit(MedicationError("Error al añadir medicación"));
      }
    });

    // -------------------------------------------------------------
    // Actualizar medicación
    // -------------------------------------------------------------
    on<UpdateMedicationEvent>((event, emit) async {
      emit(MedicationLoading());

      try {
        await updateMedication(event.medication);

        emit(MedicationUpdated(event.medication));

        final meds = await getMedicationsByUser(event.medication.userId!);
        emit(MedicationLoaded(meds));
      } catch (e) {
        emit(MedicationError("Error al actualizar medicación"));
      }
    });

    // -------------------------------------------------------------
    // 🔥 Eliminar medicación
    // -------------------------------------------------------------
    on<DeleteMedicationEvent>((event, emit) async {
      emit(MedicationLoading());

      try {
        await deleteMedication(event.medicationId);

        emit(MedicationDeleted(event.medicationId));
      } catch (e) {
        emit(MedicationError("Error al eliminar medicación"));
      }
    });
  }
}
