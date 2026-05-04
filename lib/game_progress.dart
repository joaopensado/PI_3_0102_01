class GameProgress {
  static bool bibliotecaDesbloqueada = false;
  static bool missaoCorujitoAceita = false;
  static bool livroCorujitoEncontrado = false;
  static bool livroCorujitoEntregue = false;

  static void desbloquearBiblioteca() {
    bibliotecaDesbloqueada = true;
  }

  static void aceitarMissaoCorujito() {
    missaoCorujitoAceita = true;
  }

  static void marcarLivroCorujitoEncontrado() {
    livroCorujitoEncontrado = true;
  }

  static void entregarLivroCorujito() {
    livroCorujitoEntregue = true;
    livroCorujitoEncontrado = false;
  }

  static void resetar() {
    bibliotecaDesbloqueada = false;
    missaoCorujitoAceita = false;
    livroCorujitoEncontrado = false;
    livroCorujitoEntregue = false;
  }
}
