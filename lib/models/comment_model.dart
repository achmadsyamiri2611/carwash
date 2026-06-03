class CommentModel {
  final String carwashId;
  final String username;
  final String comment;
  final DateTime createdAt;

  CommentModel({
    required this.carwashId,
    required this.username,
    required this.comment,
    required this.createdAt,
  });

  factory CommentModel.fromFirestore(
    Map<String, dynamic> data,
  ) {
    return CommentModel(
      carwashId: data['carwashId'] ?? '',
      username: data['username'] ?? '',
      comment: data['comment'] ?? '',
      createdAt: (data['createdAt']).toDate(),
    );
  }
}