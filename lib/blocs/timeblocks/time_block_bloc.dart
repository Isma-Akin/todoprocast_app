import 'package:time_planner/time_planner.dart';
import 'package:todoprocast_app/blocs/timeblocks/time_block_event.dart';
import 'package:todoprocast_app/blocs/timeblocks/time_block_state.dart';

import '../../api/time_blocks_repository.dart';
import '../../models/timeblock_models.dart';
import '../blocs.dart';

class TimeBlocksBloc extends Bloc<TimeBlocksEvent, TimeBlocksState> {
  final TimeBlocksRepository repository;

  TimeBlocksBloc(this.repository) : super(TimeBlocksLoadInProgress()) {
    on<LoadTimeBlocks>(_onLoadTimeBlocks);
    on<AddTimeBlock>(_onAddTimeBlock);
    on<UpdateTimeBlock>(_onUpdateTimeBlock);
    on<DeleteTimeBlock>(_onDeleteTimeBlock);
  }

  Future<void> _onAddTimeBlock(AddTimeBlock event, Emitter<TimeBlocksState> emit) async {
    try {
      await repository.addTimeBlock(event.todo, event.taskModel);
      final taskModels = await repository.loadTimeBlocks(event.todo);
      print("Loaded ${taskModels.length} taskModels");
      final tasks = taskModels.map((taskModel) {
        print("Converting taskModel to TimePlannerTask");
        return taskModel.toTimePlannerTask();
      }).toList();
      print("Converted taskModels to tasks");
      emit(TimeBlocksLoadSuccess(tasks));
    } catch (error, stackTrace) {
      print('Error in _onAddTimeBlock: $error');
      print('Stack Trace: $stackTrace');
      // Handle error as needed, possibly emit a failure state.
    }
  }

  Future<void> _onLoadTimeBlocks(LoadTimeBlocks event, Emitter<TimeBlocksState> emit) async {
    emit(TimeBlocksLoadInProgress());
    try {
      final List<TaskModel> taskModels = await repository.loadTimeBlocks(event.todo);
      final List<TimePlannerTask> tasks = taskModels.map((taskModel) => taskModel.toTimePlannerTask()).toList();
      emit(TimeBlocksLoadSuccess(tasks));
    } catch (error) {
      print('Error in _onLoadTimeBlocks: $error');
      emit(TimeBlocksLoadFailure());
    }
  }

  Future<void> _onUpdateTimeBlock(UpdateTimeBlock event, Emitter<TimeBlocksState> emit) async {
    try {
      await repository.updateTimeBlock(event.todo, event.taskModel);
      final List<TaskModel> taskModels = await repository.loadTimeBlocks(event.todo);
      final List<TimePlannerTask> tasks = taskModels.map((taskModel) => taskModel.toTimePlannerTask()).toList();
      emit(TimeBlocksLoadSuccess(tasks));
    } catch (error) {
      // Handle error as needed, possibly emit a failure state.
    }
  }

  Future<void> _onDeleteTimeBlock(DeleteTimeBlock event, Emitter<TimeBlocksState> emit) async {
    try {
      await repository.deleteTimeBlock(event.todo, event.taskModel);
      final List<TaskModel> taskModels = await repository.loadTimeBlocks(event.todo);
      final List<TimePlannerTask> tasks = taskModels.map((taskModel) => taskModel.toTimePlannerTask()).toList();
      emit(TimeBlocksLoadSuccess(tasks));
    } catch (error) {
      // Handle error as needed, possibly emit a failure state.
    }
  }

}
