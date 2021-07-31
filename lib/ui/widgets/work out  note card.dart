import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workoutnote/models/work%20out%20list%20%20model.dart';

class WorkOutNote extends StatelessWidget {
   final height;
   WorkOut workout;
   WorkOutNote(this.height, this.workout);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 0.4*height,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Container(
                  margin: EdgeInsets.only(left: 10),

                  child: Text(workout.title??"UNKNOWN",  style: TextStyle(
                    fontSize: 20
                  ),)), IconButton(onPressed: () {}, icon: Icon(Icons.apps_sharp))],
            ),
            Divider(),
            Text("blablabla, 1kg, 10rep, 3set"),
            Text("blablabla, 1kg, 10rep, 3set"),
            Text("blablabla, 1kg, 10rep, 3set"),
            Spacer(),
            Container(
              alignment: Alignment.center,
              child: Text("00:00:${workout.duration}", style: TextStyle(
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
                child: Text("반보과기"),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
