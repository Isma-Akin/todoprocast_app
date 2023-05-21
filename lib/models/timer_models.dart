enum TimerStatus { initial, running, paused, stopped, completed }

class TimerModel {
  final String id;
  final String todoId;
  final DateTime startTime;
  int duration;
  TimerStatus status;

  TimerModel(this.id, this.todoId, this.startTime, this.duration, this.status);

  TimerModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        todoId = json['todoId'],
        startTime = DateTime.parse(json['startTime']),
        duration = json['duration'],
        status = TimerStatus.values[json['status']];

  Map<String, dynamic> toJson() => {
    'id': id,
    'todoId': todoId,
    'startTime': startTime.toIso8601String(),
    'duration': duration,
    'status': status.index,
  };
}

