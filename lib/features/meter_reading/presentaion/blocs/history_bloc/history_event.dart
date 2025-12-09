abstract class HistoryEvent {}

class LoadAllReadingsEvent extends HistoryEvent {}

class DeleteReadingEvent extends HistoryEvent {
  final String readingId;

  DeleteReadingEvent(this.readingId);
}
