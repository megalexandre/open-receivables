part of '../api_endpoints.dart';

class _GenerateInvoices {
  const _GenerateInvoices();

  String get candidates => '${ApiEndpoints._base}/invoice-candidates';
  String get generate => '${ApiEndpoints._base}/invoices/generate';
}
