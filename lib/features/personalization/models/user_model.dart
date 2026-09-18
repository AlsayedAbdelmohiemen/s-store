import '../../../utils/formatters/formatter.dart';

/// Model class representing user data.
class UserModel {
  // Keep those values which you do not want to update
  final String id;
  String firstName;
  String lastName;
  String username;
  final String email;
  String phoneNumber;
  String profilePicture;
  String gender;
  String dateOfBirth;

  /// Constructor for UserModel.
  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    this.gender = '',
    this.dateOfBirth = '',
  });

  /// Helper function to get the full name.
  String get fullName => '$firstName $lastName';

  /// Helper function to format phone number.
  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  /// Static function to split full name into first and last name.
  static List<String> nameParts(String fullName) => fullName.split(" ");

  /// Static function to generate a username from the full name.
  static String generateUsername(String fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername = "$firstName$lastName"; // Combine first and last name
    String usernameWithPrefix = "cwt_$camelCaseUsername"; // Add "cwt_" prefix
    return usernameWithPrefix;
  }

  /// Static function to create an empty user model.
  static UserModel empty() => UserModel(
        id: '',
        firstName: '',
        lastName: '',
        username: '',
        email: '',
        phoneNumber: '',
        profilePicture: '',
        gender: '',
        dateOfBirth: '',
      );

  /// Convert model to JSON structure for storing data in Supabase / Firestore.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'FirstName': firstName,
      'LastName': lastName,
      'Username': username,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,
      'Gender': gender,
      'DateOfBirth': dateOfBirth,
    };
  }

  /// Factory method to create a UserModel from a JSON map.
  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'] ?? '',
      firstName: data['FirstName'] ?? data['firstName'] ?? '',
      lastName: data['LastName'] ?? data['lastName'] ?? '',
      username: data['Username'] ?? data['username'] ?? '',
      email: data['Email'] ?? data['email'] ?? '',
      phoneNumber: data['PhoneNumber'] ?? data['phoneNumber'] ?? '',
      profilePicture: data['ProfilePicture'] ?? data['profilePicture'] ?? '',
      gender: data['Gender'] ?? data['gender'] ?? '',
      dateOfBirth: data['DateOfBirth'] ?? data['dateOfBirth'] ?? '',
    );
  }
}
