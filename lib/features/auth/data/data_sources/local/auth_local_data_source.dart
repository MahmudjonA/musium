abstract class AuthLocalDataSource {
  //! Remember me
  Future<void> saveRememberMe(String email, String password);

  Future<Map<String, String>> getRemembered();

  Future<void> clearRememberedCredentials();
}

