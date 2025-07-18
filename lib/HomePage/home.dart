import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pie_chart/pie_chart.dart';
import 'findmate.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, double> _categoryCounts = {};
  late Future<void> _fetchFuture;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _fetchFuture = _fetchCategoryCounts(
      ['Korean', 'Chinese', 'Japanese', 'Western', 'LateSnack', 'Dessert'],
      _categoryCounts,
    ).then((_) {
      print("Final _categoryCounts: $_categoryCounts");
    });
  }

  Future<void> _fetchCategoryCounts(
      List<String> categories, Map<String, double> categoryCounts) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    for (String category in categories) {
      try {
        final QuerySnapshot snapshot =
            await firestore.collection(category).get();
        categoryCounts[_getCategoryLabel(category)] =
            snapshot.docs.length.toDouble();
      } catch (e) {
        print("Error fetching category $category: $e");
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 90),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                  ),
                  const SizedBox(height: 0),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Center(
              child: Text(
                "혼밥말고 함께하세요",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder(
                future: _fetchFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text("데이터 로드 중 오류 발생: ${snapshot.error}"),
                    );
                  }

                  if (_categoryCounts.isEmpty ||
                      _categoryCounts.values.every((count) => count == 0)) {
                    return const Center(child: Text("차트에 표시할 데이터가 없습니다."));
                  }

                  return Column(
                    children: [
                      const SizedBox(height: 15),
                      _buildTopCategory(),
                      const SizedBox(height: 20),
                      _buildCategoryRanking(),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 25),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLottieCircle(
                        context,
                        "https://lottie.host/38977bd0-40ec-4a0a-b57e-6b5ab196c761/Lp9GuVzlsK.json",
                        '한식',
                        'Korean'),
                    const SizedBox(width: 10),
                    _buildLottieCircle(
                        context,
                        "https://lottie.host/bfc93f77-20a0-4f4b-9d87-4242beaad756/HqbFaYRD21.json",
                        '중식',
                        'Chinese'),
                    const SizedBox(width: 10),
                    _buildLottieCircle(
                        context,
                        "https://lottie.host/e3d0f572-cc1a-47a2-9712-9c6a892fe684/kBtkxl7hoi.json",
                        '일식',
                        'Japanese'),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLottieCircle(
                        context,
                        "https://lottie.host/663b3be2-3e78-4a34-b804-00d1ec4e7d34/EPoCzQGDM4.json",
                        '양식',
                        'Western'),
                    const SizedBox(width: 10),
                    _buildLottieCircle(
                        context,
                        "https://lottie.host/057124e7-20d3-49c9-9f9f-39aff106d9d7/yG4BgeBHOU.json",
                        '야식',
                        'LateSnack'),
                    const SizedBox(width: 10),
                    _buildLottieCircle(
                        context,
                        "https://lottie.host/be08b500-e95e-4ca3-b993-6b021bfb1abc/K0L7LBexhS.json",
                        '디저트',
                        'Dessert'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCategory() {
    final sortedCategories = _categoryCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final mostPopular =
        sortedCategories.isNotEmpty ? sortedCategories.first.key : null;

    return mostPopular != null
        ? Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "🔥 $mostPopular 🔥",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(192, 77, 71, 1),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "가장 많은 사람들이 선택했어요!",
                style: TextStyle(
                    fontSize: 14, color: Color.fromARGB(255, 99, 98, 98)),
              ),
            ],
          )
        : const SizedBox();
  }

  Widget _buildCategoryRanking() {
    final sortedCategories = _categoryCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topCategory = sortedCategories.first;
    final remainingCategories = sortedCategories.sublist(1);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ExpansionPanelList(
        elevation: 1,
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            backgroundColor: Color.fromARGB(255, 245, 241, 241),
            headerBuilder: (context, isExpanded) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 12,
                  backgroundColor: _getCategoryColor(topCategory.key),
                  child: const Text(
                    '1',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  topCategory.key,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                trailing: Text(
                  "${topCategory.value.toInt()}명 참여",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              );
            },
            body: Column(
              children: [
                // 순위 목록
                Column(
                  children: remainingCategories.asMap().entries.map((entry) {
                    final rank = entry.key + 2; // 첫 번째가 이미 사용되었으므로 2부터 시작
                    final category = entry.value;

                    return ListTile(
                      leading: CircleAvatar(
                        radius: 12,
                        backgroundColor: _getCategoryColor(category.key),
                        child: Text(
                          rank.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        category.key,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      trailing: Text(
                        "${category.value.toInt()}명 참여",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    );
                  }).toList(),
                ),
                const Divider(indent: 10, endIndent: 10),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildCategoryChart(),
                ),
              ],
            ),
            isExpanded: _isExpanded, // 초기에는 접혀있도록 설정
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChart() {
    return PieChart(
        dataMap: _categoryCounts,
        animationDuration: const Duration(milliseconds: 800),
        chartType: ChartType.ring,
        ringStrokeWidth: 32,
        chartRadius: MediaQuery.of(context).size.width * 0.3,
        colorList: const [
          Color(0XFF594545),
          Color(0XFF705C5C),
          Color(0XFF815B5B),
          Color(0XFF9E7676),
          Color(0XFFAB9B9B),
          Color(0XFFBAAAAA),
        ],
        chartValuesOptions: const ChartValuesOptions(
          showChartValuesInPercentage: true,
          showChartValues: true,
          chartValueBackgroundColor: Colors.grey,
        ),
        legendOptions: const LegendOptions(
          showLegends: true,
        ),
        centerText: "FOOD");
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'Korean':
        return '한식';
      case 'Chinese':
        return '중식';
      case 'Japanese':
        return '일식';
      case 'Western':
        return '양식';
      case 'LateSnack':
        return '야식';
      case 'Dessert':
        return '디저트';
      default:
        return category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case '한식':
        return Color(0XFF594545);
      case '중식':
        return Color(0XFF705C5C);
      case '일식':
        return Color(0XFF815B5B);
      case '양식':
        return Color(0XFF9E7676);
      case '야식':
        return Color(0XFF705C5C);
      case '디저트':
        return Color(0XFFBAAAAA);
      default:
        return Colors.grey;
    }
  }

  Widget _buildLottieCircle(
      BuildContext context, String lottieUrl, String label, String category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FindMatePage(selectedCategory: category),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          width: 110,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Lottie.network(
                    lottieUrl,
                    fit: BoxFit.cover,
                    repeat: true,
                    animate: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  label,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
