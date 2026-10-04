class Validators {
  Validators._();

  static String? campoObrigatorio(
    String? valor, {
    String mensagem = 'Este campo é obrigatório.',
  }) {
    if (valor == null || valor.trim().isEmpty) {
      return mensagem;
    }
    return null;
  }

  static String? nomeArtista(String? valor) {
    final obrigatorio =
        campoObrigatorio(valor, mensagem: 'Informe o nome de um artista.');
    if (obrigatorio != null) return obrigatorio;

    if (valor!.trim().length < 2) {
      return 'Digite pelo menos 2 caracteres.';
    }
    return null;
  }
}
