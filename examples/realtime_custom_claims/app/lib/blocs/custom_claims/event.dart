sealed class CustomClaimsEvent {}

class CustomClaimsEvent_Initialize extends CustomClaimsEvent {}

class CustomClaimsEvent_Refresh extends CustomClaimsEvent {
  CustomClaimsEvent_Refresh({required this.lastUpdatedAt});

  final DateTime lastUpdatedAt;
}
