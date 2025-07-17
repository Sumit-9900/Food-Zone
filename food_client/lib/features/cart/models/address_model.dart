import 'dart:convert';

class AddressModel {
  final String? id;
  final String fullName;
  final String phoneNumber;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String postalCode;

  AddressModel({
    this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.postalCode,
  });

  AddressModel copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? postalCode,
  }) {
    return AddressModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'postalCode': postalCode,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map, String docId) {
    return AddressModel(
      id: docId,
      fullName: map['fullName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      addressLine1: map['addressLine1'] as String,
      addressLine2:
          map['addressLine2'] != null ? map['addressLine2'] as String : null,
      city: map['city'] as String,
      postalCode: map['postalCode'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source, String docId) =>
      AddressModel.fromMap(json.decode(source) as Map<String, dynamic>, docId);

  @override
  String toString() {
    return 'AddressModel(id: $id, fullName: $fullName, phoneNumber: $phoneNumber, addressLine1: $addressLine1, addressLine2: $addressLine2, city: $city, postalCode: $postalCode)';
  }

  @override
  bool operator ==(covariant AddressModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.fullName == fullName &&
        other.phoneNumber == phoneNumber &&
        other.addressLine1 == addressLine1 &&
        other.addressLine2 == addressLine2 &&
        other.city == city &&
        other.postalCode == postalCode;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullName.hashCode ^
        phoneNumber.hashCode ^
        addressLine1.hashCode ^
        addressLine2.hashCode ^
        city.hashCode ^
        postalCode.hashCode;
  }
}
