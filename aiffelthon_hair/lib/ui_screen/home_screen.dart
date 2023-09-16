import 'package:flutter/material.dart';
import 'servey_result_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Survey',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("문진 설문 시작"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SurveyScreen()),
            );
          },
        ),
      ),
    );
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
    return Scaffold(
      appBar: AppBar(title: Text("설문조사")),
      body: ListView(padding: EdgeInsets.all(16.0), children: [
        _buildRadioListTile('성별', ['남', '여'], gender, (value) {
          setState(() {
            gender = value;
          });
        }),
        _buildRadioListTile(
            '나이', ['10대', '20대', '30대', '40대', '50대', '60대 이상'], age, (value) {
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
            '샴푸 사용 빈도', ['1일 1회', '1일 2회', '2일 1회', '1주일 1회'], shampooFrequency,
            (value) {
          setState(() {
            shampooFrequency = value;
          });
        }),
        _buildRadioListTile(
            '펌 주기', ['하지않음', '1~3회/연', '4~6회/연', '7회 이상/연'], permFrequency,
            (value) {
          setState(() {
            permFrequency = value;
          });
        }),
        _buildRadioListTile('염색 주기(자가 염색 포함)',
            ['하지않음', '1~3회/연', '4~6회/연', '7회 이상/연'], dyeFrequency, (value) {
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
        _buildRadioListTile('샴푸 구매시 중요시 고려하는 부분은 무엇인가요?',
            ['헹굼 후 느낌', '세정력', '향', '두피자극', '가격'], shampooPriority, (value) {
          setState(() {
            shampooPriority = value;
          });
        }),
        SizedBox(height: 20),
        ElevatedButton(
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
                builder: (context) => ResultScreen(surveyData: surveyResults),
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
      ]),
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
