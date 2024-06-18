
import 'package:http/http.dart' as http;
import 'dart:async';

Future<http.Response> fetchData(String url) async {
  int retryCount = 0;
  const int maxRetries = 3;
  const Duration retryDelay = Duration(seconds: 2);

  while (retryCount < maxRetries) {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      retryCount++;
      if (retryCount >= maxRetries) {
        rethrow;
      }
      await Future.delayed(retryDelay);
    }
  }
  throw Exception('Max retries reached');
}
