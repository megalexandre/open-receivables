import 'package:flutter/material.dart';
import 'package:organizagrana/features/boletos/domain/boleto.dart';

class BoletoFilterBar extends StatefulWidget {
  const BoletoFilterBar({
    super.key,
    required this.onFilter,
    required this.onPrint,
  });

  final void Function(BoletoFilter) onFilter;
  final VoidCallback onPrint;

  @override
  State<BoletoFilterBar> createState() => _BoletoFilterBarState();
}

class _BoletoFilterBarState extends State<BoletoFilterBar> {
  final _numberCtrl = TextEditingController();
  final _memberCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _competenciaCtrl = TextEditingController();
  final _vencimentoCtrl = TextEditingController();
  BoletoStatus? _status;

  @override
  void dispose() {
    _numberCtrl.dispose();
    _memberCtrl.dispose();
    _addressCtrl.dispose();
    _competenciaCtrl.dispose();
    _vencimentoCtrl.dispose();
    super.dispose();
  }

  void _clear() {
    setState(() {
      _numberCtrl.clear();
      _memberCtrl.clear();
      _addressCtrl.clear();
      _competenciaCtrl.clear();
      _vencimentoCtrl.clear();
      _status = null;
    });
    widget.onFilter(const BoletoFilter());
  }

  void _consult() {
    widget.onFilter(BoletoFilter(
      number: _numberCtrl.text.trim().isEmpty ? null : _numberCtrl.text.trim(),
      memberSearch:
          _memberCtrl.text.trim().isEmpty ? null : _memberCtrl.text.trim(),
      status: _status,
      addressSearch:
          _addressCtrl.text.trim().isEmpty ? null : _addressCtrl.text.trim(),
      competencia: _competenciaCtrl.text.trim().isEmpty
          ? null
          : _competenciaCtrl.text.trim(),
      vencimento: _vencimentoCtrl.text.trim().isEmpty
          ? null
          : _vencimentoCtrl.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _field('Número', _numberCtrl, hint: '25XXXX', width: 120),
                const SizedBox(width: 12),
                _statusDropdown(),
                const SizedBox(width: 12),
                _field('Sócio', _memberCtrl, hint: 'Nome ou número', width: 180),
                const SizedBox(width: 12),
                _field('Endereço', _addressCtrl,
                    hint: 'Av. Fernando...', width: 180),
                const SizedBox(width: 12),
                _field('Competência', _competenciaCtrl,
                    hint: 'MM/AAAA', width: 110),
                const SizedBox(width: 12),
                _field('Vencimento', _vencimentoCtrl,
                    hint: 'dd/MM/aaaa', width: 120),
                const Spacer(),
                TextButton.icon(
                  onPressed: _clear,
                  icon: const Icon(Icons.refresh_outlined, size: 16),
                  label: const Text('Limpar'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: widget.onPrint,
                  icon: const Icon(Icons.print_outlined, size: 16),
                  label: const Text('Imprimir'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _consult,
                  icon: const Icon(Icons.search_outlined, size: 16),
                  label: const Text('Consultar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl,
      {String? hint, double width = 160}) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 4),
          TextFormField(
            controller: ctrl,
            decoration: InputDecoration(
              hintText: hint,
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusDropdown() {
    return SizedBox(
      width: 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status', style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 4),
          DropdownButtonFormField<BoletoStatus?>(
            initialValue: _status,
            decoration: const InputDecoration(isDense: true),
            items: [
              const DropdownMenuItem(child: Text('Todos')),
              ...BoletoStatus.values.map(
                (s) => DropdownMenuItem(value: s, child: Text(s.label)),
              ),
            ],
            onChanged: (v) => setState(() => _status = v),
          ),
        ],
      ),
    );
  }
}
