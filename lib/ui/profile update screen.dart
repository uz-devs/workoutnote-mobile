
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workoutnote/utils/utils.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen() ;

  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  @override
  Widget build(BuildContext context) {
    print(userPreferences!.getString("gender"));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(

          icon: Icon(Icons.arrow_back_ios),
          color: Colors.deepPurpleAccent,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text("Profile Info",  style: TextStyle(color: Colors.deepPurpleAccent),),
      ),

      body: Container(
        margin: EdgeInsets.only(top: 20.0,  bottom: 20.0),
        child: ListView.separated(
            itemBuilder: (context, index) {
              if(index  == 0)
                return Container(
                  margin: EdgeInsets.only(left: 15.0, right:15.0),
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      Text("Name", style: TextStyle(
                        color: Colors.deepPurpleAccent
                      ),),
                      TextFormField(
                        controller: TextEditingController()..text = userPreferences!.getString("name")??"",
                        decoration: InputDecoration(
                          isDense: true,

                          contentPadding: EdgeInsets.only(top: 5.0),
                          hintText: "Enter your name"
                        ),

                      )
                    ],
                  ),
                );
             else  if(index == 1)
               return Container(
                 margin: EdgeInsets.only(left: 15.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text("Gender", style: TextStyle(
                         color: Colors.deepPurpleAccent
                     ),),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         Radio(
                           value:userPreferences!.getString("gender") == "MALE"?1:0,  groupValue: 1, onChanged: (int? value) {  },
                         ),
                         Text("male"),
                         Radio(
                           value: userPreferences!.getString("gender") == "FEMALE"?1:0, groupValue: 1, onChanged: (int? value) {  },
                         ),
                         Text("female"),

                       ],
                     )
                   ],
                 ),
               );

             else  if (index == 2)
               return Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Container(
                     margin: EdgeInsets.only(left: 15),
                     child: Text("Birth date", style: TextStyle(
                         color: Colors.deepPurpleAccent
                     ),),
                   ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       DropdownButton(
                           hint: Text("Year"),

                           onChanged: (item) {},
                           items: List.generate(100, (index) {
                         return DropdownMenuItem(
                             value: 1,


                             child: Text("${index + 1921}"));
                       }) ),
                       DropdownButton(
                           hint: Text("Month"),

                           onChanged: (item) {},
                           items: List.generate(12, (index) {
                             return DropdownMenuItem(
                                 value: 1,


                                 child: Text("${index + 1}"));
                           }) ),
                       DropdownButton(
                           hint: Text("Day"),

                           onChanged: (item) {},
                           items: List.generate(30, (index) {
                             return DropdownMenuItem(
                                 value: 1,


                                 child: Text("${index + 1}"));
                           }) ),

                     ],
                   ),
                   Container(
                     margin: EdgeInsets.only(left: 15),
                     child: Text("Email", style: TextStyle(
                         color: Colors.deepPurpleAccent
                     ),),
                   ),
                   Container(
                     margin: EdgeInsets.only(left: 15.0, right: 15.0),
                     child: TextFormField(
                       decoration: InputDecoration(
                           isDense: true,


                           contentPadding: EdgeInsets.only(top: 5.0),
                           hintText: "Enter your email"
                       ),

                     ),
                   )
                 ],
               );


             else if(index == 3) return Container(
                  margin: EdgeInsets.only(top: 10.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Text("Phone number", style: TextStyle(
                            color: Colors.deepPurpleAccent
                        ),),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15.0, right: 15.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.only(top: 5.0),
                              hintText: "Enter your phone number"
                          ),

                        ),
                      )
                    ],
                  ),
             );
             else return Container(
                  margin: EdgeInsets.all(15.0),
               child: CupertinoButton(
                      color: Colors.deepPurpleAccent,
                      borderRadius: const BorderRadius.all(Radius.circular(120)),
                      child: Text("Update"),
                      onPressed: () {

                      }),
             );
            },
            separatorBuilder: (context,  index) {
              if(index == 0)
              return  Divider(thickness: 0, color: Colors.white,);
              else if (index == 1)
                return Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: Divider(color: Colors.deepPurpleAccent,));
              return Divider();
            },
            itemCount: 5),
      )
    );
  }
}
