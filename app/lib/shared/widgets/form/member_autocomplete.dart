import 'package:flutter/material.dart';
import 'package:organizagrana/features/members/domain/member.dart';

typedef MemberSearch = Future<List<Member>> Function(String query);

/// Autocomplete de sócios com busca no servidor: o usuário digita e as
/// opções retornadas pela API aparecem abaixo do campo. A busca é
/// debounced para não consultar a cada tecla.
///
/// O valor reportado em [onChanged]/[validator] fica nulo enquanto o
/// texto digitado não corresponder a uma opção escolhida.
class MemberAutocomplete extends StatefulWidget {
  const MemberAutocomplete({
    required this.search,
    required this.onChanged,
    this.initialValue,
    this.validator,
    this.label = 'Sócio',
    super.key,
  });

  final MemberSearch search;
  final ValueChanged<Member?>? onChanged;
  final Member? initialValue;
  final FormFieldValidator<Member>? validator;
  final String label;

  @override
  State<MemberAutocomplete> createState() => _MemberAutocompleteState();
}

class _MemberAutocompleteState extends State<MemberAutocomplete> {
  static const _debounce = Duration(milliseconds: 300);

  late final TextEditingController _controller;
  final _focusNode = FocusNode();

  Member? _selected;
  String _lastQuery = '';
  List<Member> _lastOptions = const [];
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
    _controller = TextEditingController(
      text: _selected != null ? _display(_selected!) : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  static String _display(Member m) =>
      m.memberNumber != null ? '${m.memberNumber} – ${m.name}' : m.name;

  Future<Iterable<Member>> _search(TextEditingValue value) async {
    final query = value.text.trim();
    _lastQuery = query;
    await Future<void>.delayed(_debounce);
    // Outra tecla chegou durante o debounce; deixa a chamada mais nova buscar.
    if (query != _lastQuery) return _lastOptions;

    if (mounted) setState(() => _searching = true);
    try {
      final results = await widget.search(query);
      if (query == _lastQuery) _lastOptions = results;
      return _lastOptions;
    } catch (_) {
      return _lastOptions;
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  void _onSelected(Member m) {
    setState(() => _selected = m);
    widget.onChanged?.call(m);
  }

  // Editar o texto invalida a seleção até o usuário escolher de novo.
  void _onTextChanged(String text) {
    if (_selected == null) return;
    if (_display(_selected!) != text) {
      setState(() => _selected = null);
      widget.onChanged?.call(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RawAutocomplete<Member>(
          textEditingController: _controller,
          focusNode: _focusNode,
          displayStringForOption: _display,
          optionsBuilder: _search,
          onSelected: _onSelected,
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: widget.label,
                isDense: true,
                suffixIcon: _searching
                    ? const Padding(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : const Icon(Icons.search, size: 16),
              ),
              validator: (_) => widget.validator?.call(_selected),
              onChanged: _onTextChanged,
              onFieldSubmitted: (_) => onFieldSubmitted(),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            final highlighted = AutocompleteHighlightedOption.of(context);
            final colorScheme = Theme.of(context).colorScheme;
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(6),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 240,
                    maxWidth: constraints.maxWidth,
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final m = options.elementAt(index);
                      return InkWell(
                        onTap: () => onSelected(m),
                        child: Container(
                          color: index == highlighted
                              ? colorScheme.primary.withValues(alpha: 0.08)
                              : null,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Text(
                            _display(m),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
