import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoprocast_app/api/todo_repository.dart';

import '../../models/sharedpreferences_helper.dart';
import '../blocs.dart';
import 'group_event.dart';
import 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  SharedPreferencesHelper _sharedPreferencesHelper = SharedPreferencesHelper();
  SharedPreferences? _prefs;
  TodoRepository? _todoRepository;

  GroupBloc(TodoRepository todoRepository, SharedPreferences prefs) : super(GroupsInitial()) {
    on<AddGroup>(_onAddGroup);
    on<RemoveGroup>(_onRemoveGroup);
    on<AddTodoToGroup>(_onAddTodoToGroup);
    on<LoadGroups>(_onLoadGroups);
  }

  void _onAddGroup(AddGroup event, Emitter<GroupState> emit) async {
    try {
      emit(GroupsLoading());
      await SharedPreferencesHelper.saveGroupToLocal(event.group);
      final groups = await SharedPreferencesHelper.getGroups();
      emit(GroupsLoaded(groups));
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }

  void _onRemoveGroup(RemoveGroup event, Emitter<GroupState> emit) async {
    try {
      emit(GroupsLoading());
      await SharedPreferencesHelper.removeGroupFromLocal(event.group);
      final groups = await SharedPreferencesHelper.getGroups();
      emit(GroupsLoaded(groups));
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }

  void _onAddTodoToGroup(AddTodoToGroup event, Emitter<GroupState> emit) async {
    try {
      print('AddTodoToGroup event fired');
      print('Todo: ${event.todo}');
      print('Group: ${event.group}');
      emit(GroupsLoading());
      final updatedGroup = event.group.copy()..todos.add(event.todo);
      print('Updated group: $updatedGroup');
      await SharedPreferencesHelper.saveGroupToLocal(updatedGroup);
      final groups = await SharedPreferencesHelper.getGroups();
      print('Updated groups: $groups');
      emit(GroupsLoaded(groups));
    } catch (e) {
      print('Error in _onAddTodoToGroup: $e');
      emit(GroupsError(e.toString()));
    }
  }


  void _onLoadGroups(LoadGroups event, Emitter<GroupState> emit) async {
    try {
      emit(GroupsLoading());
      final groups = await SharedPreferencesHelper.getGroups();
      emit(GroupsLoaded(groups));
    } catch (e) {
      emit(GroupsError(e.toString()));
    }
  }
}
