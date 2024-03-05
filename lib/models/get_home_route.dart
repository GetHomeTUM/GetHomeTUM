class GetHomeRoute {
  // TODO Declare the attributes necessary to display the route correctly
  final DateTime departureTime;
  final String line;

  GetHomeRoute({required this.departureTime, required this.line});

  factory GetHomeRoute.fromJson(Map<String, dynamic> data) {
    final departureTime = data['name'] as String;
    final line = data['cuisine'] as String;
    return GetHomeRoute(departureTime: departureTime, line : line);
  }
}
