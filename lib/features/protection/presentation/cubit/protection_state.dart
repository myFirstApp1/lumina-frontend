abstract class ProtectionState {
  const ProtectionState();
}

class ProtectionInitial extends ProtectionState {
  const ProtectionInitial();
}

class ProtectionLoading extends ProtectionState {
  const ProtectionLoading();
}

class ProtectionActive extends ProtectionState {
  final String status;

  const ProtectionActive({
    required this.status,
  });
}

class ProtectionPaused extends ProtectionState {
  final int minutes;

  const ProtectionPaused({
    required this.minutes,
  });
}

class ProtectionStopped extends ProtectionState {
  const ProtectionStopped();
}

class ProtectionError extends ProtectionState {
  final String message;

  const ProtectionError(this.message);
}