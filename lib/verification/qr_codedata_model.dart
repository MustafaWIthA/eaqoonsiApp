class QRCodeDataModel {
  final String userId;
  final int verificationType;

  QRCodeDataModel({
    required this.userId,
    required this.verificationType,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'verificationType': verificationType,
      };
}
