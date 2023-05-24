import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'utils/date_utils.dart' as date_util;
import 'utils/colors_utils.dart';
import 'package:flutter/gestures.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  // ignore: avoid_types_as_parameter_names
  _MyHomePageState createState() =>
      _MyHomePageState(deleteFunction: (BuildContext) {});
}

_myHomePageState(
    {required void Function(dynamic context) deleteFunction}) {} //added

class _MyHomePageState extends State<MyHomePage> {
  double width = 0;
  double height = 0;
  late ScrollController scrollController;
  List<DateTime> currentMonthList = List.empty();
  DateTime currentDateTime = DateTime.now();
  List<String> todoList = <String>[];
  TextEditingController textController = TextEditingController();
  Function(BuildContext)? deleteFunction; //added

  _MyHomePageState({
    //added
    required this.deleteFunction,
  });

  get index => null;

  @override
  void initState() {
    super.initState();
    currentMonthList = date_util.DateUtils.daysInMonth(currentDateTime);
    currentMonthList.sort((a, b) => a.day.compareTo(b.day));
    currentMonthList = currentMonthList.toSet().toList();
    scrollController =
        ScrollController(initialScrollOffset: 70.0 * currentDateTime.day);
    super.initState();
  }

  Widget backgroundView() {
    return Container(
      decoration: BoxDecoration(
          color: HexColor("072965"),
          image: DecorationImage(
              image: const AssetImage("assets/images/bg.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Color.fromARGB(255, 124, 98, 201).withOpacity(0.2),
                  BlendMode.lighten))),
    );
  }

  Widget topView() {
    return Container(
      height: height * 0.35,
      width: width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                HexColor("488BC8").withOpacity(0.7),
                HexColor("488BC8").withOpacity(0.5),
                HexColor("488BC8").withOpacity(0.3),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 1.0),
              stops: const [0.0, 0.5, 1.0],
              tileMode: TileMode.clamp),
          boxShadow: const [
            BoxShadow(
                blurRadius: 40,
                color: Colors.black12,
                offset: Offset(4, 4),
                spreadRadius: 2)
          ],
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(40),
              bottomLeft: Radius.circular(40))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[titleView(), horizontalCapsuleListView()],
      ),
    );
  }

  Widget titleView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Text(
        date_util.DateUtils.months[currentDateTime.month - 1] +
            ' ' +
            currentDateTime.year.toString(),
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  Widget horizontalCapsuleListView() {
    return SizedBox(
      //changed Container to SizedBox
      width: width,
      height: 190,
      child: ListView.builder(
          itemCount: currentMonthList.length,
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return capsuleView(index);
          }),
    );
  }

  Widget capsuleView(int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentDateTime = currentMonthList[index];
          });
        },
        child: Container(
          height: 140,
          width: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: (currentMonthList[index].day != currentDateTime.day)
                    ? [
                        Colors.white.withOpacity(0.8),
                        Colors.white.withOpacity(0.7),
                        Colors.white.withOpacity(0.6),
                      ]
                    : [
                        HexColor("ED6184"),
                        HexColor("EF315B"),
                        HexColor("E2042D")
                      ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(0.0, 1.0),
                stops: const [0.0, 0.5, 1.0],
                tileMode: TileMode.clamp),
            borderRadius: BorderRadius.circular(40),
            boxShadow: const [
              BoxShadow(
                  blurRadius: 4,
                  color: Colors.black12,
                  offset: Offset(4, 4),
                  spreadRadius: 2)
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  currentMonthList[index].day.toString(),
                  style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color:
                          (currentMonthList[index].day != currentDateTime.day)
                              ? HexColor("465876")
                              : Colors.white),
                ),
                Text(
                    date_util.DateUtils
                        .weekdays[currentMonthList[index].weekday - 1],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          (currentMonthList[index].day != currentDateTime.day)
                              ? HexColor("465876")
                              : Colors.white,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget todoListView() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, height = 340, 10, 10),
      width: width,
      height: height * 10,
      child: ListView.builder(
          itemCount: todoList.length,
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext context, int index) {
            return Slidable(
              //added, changed from container
              endActionPane: ActionPane(
                  //added
                  motion: StretchMotion(), //added
                  children: [
                    //added
                    SlidableAction(
                      //added
                      onPressed: deleteFunction, //added
                      icon: Icons.delete, //added
                      backgroundColor: const Color.fromARGB(255, 229, 115, 115),
                      borderRadius: BorderRadius.circular(12), //added
                    )
                  ]),
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 15), //added const
                width: width - 20,
                height: 85,
                decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.white12,
                          blurRadius: 2,
                          offset: Offset(2, 2),
                          spreadRadius: 3)
                    ]),
                child: Center(
                  child: Text(
                    todoList[index],
                    style: TextStyle(
                        //added const
                        color: Color.fromARGB(255, 0, 46, 92),
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }),
    );
  }

//plus button
  Widget floatingActionView() {
    return FloatingActionButton(
      onPressed: () {
        textController.text = "";
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    //replaced Container with SizedBox
                    height: 200,
                    width: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "ADD A TASKsssss",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextField(
                          controller: textController,
                          style: const TextStyle(color: Colors.white),
                          autofocus: true,
                          decoration: const InputDecoration(
                              hintText: "ADD YOUR TASK",
                              hintStyle: TextStyle(color: Colors.white60)),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: 320,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                todoList.add(textController.text);
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text("ADD"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      },
      child: Container(
        width: 100,
        height: 100,
        child: const Icon(
          Icons.add,
          size: 30,
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                colors: [
                  HexColor("ED6184"),
                  HexColor("EF3158"),
                  HexColor("E2042D")
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(0.0, 1.0),
                stops: const [0.0, 0.5, 1.0],
                tileMode: TileMode.clamp)),
      ),
    );
  }

//delete task
  void deleteTask(index) {}

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Stack(
          children: <Widget>[backgroundView(), topView(), todoListView()],
          //return _myHomePageState(
          //deleteFunction: (context) => deleteTask(index),
          // )
        ),
        floatingActionButton: floatingActionView());
  }
}
