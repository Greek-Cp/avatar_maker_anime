class UserModel {
  // Informasi Pribadi
  String? uid;
  String email;
  String password;
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
    this.password = "",
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
      password: json['password'] ?? "",
      username: json['username'] ?? "",
      displayName: json['displayName'] ?? "",
      photoURL: json['photoURL'] ?? "",
      phoneNumber: json['phoneNumber'] ?? "",
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      gender: json['gender'] ?? "",
      createdAt: _parseTimestamp(json['createdAt']),
      lastLoginAt: json['lastLoginAt'] != null
          ? _parseTimestamp(json['lastLoginAt'])
          : null,
      updatedAt: _parseTimestamp(json['updatedAt']),
    );
  }

  // Dari UserModel ke JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'password': password,
      'username': username,
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'createdAt': _timestampFromDateTime(createdAt),
      'lastLoginAt':
          lastLoginAt != null ? _timestampFromDateTime(lastLoginAt!) : null,
      'updatedAt': _timestampFromDateTime(updatedAt),
    };
  }

  // Mengonversi Firebase timestamp ke DateTime
  static DateTime _parseTimestamp(Map<String, dynamic> timestamp) {
    int seconds = timestamp['_seconds'];
    int nanoseconds = timestamp['_nanoseconds'];

    // Mengonversi detik dan nanodetik ke DateTime
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);
    return dateTime.add(Duration(
        milliseconds:
            nanoseconds ~/ 1000000)); // Menambahkan nanodetik ke DateTime
  }

  // Mengonversi DateTime ke format Firebase timestamp (_seconds dan _nanoseconds)
  static Map<String, dynamic> _timestampFromDateTime(DateTime dateTime) {
    int seconds =
        dateTime.toUtc().millisecondsSinceEpoch ~/ 1000; // Mengonversi ke detik
    int nanoseconds = (dateTime.microsecond *
        1000); // Mengonversi microseconds ke nanoseconds
    return {
      '_seconds': seconds,
      '_nanoseconds': nanoseconds,
    };
  }
}
