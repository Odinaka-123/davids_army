class UserProfile {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  UserProfile({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phone": phone,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map["uid"],
      firstName: map["firstName"],
      lastName: map["lastName"],
      email: map["email"],
      phone: map["phone"],
    );
  }
}
