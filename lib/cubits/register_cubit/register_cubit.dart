import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> registerUser(
      {required String email, required String password}) async {
    emit(RegisterLoading());
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'user-not-found') {
        emit(RegisterFailure(errorMessage: 'user-not-found'));
      } else if (ex.code == 'wrong-password') {
        emit(RegisterFailure(errorMessage: 'wrong-password'));
      }
    } catch (e) {
      emit(RegisterFailure(errorMessage: 'something went wrong'));
    }
  }
}
