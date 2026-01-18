class CommunityModel {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String communityName;
  final String phone;
  final Map<String, dynamic> location;
  final String propertyType;
  final String communityImageUrl;
  final String documentProofUrl;
  final String status;
  final String createdAt;
  final String updatedAt;

  CommunityModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.communityName,
    required this.phone,
    required this.location,
    required this.propertyType,
    required this.communityImageUrl,
    required this.documentProofUrl,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CommunityModel.fromMap(Map<String, dynamic> map, String id) {
    return CommunityModel(
      id: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userEmail: map['userEmail'] ?? '',
      communityName: map['communityName'] ?? '',
      phone: map['phone'] ?? '',
      location: Map<String, dynamic>.from(map['location'] ?? {}),
      propertyType: map['propertyType'] ?? '',
      communityImageUrl: map['communityImageUrl'] ?? '',
      documentProofUrl: map['documentProofUrl'] ?? '',
      status: map['status'] ?? '',
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'communityName': communityName,
      'phone': phone,
      'location': location,
      'propertyType': propertyType,
      'communityImageUrl': communityImageUrl,
      'documentProofUrl': documentProofUrl,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
