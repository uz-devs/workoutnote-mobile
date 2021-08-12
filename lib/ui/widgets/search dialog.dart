import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/models/exercises%20model.dart';
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
  String _searchWord = "";

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchDialogProvider>(builder: (context, dialogProvider, child) {

      List<Exercise> showExercises = [];
      if (!dialogProvider.requestDone) {
        dialogProvider.requestDone = true;
        dialogProvider.fetchBodyParts().then((value) {});
        dialogProvider.fetchExercises().then((value) {});
      }
      dialogProvider.filterExercises(showExercises);
      dialogProvider.searchExercises(_searchWord,  showExercises);
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        insetPadding: EdgeInsets.all(20),
        child: Container(
          height: 0.9 * widget.height,
          child: Scrollbar(
              thickness: 3,
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    if (index == 0) return Container(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "${exercises[widget.configProvider.activeLanguage()]}",
                                style: TextStyle(fontSize: 21, color: Color.fromRGBO(102, 51, 204, 1)),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.only(right: 10.0),
                                child: IconButton(
                                    icon: Icon(Icons.clear, color: Color.fromRGBO(102, 51, 204, 1)),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                              ),
                            )
                          ],
                        ),
                      );
                    else if (index == 1) return Container(
                        height: 40,
                        margin: EdgeInsets.only(left: 10, right: 10.0),
                        child: TextFormField(
                          onFieldSubmitted: (word){
                            setState(() {
                               dialogProvider.searchExercises(word, showExercises);
                            });
                            },
                          controller: searchController,
                          onChanged: (searchWord) {
                            setState(() {
                              _searchWord = searchWord;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: "Exercise name",
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.search, color: Color.fromRGBO(102, 51, 204, 1)),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                searchController.clear();
                                setState(() {
                                  _searchWord = "";
                                });
                              },
                              icon: Icon(Icons.close),
                              color: Color.fromRGBO(102, 51, 204, 1),
                            ),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide(width: 1.5, color: Color.fromRGBO(102, 51, 204, 1))),
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
                            children: List.generate(dialogProvider.myBodyParts.length, (index) {
                              if (index == 0) {
                                return Container(
                                  margin: EdgeInsets.only(left: 10.0, right: 10.0),
                                  child: InkWell(
                                      onTap: () {},
                                      child: FilterChip(
                                        onSelected: (bool  val){

                                          setState(() {
                                            dialogProvider.showFavorite = !dialogProvider.showFavorite;
                                          });
                                          },
                                        shape: StadiumBorder(side: BorderSide(color: Color.fromRGBO(102, 51, 204, 1))),

                                        label: Text(
                                          "Favorites",
                                          style: TextStyle(color: dialogProvider.showFavorite?Colors.white:  Color.fromRGBO(102, 51, 204, 1)),
                                        ),
                                        backgroundColor: dialogProvider.showFavorite?Color.fromRGBO(102, 51, 204, 1):Colors.transparent,
                                      )),
                                );
                              }
                              else {
                                index = index - 1;
                                return Container(
                                    margin: EdgeInsets.only(right: 10.0),
                                    child:  FilterChip(
                                          onSelected: (bool val) {
                                            dialogProvider.onBodyPartBressed(dialogProvider.myBodyParts[index].name);
                                            },
                                        shape: StadiumBorder(side: BorderSide(color: Color.fromRGBO(102, 51, 204, 1))),
                                          label: Text(dialogProvider.myBodyParts[index].name, style: TextStyle(color: dialogProvider.activeBodyPart == dialogProvider.myBodyParts[index].name?Colors.white:Color.fromRGBO(102, 51, 204, 1)),),
                                          backgroundColor: dialogProvider.activeBodyPart == dialogProvider.myBodyParts[index].name ? Color.fromRGBO(102, 51, 204, 1):Colors.transparent,
                                        ));
                              }
                            })),
                      );
                    } else {
                      index = index - 3;
                      return InkWell(
                        onTap: () {


                          Navigator.pop(context, showExercises[index]);

                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 8,
                                  child: showExercises[index].namedTranslations!.english == null?
                                   Text("${showExercises[index].name}(${showExercises[index].bodyPart})"):
                                   Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text("${showExercises[index].namedTranslations!.english}"),
                                       Text("${showExercises[index].name}(${showExercises[index].bodyPart})")
                                        ],
                                   )
                              ),
                              Expanded(
                                  flex: 2,
                                  child: IconButton(
                                    onPressed: () async {
                                      if (!showExercises[index].isFavorite) {
                                        await dialogProvider.setFavoriteExercise(userPreferences!.getString("sessionKey") ?? "", showExercises[index].id ?? -1, showExercises[index]);
                                      } else {
                                        await dialogProvider.unsetFavoriteExercise(userPreferences!.getString("sessionKey") ?? "", showExercises[index].id ?? -1, showExercises[index]);
                                      }
                                    },
                                    icon: Icon(
                                      showExercises[index].isFavorite? Icons.favorite : Icons.favorite_border,
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
                    return Container(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Divider(
                        color: index > 2 ? Color.fromRGBO(102, 51, 204, 1) : Colors.white,
                      ),
                    );
                  },
                  itemCount: showExercises.length+3)),
        ),
      );
    });
  }



  //for future use
  Widget _buildSearchWidget(){
    return Container();
  }
  Widget _buildTitle(){
    return Container();
  }
  Widget _buildFilterButtons(){
    return Container();
  }
  Widget _buildExercise(){
    return  Container();
  }

}
