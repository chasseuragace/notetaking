import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notetaking/simple_utils.dart';
import 'package:notetaking/constant.dart';
import 'package:notetaking/podo/note.dart';
class EditText extends StatefulWidget {
  final String noteDescription, noteTitle, noteColor;
  final bool isNewNote;
  EditText({
    Key key,
    this.noteDescription,
    this.noteTitle,
    this.noteColor, this.isNewNote=false,
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
    setOrientation();
    _descController = TextEditingController(text: widget.noteDescription ?? "");
    _titleController = TextEditingController(text: widget.noteTitle ?? "");
    if (_titleController.text.isEmpty)
      _nodeTitle.requestFocus();
    else if (_titleController.text.isEmpty) _nodeDesc.requestFocus();
    colorChooser = ValueNotifier(max(
        colors.indexWhere((element) => "${element.value}" == widget.noteColor),
        0));

  }

  TextEditingController _titleController;
  TextEditingController _descController;

  final FocusNode _nodeTitle = FocusNode();
  final FocusNode _nodeDesc = FocusNode();


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onBackPress();
        return false;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: onBackPress,
            ),
            actions: [
             if(!widget.isNewNote) IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () async{
              var res= await   showSimpleAlert(context,title:  Constants.alertDeleteTitle,message: Constants.alertDeleteMessage);
              if(res??false)
                  Navigator.of(context).pop(true);
                },
              )
            ],
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * .2,
                      child: TweenAnimationBuilder(
                        curve: Curves.easeInOutBack,
                        duration: Duration(milliseconds: 800),
                        tween: Tween<double>(begin: .1, end: 1),
                        builder:
                            (BuildContext context, double value, Widget child) {
                          return Transform.scale(
                              scale: value,
                              child: Transform.translate(
                                offset: Offset(0, (value - 1) * 80),
                                child: child,
                              ));
                        },
                        child: Hero(
                          tag: "edit",
                          child: Image.asset(
                            "assets/edit.png",
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextFormField(


                      maxLines: 8,
                      minLines: 1,
                      focusNode: _nodeTitle,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (va) {
                        _nodeDesc.requestFocus();
                      },

                      textAlign: TextAlign.justify,
                      controller: _titleController,
                      onChanged: (val) {},
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(fontSize: 30),
                      decoration: InputDecoration(
                        // prefixIcon: Icon(Icons.lock),
                        hintText: "Title",
                        border: InputBorder.none,
                        hintStyle: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(color: Colors.grey),
                      ),
                    ),
                  ),
                  ValueListenableBuilder<int>(
                      valueListenable: colorChooser,
                      builder: (context, value, child) {
                        return Container(
                          height: 35,
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: colors.length,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              itemBuilder: (BuildContext context, int index) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: GestureDetector(
                                      onTap: () {
                                        colorChooser.value = index;
                                      },
                                      child: Material(
                                        elevation: 2,
                                        borderRadius: BorderRadius.circular(30),
                                        color: colors[index],
                                        child: Icon(
                                          Icons.check,
                                          color: index == value
                                              ? index == 0
                                                  ? Colors.black
                                                  : Colors.white
                                              : Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  width: 12,
                                );
                              },
                            ),
                          ),
                        );
                      }),
                  ValueListenableBuilder<int>(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(

                          minLines: 8,
                          maxLines: 20,
                          keyboardType: TextInputType.multiline,
                          onFieldSubmitted: (va) {},

                          focusNode: _nodeDesc,
                          textAlign: TextAlign.justify,
                          controller: _descController,
                          onChanged: (val) {},
                          style: Theme.of(context).textTheme.headline5,
                          decoration: InputDecoration(
                            // prefixIcon: Icon(Icons.lock),
                            hintText: "Description",
                            border: InputBorder.none,
                            hintStyle: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(color: Colors.black54),
                          ),
                        ),
                      ),
                      valueListenable: colorChooser,
                      builder: (context, value, child) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                              color: colors[value].withOpacity(.65),
                              borderRadius: BorderRadius.circular(16),
                              child: child),
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  onBackPress() {
    if (widget.noteTitle != _titleController.text ||
        widget.noteDescription != _descController.text ||
        widget.noteColor != '${colors[colorChooser.value].value}')
      Navigator.of(context).pop(Note(
        _titleController.text.trim(),
        _descController.text.trim(),
        colors[colorChooser.value].value.toString(),
      ));
    else
      Navigator.of(context).pop(false);
  }

  resetOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
  }
  setOrientation(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
}
