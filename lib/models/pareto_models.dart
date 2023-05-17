import 'package:equatable/equatable.dart';

class ParetoItem extends Equatable {
  final String id;
  final String name;
  final int value;

  const ParetoItem({required this.id, required this.name, required this.value});

  @override
  List<Object> get props => [id, name, value];
}
