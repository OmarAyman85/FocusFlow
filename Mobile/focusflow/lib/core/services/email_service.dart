// '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'; // Replace with your SendGrid API key
import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  final String apiKey =
      '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'; // Replace with your SendGrid API key

  Future<void> sendEmail(
    String recipientEmail,
    String subject,
    String message,
  ) async {
    final url = Uri.parse('https://api.sendgrid.com/v3/mail/send');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final body = json.encode({
      "personalizations": [
        {
          "to": [
            {"email": recipientEmail},
          ],
          "subject": subject,
        },
      ],
      "from": {
        "email": "omar.shivy85@gmail.com",
      }, // Replace with your verified SendGrid sender email
      "content": [
        {"type": "text/plain", "value": message},
      ],
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 202) {
      // print("Email sent successfully!");
    } else {
      // print("Failed to send email: ${response.statusCode}");
      // print("Response body: ${response.body}");
    }
  }
}
