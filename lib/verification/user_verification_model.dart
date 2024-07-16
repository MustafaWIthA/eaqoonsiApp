class UserVerificationModel {
  final String userId;
  final int verificationType;

  UserVerificationModel({
    required this.userId,
    required this.verificationType,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'verificationType': verificationType,
      };

  factory UserVerificationModel.fromJson(Map<String, dynamic> json) =>
      UserVerificationModel(
        userId: json['userId'],
        verificationType: json['verificationType'],
      );
}
