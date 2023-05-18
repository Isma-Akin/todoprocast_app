import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../blocs/paretos/pareto_bloc.dart';
import '../../../blocs/paretos/pareto_event.dart';
import '../../../blocs/paretos/pareto_state.dart';
import '../../../models/pareto_models.dart';
import 'package:fl_chart/fl_chart.dart';


class ParetoAnalysisPage extends StatelessWidget {
  const ParetoAnalysisPage({Key? key}) : super(key: key);

  Future<void> _showAddParetoItemDialog(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController valueController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Add Pareto Item'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: valueController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Value'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    valueController.text.isNotEmpty) {
                  int value = int.tryParse(valueController.text) ?? 0;
                  ParetoItem newItem = ParetoItem(
                    id: const Uuid().v4(),
                    name: nameController.text,
                    value: value,
                  );
                  context.read<ParetoBloc>().add(ParetoItemAdded(newItem));
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pareto Analysis',
          style: GoogleFonts.openSans(
              fontSize: 25),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: BlocBuilder<ParetoBloc, ParetoState>(
              builder: (context, state) {
                if (state is ParetoLoaded && state.items.isNotEmpty) {
                  return ParetoChart(items: state.items);
                } else if (state is ParetoLoaded && state.items.isEmpty) {
                  return Center(
                    child: Text('No items added yet. Tap the + button to add an item.'),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: BlocBuilder<ParetoBloc, ParetoState>(
              builder: (context, state) {
                if (state is ParetoLoaded) {
                  return ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text('Value: ${item.value}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context.read<ParetoBloc>().add(ParetoItemDeleted(item.id));
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddParetoItemDialog(context);
        },
        child: const Icon(Icons.add),
      ),


    );
  }
}

class ParetoChart extends StatelessWidget {
  final List<ParetoItem> items;

  const ParetoChart({required this.items});

  @override
  Widget build(BuildContext context) {
    List<BarChartRodData> barData = items
        .map((item) => BarChartRodData(
      y: item.value.toDouble(),
      width: 20,
    ))
        .toList();

    int cumulativeValue = 0;
    List<FlSpot> lineData = items.map((item) {
      cumulativeValue += item.value;
      return FlSpot(items.indexOf(item).toDouble(), cumulativeValue.toDouble());
    }).toList();

    return BarChart(
      BarChartData(
        barGroups: barData.map((data) {
          return BarChartGroupData(
            x: barData.indexOf(data),
            barRods: [data],
          );
        }).toList(),
        titlesData: FlTitlesData(
          leftTitles: SideTitles(showTitles: true),
          bottomTitles: SideTitles(
            showTitles: true,
            getTitles: (double value) {
              return items[value.toInt()].name;
            },
          ),
        ),
      ),
      swapAnimationDuration: const Duration(milliseconds: 150),
    );
  }
}

// body: Column(
// children: [
// Expanded(
// child: BlocBuilder<ParetoBloc, ParetoState>(
// builder: (context, state) {
// if (state is ParetoLoaded) {
// return ParetoChart(items: state.items);
// } else {
// return Center(child: CircularProgressIndicator());
// }
// },
// ),
// ),
// //
// ],
// ),
