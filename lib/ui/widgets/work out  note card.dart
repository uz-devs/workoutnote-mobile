import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business%20logic/config%20provider.dart';
import 'package:workoutnote/models/work%20out%20list%20%20model.dart';
import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

class WorkOutNote extends StatelessWidget {
   final height;
   WorkOut workout;
   WorkOutNote(this.height, this.workout);

  @override
  Widget build(BuildContext context) {
    var configProvider = Provider.of<ConfigProvider>(context, listen: true );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: EdgeInsets.only(left: 15),
            child: Text("${toDate(workout.timestamp??0)}",  style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.deepPurpleAccent
            ),)),
        Container(
          margin: EdgeInsets.all(10),
          height: 0.4*height,
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Container(
                        margin: EdgeInsets.only(left: 10),

                        child: Text(workout.title??"UNKNOWN",  style: TextStyle(fontSize: 20),)),

                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 10),
                      child: SvgPicture.asset("assets/icons/menu.svg", height: 24,
                        width: 24, color: Colors.black12,),
                    )

                    ],
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: workout.lifts!.length,  itemBuilder: (context,  index){
                      return Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: Text("${workout.lifts![index].exerciseName}, ${workout.lifts![index].liftMas}kg, ${workout.lifts![index].repetitions}rep, 2 sets",  style: TextStyle(
                          fontSize:15
                        ),),
                      );

                    }
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text("00:00:${workout.duration!=0?workout.duration:00}", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.deepPurpleAccent
                    ),),
                  ),
                  Container(
                    width: double.infinity,

                    margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.deepPurpleAccent,
                      textColor: Colors.white,
                      child: Text("${repeat[configProvider.activeLanguage()]}"),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
