import 'package:cloud_firestore/cloud_firestore.dart';

UserModel? user;
class UserModel{
  final String email;
  final String password;
  final String name;
  final String uid;
  final String phoneNumber;
  final List search;
  final DateTime date;
  final bool delete;
  final bool active;
  final int status;
  DocumentReference? reference;


//<editor-fold desc="Data Methods">
  UserModel({
    required this.email,
    required this.password,
    required this.name,
    required this.uid,
    required this.search,
    required this.date,
    required this.delete,
    required this.status,
    required this.active,
    required this.phoneNumber,
    this.reference,
  });



  UserModel copyWith({
    String? email,
    String? uid,
    String? password,
    String? phoneNumber,
    String? name,
    String? adminRole,
    List? search,
    DateTime? date,
    bool? delete,
    bool? active,
    int? status,
    DocumentReference? reference,
  }) {
    return UserModel(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      date: date ?? this.date,
      uid: uid ?? this.uid,
      search: search ?? this.search,
      delete: delete ?? this.delete,
      status: status ?? this.status,
      reference: reference ?? this.reference,
      active: active ?? this.active,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': this.email,
      'password': this.password,
      'name': this.name,
      'date': this.date,
      'uid': this.uid,
      'search': this.search,
      'delete': this.delete,
      'status': this.status,
      'reference': this.reference,
      'active': this.active,
      'phoneNumber': this.phoneNumber,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      password: map['password'] as String,
      phoneNumber: map['phoneNumber'] as String,
      name: map['name'] as String,
      status: map['status'] as int,
      uid: map['uid'] as String,
      search:List<String>.from(map['search']),
      date: map['date'] .toDate(),
      delete: map['delete'] as bool,
      active: map['active'] as bool,
      reference: map['reference'] as DocumentReference,
    );
  }

//</editor-fold>
}