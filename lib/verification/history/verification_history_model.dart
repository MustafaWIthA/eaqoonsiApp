class VerificationHistoryModel {
  final String verifiedBy;
  final String username;
  final DateTime verifiedAt;
  final String verificationType;

  VerificationHistoryModel({
    required this.verifiedBy,
    required this.username,
    required this.verifiedAt,
    required this.verificationType,
  });

  factory VerificationHistoryModel.fromJson(Map<String, dynamic> json) {
    return VerificationHistoryModel(
      verifiedBy: json['verifiedBy'],
      username: json['username'],
      verifiedAt: DateTime.parse(json['verifiedAt']),
      verificationType: json['verificationType'],
    );
  }
}
