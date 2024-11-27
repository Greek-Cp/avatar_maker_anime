class UserModel {
  // Informasi Pribadi
  String? uid;
  String email;
  String username;
  String displayName;
  String photoURL;

  // Informasi Tambahan
  String phoneNumber;
  DateTime? dateOfBirth;
  String gender;

  // Metadata
  DateTime createdAt;
  DateTime? lastLoginAt;
  DateTime updatedAt;

  // Constructor
  UserModel({
    this.uid,
    this.email = "",
    this.username = "",
    this.displayName = "",
    this.photoURL = "",
    this.phoneNumber = "",
    this.dateOfBirth,
    this.gender = "",
    DateTime? createdAt,
    this.lastLoginAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Dari JSON ke UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'] ?? "",
      username: json['username'] ?? "",
      displayName: json['displayName'] ?? "",
      photoURL: json['photoURL'] ?? "",
      phoneNumber: json['phoneNumber'] ?? "",
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      gender: json['gender'] ?? "",
      createdAt: DateTime.parse(json['createdAt']),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'])
          : null,
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Dari UserModel ke JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
