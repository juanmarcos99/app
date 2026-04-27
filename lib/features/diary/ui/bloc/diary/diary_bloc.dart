import 'package:app/features/diary/diary.dart';
import 'package:app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  final AddCrisis addCrisis;
  final GetCrisesByDay getCrisesByDay;
  final GetCrisesDays getCrisesDays;
  final AddAdverseEvent addAdverseEvent;
  final GetAdverseAventByDayAndUser getAdverseAventByDayAndUser;
  final GetAdverseEventDaysByUser getAdverseEventDaysByUser;
  final DeleteCrisis deleteCrisis;
  final DeleteAdverseEvent deleteAdverseEvent;
  final UpdateCrisis updateCrisis;
  final UpdateAdverseEvent updateAdverseEvent;

  ///Atributo que guarda el día seleccionado
  DateTime daySelected = DateUtils.dateOnly(DateTime.now());

  final AddRemoteCrisis addRemoteCrisis;
  final AddRemoteAdverseEvent addRemoteAdverseEvent;
  final AddToSyncQueueUseCase addToSyncQueueUseCase;
  final GetPendingSyncTasksUseCase getPendingSyncTasksUseCase;

  DiaryBloc(
    this.addCrisis,
    this.getCrisesByDay,
    this.getCrisesDays,
    this.addAdverseEvent,
    this.getAdverseAventByDayAndUser,
    this.getAdverseEventDaysByUser,
    this.deleteCrisis,
    this.deleteAdverseEvent,
    this.updateCrisis,
    this.updateAdverseEvent,
    this.addRemoteCrisis,
    this.addRemoteAdverseEvent,
    this.addToSyncQueueUseCase,
    this.getPendingSyncTasksUseCase,
  ) : super(DiaryInitial()) {
    // Evento para cambiar el día
    on<DayChangeEvent>((event, emit) {
      daySelected = DateUtils.dateOnly(event.newDay);
      emit(DayChangedState(daySelected));
    });

    // Evento para cargar el calendario
    on<LoadCalendarEvent>((event, emit) async {
      emit(DiaryLoading());
      try {
        final crisisDays = (await getCrisesDays(event.userId)).toSet();
        final aeDays = (await getAdverseEventDaysByUser(event.userId)).toSet();
        emit(CalendarLoaded(crisisDays, aeDays));
      } catch (e) {
        emit(CalendarError(e.toString()));
      }
    });

    // Evento cargar las tarjetas
    on<LoadTarjetasEvent>((event, emit) async {
      emit(DiaryLoading());
      try {
        final crises = await getCrisesByDay(
          DateUtils.dateOnly(event.date),
          event.userId,
        );
        final eventos = await getAdverseAventByDayAndUser(
          DateUtils.dateOnly(event.date),
          event.userId,
        );
        emit(TarjetasLoaded(crises, eventos));
      } catch (e) {
        emit(TarjetasLoading(e.toString()));
      }
    });
    //para añadir crisis
    on<AddCrisisEvent>((event, emit) async {
      emit(DiaryLoading());
      try {
        final crisisWithId = event.crisis.copyWith(id: IdGenerator.generate());
        await addCrisis(crisisWithId);
        emit(CrisisAdded(crisisWithId));

        // Sync remoto
        try {
          final pendingTasks = await getPendingSyncTasksUseCase();
          if (pendingTasks.isEmpty) {
            await addRemoteCrisis(crisisWithId);
          } else {
            throw ServerException("Cola de sincronización activa");
          }
        } on ServerException catch (e) {
          emit(RemoteError('Guardado localmente. Pendiente de sincronizar.'));
          final task = SyncTaskModel(
            endpoint: 'crisis',
            userId: crisisWithId.userId!,
            method: 'INSERT',
            payload: crisisWithId.toMap(),
          );
          await addToSyncQueueUseCase(task);
          debugPrint('Crisis encolada: ${e.message}');
        }
      } catch (e) {
        emit(DiaryError(e.toString()));
      }
    });

    //para añadir evento adverso
    on<AddAdverseEventEvent>((event, emit) async {
      emit(DiaryLoading());
      try {
        final eventWithId = event.av.copyWith(id: IdGenerator.generate());
        await addAdverseEvent(eventWithId);
        emit(AdverseEventAdded(eventWithId));

        // Sync remoto
        try {
          final pendingTasks = await getPendingSyncTasksUseCase();
          if (pendingTasks.isEmpty) {
            await addRemoteAdverseEvent(eventWithId);
          } else {
            throw ServerException("Cola de sincronización activa");
          }
        } on ServerException catch (e) {
          emit(RemoteError('Guardado localmente. Pendiente de sincronizar.'));
          final adverseEventModel = AdverseEventModel(
            id: eventWithId.id,
            registerDate: eventWithId.registerDate,
            eventDate: eventWithId.eventDate,
            description: eventWithId.description,
            userId: eventWithId.userId,
          );
          final task = SyncTaskModel(
            endpoint: 'adverse_events',
            userId: eventWithId.userId!,
            method: 'INSERT',
            payload: adverseEventModel.toMap(),
          );
          await addToSyncQueueUseCase(task);
          debugPrint('Evento adverso encolado: ${e.message}');
        }
      } catch (e) {
        emit(DiaryError(e.toString()));
      }
    });

    //para eliminar crisis
    on<DeleteCrisisEvent>((event, emit) async {
      emit(DiaryLoading());
      try {
        await deleteCrisis(event.crisisId);
        emit(CrisisDeleted(event.crisisId));

        // Intento remoto
        try {
          await addRemoteCrisis.repository.deleteRemoteCrisis(event.crisisId);
        } catch (e) {
          final task = SyncTaskModel(
            endpoint: 'crisis',
            userId: event.userId,
            method: 'DELETE',
            payload: {'id': event.crisisId},
          );
          await addToSyncQueueUseCase(task);
          debugPrint('Eliminación de crisis encolada: $e');
        }
      } catch (e) {
        emit(DiaryError(e.toString()));
      }
    });

    //para eliminar evento adverso
    on<DeleteAdverseEventEvent>((event, emit) async {
      emit(DiaryLoading());
      try {
        await deleteAdverseEvent(event.adverseEventId);
        emit(AdverseEventDeleted(event.adverseEventId));
        
        try {
          await addRemoteAdverseEvent.repository.deleteRemoteEvent(event.adverseEventId);
        } catch (e) {
          final task = SyncTaskModel(
            endpoint: 'adverse_events',
            userId: event.userId,
            method: 'DELETE',
            payload: {'id': event.adverseEventId},
          );
          await addToSyncQueueUseCase(task);
          debugPrint('Eliminación de evento adverso encolado: $e');
        }
      } catch (e) {
        emit(DiaryError(e.toString()));
      }
    });

    on<UpdateCrisisEvent>((event, emit) async {
      emit(DiaryLoading());
      try {
        await updateCrisis(event.crisis);
        emit(CrisisUpdated(event.crisis));

        // Sync remoto
        try {
          await addRemoteCrisis.repository.updateRemoteCrisis(event.crisis);
        } catch (e) {
          final crisisModel = CrisisModel(
            id: event.crisis.id,
            registeredDate: event.crisis.registeredDate!,
            crisisDate: event.crisis.crisisDate!,
            timeRange: event.crisis.timeRange!,
            quantity: event.crisis.quantity!,
            type: event.crisis.type!,
            userId: event.crisis.userId!,
          );
          final task = SyncTaskModel(
            endpoint: 'crisis',
            userId: event.crisis.userId!,
            method: 'UPDATE',
            payload: crisisModel.toMap(),
          );
          await addToSyncQueueUseCase(task);
        }
      } catch (e) {
        emit(DiaryError(e.toString()));
      }
    });

    on<UpdateAdverseEventEvent>((event, emit) async {
      emit(DiaryLoading());
      try {
        await updateAdverseEvent(event.adverseEvent);
        emit(AdverseEventUpdated(event.adverseEvent));
        
        // Sync remoto
        try {
          await addRemoteAdverseEvent.repository.updateRemoteEvent(event.adverseEvent);
        } catch (e) {
          final adverseEventModel = AdverseEventModel(
            id: event.adverseEvent.id,
            registerDate: event.adverseEvent.registerDate,
            eventDate: event.adverseEvent.eventDate,
            description: event.adverseEvent.description,
            userId: event.adverseEvent.userId,
          );
          final task = SyncTaskModel(
            endpoint: 'adverse_events',
            userId: event.adverseEvent.userId!,
            method: 'UPDATE',
            payload: adverseEventModel.toMap(),
          );
          await addToSyncQueueUseCase(task);
        }
      } catch (e) {
        emit(DiaryError(e.toString()));
      }
    });
  }
}
