import '../../../model/notes.dart';

abstract class NoteRepository {
  Future<void> addNote(Notes note);
}