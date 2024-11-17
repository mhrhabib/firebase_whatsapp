import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_firebase/common/repositories/common_firebase_storage_repository.dart';
import 'package:whats_app_firebase/common/utils/utils.dart';
import 'package:whats_app_firebase/features/auth/screens/otp_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whats_app_firebase/features/auth/screens/user_information_screen.dart';
import 'package:whats_app_firebase/models/user_model.dart';
import 'package:whats_app_firebase/screens/mobile_layout_screen.dart';

final authRepoSitoryProvider = Provider((ref) => AuthRepository(auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseAuth auth;

  final FirebaseFirestore firestore;
  final googleSignIn = GoogleSignIn();

  AuthRepository({required this.auth, required this.firestore});

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            throw Exception(e.message);
          },
          codeSent: ((String verificationId, int? ressendToken) async {
            Navigator.pushNamed(context, OtpScreen.routeName, arguments: verificationId);
          }),
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google sign-in aborted.')),
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await auth.signInWithCredential(credential);
      if (result.user != null) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UserInformationScreen(
            user: result.user!,
          ),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to sign in with Google.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing in: $error')),
      );
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await auth.signOut();
      await googleSignIn.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have signed out successfully.')),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $error')),
      );
    }
  }

  void saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required Ref ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://www.google.com/url?sa=i&url=https%3A%2F%2Fstackoverflow.com%2Fquestions%2F49917726%2Fretrieving-default-image-all-url-profile-picture-from-facebook-graph-api&psig=AOvVaw06bNLiCvtOe4NiVlSxSHyC&ust=1731820901371000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCLjWm9-N4IkDFQAAAAAdAAAAABAE';

      if (profilePic != null) {
        photoUrl = await ref.read(commonFirebaseStorageRepository).storeFileToFirebase('profilePic/$uid', profilePic);
      }
      var user = UserModel(
        name: name,
        uid: uid,
        profilePic: photoUrl,
        isOnline: true,
        phoneNumber: auth.currentUser!.uid,
        groupId: [],
      );
      await firestore.collection('users').doc(uid).set(user.toMap());
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MobileLayoutScreen()), (route) => false);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
