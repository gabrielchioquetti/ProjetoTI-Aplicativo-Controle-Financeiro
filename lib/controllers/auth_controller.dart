class AuthController {
  static String? validarCadastro({
    required String nome,
    required String email,
    required String senha,
    required String confirmarSenha,
  }) {
    if (
      nome.isEmpty ||
      email.isEmpty ||
      senha.isEmpty ||
      confirmarSenha.isEmpty
    ) {
      return "Preencha todos os campos";
    }
    if (!email.contains("@")) {
      return "Digite um email válido";
    }
    if (senha.length < 6) {
      return "A senha deve ter no mínimo 6 caracteres";
    }
    if (senha != confirmarSenha) {
      return "As senhas não coincidem";
    }
    return null;
  }
  static String? validarLogin({
    required String email,
    required String senha,
  }) {
    if (
      email.isEmpty ||
      senha.isEmpty
    ) {
      return "Preencha todos os campos";
    }
    if (!email.contains("@")) {
      return "Digite um email válido";
    }
    return null;
  }
}