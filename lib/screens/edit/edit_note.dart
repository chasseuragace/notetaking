import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notetaking/services/firebase_store/firebase_db.dart';

class EditText extends StatefulWidget {
  final String positiveText, negativeText, noteDescription, noteTitle, noteColor;
  final bool enableMultiline;
  final bool extremeLength;

  EditText({
    Key key,
    this.positiveText = "Save",
    this.negativeText = "Cancel",
    this.noteDescription,
    this.noteTitle = "Edit",
    this.enableMultiline = true,
    this.extremeLength = false, this.noteColor,
  }) : super(key: key);

  @override
  _EditTextState createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  ValueNotifier<int> colorChooser;
  List<Color> colors = const [
    Color(0xfff2f3f9),
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.deepPurple,
    Colors.cyan,
    Colors.brown
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    resetOrientation();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _descController = TextEditingController(text: widget.noteDescription ?? "");
    _titleController = TextEditingController(text: widget.noteTitle ?? "");
    _node.requestFocus();
    colorChooser=ValueNotifier(max(colors.indexWhere((element) => "${element.value}"==widget.noteColor),0))  ;
  }

  TextEditingController _titleController;
  TextEditingController _descController;

  final FocusNode _node = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Widget okButton = OutlineButton.icon(
      icon: Icon(Icons.check),
      shape: StadiumBorder(),
      label: Text(widget.positiveText),
      onPressed: () {
        if (_formKey.currentState.validate())
        Navigator.of(context)
            .pop(Note.dummy(_titleController.text, _descController.text, colors[colorChooser.value].value.toString()));
      },
    );
    Widget cancelButton = OutlineButton.icon(
      icon: Icon(Icons.close),
      shape: StadiumBorder(),
      label: Text(widget.negativeText),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white10,
              child: Form(
                key: _formKey,
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Center(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * .2,
                            child: TweenAnimationBuilder(
                              curve: Curves.easeInOutBack,
                              duration: Duration(milliseconds: 800),
                              tween: Tween<double>(begin: .1, end: 1),
                              builder: (BuildContext context, double value,
                                  Widget child) {
                                return Transform.scale(
                                    scale: value,
                                    child: Transform.translate(
                                      offset: Offset(0, (value - 1) * 80),
                                      child: child,
                                    ));
                              },
                              child: Image.asset(
                                "assets/edit.png",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:8.0),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 40,
                        maxLines: 2,
                        keyboardType: TextInputType.text,
                        onFieldSubmitted: (va) {
                          _node.requestFocus();
                        },
                        validator: (value) {
                          return value.isEmpty
                              ? "No point taking a blank note!"
                              : null;
                        },
                        textAlign:
                            TextAlign.justify,

                        controller: _titleController,
                        onChanged: (val) {},
                        style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 30),
                        decoration: InputDecoration(
                          // prefixIcon: Icon(Icons.lock),

                          border: InputBorder.none,
                          hintStyle: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(color: Colors.grey),
                        ),
                      ),
                    ),

                    ValueListenableBuilder<int>(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          maxLength: widget.enableMultiline
                              ? (widget.extremeLength ? 1204 : 255)
                              : 40,
                          maxLines: widget.enableMultiline ? 5 : 2,
                          keyboardType: TextInputType.multiline,
                          onFieldSubmitted: (va) {},
                          validator: (value) {
                            return value.isEmpty
                                ? "No point taking a blank note!"
                                : null;
                          },
                          focusNode: _node,
                          textAlign: widget.enableMultiline
                              ? TextAlign.justify
                              : TextAlign.center,
                          controller: _descController,
                          onChanged: (val) {},
                          style: Theme.of(context).textTheme.headline5,
                          decoration: InputDecoration(
                            // prefixIcon: Icon(Icons.lock),

                            border: InputBorder.none,
                            hintStyle: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(color: Colors.grey),
                          ),
                        ),
                      ),
                      valueListenable:  colorChooser,
                      builder: (context, value,child) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(16),
                            color: colors[value].withOpacity(.25),
                            child: child
                          ),
                        );
                      }
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ValueListenableBuilder<int>(
                      valueListenable: colorChooser,
                      builder: (context, value,child) {
                        return Container(
                          height: 35,
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ListView.separated(

                              scrollDirection: Axis.horizontal,
                              itemCount: colors.length,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              itemBuilder: (BuildContext context, int index) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,child: GestureDetector(
                                      onTap: (){
                                        colorChooser.value=index;

                                      },
                                      child: Material(
                                        elevation: 2,
                                        borderRadius: BorderRadius.circular(30),
                                        color: colors[index],
                                        child: Icon(Icons.check,color: index==value ? index==0?Colors.black: Colors.white:Colors.transparent,),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  width: 12,
                                );
                              },
                            ),
                          ),
                        );
                      }
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            cancelButton,
                            okButton,
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  resetOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
  }
}
