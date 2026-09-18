import '../../../utils/formatters/formatter.dart';

class AddressModel {
  String id;
  final String name;
  final String phoneNumber;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final DateTime? dateTime;
  bool selectedAddress;

  AddressModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.dateTime,
    this.selectedAddress = false,
  });

  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  static AddressModel empty() => AddressModel(
        id: '',
        name: '',
        phoneNumber: '',
        street: '',
        city: '',
        state: '',
        postalCode: '',
        country: '',
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'Name': name,
      'PhoneNumber': phoneNumber,
      'Street': street,
      'City': city,
      'State': state,
      'PostalCode': postalCode,
      'Country': country,
      'DateTime': (dateTime ?? DateTime.now()).toIso8601String(),
      'SelectedAddress': selectedAddress,
    };
    if (id.isNotEmpty) {
      map['id'] = id;
    }
    return map;
  }

  factory AddressModel.fromMap(Map<String, dynamic> document) {
    if (document.isEmpty) return AddressModel.empty();
    return AddressModel(
      id: document['id']?.toString() ?? document['Id']?.toString() ?? '',
      name: document['Name'] ?? document['name'] ?? '',
      phoneNumber: document['PhoneNumber'] ?? document['phoneNumber'] ?? '',
      street: document['Street'] ?? document['street'] ?? '',
      city: document['City'] ?? document['city'] ?? '',
      state: document['State'] ?? document['state'] ?? '',
      postalCode: document['PostalCode'] ?? document['postalCode'] ?? '',
      country: document['Country'] ?? document['country'] ?? '',
      dateTime: document['DateTime'] != null
          ? DateTime.tryParse(document['DateTime'].toString())
          : (document['dateTime'] != null
              ? DateTime.tryParse(document['dateTime'].toString())
              : null),
      selectedAddress: document['SelectedAddress'] ??
          document['selectedAddress'] ??
          false,
    );
  }

  factory AddressModel.fromJson(Map<String, dynamic> data) =>
      AddressModel.fromMap(data);

  @override
  String toString() {
    return '$street, $city, $state $postalCode, $country';
  }
}
