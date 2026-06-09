import 'package:organizagrana/features/addresses/data/addresses_api_client.dart';
import 'package:organizagrana/features/addresses/domain/address.dart';
import 'package:organizagrana/features/addresses/domain/address_failure.dart';
import 'package:organizagrana/shared/errors/app_failure.dart';

export 'package:organizagrana/shared/errors/app_failure.dart'
    show ValidationFailure, ApiValidationError;

class AddressesResult {
  const AddressesResult({
    required this.addresses,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<Address> addresses;
  final int total;
  final int page;
  final int pageSize;
}

class AddressesService {
  AddressesService({required AddressesApiClient apiClient})
      : _apiClient = apiClient;

  final AddressesApiClient _apiClient;

  Future<AddressesResult> list({
    int page = 1,
    int pageSize = 5,
    String? sortBy,
    bool sortAscending = true,
    String? addressType,
    String? name,
  }) async {
    try {
      final json = await _apiClient.list(
        page: page,
        pageSize: pageSize,
        sortBy: sortBy,
        sortAscending: sortAscending,
        addressType: addressType,
        name: name,
      );
      final data = (json['data'] as List).cast<Map<String, dynamic>>();
      final pagination = json['pagination'] as Map<String, dynamic>;
      return AddressesResult(
        addresses: data.map(Address.fromJson).toList(),
        total: (pagination['total_count'] as num).toInt(),
        page: (pagination['current_page'] as num).toInt(),
        pageSize: (pagination['per_page'] as num).toInt(),
      );
    } on AppFailure catch (e) {
      throw AddressFailure(e.type);
    }
  }

  Future<Address> create(Address address) async {
    try {
      final json = await _apiClient.create(address);
      return Address.fromJson(json);
    } on ValidationFailure {
      rethrow;
    } on AppFailure catch (e) {
      throw AddressFailure(e.type);
    }
  }

  Future<Address> update(Address address) async {
    try {
      final json = await _apiClient.update(address);
      return Address.fromJson(json);
    } on ValidationFailure {
      rethrow;
    } on AppFailure catch (e) {
      throw AddressFailure(e.type);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _apiClient.delete(id);
    } on AppFailure catch (e) {
      throw AddressFailure(e.type);
    }
  }
}
