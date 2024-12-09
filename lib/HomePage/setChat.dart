import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mymate/moveMap.dart';
import 'products.dart';

class ChatPage extends StatefulWidget {
  final String category;

  const ChatPage({Key? key, required this.category}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();
  String _selectedGender = 'men';
  int? _selectedCount;
  LatLng? _location;

  final List<int> _dropdownItems = [1, 2, 3, 4, 5, 6]; // 인원 수를 정수로 정의

  Future<void> _saveChat() async {
    final String title = _titleController.text;
    final String memo = _memoController.text;

    if (title.isEmpty ||
        memo.isEmpty ||
        _selectedCount == null ||
        _location == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 필드를 입력해주세요.')),
      );
      return;
    }

    try {
      await _firestoreService.addMate(
        category: widget.category,
        title: title,
        memo: memo,
        gender: _selectedGender,
        count: _selectedCount!,
        location: GeoPoint(_location!.latitude, _location!.longitude),
        currentCount: 0,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('채팅방이 성공적으로 저장되었습니다!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 중 오류가 발생했습니다: $e')),
      );
    }
  }

  Future<void> _pickLocation() async {
    final LatLng? selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Movelocation(),
      ),
    );
    if (selectedLocation != null) {
      setState(() {
        _location = selectedLocation;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅방 생성'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: '채팅방 이름',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _memoController,
                decoration: InputDecoration(
                  labelText: '메모',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<int>(
                      hint: const Text('인원 수'),
                      value: _selectedCount,
                      items: _dropdownItems.map((int item) {
                        return DropdownMenuItem<int>(
                          value: item,
                          child: Text('$item명'),
                        );
                      }).toList(),
                      onChanged: (int? value) {
                        setState(() {
                          _selectedCount = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Radio<String>(
                        value: 'men',
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value!;
                          });
                        },
                      ),
                      Text('남자'),
                    ],
                  ),
                  SizedBox(width: 10),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'woman',
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value!;
                          });
                        },
                      ),
                      Text('여자'),
                    ],
                  ),
                  SizedBox(width: 10),
                  Row(
                    children: [
                      Radio<String>(
                        value: 'doncare',
                        groupValue: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value!;
                          });
                        },
                      ),
                      Text('남녀무관'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: _pickLocation,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(width: 1, color: Color(0XFFC5524C)),
                  ),
                ),
                child: Text(
                  _location == null ? '위치 설정' : '위치 수정',
                  style: TextStyle(
                    color: Color(0XFFC5524C),
                    fontSize: 15,
                    fontFamily: 'Pretendard Variable',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: ElevatedButton(
                  onPressed: _saveChat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(192, 77, 71, 1),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text(
                    '생성하기',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Pretendard Variable',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
