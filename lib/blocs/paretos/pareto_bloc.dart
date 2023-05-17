import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/pareto_models.dart';
import 'pareto_event.dart';
import 'pareto_state.dart';

class ParetoBloc extends Bloc<ParetoEvent, ParetoState> {
  ParetoBloc() : super(ParetoInitial()) {
    on<ParetoItemAdded>(_onParetoItemAdded);
    on<ParetoItemUpdated>(_onParetoItemUpdated);
    on<ParetoItemDeleted>(_onParetoItemDeleted);
    // add(LoadParetoItems());
  }

  List<ParetoItem> _items = [];

  void _onParetoItemAdded(ParetoItemAdded event, Emitter<ParetoState> emit) {
    _items.add(event.item);
    _items.sort((a, b) => b.value.compareTo(a.value));
    emit(ParetoLoaded(List<ParetoItem>.from(_items)));
  }

  void _onParetoItemUpdated(ParetoItemUpdated event, Emitter<ParetoState> emit) {
    int index = _items.indexWhere((item) => item.id == event.item.id);
    if (index != -1) {
      _items[index] = event.item;
      _items.sort((a, b) => b.value.compareTo(a.value));
      emit(ParetoLoaded(List<ParetoItem>.from(_items)));
    }
  }

  void _onParetoItemDeleted(ParetoItemDeleted event, Emitter<ParetoState> emit) {
    _items.removeWhere((item) => item.id == event.itemId);
    emit(ParetoLoaded(List<ParetoItem>.from(_items)));
  }

  // void _onLoadParetoItems(LoadParetoItems event, Emitter<ParetoState> emit) async {
  //   emit(ParetoLoaded(_items));
  // }
}

