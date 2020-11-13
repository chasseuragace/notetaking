import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';



class FireBaseAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  User  _loggedinUser;
  String get getLoggedInUser => _loggedinUser?.uid;
//user login state
  Stream<User> get loggedInUser {
    return auth.authStateChanges().map((user) {
      if (user == null) {
        //  print('User is currently signed out!');
      } else {
_loggedinUser=user;
        print(
            " created at ${user.metadata.creationTime} login at ${user.metadata.lastSignInTime}  ");
        print(
            " difference ${user.metadata.lastSignInTime.difference(user.metadata.creationTime).inSeconds} seconds ");
        if (user.metadata.lastSignInTime
                .difference(user.metadata.creationTime)
                .inSeconds <
            5) {
          print("create new user object in firebase");
          /*{
          storeService.adduser(user);
        }*/
        }
      }
      return user;
    });
  }



  //signout
  signOut() async {
    await FirebaseAuth.instance.signOut();
    GoogleSignIn().disconnect();
  }

  //delete my account
  delete() async {
    try {
      await FirebaseAuth.instance.currentUser.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
      }
    }
  }

//sign in with google
  Future<UserCredential> signInWithGoogle(
      {bool silent = false, Null Function() onError}) async {
    // Trigger the authentication flow
    try {
      GoogleSignInAccount googleUser;
      if (silent)
        googleUser = await GoogleSignIn().signInSilently();
      else
        googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // Create a new credential
      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      print("exception on login ${e.runtimeType}");
      onError();
      return null;
    }
  }
}
