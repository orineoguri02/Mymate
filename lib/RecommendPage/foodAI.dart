//food Ai

import 'package:flutter/material.dart';
import 'package:mymate/RecommendPage/openai_service.dart';
import 'package:mymate/env/env.dart';

class FoodAIPage extends StatefulWidget {
  const FoodAIPage({Key? key}) : super(key: key);

  @override
  State<FoodAIPage> createState() => _FoodAIPageState();
}

class _FoodAIPageState extends State<FoodAIPage> {
  final TextEditingController _controller = TextEditingController();
  final OpenAIService _openAIService = OpenAIService();
  List<Map<String, String>> messages = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print("Loaded API Key: ${Env.apiKey}");
  }

  Future<void> _sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({"role": "user", "content": userMessage});
      isLoading = true;
    });

    _controller.clear();

    try {
      final aiResponse = await _openAIService.createModel(userMessage);

      setState(() {
        messages.add({"role": "ai", "content": aiResponse});
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        messages.add({"role": "ai", "content": "오류가 발생했습니다. 다시 시도해주세요."});
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '음식 추천',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(15, 20, 20, 20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message["role"] == "user";

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 7),
                  child: Row(
                    mainAxisAlignment: isUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      if (!isUser)
                        Container(
                          height: 60,
                          width: 60,
                          child: CircleAvatar(
                              child: Image.asset('assets/aimate.png')),
                        ),
                      const SizedBox(width: 8.0),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: isUser
                                ? Colors.grey[200]
                                : const Color.fromRGBO(192, 77, 71, 1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            message["content"]!,
                            style: TextStyle(
                              color: isUser ? Colors.black : Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      if (isUser) const SizedBox(width: 8.0),
                    ],
                  ),
                );
              },
            ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0XFFF2F3F5),
                    ),
                    child: TextField(
                      controller: _controller,
                      cursorColor: const Color(0XFFC5524C),
                      decoration: InputDecoration(
                        hintText: 'Ask to AI Mate...',
                        hintStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Pretendard Variable",
                          color: Color(0XFF4E5968),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            color: Color(0XFFD9D9D9),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            color: Color(0XFFD9D9D9),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            color: Color(0XFFD9D9D9),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 20),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.send_rounded,
                            size: 30,
                            color: Color(0XFF4E5968),
                          ),
                          onPressed: _sendMessage,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
