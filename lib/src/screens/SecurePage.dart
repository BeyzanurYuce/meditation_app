import 'package:flutter/material.dart';

import 'package:meditation_app/src/utils/secure_stroge.dart';
import 'package:meditation_app/src/widgets/secure_widget.dart';
class SecurePage extends StatefulWidget {
  @override
  _SecurePageState createState() => _SecurePageState();
}

class _SecurePageState extends State<SecurePage> {
  final formKey = GlobalKey<FormState>();
  final controllerName = TextEditingController();
  DateTime? birthday;

  @override
  void initState() {
    super.initState();

    init();
  }

  Future init() async {
    final name = await UserSecureStorage.getUsername() ?? '';
    final birthday = await UserSecureStorage.getBirthday();

    setState(() {
      this.controllerName.text = name;
      this.birthday = birthday;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Color(0xff885566),
      title: Text('Birthday reminder'),
      elevation: 0.0,
    ),
    body: SafeArea(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/hp1.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            const SizedBox(height: 12),
            buildName(),
            const SizedBox(height: 12),
            buildBirthday(),
            const SizedBox(height: 12),

            buildButton(),
          ],
        ),
      ),
    ),
  );

  Widget buildName() => buildTitle(
    title: 'Name',
    child: TextFormField(
      controller: controllerName,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person_outline),
        hintText: 'Name',
      ),
    ),
  );

  Widget buildBirthday() => buildTitle(
    title: 'Birthday',
    child: BirthdayWidget(
      birthday: birthday,
      onChangedBirthday: (birthday) =>
          setState(() => this.birthday = birthday),
    ),
  );



  Widget buildButton() => ButtonWidget(
      text: 'Save',
      onClicked: () async {
        await UserSecureStorage.setUsername(controllerName.text);


        if (birthday != null) {
          await UserSecureStorage.setBirthday(birthday!);
        }
      });

  Widget buildTitle({
    required String title,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          child,
        ],
      );
}