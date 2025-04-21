
abstract class ReportState {}

class ReportInitial extends ReportState {}

class GetReportLoading extends ReportState {}
class GetReportSuccess extends ReportState {}
class GetReportError extends ReportState {}

class FilterChangedState extends ReportState {}
class ReportFilterChanged extends ReportState {}
class ReportActivityLevelChanged extends ReportState {}
