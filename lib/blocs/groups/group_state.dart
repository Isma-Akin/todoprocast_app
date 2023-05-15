import '../../models/group_models.dart';

abstract class GroupState {}

class GroupsInitial extends GroupState {}

class GroupsLoading extends GroupState {}

class GroupsLoaded extends GroupState {
  final List<Group> groups;

  GroupsLoaded(this.groups);
}

class GroupsError extends GroupState {
  final String message;

  GroupsError(this.message);
}
