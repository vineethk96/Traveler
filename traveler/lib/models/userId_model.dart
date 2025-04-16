class UserIdModel{
  final String userId;

  UserIdModel({
    required this.userId,
  });

  Map<String, String> toJson(){
    return {
      'user_id': userId,
    };
  }
}