class EmergencyEvent {
  final String id;
  final DateTime createdAt;
  EmergencyEvent({required this.id, required this.createdAt});
}

class EmergencyRepository {
  List<EmergencyEvent> loadInitial() {
    return [EmergencyEvent(id: 'seed-1', createdAt: DateTime.now())];
  }

  Future<void> logEmergency(String uid) async {
    // Stub für Web
  }
}
