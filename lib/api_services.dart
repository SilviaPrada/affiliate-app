import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class ApiService {
  static const String baseUrl = "http://192.168.0.104:5000/api";

  // Simpan token
  static Future<void> saveToken(String token, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
    await prefs.setString("role", role);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("role");
  }

  // Login
  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );
    return jsonDecode(res.body);
  }

  // Get Members
  static Future<List<dynamic>> getMembers() async {
    final token = await getToken();
    final res = await http.get(
      Uri.parse("$baseUrl/members"),
      headers: {"Authorization": "Bearer $token"},
    );

    final decoded = jsonDecode(res.body);

    if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
      // Jika API membungkus data di dalam 'data'
      return decoded['data'] as List<dynamic>;
    } else if (decoded is List) {
      // Jika langsung berupa list (seperti contoh JSON kamu)
      return decoded;
    } else {
      throw Exception("Invalid API response: expected List or data[]");
    }
  }

  // Get Managers for ComboBox
  static Future<List<dynamic>> getManagers() async {
    final token = await getToken();
    final res = await http.get(
      Uri.parse("$baseUrl/members/managers"),
      headers: {"Authorization": "Bearer $token"},
    );
    return jsonDecode(res.body);
  }

  // Add Member
  static Future<void> addMember(Map<String, dynamic> data) async {
    final token = await getToken();
    await http.post(
      Uri.parse("$baseUrl/members"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );
  }

  // Update Member (PUT)
  static Future<void> updateMember(String id, Map<String, dynamic> data) async {
    final token = await getToken();
    await http.put(
      Uri.parse("$baseUrl/members/$id"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );
  }

  // Delete Member (DELETE)
  static Future<void> deleteMember(String id) async {
    final token = await getToken();
    await http.delete(
      Uri.parse("$baseUrl/members/$id"),
      headers: {"Authorization": "Bearer $token"},
    );
  }

  // Report
  static Future<List<dynamic>> getReport() async {
    final token = await getToken();
    final res = await http.get(
      Uri.parse("$baseUrl/reports"),
      headers: {"Authorization": "Bearer $token"},
    );
    return jsonDecode(res.body);
  }
  
  static Future<String?> downloadReportExcel() async {
    try {
      if (Platform.isAndroid) {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          print("Storage permission denied");
          return null;
        }
      }

      final token = await getToken();
      final res = await http.get(
        Uri.parse("$baseUrl/reports/export"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        final bytes = res.bodyBytes;

        Directory? dir;
        if (Platform.isAndroid) {
          dir = Directory('/storage/emulated/0/Download');
          if (!await dir.exists()) {
            dir = await getExternalStorageDirectory();
          }
        } else {
          dir = await getApplicationDocumentsDirectory();
        }

        final file = File("${dir!.path}/report.xlsx");

        await file.writeAsBytes(bytes);
        print("Excel saved to: ${file.path}");

        await OpenFilex.open(file.path);
        return file.path;
      } else {
        print("Download failed: ${res.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error downloading Excel: $e");
      return null;
    }
  }
}
