import 'api_client.dart';

class TrainerCourse {
  final int id;
  final String title;
  final String category;
  final String level;
  final String status;
  final int lessonsCount;
  final int learnersCount;
  final String createdDate;

  const TrainerCourse({
    required this.id,
    required this.title,
    required this.category,
    required this.level,
    required this.status,
    required this.lessonsCount,
    required this.learnersCount,
    required this.createdDate,
  });

  factory TrainerCourse.fromJson(Map<String, dynamic> json) {
    return TrainerCourse(
      id: json['id'] as int,
      title: json['title'] as String,
      category: json['category'] as String,
      level: json['level'] as String,
      status: json['status'] as String,
      lessonsCount: json['lessonsCount'] as int,
      learnersCount: json['learnersCount'] as int,
      createdDate: json['createdDate'] as String,
    );
  }
}

class TrainerDashboardData {
  final int coursesCount;
  final int learnersCount;
  final int examsCount;
  final List<TrainerCourse> courses;

  const TrainerDashboardData({
    required this.coursesCount,
    required this.learnersCount,
    required this.examsCount,
    required this.courses,
  });

  factory TrainerDashboardData.fromJson(Map<String, dynamic> json) {
    return TrainerDashboardData(
      coursesCount: json['coursesCount'] as int,
      learnersCount: json['learnersCount'] as int,
      examsCount: json['examsCount'] as int,
      courses: (json['courses'] as List<dynamic>)
          .map((c) => TrainerCourse.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TrainerDashboardService {
  final ApiClient _client;

  const TrainerDashboardService({ApiClient client = const ApiClient()})
      : _client = client;

  Future<TrainerDashboardData> getStats({String? email, int? id}) async {
    final Map<String, String> query = {};
    if (email != null) query['email'] = email;
    if (id != null) query['id'] = id.toString();

    final json = await _client.get('/trainer/dashboard/stats', query: query)
        as Map<String, dynamic>;
    return TrainerDashboardData.fromJson(json);
  }
}
