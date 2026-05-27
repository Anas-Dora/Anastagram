class ActionFeedback {
  const ActionFeedback(this.message, {this.isError = false});

  final String message;
  final bool isError;
}

