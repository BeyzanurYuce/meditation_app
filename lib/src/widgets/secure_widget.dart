import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BirthdayWidget extends StatefulWidget {
  final DateTime? birthday;
  final ValueChanged<DateTime> onChangedBirthday;

  const BirthdayWidget({
    Key? key,
    this.birthday,
    required this.onChangedBirthday,
  }) : super(key: key);

  @override
  _BirthdayWidgetState createState() => _BirthdayWidgetState();
}

class _BirthdayWidgetState extends State<BirthdayWidget> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    setDate();
  }

  @override
  void didUpdateWidget(covariant BirthdayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    setDate();
  }

  void setDate() => setState(() {
    controller.text = widget.birthday == null
        ? ''
        : DateFormat.yMd().format(widget.birthday!);
  });

  @override
  Widget build(BuildContext context) => FocusBuilder(
    onChangeVisibility: (isVisible) {
      if (isVisible) {
        selectDate(context);
        //
      } else {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    },
    focusNode: focusNode,
    builder: (hasFocus) => TextFormField(
      controller: controller,
      validator: (value) =>
      value != null && value.isEmpty ? 'Is Required' : null,
      decoration: InputDecoration(
        prefixText: ' ',
        hintText: 'Birthday',
        prefixIcon: Icon(Icons.calendar_today_rounded),
        border: OutlineInputBorder(),
      ),
    ),
  );

  Future selectDate(BuildContext context) async {
    final birthday = await showDatePicker(
      context: context,
      initialDate: widget.birthday ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (birthday == null) return;

    widget.onChangedBirthday(birthday);
  }
}

class FocusBuilder extends StatefulWidget {
  final FocusNode focusNode;
  final Widget Function(bool hasFocus) builder;
  final ValueChanged<bool> onChangeVisibility;

  const FocusBuilder({
    Key? key,
    required this.focusNode,
    required this.builder,
    required this.onChangeVisibility,
  }) : super(key: key);

  @override
  _FocusBuilderState createState() => _FocusBuilderState();
}

class _FocusBuilderState extends State<FocusBuilder> {
  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => widget.onChangeVisibility(true),
    child: Focus(
      focusNode: widget.focusNode,
      onFocusChange: widget.onChangeVisibility,
      child: widget.builder(widget.focusNode.hasFocus),
    ),
  );
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    required this.text,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      minimumSize: Size.fromHeight(52),
      primary: Color(0xff885566),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    onPressed: onClicked,
  );
}



class PetsButtonsWidget extends StatelessWidget {
  final List<String> pets;
  final ValueChanged<String> onSelectedPet;

  const PetsButtonsWidget({
    Key? key,
    required this.pets,
    required this.onSelectedPet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).unselectedWidgetColor;
    final allPets = ['Dog', 'Cat', 'Other'];

    return Container(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: background,
        ),
        child: ToggleButtons(
          isSelected: allPets.map((pet) => pets.contains(pet)).toList(),
          selectedColor: Colors.cyan,
          color: Colors.cyan,
          fillColor: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(10),
          renderBorder: false,
          children: allPets.map(buildPet).toList(),
          onPressed: (index) => onSelectedPet(allPets[index]),
        ),
      ),
    );
  }

  Widget buildPet(String text) => Container(
    padding: EdgeInsets.symmetric(horizontal: 24),
    child: Text(text),
  );
}



class TitleWidget extends StatelessWidget {
  final IconData icon;
  final String text;

  const TitleWidget({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 50,color: Colors.cyan,),
      const SizedBox(width: 25),
      Text(

        text,
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.w400,color: Colors.cyan),
        textAlign: TextAlign.center,
      ),
    ],
  );
}