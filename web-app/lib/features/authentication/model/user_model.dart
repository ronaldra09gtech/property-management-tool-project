import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tranquilestate_admin_panel/utils/constants/enums.dart';
import 'package:tranquilestate_admin_panel/utils/formatters/formatter.dart';

// class UserModel {
//   /// Model Class
//   final String? id;
//   String firstName;
//   String lastName;
//   String userName;
//   String email;
//   String phoneNumber;
//   String profilePicture;
//   AppRole role;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//
//   /// Constructor for User Model
//   UserModel(
//       {this.id,
//       required this.email,
//       this.firstName,
//       this.lastName,
//       this.userName,
//       this.phoneNumber,
//       this.profilePicture,
//       this.role = AppRole.user,
//       this.createdAt,
//       this.updatedAt});
//
//   ///Helper methods
//   String get fullName => '$firstName $lastName';
//
//   String get formattedDate => TFormatter.formatDate(createdAt);
//
//   String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);
//
//   String get formatterPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);
//
//   ///Static function to create an empty user model
//   static UserModel empty() => UserModel(email: '');
//
//   ///Converter model to JSON Structure for storing data in Firebase
//   Map<String, dynamic> toJson() {
//     return {
//       'FirstName': firstName,
//       'LastName': lastName,
//       'UserName': userName,
//       'Email': email,
//       'PhoneNumber': phoneNumber,
//       'ProfilePicture': profilePicture,
//       'Role': role.name.toString(),
//       'CreatedAt': createdAt,
//       'UpdatedAt': updatedAt = DateTime.now()
//     };
//   }
//
//   ///Factory method to create a User Model from a Firebase document snapshot
//   factory UserModel.fromSnapshot(
//       DocumentSnapshot<Map<String, dynamic>> document) {
//     if (document.data() != null) {
//       final data = document.data()!;
//       return UserModel(
//         id: document.id,
//         firstName: data.containsKey('FirstName') ? data['FirstName'] ?? '' : '',
//         lastName: data.containsKey('LastName') ? data['LastName'] ?? '' : '',
//         userName: data.containsKey('UserName') ? data['Username'] ?? '' : '',
//         email: data.containsKey('Email') ? data['Email'] ?? '' : '',
//         phoneNumber: data.containsKey('PhoneNumber') ? data['PhoneNumber'] ?? '' : '',
//         role: data.containsKey('Role') ? (data['Role'] ?? AppRole.user) == AppRole.admin.name.toString() ? AppRole.admin : AppRole.client: AppRole.user,
//         createdAt: data.containsKey('CreatedAt') ? data['CreatedAt']?.toDate() ?? DateTime.now() : DateTime.now(),
//         updatedAt: data.containsKey('UpdatedAt') ? data['UpdatedAt']?.toDate() ?? DateTime.now() : DateTime.now(),
//       );
//     } else {
//       return empty();
//     }
//   }
// }
