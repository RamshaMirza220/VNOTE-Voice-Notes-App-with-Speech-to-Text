import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/voice_note.dart';

class StorageService {
  static const String _notesKey = 'voice_notes';

  Future<List<VoiceNote>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getString(_notesKey);

    if (notesJson != null) {
      final List<dynamic> notesList = json.decode(notesJson);
      final notes = notesList.map((e) => VoiceNote.fromJson(e)).toList();
      notes.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return notes;
    }
    return [];
  }

  Future<void> saveNotes(List<VoiceNote> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = json.encode(notes.map((e) => e.toJson()).toList());
    await prefs.setString(_notesKey, notesJson);
  }
}
