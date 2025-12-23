class DashboardStaticRepo {
  static List<DashboardStatModel> stats = [
    DashboardStatModel(stat: '8', title: 'Goals Created'),
    DashboardStatModel(stat: '25', title: 'Completed'),
    DashboardStatModel(stat: '168', title: 'Hours Together'),
    DashboardStatModel(stat: '6', title: 'Skills gained'),
  ];
}

class DashboardStatModel {
  final String title, stat;

  DashboardStatModel({required this.stat, required this.title});
}
