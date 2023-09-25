import 'package:aiffelthon_hair/ui_screen/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'servey_result_screen.dart';

//void main() => runApp(
//      ChangeNotifierProvider(
//        create: (context) => ThemeProvider(),
//        child: MyApp(),
//      ),
//    );

// class ThemeProvider extends ChangeNotifier {
//   bool _isDarkModeOn = false;

//   bool get isDarkModeOn => _isDarkModeOn;

//   void toggleTheme() {
//     _isDarkModeOn = !_isDarkModeOn;
//     notifyListeners();
//   }
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Dark Mode Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.green,
//         brightness: Brightness.light,
//       ),
//       darkTheme: ThemeData(
//         brightness: Brightness.dark,
//       ),
//       home: const NavigationScreen(),
//     );
//   }
// }

class HomeScreen extends StatefulWidget {
  // Home 화면에서 Analysis,History 화면으로 네비게이션 전환을 위한 콜백함수
  final VoidCallback onSwitchAnalysisTab;
  final VoidCallback onSwitchHistoryTab;

  HomeScreen(
      {required this.onSwitchAnalysisTab, required this.onSwitchHistoryTab});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> adImages = [
    'https://create.co.kr/public_html/data/editor/2103/thumb-20210330103458_eccgsddt_755x1007.jpg',
    'https://img.allurekorea.com/allure/2022/07/style_62d4f506f0c4e-700x700.jpg',
    'https://www.miseenscene.com/kr/ko/resource/images/BRD/20220428/20220511_hairandscarp-detail_01.jpg',
    'https://www.cmn.co.kr/webupload/ckeditor/images/20220124_170149_0403560.jpg',
    'https://post-phinf.pstatic.net/MjAyMjAyMThfMTQ3/MDAxNjQ1MTU4OTg4MTg0.SWaYij7Pg_0KWCt_-x5ZqHDeXOCp_Dq24lkt5_nu7NEg.wrqULXE1MKa0aqb78My_hry1QkAiKaG31ytxXwfHT5og.JPEG/0.jpg?type=w800_q75',
  ];
  final List<String> shampooTypes = [
    '양호 샴푸',
    '건성 샴푸',
    '지성 샴푸',
    '민감성 샴푸',
    '지루성 샴푸',
    '염증성 샴푸',
    '비듬성 샴푸',
    '탈모성샴푸'
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    TextStyle titleStyle = themeProvider.isDarkMode
        ? const TextStyle(color: Colors.white)
        : const TextStyle(color: Colors.black);
    Color scaffoldBackgroundColor =
        themeProvider.isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
        backgroundColor: scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('두피새싹', style: titleStyle),
          backgroundColor:
              themeProvider.isDarkMode ? Colors.black : Colors.green,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              Container(
                height: 275.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: adImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(adImages[index]),
                    );
                  },
                ),
              ),
              const SizedBox(height: 50),
              Column(
                children: [
                  const Text('모든 제품 확인하기'),
                  Container(
                    height: 120, // Adjust the height as needed
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: shampooTypes.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Icon(Icons.water_drop,
                                  size: 40), // Replace with your shampoo icon
                              const SizedBox(height: 10.0),
                              Text(shampooTypes[index]),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  children: [
                    Container(
                      width: 400.0,
                      height: 100.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        child: Text(
                          "문진 설문 시작",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: 20.0,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SurveyScreen()),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20.0), // 버튼 사이의 간격을 주기 위해 추가
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 190.0,
                          height: 200.0,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green),
                            ),
                            child: Text(
                              "두피 분석하기",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontSize: 15.0,
                              ),
                            ),
                            onPressed: () {
                              widget.onSwitchAnalysisTab();
                            },
                          ),
                        ),
                        Container(
                          width: 190.0,
                          height: 200.0,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green),
                            ),
                            child: Text(
                              "내 기록",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontSize: 15.0,
                              ),
                            ),
                            onPressed: () {
                              widget.onSwitchHistoryTab();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class SurveyScreen extends StatefulWidget {
  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  String? gender;
  String? age;
  String? scalpType;

  String? permFrequency;
  String? dyeFrequency;
  String? currentHairState;
  String? shampooFrequency;
  List<String> hairProducts = [];
  bool? wantCustomCare;
  String? shampooPriority;
  String? resultText;

  bool isFormComplete() {
    return gender != null &&
        age != null &&
        scalpType != null &&
        permFrequency != null &&
        dyeFrequency != null &&
        currentHairState != null &&
        shampooFrequency != null &&
        hairProducts.isNotEmpty &&
        wantCustomCare != null &&
        shampooPriority != null;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context); // ThemeProvider 상태 가져오기

    // 테마 정보에 따라 Text의 스타일을 설정합니다.
    TextStyle titleStyle = themeProvider.isDarkMode
        ? TextStyle(color: Colors.white)
        : TextStyle(color: Colors.black);
    Color scaffoldBackgroundColor =
        themeProvider.isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("설문조사", style: titleStyle),
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                _buildRadioListTile('성별', ['남', '여'], gender, (value) {
                  setState(() {
                    gender = value;
                  });
                }),
                _buildRadioListTile(
                    '나이', ['10대', '20대', '30대', '40대', '50대', '60대 이상'], age,
                    (value) {
                  setState(() {
                    age = value;
                  });
                }),
                _buildRadioListTile(
                  '두피 유형',
                  ['양호', '건성', '지성', '민감성', '지루성', '염증성', '비듬성', '탈모성'],
                  scalpType,
                  (value) {
                    setState(() {
                      scalpType = value;
                    });
                  },
                ),
                _buildRadioListTile(
                    '샴푸 사용 빈도',
                    ['1일 1회', '1일 2회', '2일 1회', '1주일 1회'],
                    shampooFrequency, (value) {
                  setState(() {
                    shampooFrequency = value;
                  });
                }),
                _buildRadioListTile(
                    '펌 주기',
                    ['하지않음', '1~3회/연', '4~6회/연', '7회 이상/연'],
                    permFrequency, (value) {
                  setState(() {
                    permFrequency = value;
                  });
                }),
                _buildRadioListTile(
                    '염색 주기(자가 염색 포함)',
                    ['하지않음', '1~3회/연', '4~6회/연', '7회 이상/연'],
                    dyeFrequency, (value) {
                  setState(() {
                    dyeFrequency = value;
                  });
                }),
                _buildRadioListTile(
                    '현재 모발 상태',
                    ['자연 모발', '펌 모발', '염색 모발', '탈모 모발', '곱슬 모발', '기타'],
                    currentHairState, (value) {
                  setState(() {
                    currentHairState = value;
                  });
                }),
                _buildCheckboxList('현재 사용하고 있는 두피모발용 제품',
                    ['샴푸', '린스', '트리트먼트', '헤어에센스', '탈모 관련 제품', '기타']),
                _buildYesNo('맞춤 두피케어 제품사용을 희망(선호) 하시나요?'),
                _buildRadioListTile(
                    '샴푸 구매시 중요시 고려하는 부분은 무엇인가요?',
                    ['헹굼 후 느낌', '세정력', '향', '두피자극', '가격'],
                    shampooPriority, (value) {
                  setState(() {
                    shampooPriority = value;
                  });
                }),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Text('제출'),
                  onPressed: () {
                    if (isFormComplete()) {
                      Map<String, dynamic> surveyResults = {
                        'gender': gender,
                        'age': age,
                        'scalpType': scalpType,
                        'shampooFrequency': shampooFrequency,
                        'permFrequency': permFrequency,
                        'dyeFrequency': dyeFrequency,
                        'currentHairState': currentHairState,
                        'hairProducts': hairProducts,
                        'wantCustomCare': wantCustomCare,
                        'shampooPriority': shampooPriority,
                      };

                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ResultScreen(surveyData: surveyResults),
                      ));
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('알림'),
                          content: Text('모든 항목을 선택해주세요'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('확인'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioListTile(String title, List<String> options,
      String? currentValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 20.0)), // 질문의 글씨 크기를 20.0으로 설정
        SizedBox(height: 5.0), // 질문과 첫 번째 답변 사이의 간격
        ...options.map((option) => Column(
              children: [
                RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: currentValue,
                  onChanged: onChanged,
                ),
                SizedBox(height: 3.0), // 답변 간의 간격
              ],
            ))
      ],
    );
  }

  Widget _buildCheckboxList(String question, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question,
            style: TextStyle(fontSize: 20.0)), // 여기에 글씨 크기를 조정하는 코드를 추가
        SizedBox(height: 5.0), // 간격 추가
        ...items.map((item) {
          return Column(
            children: [
              CheckboxListTile(
                title: Text(item),
                value: hairProducts.contains(item),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      hairProducts.add(item);
                    } else {
                      hairProducts.remove(item);
                    }
                  });
                },
              ),
              SizedBox(height: 1.0), // 답변 간의 간격
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildYesNo(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 20.0)), // 여기에 글씨 크기를 조정하는 코드를 추가
        SizedBox(height: 5.0), // 간격 추가
        Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: wantCustomCare,
              onChanged: (bool? value) {
                setState(() {
                  wantCustomCare = value!;
                });
              },
            ),
            Text('예'),
            Radio<bool>(
              value: false,
              groupValue: wantCustomCare,
              onChanged: (bool? value) {
                setState(() {
                  wantCustomCare = value!;
                });
              },
            ),
            Text('아니요'),
          ],
        ),
      ],
    );
  }
}
