class AuthErrorMessagesService {
  static String getAuthErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'El correo ingresado no es válido.';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada.';
      case 'user-not-found':
        return 'No existe ninguna cuenta con este correo.';
      case 'invalid-credential':
        return 'La contraseña o email son incorrectos.';
      case 'too-many-requests':
        return 'Demasiados intentos fallidos. Inténtalo más tarde.';
      case 'email-already-in-use':
        return 'Este correo ya está registrado.';
      case 'username-already-in-use':
        return 'El nombre de usuario ya esta en uso.';
      case 'weak-password':
        return 'La contraseña es demasiado débil, se necesitan al menos 6 digitos.';
      case 'operation-not-allowed':
        return 'El método de autenticación no está habilitado.';
      default:
        return 'Ha ocurrido un error inesperado. Inténtalo nuevamente.';
    }
  }
}
