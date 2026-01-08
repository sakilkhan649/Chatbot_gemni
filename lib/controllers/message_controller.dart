import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class MessageController extends GetxController {
  var responseText = "".obs;
  var messages = <Map<String, dynamic>>[].obs;
  var isTyping = false.obs;

  Future<void> sendMessage(String message) async {
    // Add user message
    messages.add({'text': message, 'isUser': true, 'time': _formattedTime()});

    responseText.value = "Thinking...";
    isTyping.value = true;

    update(); // Optional, mainly for GetBuilder

    try {
      String reply = await GooglleApiService.getApiResponse(message);

      responseText.value = reply;

      // Add AI response
      messages.add({'text': reply, 'isUser': false, 'time': _formattedTime()});
    } catch (e) {
      responseText.value = "Error: ${e.toString()}";
    } finally {
      isTyping.value = false;
      update();
    }
  }

  String _formattedTime() {
    return DateFormat('hh:mm a').format(DateTime.now());
  }
}
