import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService{
  GoogleAuthService._();
  static GoogleAuthService googleAuthService = GoogleAuthService._();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signInWithGoogle() async {
    try{
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // UserCredential userCredential =
      await  FirebaseAuth.instance.signInWithCredential(credential);
    }catch(e){
      // print("------------------> Error in Google Sign In $e");
    }
  }

  Future<void> signOutFromGoogle() async {
    await GoogleSignIn().signOut();
  }

  User? getCurrentUser(){
    User? user = _firebaseAuth.currentUser;
    return user;
  }
}