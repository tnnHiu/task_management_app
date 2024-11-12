import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthBloc() : super(AuthInitial()) {
    on<EmailSignInEvent>(_onEmailLogin);
    on<EmailSignUpEvent>(_onEmailSignup);
    on<GoogleSignInEvent>(_onGoogleSignIn);
    on<AuthGateEvent>(_onAuthGateEvent);
    on<SignOutEvent>(_onSignOutEvent);
  }

  Future<void> _onSignOutEvent(
      SignOutEvent event, Emitter<AuthState> emit) async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    emit(AuthInitial());
  }

  Future<void> _onAuthGateEvent(
    AuthGateEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (await _auth.authStateChanges().isEmpty) {
      emit(AuthFailure(errMessage: "User not logged in"));
    } else {
      emit(AuthSuccess());
    }
  }

  Future<void> _onEmailLogin(
    EmailSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(errMessage: e.message!));
    }
  }

  Future<void> _onEmailSignup(
    EmailSignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      if (event.password != event.confirmPassword) {
        emit(
          AuthFailure(
            errMessage: "Passwords do not match",
          ),
        );
        return;
      }
      await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(
        AuthFailure(errMessage: e.message!),
      );
    }
  }

  Future<void> _onGoogleSignIn(
    GoogleSignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        emit(AuthFailure(errMessage: "Google sign in failed"));
        return;
      }
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(oAuthCredential);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(errMessage: e.toString()));
    }
  }
}
