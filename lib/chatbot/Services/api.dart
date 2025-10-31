import '../Screens/chat/message.dart';
import 'package:dio/dio.dart';

class API {
  final Dio dio = Dio();
  CancelToken cancelToken = CancelToken();

  // Converts messages to a format suitable for the API
  List<Map<String, dynamic>> convertToConversation(List<Message> messages) {
    return messages.map((message) {
      return {
        'content': message.message ?? '',
        'role': message.role ? 'assistant' : 'user',
      };
    }).toList();
  }

  Future<void> stopGenerating() async {
    if (!cancelToken.isCancelled) {
      cancelToken.cancel("Stopped by user.");
    }
    cancelToken = CancelToken();
  }

  // TODO: Replace with your own API endpoint and request logic
  Future<String?> getResponse(String prompt, List<Message> messages) async {
    try {
      final response = await dio.post(
          'https://your-api-endpoint.com', // Replace this URL with your API
          data: {
            'conversation': convertToConversation(messages),
            'prompt': prompt,
            'model': 'YOUR_MODEL_HERE', // Replace with your AI model if needed
          },
          cancelToken: cancelToken,
          options: Options(
              headers: {
                'Content-Type': 'application/json'
              }
          )
      );
      return response.data['body'];
    } catch (e) {
      if (e is DioException) {
        if (CancelToken.isCancel(e)) {
          print("Request was cancelled.");
          return null;
        }

        String errorPrefix = 'Error generating response: ';

        switch (e.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            return errorPrefix + "Connection timed out. Please check your internet and try again.";
          case DioExceptionType.badResponse:
            return errorPrefix + "Server returned an error. Please try again later.";
          case DioExceptionType.connectionError:
          case DioExceptionType.unknown:
            return errorPrefix + "Could not connect to the server. Please check your internet connection.";
          default:
            return errorPrefix + "An unexpected error occurred. Please try again.";
        }
      }

      return 'Error generating response: $e';
    }
  }
}
