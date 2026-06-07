import 'package:organizagrana/features/addresses/data/addresses_api_client.dart';
import 'package:organizagrana/features/addresses/domain/address.dart';
import 'package:organizagrana/features/addresses/domain/address_failure.dart';
import 'package:organizagrana/shared/errors/app_failure.dart';

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
  }) async {
    try {
      final json = await _apiClient.list(
        page: page,
        pageSize: pageSize,
        sortBy: sortBy,
        sortAscending: sortAscending,
      );
      final data = (json['data'] as List).cast<Map<String, dynamic>>();
      return AddressesResult(
        addresses: data.map(Address.fromJson).toList(),
        total: (json['total'] as num).toInt(),
        page: (json['page'] as num).toInt(),
        pageSize: (json['pageSize'] as num).toInt(),
      );
    } on AppFailure catch (e) {
      throw AddressFailure(e.type);
    }
  }

  Future<Address> create(Address address) async {
    try {
      final json = await _apiClient.create(address);
      return Address.fromJson(json);
    } on AppFailure catch (e) {
      throw AddressFailure(e.type);
    }
  }

  Future<Address> update(Address address) async {
    try {
      final json = await _apiClient.update(address);
      return Address.fromJson(json);
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
