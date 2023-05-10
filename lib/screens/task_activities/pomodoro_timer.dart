import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:timer_count_down/timer_controller.dart';


class PomodoroTimer extends StatefulWidget {
  @override
  _PomodoroTimerState createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {

  CountdownController _controller = CountdownController();

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF00BFA5),
                Color(0xFF00C853),
              ],
            ),
          ),
        ),
        title: const Text('Pomodoro Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Countdown(
              controller: _controller,
              seconds: 25 * 60,
              build: (_, double time) => Text(
                '${time ~/ 60}:${(time % 60).toInt().toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 50),
              ),
              interval: const Duration(milliseconds: 100),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _controller.start();
                  },
                  child: const Text('Start'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _controller.pause();
                  },
                  child: const Text('Pause'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _controller.restart();
                  },
                  child: const Text('Restart'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
