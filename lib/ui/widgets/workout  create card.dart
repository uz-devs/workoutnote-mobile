import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business%20logic/config%20provider.dart';
import 'package:workoutnote/business%20logic/main%20%20screen%20provider.dart';
import 'package:workoutnote/models/editible%20lift%20model.dart';
import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

class CreateWorkOutCard extends StatelessWidget {
  var titleContoller = TextEditingController();
  final width;
  final height;

  CreateWorkOutCard(this.width, this.height);

  @override
  Widget build(BuildContext context) {
    var configProvider = Provider.of<ConfigProvider>(context, listen: true);
    return Container(
      margin: EdgeInsets.all(10),
      child: Consumer<MainScreenProvider>(builder: (context, exProvider, child) {

        if(!exProvider.timeRefreshed && userPreferences!.getInt("time") != null){
          exProvider.timeRefreshed = true;
          exProvider.hrs = ((userPreferences!.getInt("time")! / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
          exProvider.mins = ((userPreferences!.getInt("time")! / 60) % 60).floor().toString().padLeft(2, '0');
          exProvider.secs = (userPreferences!.getInt("time")! % 60).floor().toString().padLeft(2, '0');
        }


        int count = exProvider.selectedExercises.length + 7;
        if (!exProvider.appRefereshed) exProvider.firstEnterApp();
        print(count);
        return Card(
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
                    if (index > 4)
                      return Divider(
                        height: 1,
                        color: Colors.grey,
                      );
                    else
                      return Divider(
                        height: 0,
                        color: Colors.white,
                      );
                  },
                  itemCount: count,
                  itemBuilder: (context, index) {
                    if (index == 0)
                      return Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            "${DateFormat("yyyy.MM.dd").format(DateTime.now())}, ${DateFormat("EEEE").format(DateTime.now())}",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ));
                    else if (index == 1)
                      return Container(
                        margin: EdgeInsets.only(left: 10, right: 10.0),
                        child: TextField(
                          onChanged: (c) async{
                         await exProvider.saveTitleToSharedPreference(c);
                          },
                          decoration: InputDecoration(
                            hintText: "${title[configProvider.activeLanguage()]}",
                            suffixIcon: IconButton(
                              onPressed: exProvider.titleContoller.clear,
                              icon: Icon(Icons.clear, color: Colors.deepPurpleAccent),
                            ),
                          ),
                          controller: exProvider.titleContoller,
                        ),
                      );
                    else if (index == 2) {
                      return Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10.0),
                              child: Text(
                                "${exProvider.hrs}:${exProvider.mins}:${exProvider.secs}",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 40, color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Spacer(),
                            if (exProvider.timerSubscription != null)
                              Container(
                                margin: EdgeInsets.only(bottom: 10.0),
                                child: IconButton(
                                    onPressed: () {
                                      exProvider.stopTimer();
                                    },
                                    icon: Icon(
                                      Icons.stop_circle_outlined,
                                      color: Colors.deepPurpleAccent,
                                      size: 50,
                                    )),
                              ),
                            Container(
                              margin: EdgeInsets.only(right: 20.0, bottom: 10.0),
                              child: (exProvider.timerSubscription == null || exProvider.timerSubscription!.isPaused)
                                  ? IconButton(
                                      onPressed: () {
                                        if (exProvider.timerSubscription == null) {
                                          exProvider.startTimer();
                                        } else if (exProvider.timerSubscription!.isPaused) {
                                          exProvider.resumeTimer();
                                        }
                                      },
                                      icon: Icon(
                                        Icons.play_circle_outline,
                                        color: Colors.deepPurpleAccent,
                                        size: 50,
                                      ))
                                  : IconButton(
                                      onPressed: () {
                                        exProvider.pauseTimer();
                                      },
                                      icon: Icon(
                                        Icons.pause_circle_outline,
                                        color: Colors.deepPurpleAccent,
                                        size: 50,
                                      )),
                            ),
                          ],
                        ),
                      );
                    } else if (index == 3) {
                      return Container(
                        margin: EdgeInsets.only(left: 10.0, top: 30),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                            color: Colors.deepPurpleAccent,
                            onPressed: () async {
                              await showdialog(context, configProvider);
                            },
                            textColor: Colors.white,
                            child: Text("${seeExercises[configProvider.activeLanguage()]}"),
                          ),
                        ),
                      );
                    } else if (index == 4) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(bottom: 10, left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(230, 230, 250, 1),
                            border: Border.all(
                              color: Color.fromRGBO(230, 230, 250, 1),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          children: [
                            Container(
                              width: 0.1 * width,
                              child: Text(
                                "No.",
                                style: TextStyle(color: Colors.deepPurpleAccent),
                              ),
                            ),
                            Container(
                              width: 0.3 * width,
                              child: Text(
                                "${exercisesName[configProvider.activeLanguage()]}",
                                style: TextStyle(color: Colors.deepPurpleAccent),
                              ),
                            ),
                            Container(
                              width: 0.1 * width,
                              child: Text(
                                "KG",
                                style: TextStyle(color: Colors.deepPurpleAccent),
                              ),
                            ),
                            Container(
                              width: 0.1 * width,
                              child: Text(
                                "REP",
                                style: TextStyle(color: Colors.deepPurpleAccent),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (index == count - 2) {
                      return Container(
                        padding: EdgeInsets.only(left: 10, right: 10.0),
                        margin: EdgeInsets.only(bottom: 10, left: 10.0, right: 10.0),
                        child: Row(
                          children: [
                            Container(
                                width: 0.1 * width,
                                child: Text(
                                  "",
                                  style: TextStyle(color: Colors.grey),
                                )),
                            InkWell(
                              onTap: () async {
                                await showdialog(context, configProvider);
                              },
                              child: Container(
                                width: 0.3 * width,
                                child: Text(
                                  "${exProvider.unselectedExercise == null ? "no exercise  selected" : exProvider.unselectedExercise!.name}(${(exProvider.unselectedExercise == null ? "" : exProvider.unselectedExercise!.bodyPart)})",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                            Container(
                              width: 0.1 * width,
                              child: Text(
                                exProvider.unselectedLift == null ? "KG" : "01",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Container(
                              width: 0.1 * width,
                              child: Text(
                                exProvider.unselectedLift == null ? "REP" : "01",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: 0.1 * width,
                              child: IconButton(
                                onPressed: () async {
                                  if (exProvider.unselectedExercise != null) {
                                    exProvider.addExercise(EditableLift.create(exProvider.unselectedExercise!.name, exProvider.unselectedExercise!.id, exProvider.unselectedExercise!.bodyPart, 00, 00, true));
                                    await exProvider.saveListToSharePreference();
                                  } else
                                    showToast("Please, select exercise!");
                                },
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (index > 4 && index < count - 2 && index < count - 1) {
                      index = index - 5;
                      return Container(
                        key: Key(index.toString()),
                        padding: EdgeInsets.only(left: 10, right: 10.0),
                        margin: EdgeInsets.only(bottom: 10, left: 10.0, right: 10.0),
                        child: Row(
                          children: [
                            Container(
                              width: 0.1 * width,
                              child: Text(
                                "${index + 1}",
                                style: TextStyle(color: exProvider.selectedExercises[index].isSelected ? Colors.deepPurpleAccent : Colors.grey),
                              ),
                            ),
                            InkWell(
                              onTap: () async {},
                              child: Container(
                                width: 0.4 * width,
                                child: Text(
                                  "${exProvider.selectedExercises[index].exerciseName}(${exProvider.selectedExercises[index].bodyPart})" ?? "",
                                  style: TextStyle(color: exProvider.selectedExercises[index].isSelected ? Colors.deepPurpleAccent : Colors.grey),
                                ),
                              ),
                            ),
                            Container(
                              width: 0.1 * width,
                              child: Text(
                                "1",
                                style: TextStyle(color: exProvider.selectedExercises[index].isSelected ? Colors.deepPurpleAccent : Colors.grey),
                              ),
                            ),
                            Container(
                              width: 0.1 * width,
                              child: Text(
                                "1",
                                style: TextStyle(color: exProvider.selectedExercises[index].isSelected ? Colors.deepPurpleAccent : Colors.grey),
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: 0.1 * width,
                              child: IconButton(
                                onPressed: () async {
                                  exProvider.updateExercise(index);
                                  exProvider.saveListToSharePreference();
                                  },
                                icon: Icon(
                                  Icons.check_box,
                                  size: 40,
                                  color: exProvider.selectedExercises[index].isSelected ? Colors.deepPurpleAccent : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else
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
                                onPressed: () async{
                                  exProvider.removeExercises();
                                 await exProvider.saveListToSharePreference();
                                },
                                textColor: Colors.white,
                                child: Text("${remove[configProvider.activeLanguage()]}"),
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
                                onPressed: () {
                                  exProvider.createWorkOutSession(userPreferences!.getString("sessionKey") ?? "fuck", exProvider.titleContoller.text, DateTime.now().microsecondsSinceEpoch, 1).then((value) {});
                                },
                                textColor: Colors.white,
                                child: Text("${save[configProvider.activeLanguage()]}"),
                              ),
                            ),
                          ],
                        ),
                      );
                  }),
            ));
      }),
    );
  }

  Future<void> showdialog(BuildContext context, ConfigProvider configProvider) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Consumer<MainScreenProvider>(builder: (context, exProvider, child) {
            if (!exProvider.requestDone2) {
              exProvider.requestDone2 = true;
              exProvider.fetchBodyParts().then((value) {});
              exProvider.fetchExercises().then((value) {});
            }
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              insetPadding: EdgeInsets.all(20),
              child: Container(
                height: 0.9 * height,
                child: Scrollbar(
                    thickness: 3,
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          if (index == 0)
                            return Container(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${exercises[configProvider.activeLanguage()]}",
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
                              height: 40,
                              margin: EdgeInsets.only(left: 10, right: 10.0),
                              child: TextFormField(
                                controller: exProvider.searchController,
                                onChanged: (searchWord) {
                                  exProvider.searchResults(searchWord);
                                },
                                decoration: InputDecoration(
                                  prefixIcon: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.search),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () => exProvider.searchController.clear(),
                                    icon: Icon(Icons.clear, color: Colors.deepPurpleAccent),
                                  ),
                                  isDense: true,
                                  // Added this
                                  contentPadding: EdgeInsets.all(8),
                                  // Added this
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            );
                          else if (index == 2) {
                            return Container(
                              height: height * 0.1,
                              child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: List.generate(exProvider.bodyParts.length, (index) {
                                    if (index == 0) {
                                      return Container(
                                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                                        child: InkWell(
                                            onTap: () {},
                                            child: Chip(
                                              label: Text(
                                                "Favorites",
                                                style: TextStyle(color: Colors.white),
                                              ),
                                              backgroundColor: Colors.red,
                                            )),
                                      );
                                    } else {
                                      index = index - 1;
                                      return Container(
                                          margin: EdgeInsets.only(right: 10.0),
                                          child: InkWell(
                                              onTap: () {
                                                exProvider.onBodyPartBressed(exProvider.bodyParts[index].name);
                                              },
                                              child: Chip(
                                                label: Text(exProvider.bodyParts[index].name),
                                                backgroundColor: exProvider.activeBodyPart == exProvider.bodyParts[index].name ? Colors.grey : Colors.black12,
                                              )));
                                    }
                                  })),
                            );
                          } else {
                            index = index - 3;
                            return InkWell(
                              onTap: () {
                                if (exProvider.exercisesByBodyParts.isEmpty)
                                  exProvider.unselectedExercise = exProvider.exercises[index];
                                else
                                  exProvider.unselectedExercise = exProvider.exercisesByBodyParts[index];
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 8,
                                        child: Container(
                                            margin: EdgeInsets.only(left: 10.0),
                                            child: Text(
                                                "${exProvider.exercisesByBodyParts.isEmpty ? exProvider.exercises[index].name : exProvider.exercisesByBodyParts[index].name} (${exProvider.exercisesByBodyParts.isEmpty ? exProvider.exercises[index].bodyPart : exProvider.exercisesByBodyParts[index].bodyPart})"))),
                                    Expanded(
                                        flex: 2,
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.favorite_border,
                                            color: Colors.red,
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                        separatorBuilder: (BuildContext context, index) {
                          return Divider(
                            color: index > 2 ? Colors.grey : Colors.white,
                          );
                        },
                        itemCount: exProvider.exercisesByBodyParts.isEmpty ? exProvider.exercises.length + 3 : exProvider.exercisesByBodyParts.length + 3)),
              ),
            );
          });
        });
  }
}
