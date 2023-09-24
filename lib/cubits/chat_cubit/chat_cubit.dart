import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../../constants.dart';
import '../../models/message_model.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  List<Message> messagesList = [];
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollections);

  ChatCubit() : super(ChatInitial());

  void sendMessage({required String message, required String email}) {
    messagesList.clear();
    messages.add(
      {kMessage: message, kCreatedAt: DateTime.now(), 'id': email},
    );
  }

  void getMessages() {
    messages.orderBy(kCreatedAt, descending: true).snapshots().listen((event) {
      messagesList = List.generate(
          event.docs.length, (index) => Message.fromJson(event.docs[index]));
      emit(ChatSuccess(messages: messagesList));
    });
  }
}
