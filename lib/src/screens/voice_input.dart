import 'package:meditation_app/src/screens/NotesPage.dart';
import 'package:meditation_app/src/services/NoteDatabase.dart';

import 'package:meditation_app/src/utils/NoteFiles.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
class VoiceInput extends StatefulWidget {
  final Note? note;

  VoiceInput({Key? key,this.note,}) : super(key: key);

  @override
  _VoiceInputState createState() => _VoiceInputState();
}

class _VoiceInputState extends State<VoiceInput> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number=0;
  late String title='';
  late String description='';
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }
String voicenote='';
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {

    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      voicenote=result.recognizedWords ;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Notes'),
        backgroundColor:
        Color(0xFFE1D7CE),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),

            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  _speechToText.isListening
                      ? '$_lastWords'
                      : _speechEnabled
                      ? 'Tap the microphone for voice input'
                      : 'Speech not available',
                ),
              ),
            ),
            FlatButton(
                onPressed: addOrUpdateVoice,

                color: Colors.white,
                child: Text('Add', style: TextStyle(
                  color: Color(0xFF896C64),
                ),)
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn1",
        backgroundColor: Color(0xFF896C64),
        onPressed:
        _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }


  void addOrUpdateVoice() async {


    if (true) {
      final isUpdating = widget.note != null;
      if (isUpdating) {
        await updateVoice();
      } else {
        await addVoice();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateVoice() async {
    final note = widget.note!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
    );

    await NotesDatabase.instance.update(note);
  }

  Future addVoice() async {
    final note = Note(
      title: 'Voice Note',
      isImportant: true,
      number: number,
      description: voicenote,
      createdTime: DateTime.now(),

    );

    await NotesDatabase.instance.create(note);
  }
}