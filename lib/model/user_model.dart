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
}
