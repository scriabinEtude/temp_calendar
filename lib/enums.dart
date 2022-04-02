enum ReserveType { none, closed, reserved }

enum RequestType {
  general,
  vaccination,
  healthScreenings,
  surgeryConsultation,
  surgery
}

extension RequestTypeKorName on RequestType {
  String korName() {
    switch (this) {
      case RequestType.general:
        return '일반진료';
      case RequestType.vaccination:
        return '예방접종';
      case RequestType.healthScreenings:
        return '건강검진';
      case RequestType.surgeryConsultation:
        return '수술상담';
      case RequestType.surgery:
        return '수술';
    }
  }
}
