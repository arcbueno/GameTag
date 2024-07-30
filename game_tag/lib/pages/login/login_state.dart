sealed class LoginState {}

class LoginFormState extends LoginState {
  final bool isLoading;
  final String? errorMessage;

  LoginFormState({
    this.isLoading = false,
    this.errorMessage,
  });

  LoginFormState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return LoginFormState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class SignupFormState extends LoginState {
  final bool isLoading;
  final String? errorMessage;

  SignupFormState({
    this.isLoading = false,
    this.errorMessage,
  });

  SignupFormState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return SignupFormState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
