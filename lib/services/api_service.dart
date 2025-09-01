import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "http://192.168.1.7:9000/api", // Android Emulator
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    },
  ));

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> register(String name, String email, String password, String confirmPassword) async {
    final response = await _dio.post("/register", data: {
      "name": name,
      "email": email,
      "password": password,
      "password_confirmation": confirmPassword,
    });
    await storage.write(key: "token", value: response.data["token"]);
    return response.data;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _dio.post("/login", data: {
      "email": email,
      "password": password,
    });
    await storage.write(key: "token", value: response.data["token"]);
    return response.data;
  }

  Future<Map<String, dynamic>> getProfile() async {
    String? token = await storage.read(key: "token");
    final response = await _dio.get("/me",
        options: Options(headers: {"Authorization": "Bearer $token"}));
    return response.data;
  }

  Future<void> logout() async {
    String? token = await storage.read(key: "token");
    await _dio.post("/logout",
        options: Options(headers: {"Authorization": "Bearer $token"}));
    await storage.delete(key: "token");
  }
}
