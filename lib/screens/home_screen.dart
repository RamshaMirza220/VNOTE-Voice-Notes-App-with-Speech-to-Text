import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:intl/intl.dart';
import '../models/voice_note.dart';
import '../services/storage_service.dart';
import '../widgets/note_card.dart';
import '../widgets/listening_widget.dart';
import '../main.dart'; // Import to access global themeProvider

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final TextEditingController _searchController = TextEditingController();
  final StorageService _storageService = StorageService();

  List<VoiceNote> _notes = [];
  List<VoiceNote> _filteredNotes = [];
  bool _isListening = false;
  String _currentText = '';
  bool _speechAvailable = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _loadNotes();
  }

  void _initSpeech() async {
    _speechAvailable = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        setState(() => _isListening = false);
        _showSnackBar('Error: ${error.errorMsg}');
      },
    );
    setState(() {});
  }

  Future<void> _loadNotes() async {
    final notes = await _storageService.loadNotes();
    setState(() {
      _notes = notes;
      _filteredNotes = notes;
    });
  }

  Future<void> _saveNotes() async {
    await _storageService.saveNotes(_notes);
  }

  void _startListening() async {
    if (!_speechAvailable) {
      _showSnackBar('Speech recognition not available');
      return;
    }

    setState(() {
      _currentText = '';
      _isListening = true;
    });

    await _speech.listen(
      onResult: (result) {
        setState(() {
          _currentText = result.recognizedWords;
        });
      },
      listenMode: stt.ListenMode.confirmation,
    );
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);

    if (_currentText.isNotEmpty) {
      _showSaveDialog();
    }
  }

  void _showSaveDialog() {
    final titleController = TextEditingController(
      text: _currentText.length > 30
          ? '${_currentText.substring(0, 30)}...'
          : _currentText,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text('Content: $_currentText'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _saveNote(titleController.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _saveNote(String title) {
    final note = VoiceNote(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.isEmpty ? 'Untitled Note' : title,
      content: _currentText,
      timestamp: DateTime.now(),
    );

    setState(() {
      _notes.insert(0, note);
      _filteredNotes = _notes;
      _currentText = '';
    });

    _saveNotes();
    _showSnackBar('Note saved successfully!');
  }

  void _filterNotes(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredNotes = _notes;
      } else {
        _filteredNotes = _notes.where((note) {
          return note.title.toLowerCase().contains(query.toLowerCase()) ||
              note.content.toLowerCase().contains(query.toLowerCase()) ||
              DateFormat('MMM dd, yyyy').format(note.timestamp).contains(query);
        }).toList();
      }
    });
  }

  void _deleteNote(String id) {
    setState(() {
      _notes.removeWhere((note) => note.id == id);
      _filteredNotes = _notes;
    });
    _saveNotes();
    _showSnackBar('Note deleted');
  }

  void _editNote(VoiceNote note) {
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Note'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                note.title = titleController.text;
                note.content = contentController.text;
              });
              _saveNotes();
              Navigator.pop(context);
              _showSnackBar('Note updated!');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Notes'),
        elevation: 2,
        actions: [
          AnimatedBuilder(
            animation: themeProvider,
            builder: (context, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
                tooltip: themeProvider.isDarkMode
                    ? 'Switch to Light Mode'
                    : 'Switch to Dark Mode',
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterNotes,
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterNotes('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          if (_isListening) ListeningWidget(currentText: _currentText),
          Expanded(
            child: _filteredNotes.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = _filteredNotes[index];
                      return NoteCard(
                        note: note,
                        onEdit: () => _editNote(note),
                        onDelete: () => _deleteNote(note.id),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: _isListening ? _stopListening : _startListening,
        backgroundColor: _isListening ? Colors.red : null,
        child: Icon(_isListening ? Icons.stop : Icons.mic, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.mic_none, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _notes.isEmpty
                ? 'No notes yet.\nTap the mic to record!'
                : 'No matching notes found',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _speech.cancel();
    super.dispose();
  }
}
  