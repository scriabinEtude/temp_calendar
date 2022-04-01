import 'package:calendar01/enums.dart';
import 'package:flutter/material.dart';

class Veterinarian {
  final Image profileImage;
  final String name;

  Veterinarian({
    required this.profileImage,
    required this.name,
  });

  Veterinarian copyWith({
    Image? profileImage,
    String? name,
  }) {
    return Veterinarian(
      profileImage: profileImage ?? this.profileImage,
      name: name ?? this.name,
    );
  }
}

final List<Veterinarian> vets = [
  Veterinarian(
      profileImage: Image.asset(
          'assets/images/smilingAsianMaleDoctorPointingUpwards.png'),
      name: '김석현'),
  Veterinarian(
      profileImage: Image.asset('assets/images/profileDefault50.png'),
      name: '정지은'),
  Veterinarian(
      profileImage: Image.asset('assets/images/profileDefault50.png'),
      name: '김은지'),
];

class ReReservationBottomSheetState {
  final bool isLoading;
  final String? error;

  final DateTime focusedDay;
  final DateTime? selectedDay;

  final Veterinarian selectedVeterinarian;
  final List<Veterinarian> veterinarians;
  final Map<String, dynamic>? selectedEvent;

  final String name;
  final RequestType requestType;
  final String? description;
  final String kind;
  final int age;
  final int sex;
  final bool isNeutering;

  final String guardianName;
  final String phone;

  const ReReservationBottomSheetState({
    this.isLoading = false,
    this.error,
    required this.focusedDay,
    this.selectedDay,
    required this.selectedVeterinarian,
    this.veterinarians = const [],
    this.selectedEvent,
    this.name = '입력',
    this.requestType = RequestType.general,
    this.description,
    this.kind = '입력',
    this.age = 0,
    this.sex = 1,
    this.isNeutering = false,
    this.guardianName = '입력',
    this.phone = '010-0000-0000',
  });

  ReReservationBottomSheetState copyWith({
    bool? isLoading,
    String? error,
    DateTime? focusedDay,
    DateTime? selectedDay,
    DateTime? pickerDate,
    Veterinarian? selectedVeterinarian,
    List<Veterinarian>? veterinarians,
    Map<String, dynamic>? selectedEvent,
    String? name,
    String? guardianName,
    RequestType? requestType,
    String? description,
  }) {
    return ReReservationBottomSheetState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
      selectedVeterinarian: selectedVeterinarian ?? this.selectedVeterinarian,
      veterinarians: veterinarians ?? this.veterinarians,
      selectedEvent: selectedEvent ?? this.selectedEvent,
      name: name ?? this.name,
      guardianName: guardianName ?? this.guardianName,
      requestType: requestType ?? this.requestType,
      description: description ?? this.description,
    );
  }
}
