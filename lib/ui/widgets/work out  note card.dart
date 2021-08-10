import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business%20logic/config%20provider.dart';
import 'package:workoutnote/business%20logic/main%20%20screen%20provider.dart';
import 'package:workoutnote/models/work%20out%20list%20%20model.dart';
import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

class WorkOutNote extends StatefulWidget {
  final height;
  WorkOut workout;

  WorkOutNote(this.height, this.workout);

  @override
  _WorkOutNoteState createState() => _WorkOutNoteState();
}

class _WorkOutNoteState extends State<WorkOutNote> {
  @override
  Widget build(BuildContext context) {
    var configProvider = Provider.of<ConfigProvider>(context, listen: true);
    var mainProvider = Provider.of<MainScreenProvider>(context, listen: true);

    int count = widget.workout.lifts!.length + 3;
    return Container(
      margin: EdgeInsets.all(10),
      child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: count,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              margin: EdgeInsets.only(left: 15),
                              padding: EdgeInsets.only(top: 10.0),
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                strutStyle: StrutStyle(fontSize: 20.0),
                                text: TextSpan(style: TextStyle(color: Color.fromRGBO(102, 51, 204, 1),  fontSize: 20), text: '${widget.workout.title}'),
                              ),
                            ),
                          ),
                          Expanded(flex: 4, child: Container()),
                          Expanded(
                            flex: 1,
                            child: Container(
                                padding: EdgeInsets.only(top: 10.0, right: 10.0),
                                child: InkWell(
                                  onTap: () {
                                    if(!widget.workout.isFavorite)
                                     mainProvider.setFavoriteWorkOut(userPreferences!.getString("sessionKey")??"", widget.workout.id??-1).then((value) {
                                       setState(() {});
                                     });
                                     else  mainProvider.unsetFavoriteWorkOut(userPreferences!.getString("sessionKey")??"", widget.workout.id??-1).then((value) {
                                       setState(() {});
                                     });
                                  },
                                  child: Icon(
                                    !widget.workout.isFavorite?Icons.favorite_border:Icons.favorite,
                                    size: 30,
                                    color: Colors.red,
                                  ),
                                )),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(top: 10,  right: 10.0),
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                "assets/icons/menu.svg",
                                height: 15,
                                width: 50,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                        child: Divider(color: Colors.black54,),
                      )
                    ],
                  );
                } else if (index == count - 2) {
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 15.0),
                    child: Text(
                      "00:00:${widget.workout.duration != 0 ? widget.workout.duration : 00}",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.deepPurpleAccent),
                    ),
                  );
                } else if (index == count - 1) {
                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Colors.deepPurpleAccent,
                      textColor: Colors.white,
                      child: Text("${repeat[configProvider.activeLanguage()]}"),
                      onPressed: () {},
                    ),
                  );
                } else {
                  index = index - 1;
                  return Container(
                      margin: EdgeInsets.only(left: 15.0),
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text("${index+1}. ${widget.workout.lifts![index].exerciseName}, ${widget.workout.lifts![index].liftMas}kg, ${widget.workout.lifts![index].repetitions}rep, 2 sets"));
                }
              })),
    );
  }
}


