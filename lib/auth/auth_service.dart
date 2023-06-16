
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService{
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final User? user =_auth.currentUser;


  static Future<bool> login (String email,String pass) async{
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: pass);/*1.1 email ba pass vul hole next line e jabe na jabe login e*/
    return credential.user != null;
  }

  static Future<bool> register (String email,String pass) async{
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: pass);/*1.1 email ba pass vul hole next line e jabe na jabe login e*/
    return credential.user != null;
  }


  static Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  static Future<void> logout() => _auth.signOut();
}