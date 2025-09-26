import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = "http://your-api-url.com/api/v1";

  // Secure storage for tokens
  final _storage = const FlutterSecureStorage();
  String? _accessToken;
  String? _refreshToken;

  /// ===== AUTH =====

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/token/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data["access"];
      _refreshToken = data["refresh"];

      await _storage.write(key: "access", value: _accessToken);
      await _storage.write(key: "refresh", value: _refreshToken);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
    await _storage.deleteAll();
  }

  Future<bool> refreshToken() async {
    final storedRefresh = await _storage.read(key: "refresh");
    if (storedRefresh == null) return false;

    final response = await http.post(
      Uri.parse("$baseUrl/token/refresh/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"refresh": storedRefresh}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data["access"];
      await _storage.write(key: "access", value: _accessToken);
      return true;
    }
    return false;
  }

  Future<Map<String, String>> _authHeaders() async {
    _accessToken ??= await _storage.read(key: "access");
    return {
      "Content-Type": "application/json",
      if (_accessToken != null) "Authorization": "Bearer $_accessToken",
    };
  }

  /// ===== REQUESTS =====

  Future<List<dynamic>> getRequests() async {
    final headers = await _authHeaders();
    final res = await http.get(
      Uri.parse("$baseUrl/requests/"),
      headers: headers,
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception("Failed to load requests");
  }

  Future<Map<String, dynamic>> createRequest({
    required String requestType,
    required String description,
    required double amount,
    required int requester,
    required int department,
    required int glCode,
    required String status,
  }) async {
    final headers = await _authHeaders();
    final res = await http.post(
      Uri.parse("$baseUrl/requests/"),
      headers: headers,
      body: jsonEncode({
        "request_type": requestType,
        "description": description,
        "amount": amount,
        "status": status,
        "requester": requester,
        "department": department,
        "gl_code": glCode,
      }),
    );

    if (res.statusCode == 201) {
      return jsonDecode(res.body);
    }
    throw Exception("Failed to create request: ${res.body}");
  }

  /// ===== APPROVALS =====

  Future<List<dynamic>> getApprovals() async {
    final headers = await _authHeaders();
    final res = await http.get(
      Uri.parse("$baseUrl/approvals/"),
      headers: headers,
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception("Failed to load approvals");
  }

  Future<Map<String, dynamic>> createApproval({
    required String action,
    required String comments,
    required int requestId,
    required int approver,
  }) async {
    final headers = await _authHeaders();
    final res = await http.post(
      Uri.parse("$baseUrl/approvals/"),
      headers: headers,
      body: jsonEncode({
        "action": action,
        "comments": comments,
        "request": requestId,
        "approver": approver,
      }),
    );

    if (res.statusCode == 201) {
      return jsonDecode(res.body);
    }
    throw Exception("Failed to create approval: ${res.body}");
  }

  /// ===== PAYMENTS =====

  Future<List<dynamic>> getPayments() async {
    final headers = await _authHeaders();
    final res = await http.get(
      Uri.parse("$baseUrl/payments/"),
      headers: headers,
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception("Failed to load payments");
  }

  Future<Map<String, dynamic>> createPayment({
    required String method,
    required String referenceNo,
    required String paidAt,
    required String proofDoc,
    required int request,
    required int paidBy,
  }) async {
    final headers = await _authHeaders();
    final res = await http.post(
      Uri.parse("$baseUrl/payments/"),
      headers: headers,
      body: jsonEncode({
        "payment_method": method,
        "reference_no": referenceNo,
        "paid_at": paidAt,
        "proof_doc": proofDoc,
        "request": request,
        "paid_by": paidBy,
      }),
    );

    if (res.statusCode == 201) {
      return jsonDecode(res.body);
    }
    throw Exception("Failed to create payment: ${res.body}");
  }

  /// ===== LOOKUPS =====

  Future<List<dynamic>> getDepartments() async {
    final headers = await _authHeaders();
    final res = await http.get(
      Uri.parse("$baseUrl/departments/"),
      headers: headers,
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception("Failed to load departments");
  }

  Future<List<dynamic>> getGlCodes() async {
    final headers = await _authHeaders();
    final res = await http.get(
      Uri.parse("$baseUrl/glcodes/"),
      headers: headers,
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception("Failed to load GL Codes");
  }

  Future<List<dynamic>> getVendors() async {
    final headers = await _authHeaders();
    final res = await http.get(
      Uri.parse("$baseUrl/vendors/"),
      headers: headers,
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception("Failed to load vendors");
  }

  /// ===== USERS =====

  Future<List<dynamic>> getUsers() async {
    final headers = await _authHeaders();
    final res = await http.get(Uri.parse("$baseUrl/users/"), headers: headers);
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception("Failed to load users");
  }
}
