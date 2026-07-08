import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatMessage extends Equatable {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({required this.text, required this.isUser, required this.timestamp});

  @override
  List<Object?> get props => [text, isUser, timestamp];
}

abstract class AiCompanionState extends Equatable {
  const AiCompanionState();
  @override
  List<Object?> get props => [];
}

class AiCompanionIdle extends AiCompanionState {
  final List<ChatMessage> history;
  const AiCompanionIdle(this.history);

  @override
  List<Object?> get props => [history];
}
class AiCompanionListening extends AiCompanionState {}
class AiCompanionThinking extends AiCompanionState {
  final List<ChatMessage> history;
  const AiCompanionThinking(this.history);

  @override
  List<Object?> get props => [history];
}

class AiCompanionCubit extends Cubit<AiCompanionState> {
  AiCompanionCubit() : super(const AiCompanionIdle([])) {
    // Initial welcome message from Lumina Guardian AI
    emit(AiCompanionIdle([
      ChatMessage(
        text: "Hello! I am your Lumina Guardian AI companion. I'm monitoring in the background and listening for safety wake words. How are you feeling tonight?",
        isUser: false,
        timestamp: DateTime.now(),
      )
    ]));
  }

  void sendMessage(String text) async {
    if (state is AiCompanionIdle) {
      final currentHistory = List<ChatMessage>.from((state as AiCompanionIdle).history);
      currentHistory.add(ChatMessage(text: text, isUser: true, timestamp: DateTime.now()));
      emit(AiCompanionThinking(currentHistory));
      
      // Simulate AI response delay
      await Future.delayed(const Duration(milliseconds: 1200));
      
      String aiResponse = "I've logged that. I am here with you. Your emergency contacts are primed and we are tracking carefully.";
      if (text.toLowerCase().contains("help") || text.toLowerCase().contains("danger")) {
        aiResponse = "I detected potential distress. Would you like me to arm the pre-alert timer or initiate emergency tracking?";
      }
      
      currentHistory.add(ChatMessage(text: aiResponse, isUser: false, timestamp: DateTime.now()));
      emit(AiCompanionIdle(currentHistory));
    }
  }

  void startVoiceInteraction() {
    emit(AiCompanionListening());
  }

  void stopVoiceInteraction(String recognizedText) {
    emit(const AiCompanionIdle([]));
    if (recognizedText.isNotEmpty) {
      sendMessage(recognizedText);
    }
  }
}
