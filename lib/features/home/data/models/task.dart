class TaskModel {
  final String? id;
  final String name;
  final String? description;
  final DateTime date;
  final int priority;

  TaskModel({
    this.id,
    required this.name,
    this.description,
    required this.date,
    required this.priority,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': ?description,
      'date': date.toIso8601String(),
      'priority': priority,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map, String documentId) {
    return TaskModel(
      id: documentId,
      name: map['name'] ?? '',
      description: map['description'],
      date: DateTime.parse(map['date']),
      priority: map['priority']?.toInt() ?? 1,
    );
  }
}