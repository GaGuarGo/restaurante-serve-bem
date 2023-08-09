// ignore_for_file: unnecessary_getters_setters

class TamanhoMarmita {
  late int _quantidadeVendida = 0;
  late double _precoTotalVendido = 0;

  late String _tamanho;

  String get tamanho => _tamanho;

  set tamanho(String tamanho) {
    _tamanho = tamanho;
  }

  int get quantidadeVendida => _quantidadeVendida;

  set quantidadeVendida(int quantidadeVendida) {
    _quantidadeVendida = quantidadeVendida;
  }

  double get precoTotalVendido => _precoTotalVendido;

  set precoTotalVendido(double precoTotalVendido) {
    _precoTotalVendido = precoTotalVendido;
  }
}
