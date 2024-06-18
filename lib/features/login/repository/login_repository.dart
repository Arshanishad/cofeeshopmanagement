
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_shop_management/core/providers/firebase_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/common/globals.dart';
import '../../../core/common/search.dart';
import '../../../core/constants/firebase_constants.dart';
import '../../../core/providers/failure.dart';
import '../../../core/providers/type_def.dart';
import '../../../model/user_model.dart';

final loginRepositoryProvider=Provider((ref) => LoginRepository(firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider)));

class LoginRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  LoginRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })
      : _firestore = firestore,
        _auth = auth;

  CollectionReference get _userCollection =>
      _firestore.collection(FirebaseConstants.usersCollection);

  login({required String password, required String email}) async {
    try {
      QuerySnapshot User = await
      _userCollection
          .where("email", isEqualTo: email)
          .where("password", isEqualTo: password)
          .get();
      if (User.docs.isEmpty) {
        throw "user not exist";
      } else {
        if (kDebugMode) {
          print(User.docs[0]);
        }
        if (kDebugMode) {
          print("Admin.docs[0]");
        }
        final SharedPreferences userDatas = await SharedPreferences
            .getInstance();
        QueryDocumentSnapshot<Object?> data = User.docs[0];
        currentUserID = data.id;
        currentUserName = data.get("name");
        currentUserEmail = data.get("email");
        userDatas.setString('uid', data.id);
        userDatas.setString('email', currentUserEmail);
        currentUserID = data.id;
        user = UserModel.fromMap(
            User.docs.first.data() as Map<String, dynamic>);
      }
      return right(user);
    } on FirebaseException catch (e) {
      throw e.message ?? '';
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return left(Failure(e.toString()));
    }
  }

  Future<UserModel> getUsers(String uid) async {
    var a = await _userCollection.doc(uid).get();
    return UserModel.fromMap(a.data() as Map<String, dynamic>);
  }

  FutureEither<UserModel> checkKeepLogin() async {
    try {
      UserModel? userModel;
      var prefs = await SharedPreferences.getInstance();
      String? uid = prefs.getString("uid");
      if (uid != null) {
        currentUserID = uid;
        userModel = await getUsers(uid);
        return right(userModel);
      } else {
        return left(Failure("userId  Not Found"));
      }
    } on FirebaseException catch (e) {
      throw e.message ?? '';
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }


  logOutUser() async {
    SharedPreferences? prefs =
    await SharedPreferences.getInstance();
    prefs.remove("uid");
    prefs.remove("country");
    prefs.remove("countryId");
    prefs.remove("countryCode");
    prefs.remove("role");
    prefs.remove("email");
    prefs = null;
    prefs?.remove("user_password");
    user = null;
    currentUserEmail = "";
    currentUserID = "";
  }


  Future<int> getUserUid() async {
    try {
      DocumentSnapshot settingsDoc = await _firestore.collection('settings').doc('settings').get();
      int uid = settingsDoc.exists ? settingsDoc['userId'] ?? 0 : 0;
      await _firestore.collection('settings').doc('settings').update({'userId': FieldValue.increment(1)});
      return uid + 1;
    } catch (e) {
      if (kDebugMode) {
        print("Error getting user UID: $e");
      }
      rethrow;
    }
  }

  Future<Either<Failure, UserModel>> createUser(UserModel userModel) async {
    try {
      int uid = await getUserUid();
      if (kDebugMode) {
        print("Generated UID: U$uid");
      }

      DocumentReference userRef = _userCollection.doc("U$uid");
      await userRef.set(userModel.toMap());
      if (kDebugMode) {
        print("User document created: U$uid");
      }

      userModel = userModel.copyWith(
        reference: userRef,
        uid: "U$uid",
        search: setSearchParam("S$uid ${userModel.name} ${userModel.phoneNumber} ${userModel.email}"),
      );

      await userRef.update(userModel.toMap());
      if (kDebugMode) {
        print("User document updated: U$uid");
      }

      return Right(userModel);
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("FirebaseException: ${e.message}");
      }
      return Left(Failure(e.message ?? "Firebase Exception occurred"));
    } catch (e) {
      if (kDebugMode) {
        print("Exception: $e");
      }
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> registerUser({
    required String username,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (result.user != null) {
        UserModel userModel = UserModel(
          uid: "",
          name: username,
          email: email,
          password: password,
          search: [],
          date: DateTime.now(),
          delete: false,
          status: 0,
          active: true,
          phoneNumber: phone,
        );
        var createUserResult = await createUser(userModel);
        return createUserResult;
      } else {
        return Left(Failure("User creation failed"));
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("Authentication Error: ${e.message}");
      }
      return Left(Failure(e.message ?? "Authentication Error occurred"));
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      return Left(Failure(e.toString()));
    }
  }


  Future passwordReset({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print(e);

    }
  }

  Stream<UserModel?> getUser(String uid) {
    return _userCollection.doc(uid).snapshots().map((event) =>
        UserModel.fromMap(event.data() as Map<String, dynamic>));
  }
}










