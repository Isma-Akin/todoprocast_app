import 'package:equatable/equatable.dart';
import 'package:todoprocast_app/models/todo_models.dart';

class ParetoItem extends Equatable {
  final String id;
  final Todo todo;
  final int value;

  const ParetoItem({
    required this.id,
    required this.todo,
    required this.value
  });

  @override
  List<Object> get props => [id, todo, value];
}