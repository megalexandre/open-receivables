// Parâmetros fixos de qualidade da água exigidos pelo sistema.
const List<String> kWaterParameters = [
  'Cor Aparente',
  'Turbidez',
  'Cloro Residual',
  'Escherichia Coli',
  'Coliformes Totais',
];

class WaterAnalysis {
  const WaterAnalysis({
    required this.id,
    required this.reference,
    required this.parameter,
    required this.required_,
    required this.analyzed,
    required this.conformity,
    required this.compliant,
  });

  final String id;
  final String reference; // "03/2026"
  final String parameter;
  final double required_;
  final double analyzed;
  final double conformity;
  final bool compliant;

  factory WaterAnalysis.fromJson(Map<String, dynamic> json) => WaterAnalysis(
        id: json['id'] as String,
        reference: json['reference'] as String,
        parameter: json['parameter'] as String,
        required_: (json['required'] as num).toDouble(),
        analyzed: (json['analyzed'] as num).toDouble(),
        conformity: (json['conformity'] as num).toDouble(),
        compliant: json['compliant'] as bool,
      );
}

class WaterAnalysisEntry {
  const WaterAnalysisEntry({
    required this.parameter,
    required this.required_,
    required this.analyzed,
    required this.conformity,
  });

  final String parameter;
  final double required_;
  final double analyzed;
  final double conformity;

  Map<String, dynamic> toJson() => {
        'parameter': parameter,
        'required': required_,
        'analyzed': analyzed,
        'conformity': conformity,
      };
}

class WaterAnalysisBatch {
  const WaterAnalysisBatch({
    required this.month,
    required this.year,
    required this.entries,
  });

  final int month;
  final int year;
  final List<WaterAnalysisEntry> entries;

  Map<String, dynamic> toJson() => {
        'month': month,
        'year': year,
        'entries': entries.map((e) => e.toJson()).toList(),
      };
}
