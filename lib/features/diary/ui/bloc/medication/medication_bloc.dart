import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../diary/diary.dart';
import '../../../../../core/core.dart';

class MedicationBloc extends Bloc<MedicationEvent, MedicationState> {
  final AddMedication addMedication;
  final UpdateMedication updateMedication;
  final DeleteMedication deleteMedication;
  final GetMedicationsByUser getMedicationsByUser;
  final GetSchedulesWithNotificationIdsUseCase getSchedulesWithNotificationIds;

  MedicationBloc({
    required this.addMedication,
    required this.updateMedication,
    required this.deleteMedication,
    required this.getMedicationsByUser,
    required this.getSchedulesWithNotificationIds,
  }) : super(MedicationInitial()) {
    //  Cargar medicaciones

    on<LoadMedicationsEvent>((event, emit) async {
      emit(MedicationLoading());

      try {
        final meds = await getMedicationsByUser(event.userId);

        emit(MedicationLoaded(meds));
      } catch (e) {
        emit(MedicationError("Error al cargar medicaciones"));
      }
    });

    
    // Añadir medicación
    
    on<AddMedicationEvent>((event, emit) async {
      emit(MedicationLoading());

      try {
        final notificationService = NotificationService();

        //  Programa notificsaciones si el usuario lo pidó
        if (event.shouldScheduleNotifications) {
          for (final schedule in event.medication.schedules!) {
            await notificationService.addDailyAlert(
              notificationId: schedule.notificationId!,
              time: schedule.time!,
              title: "Recordatorio de medicación",
              body: "Es hora de tomar ${event.medication.name}",
            );
          }
        }

        //  Guardar la medicación
        await addMedication(event.medication);

        emit(MedicationAdded(event.medication));
      } catch (e) {
        Logger.e("Error en MedicationBloc - AddMedicationEvent: $e", error: e);
        emit(MedicationError("Error al añadir medicación"));
      }
    });

   
    // Actualizar medicación
    
    on<UpdateMedicationEvent>((event, emit) async {
      emit(MedicationLoading());

      try {
        final service = NotificationService();

        //  OBTENER LOS HORARIOS ANTIGUOS DESDE LA BD
        final oldSchedules = await getSchedulesWithNotificationIds(
          event.medication.id!,
        );

        //  CANCELAR TODAS LAS NOTIFICACIONES ANTIGUAS
        for (final schedule in oldSchedules) {
          if (schedule.notificationId != null) {
            await service.cancelAlert(schedule.notificationId!);
          }
        }

        // ACTUALIZAR EL MEDICAMENTO EN LA BD
        await updateMedication(event.medication);

        // SI EL USUARIO QUIERE NOTIFICACIONES → PROGRAMAR NUEVAS
        if (event.shouldScheduleNotifications) {
          for (final schedule in event.medication.schedules!) {
            await service.addDailyAlert(
              notificationId: schedule.notificationId!,
              time: schedule.time!,
              title: "Recordatorio de medicación",
              body: "Es hora de tomar ${event.medication.name}",
            );
          }
        }

        // EMITIR ESTADOS
        emit(MedicationUpdated(event.medication));

        final meds = await getMedicationsByUser(event.medication.userId!);
        emit(MedicationLoaded(meds));
      } catch (e) {
        Logger.e("Error en MedicationBloc - updateMedicationEvent: $e", error: e);
        emit(MedicationError("Error al actualizar medicación"));
      }
    });

    
    //  Eliminar medicación
    
    on<DeleteMedicationEvent>((event, emit) async {
      emit(MedicationLoading());

      try {
        final service = NotificationService();

        //  OBTENER LOS HORARIOS ANTIGUOS DESDE LA BD
        final oldSchedules = await getSchedulesWithNotificationIds(
          event.medicationId,
        );

        //  CANCELAR TODAS LAS NOTIFICACIONES ANTIGUAS
        for (final schedule in oldSchedules) {
          if (schedule.notificationId != null) {
            await service.cancelAlert(schedule.notificationId!);
          }
        }

        // ELIMINAR EL MEDICAMENTO (horarios se borran por cascade)
        await deleteMedication(event.medicationId);

        //  EMITIR ESTADO
        emit(MedicationDeleted(event.medicationId));
      } catch (e) {
        emit(MedicationError("Error al eliminar medicación"));
      }
    });
  }
}
