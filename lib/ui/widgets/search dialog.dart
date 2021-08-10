import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/providers/exercises%20dialog%20provider%20.dart';
import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

class SearchDialog extends StatefulWidget {
  final height;
  final configProvider;

  SearchDialog(this.height, this.configProvider);

  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchDialogProvider>(builder: (context, exProvider, child) {
      if (!exProvider.requestDone) {
        exProvider.requestDone = true;
        exProvider.fetchBodyParts().then((value) {});
        exProvider.fetchExercises().then((value) {});
      }
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        insetPadding: EdgeInsets.all(20),
        child: Container(
          height: 0.9 * widget.height,
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
                                "${exercises[widget.configProvider.activeLanguage()]}",
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
                          controller: searchController,
                          onChanged: (searchWord) {
                            exProvider.searchResults(searchWord);
                          },
                          decoration: InputDecoration(
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.search),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () => searchController.clear(),
                              icon: Icon(Icons.clear, color: Colors.deepPurpleAccent),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.all(5),
                            // Added this
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      );
                    else if (index == 2) {
                      return Container(
                        height: widget.height * 0.1,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: List.generate(exProvider.myBodyParts.length, (index) {
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
                                          exProvider.onBodyPartBressed(exProvider.myBodyParts[index].name);
                                        },
                                        child: Chip(
                                          label: Text(exProvider.myBodyParts[index].name),
                                          backgroundColor: exProvider.activeBodyPart == exProvider.myBodyParts[index].name ? Colors.grey : Colors.black12,
                                        )));
                              }
                            })),
                      );
                    } else {
                      index = index - 3;
                      return InkWell(
                        onTap: () {
                          if (exProvider.exercisesByBodyParts.isEmpty)
                            Navigator.pop(context, exProvider.exercises[index]);
                          else
                            Navigator.pop(context, exProvider.exercisesByBodyParts[index]);
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
                                    onPressed: () async {
                                    if( !exProvider.exercises[index].isFavorite){
                                     await  exProvider.setFavoriteExercise(userPreferences!.getString("sessionKey")??"", exProvider.exercises[index].id??-1);
                                    }
                                    else {
                                      await  exProvider.unsetFavoriteExercise(userPreferences!.getString("sessionKey")??"", exProvider.exercises[index].id??-1);

                                    }

                                    },
                                    icon: Icon(

                                     !exProvider.exercises[index].isFavorite? Icons.favorite_border: Icons.favorite,
                                      color: Colors.red,
                                      size: 30,
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
  }
}
