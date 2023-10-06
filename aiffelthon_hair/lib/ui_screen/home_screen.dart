import 'package:aiffelthon_hair/ui_screen/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'servey_result_screen.dart';

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
  final List<String> shampooTypeImages = [
    'shampoo1.png',
    'shampoo2.png',
    'shampoo3.png',
    'shampoo7.png',
    'shampoo5.png',
    'shampoo6.png',
    'shampoo4.png',
    'shampoo8.png'
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
          title: Row(
            children: [
              Text(
                '두피새싹',
                style: TextStyle(
                  fontFamily: 'DoHyeonRegular',
                  fontSize: 30.0,
                  color: Colors.green,
                ),
              ),
              SizedBox(width: 5.0), // 텍스트와 이모티콘 사이의 간격 조정
              Image.asset(
                'assets/images/fresh.png', // 이미지 파일 경로를 설정하세요.
                width: 30.0, // 이미지의 너비 조정
                height: 30.0, // 이미지의 높이 조정
              ),
            ],
          ),
          backgroundColor:
              themeProvider.isDarkMode ? Colors.black : Colors.white,
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
                  const Text(
                    '모든 제품 확인하기',
                    style: TextStyle(
                      fontFamily: 'DoHyeonRegular',
                      color: Colors.black,
                    ),
                  ),
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
                              Image.asset(
                                  'assets/images/${shampooTypeImages[index]}'), // Replace with your shampoo icon
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
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white, // 버튼의 배경색을 투명으로 설정
                          onPrimary: Colors.green, // 버튼의 텍스트 색상 설정
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.green,
                                width: 2.0), // 테두리 색상과 너비 설정
                            borderRadius:
                                BorderRadius.circular(8.0), // 버튼의 모서리 둥글기 설정
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SurveyScreen()),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 0.5, top: 0.5),
                              child: Text(
                                "문진 설문 시작",
                                style: TextStyle(
                                  fontFamily: 'DoHyeonRegular',
                                  color: Colors.black,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Image.asset(
                                'assets/images/servey.gif', // 이미지 파일 경로를 설정하세요.
                                width: 80.0, // 이미지의 너비 설정
                                height: 80.0, // 이미지의 높이 설정
                              ),
                            ),
                          ],
                        ),
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
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Colors.green,
                              shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.green, width: 2.0),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, top: 10.0),
                                      child: Text(
                                        "두피 분석하기       ",
                                        style: TextStyle(
                                          fontFamily: 'DoHyeonRegular',
                                          color: Colors.black,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Image.asset(
                                      'assets/images/analysis.gif',
                                      width: 80.0,
                                      height: 130.0,
                                    ),
                                  ),
                                ),
                              ],
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
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white, // 버튼의 배경색을 투명으로 설정
                              onPrimary: Colors.green, // 버튼의 텍스트 및 테두리 색상 설정
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.green,
                                    width: 2.0), // 테두리 색상과 너비 설정
                                borderRadius: BorderRadius.circular(
                                    8.0), // 버튼의 모서리 둥글기 설정
                              ),
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, top: 10.0),
                                      child: Text(
                                        "내 기록                 ",
                                        style: TextStyle(
                                          fontFamily: 'DoHyeonRegular',
                                          color: Colors.black,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Image.asset(
                                      'assets/images/history.gif', // 이미지 파일 경로를 설정하세요.
                                      width: 80.0,
                                      height: 130.0,
                                    ),
                                  ),
                                ),
                              ],
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
        title: Text("설문조사",
            style: TextStyle(
              fontFamily: 'DoHyeonRegular',
            )),
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
                  child: Text(
                    "제출",
                    style: TextStyle(
                      fontFamily: 'DoHyeonRegular',
                      fontSize: 18.0,
                    ),
                  ),
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
                          title: Text(
                            '알림',
                            style: TextStyle(fontFamily: 'DoHyeonRegular'),
                          ),
                          content: Text(
                            '모든 항목을 선택해주세요',
                            style: TextStyle(fontFamily: 'DoHyeonRegular'),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                '확인',
                                style: TextStyle(fontFamily: 'DoHyeonRegular'),
                              ),
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
