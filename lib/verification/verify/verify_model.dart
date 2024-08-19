class VerificationResponse {
  final String idNumber;
  final String fullName;
  final String photograph;

  VerificationResponse({
    required this.idNumber,
    required this.fullName,
    required this.photograph,
  });

  factory VerificationResponse.fromJson(Map<String, dynamic> json) {
    return VerificationResponse(
      idNumber: json['idNumber'],
      fullName: json['fullName'],
      photograph: json['photograph'],
    );
  }
}
