import 'package:calendar01/enums.dart';
import 'package:flutter/material.dart';

import 'package:calendar01/screens/re_reservation_bottom_sheet/re_reservation_bottom_sheet_state.dart';

const listDataSource = [
  "Cats come back to full alertness from the sleep state faster than any other creature.",
  "Contrary to popular belief, the cat is a social animal. A pet cat will respond and answer to speech , and seems to enjoy human companionship.",
  "Unlike humans, cats cannot detect sweetness which likely explains why they are not drawn to it at all.",
  "Grown cats have 30 teeth. Kittens have about 26 temporary teeth, which they lose when they are about 6 months old.",
  "In one stride, a cheetah can cover 23 to 26 feet (7 to 8 meters).",
  "The life expectancy of cats has nearly doubled over the last fifty years.",
  "In the original Italian version of Cinderella, the benevolent fairy godmother figure was a cat.",
  "The first official cat show in the UK was organised at Crystal Palace in 1871.",
  "70% of your cat's life is spent asleep.",
  'According to Hebrew legend, Noah prayed to God for help protecting all the food he stored on the ark from being eaten by rats. In reply, God made the lion sneeze, and out popped a cat.',
  'Cats lap liquid from the underside of their tongue, not from the top.',
  'Relative to its body size, the clouded leopard has the biggest canines of all animals’ canines. Its dagger-like teeth can be as long as 1.8 inches (4.5 cm).',
  'Cat paws act as tempetature regulators, shock absorbers, hunting and grooming tools, sensors, and more',
  'A cat uses its whiskers for measuring distances.  The whiskers of a cat are capable of registering very small changes in air pressure.',
  "In Ancient Egypt, when a person's house cat passed away, the owner would shave their eyebrows to reflect their grief.",
  "Cats' eyes shine in the dark because of the tapetum, a reflective layer in the eye, which acts like a mirror.",
  'Two members of the cat family are distinct from all others: the clouded leopard and the cheetah. The clouded leopard does not roar like other big cats, nor does it groom or rest like small cats. The cheetah is unique because it is a running cat; all others are leaping cats. They are leaping cats because they slowly stalk their prey and then leap on it.',
  'Unlike humans, cats cannot detect sweetness which likely explains why they are not drawn to it at all.',
  'A cat’s back is extremely flexible because it has up to 53 loosely fitting vertebrae. Humans only have 34.',
  'The first cat show was in 1871 at the Crystal Palace in London.'
];

class Reserve {
  String time;
  ReserveType reserveType;
  String? petName;
  RequestType? requestType;
  String? birthDate;
  int? age;
  int? genderCode; // 0 male 1 female 2 unknown
  String? realName;
  String? phone;
  double? weight;
  String? breeds;
  String? requestMessage;
  String? doctorName;
  String? reserveDate;
  String? reserveNumber;
  Color? color;

  Reserve({
    required this.time,
    required this.reserveType,
    this.petName,
    this.requestType,
    this.birthDate,
    this.age,
    this.genderCode,
    this.realName,
    this.phone,
    this.weight,
    this.breeds,
    this.requestMessage,
    this.doctorName,
    this.reserveDate,
    this.reserveNumber,
    this.color,
  });
}

final reserveDataSource = <Map<String, dynamic>>[
  {
    'time': "09:00",
    'status': ReserveType.reserve,
    'title': "라떼 진료",
    'age': 3,
    'kind': '말티즈',
    'sex': '남',
    'gardien': '김유미',
    'color': const Color(0xffff7a20)
  },
  {
    'time': "09:30",
    'status': ReserveType.reserve,
    'title': "누리 진료",
    'age': 3,
    'kind': '푸들',
    'sex': '남',
    'gardien': '임수미',
    'color': const Color(0xffff7a20)
  },
  {
    'time': "10:00",
    'status': ReserveType.none,
  },
  {
    "time": "10:30",
    'status': ReserveType.reserve,
    'title': "산 건강검진",
    'age': 8,
    'kind': '믹스묘',
    'sex': '여',
    'gardien': '이다슬',
    'color': const Color(0xff006ed4)
  },
  {
    'time': "11:00",
    'status': ReserveType.none,
  },
  {
    'time': "11:30",
    'status': ReserveType.closed,
  },
  {
    "time": "12:00",
    'status': ReserveType.reserve,
    'title': "삼식이 진료",
    'age': 9,
    'kind': '러시안블루',
    'sex': '여',
    'gardien': '김철수',
    'color': const Color(0xff006ed4)
  },
  {
    'time': "12:30",
    'status': ReserveType.none,
  },
  {
    'time': "13:00",
    'status': ReserveType.closed,
  },
  {
    'time': "13:30",
    'status': ReserveType.none,
  },
  {
    'time': "14:00",
    'status': ReserveType.none,
  },
  {
    'time': "14:30",
    'status': ReserveType.none,
  },
  {
    'time': "15:00",
    'status': ReserveType.reserve,
    'title': "기네스 수술",
    'age': 3,
    'kind': '말티즈',
    'sex': '남',
    'gardien': '박선호',
    'color': const Color(0xffff7a20)
  },
  {
    'time': "15:30",
    'status': ReserveType.none,
  },
  {
    'time': "16:00",
    'status': ReserveType.reserve,
    'title': "유디 진료",
    'age': 3,
    'kind': '푸들',
    'sex': '남',
    'gardien': '유조선',
    'color': const Color(0xffff7a20)
  },
  {
    'time': "16:30",
    'status': ReserveType.none,
  },
  {
    'time': "17:00",
    'status': ReserveType.none,
  },
  {
    'time': "17:30",
    'status': ReserveType.none,
  },
  {
    'time': "18:00",
    'status': ReserveType.none,
  },
  {
    'time': "18:30",
    'status': ReserveType.none,
  },
  {
    'time': "19:00",
    'status': ReserveType.none,
  },
  {
    'time': "19:30",
    'status': ReserveType.none,
  },
  {
    'time': "20:00",
    'status': ReserveType.none,
  },
];

final rs = reserveDataSource.map((r) {
  if (r['status'] == ReserveType.reserve) {
    return Reserve(
        time: r['time'],
        reserveType: r['status'],
        petName: (r['title'] as String).split(" ")[0],
        requestType: (r['title'] as String).split(" ")[1] == "진료"
            ? RequestType.general
            : (r['title'] as String).split(" ")[1] == "건강검진"
                ? RequestType.healthScreenings
                : (r['title'] as String).split(" ")[1] == "수술"
                    ? RequestType.surgery
                    : null,
        age: r['age'],
        breeds: r['kind'],
        genderCode: r['sex'] == '남' ? 0 : 1,
        realName: r['gardien'],
        color: r['color']);
  } else {
    return Reserve(time: r['time'], reserveType: r['status']);
  }
}).toList();
