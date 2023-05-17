import 'package:equatable/equatable.dart';
import '../../models/pareto_models.dart';

abstract class ParetoEvent extends Equatable {
  const ParetoEvent();
}

class ParetoItemAdded extends ParetoEvent {
  final ParetoItem item;

  const ParetoItemAdded(this.item);

  @override
  List<Object> get props => [item];
}

class ParetoItemUpdated extends ParetoEvent {
  final ParetoItem item;

  const ParetoItemUpdated(this.item);

  @override
  List<Object> get props => [item];
}

class ParetoItemDeleted extends ParetoEvent {
  final String itemId;

  const ParetoItemDeleted(this.itemId);

  @override
  List<Object> get props => [itemId];
}

// class LoadParetoItems extends ParetoEvent {}
