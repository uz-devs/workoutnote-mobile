import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workoutnote/services/network%20%20service.dart';

class CreateWorkOutCard extends StatelessWidget {
  var  titleContoller = TextEditingController();
  final width;
  final height;
  CreateWorkOutCard(this.width , this.height);

  @override
  Widget build(BuildContext context) {
    return Container(

    margin: EdgeInsets.all(10
    ),
      child: Card(

        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Container(
          margin: EdgeInsets.only(top: 10),
          child: ListView.separated(

              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (BuildContext context, int index) {
                if(index > 4)
                  return Divider(height: 1,  color: Colors.grey,);
                else return  Divider(height: 0, color: Colors.white,);
              },

              itemCount:7,itemBuilder: (context, index) {
            if(index == 0)
              return  Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text("${DateFormat("yyyy.MM.dd").format(DateTime.now())}, ${DateFormat("EEEE").format(DateTime.now())}",  style: TextStyle(
                    fontSize: 15,

                  ),));
            else if(index == 1)
              return   Container(
                margin: EdgeInsets.only(left: 10, right: 10.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Your title",
                    suffixIcon: IconButton(
                      onPressed: titleContoller.clear,
                      icon: Icon(Icons.clear, color:Colors.deepPurpleAccent),
                    ),


                  ),
                  controller: titleContoller,
                ),
              );
            else if(index == 2){
              return Container(
                margin: EdgeInsets.only(left: 10.0),
                child: Row(

                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Text("00:00:00", textAlign: TextAlign.center, style: TextStyle(
                        fontSize: 40,
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.bold

                      ),

                      ),
                    ),
                    Spacer(),
                    Container(


                      margin: EdgeInsets.only(right: 10.0, bottom: 10.0),
                      child: IconButton(onPressed: (){}, icon: Icon(Icons.play_circle_outline, color: Colors.deepPurpleAccent, size: 50,)),
                    ),
                    Container(

 margin: EdgeInsets.only(right: 15.0, bottom: 10.0),

                      child: IconButton(onPressed: (){}, icon: Icon(Icons.stop_circle_outlined, color: Colors.deepPurpleAccent, size: 50,)),
                    ),

                  ],
                ),
              );
            }
            else if(index == 3) return Container(
                margin: EdgeInsets.only(left: 10.0, top: 30),
              child: Align(
                   alignment: Alignment.topLeft,
                  child:MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    color: Colors.deepPurpleAccent,
                    onPressed: (){},
                    textColor: Colors.white,
                    child: Text("See all exercises"),

                  ),
                ),
            );
            else if(index == 4) {
              return Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(bottom: 10, left: 10.0, right: 10.0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(230, 230, 250, 1),
                    border: Border.all(
                      color: Color.fromRGBO(230, 230, 250, 1),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Row(

                  children: [
                    Container(
                      width: 0.1*width,
                      child: Text("No.", style: TextStyle(
                        color: Colors.deepPurpleAccent
                      ),),
                    ),
                    Container(
                      width: 0.4*width,

                      child: Text("Exercise", style: TextStyle(
                          color: Colors.deepPurpleAccent
                      ),),
                    ),
                    Container(
                      width: 0.1*width,
                      child: Text("KG", style: TextStyle(
                          color: Colors.deepPurpleAccent
                      ),),
                    ),
                    Container(
                      width: 0.1*width,
                      child: Text("REP", style: TextStyle(
                          color: Colors.deepPurpleAccent
                      ),),
                    ),

                  ],
                ),
              );
            }
            else  if(index == 5){
              return  Container(


                padding: EdgeInsets.only(left: 10, right: 10.0),
                margin: EdgeInsets.only(bottom: 10, left: 10.0, right: 10.0),
                child: Row(

                  children: [
                    Container(
                      width: 0.1*width,
                      child: Text("1", style: TextStyle(
                      ),),
                    ),
                    InkWell(
                      onTap: ()async{
                        await showdialog(context);

                      },
                      child: Container(
                        width: 0.4*width,

                        child: Text("dummy exercise", style: TextStyle(
                        ),),
                      ),
                    ),
                    Container(
                      width: 0.1*width,
                      child: Text("KG", style: TextStyle(
                      ),),
                    ),
                    Container(
                      width: 0.1*width,
                      child: Text("REP", style: TextStyle(
                      ),),
                    ),
                    Spacer(),
                    Container(
                      width: 0.1*width,
                      child: IconButton(onPressed: () {}, icon: Icon(Icons.add_circle_outline),),
                    ),
                  ],
                ),
              );
            }
            else{
              return Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10.0),
                      width: 100,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        color: Colors.grey,
                        onPressed: (){},
                        textColor: Colors.white,
                        child: Text("remove"),

                      ),
                    ),
                    Container(
                      width: 100,
                      margin: EdgeInsets.only(right: 10.0),

                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                        color: Colors.deepPurpleAccent,
                        onPressed: (){},
                        textColor: Colors.white,
                        child: Text("save"),

                      ),
                    ),
                  ],
                ),
              );
            }

          }),
        )
      ),
    );
  }

  Future<void> showdialog(BuildContext context) async{
    var  response = await WebServices.fetchExercises();
     print("fehieqruqghoeruighiqprug");
    print(response.statusCode);
    print(response.body);

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return  Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            insetPadding: EdgeInsets.all(10),
            child: Container(
              height: 0.9*height,
              child: Scrollbar(
                thickness: 3,
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      if(index == 0)
                        return  Container(

                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Exercise",
                                  style: TextStyle(fontSize: 21, color: Colors.deepPurpleAccent),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                              )
                            ],
                          ),
                        );
                      else if (index == 1)
                        return Container(
                        margin: EdgeInsets.only(left: 10, right: 10.0),
                        child: TextFormField(

                            decoration: InputDecoration(
                              prefixIcon: IconButton(
                                onPressed: (){},
                                icon: Icon(Icons.search),
                              ),
                              suffixIcon:IconButton(
                                onPressed: titleContoller.clear,
                                icon: Icon(Icons.clear, color:Colors.deepPurpleAccent),
                              ),

                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                      );
                      else {
                        return Container(
                          height: height*0.1,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Chip(label: Text("chip1")),
                              Chip(label: Text("chip1")),
                              Chip(label: Text("chip1")),
                              Chip(label: Text("chip1")),
                              Chip(label: Text("chip1")),
                            ],
                          ),
                        );
                      }
                },
                    separatorBuilder: (BuildContext context, index) {
                     return Divider(color: index > 3?Colors.grey:Colors.white,);
                    },  itemCount: 3)
              ),

            ),
          );
        }

    );
  }



}
