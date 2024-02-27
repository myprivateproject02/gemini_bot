import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gemini_bot/models/chat_message_model.dart';
import 'package:gemini_bot/utils/constant.dart';

class ChatRepo {
  static Future<String> chatTextGenerationRepo(
      List<ChatMessageModel> previousMessages) async {
    try {
      Dio dio = Dio();

      final response = await dio.post(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$API_KEY",
          data: {
            "contents": previousMessages.map((e) => e.toMap()).toList(),
            "generationConfig": {
              "temperature": 0.2,
              "topK": 1,
              "topP": 1,
              "maxOutputTokens": 2048,
              "stopSequences": []
            },
            "safetySettings": [
              {
                "category": "HARM_CATEGORY_HARASSMENT",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
              },
              {
                "category": "HARM_CATEGORY_HATE_SPEECH",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
              },
              {
                "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
              },
              {
                "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
                "threshold": "BLOCK_MEDIUM_AND_ABOVE"
              }
            ]
          });

      var jsonRespomse = jsonEncode(response.data);
      print("jsonRespomse is = $jsonRespomse");

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return response
            .data['candidates'].first['content']['parts'].first['text'];
      }

      return '';
    } catch (e) {
      print("error $e");
      return '';
    }
  }
}
