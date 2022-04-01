import 'package:calendar01/enums.dart';

class EventDetailState {
  final bool isLoading;
  final String? error;
  final DateTime reservationTime;

  // 반려동물
  final String name;
  final RequestType requestType;
  final String breeds;
  final int age;
  final int sex;
  final bool doesNeutering;
  final double weight;

  // 보호자
  final String guardian;
  final String phone;
  final String description;

  // 의료진
  final String veterinarian;
  final int reservationNumber;
  final DateTime createdAt;

  const EventDetailState({
    this.isLoading = false,
    this.error,
    required this.reservationTime,
    required this.name,
    required this.requestType,
    required this.breeds,
    required this.age,
    required this.sex,
    required this.doesNeutering,
    required this.weight,
    required this.guardian,
    required this.phone,
    required this.description,
    required this.veterinarian,
    required this.reservationNumber,
    required this.createdAt,
  });

  EventDetailState copyWith({
    bool? isLoading,
    String? error,
    DateTime? reservationTime,
    String? name,
    RequestType? requestType,
    String? kind,
    int? age,
    int? sex,
    bool? doesNeutering,
    double? weight,
    String? guardian,
    String? phone,
    String? description,
    String? veterinarian,
    int? reservationNumber,
    DateTime? createdAt,
  }) {
    return EventDetailState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      reservationTime: reservationTime ?? this.reservationTime,
      name: name ?? this.name,
      requestType: requestType ?? this.requestType,
      breeds: kind ?? this.breeds,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      doesNeutering: doesNeutering ?? this.doesNeutering,
      weight: weight ?? this.weight,
      guardian: guardian ?? this.guardian,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      veterinarian: veterinarian ?? this.veterinarian,
      reservationNumber: reservationNumber ?? this.reservationNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
