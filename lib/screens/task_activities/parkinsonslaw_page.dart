import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoprocast_app/models/models.dart';

class ParkinsonsLawPage extends StatefulWidget {
  final Todo todo;

  const ParkinsonsLawPage({required this.todo});

  @override
  _ParkinsonsLawPageState createState() => _ParkinsonsLawPageState();
}

class _ParkinsonsLawPageState extends State<ParkinsonsLawPage> {
  late Duration _timeRemaining;
  late Timer _timer;

  void _startParkinsonsLawTimer(Duration duration) {
    setState(() {
      _timeRemaining = duration;
    });
    Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (_timeRemaining.inSeconds > 0) {
          _timeRemaining -= Duration(seconds: 1);
        } else {
          _timeRemaining = Duration.zero;
        }
      });
    });
  }

  @override
  void initState() {
    _timeRemaining = widget.todo.deadline.difference(DateTime.now());
    super.initState();
  }

  @override
  void dispose() {
    // Cancel the timer if the screen is disposed
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parkinson\'s law'),
        titleTextStyle: GoogleFonts.openSans(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(widget.todo.task, style: GoogleFonts.openSans(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),),
        const SizedBox(height: 16),
        Text('Time remaining: ${_timeRemaining.inDays} days '
                '${_timeRemaining.inHours % 24} hours '
                '${_timeRemaining.inMinutes % 60} minutes '
                '${_timeRemaining.inSeconds % 60} seconds',
              style: GoogleFonts.openSans(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
        ),),
          const SizedBox(height: 16),
          Text('Set Parkinson\'s law timer:', style: GoogleFonts.openSans(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
          ),),
          Row(
            children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Enter time in minutes',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final durationInMinutes = int.tryParse(value);
                if (durationInMinutes != null) {
                  _startParkinsonsLawTimer(Duration(minutes: durationInMinutes));
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _startParkinsonsLawTimer(Duration(minutes: 30));
            },
            child: Text('30 mins', style: GoogleFonts.openSans(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),),
            ),
        ],
      ),
    ],
    ),
        ),
    );
    }
  }
