class TaskModel {
  String? id;
  final String name;
  final String? description;
  final DateTime dateTime;
  final int priority;
  bool? isCompleted;

  TaskModel({
    this.id,
    required this.dateTime,
    required this.name,
    this.description,
    required this.priority,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': ?description,
      'dateTime': dateTime.microsecondsSinceEpoch,
      'priority': priority,
      'isCompleted': isCompleted,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      name: map['name'] ?? '',
      description: map['description'] ?? "",
      dateTime: DateTime.fromMicrosecondsSinceEpoch(map['dateTime']),
      priority: map['priority']?.toInt() ?? 1,
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}
