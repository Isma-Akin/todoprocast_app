import 'package:equatable/equatable.dart';
import '../../models/pareto_models.dart';

abstract class ParetoState extends Equatable {
  const ParetoState();

  @override
  List<Object> get props => [];
}

class ParetoInitial extends ParetoState {}

class ParetoLoading extends ParetoState {}

class ParetoLoaded extends ParetoState {
  final List<ParetoItem> items;

  const ParetoLoaded(this.items);

  @override
  List<Object> get props => [items];
}

class ParetoError extends ParetoState {
  final String message;

  const ParetoError(this.message);

  @override
  List<Object> get props => [message];
}
