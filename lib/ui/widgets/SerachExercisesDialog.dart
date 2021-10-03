import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:workoutnote/business_logic/ConfigProvider.dart';
import 'package:workoutnote/business_logic/ExerciseDialogProvider.dart';
import 'package:workoutnote/data/models/ExerciseModel.dart';
import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

class SearchDialog extends StatefulWidget {
  final height;

  SearchDialog(this.height);

  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  TextEditingController searchController = TextEditingController();
  String _searchWord = '';
  ConfigProvider configProvider = ConfigProvider();

  @override
  Widget build(BuildContext context) {
    configProvider = Provider.of<ConfigProvider>(context, listen: true);
    return Consumer<ExercisesDialogProvider>(
        builder: (context, dialogProvider, child) {
      List<Exercise> showExercises = [];
      dialogProvider.filterExercises(showExercises);
      dialogProvider.searchExercises(_searchWord, showExercises);
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        insetPadding: EdgeInsets.all(20),
        child: Container(
          padding: EdgeInsets.all(5.0),
          height: 0.9 * widget.height,
          child: _buildExercisesList(dialogProvider, showExercises),
        ),
      );
    });
  }

  Widget _buildExercisesList(
      ExercisesDialogProvider dialogProvider, List<Exercise> showExercises) {
    return ListView.separated(
        itemBuilder: (context, index) {
          if (index == 0) return Container(

              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${exercises[configProvider.activeLanguage()]}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                          fontSize: 15, color: Color.fromRGBO(102, 51, 204, 1)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(right: 10.0),
                      child: IconButton(
                          icon: Icon(Icons.clear,
                              color: Color.fromRGBO(102, 51, 204, 1)),
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
              margin: EdgeInsets.only(left: 14, right: 14),
              child: TextFormField(
                onFieldSubmitted: (word) {
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
                  hintText: '${exerciseHint[configProvider.activeLanguage()]}',
                  hintStyle: TextStyle(color: Colors.grey, fontSize : 15.0),
                  prefixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.search,
                        color: Colors.grey,  size:20.0),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchController.clear();
                      setState(() {
                        _searchWord = '';
                      });
                    },
                    icon: Icon(Icons.close),
                    color: Color.fromRGBO(102, 51, 204, 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          width: 2.0, color: Color.fromRGBO(102, 51, 204, 1))),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      width: 2.0,
                      color: Color.fromRGBO(102, 51, 204, 1),
                    ),
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
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  children:
                      List.generate(dialogProvider.myBodyParts.length, (index) {
                    if (index == 0) {
                      return Container(
                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: InkWell(
                            onTap: () {},
                            child: FilterChip(
                              onSelected: (bool val) {
                                setState(() {
                                  dialogProvider.showFavorite =
                                      !dialogProvider.showFavorite;
                                });
                              },
                              shape: StadiumBorder(
                                  side: BorderSide(
                                    width: 2.0,
                                      color: Color.fromRGBO(102, 51, 204, 1))),
                              label: Text(
                                '${favorites[configProvider.activeLanguage()]}',
                                style: TextStyle(
                                  fontSize: 13.0,
                                    color: dialogProvider.showFavorite
                                        ? Colors.white
                                        : Color.fromRGBO(102, 51, 204, 1)),
                              ),
                              backgroundColor: dialogProvider.showFavorite
                                  ? Color.fromRGBO(102, 51, 204, 1)
                                  : Colors.transparent,
                            )),
                      );
                    } else {
                      index = index - 1;
                      return Container(
                          margin: EdgeInsets.only(right: 10.0),
                          child: FilterChip(
                            onSelected: (bool val) {
                              dialogProvider.onBodyPartpressed(
                                  dialogProvider.myBodyParts[index].name);
                            },
                            shape: StadiumBorder(
                                side: BorderSide(
                                  width: 2.0,
                                    color: Color.fromRGBO(102, 51, 204, 1))),
                            label: Text(
                              dialogProvider.myBodyParts[index].name,
                              style: TextStyle(
                                fontSize: 13.0,
                                  color: dialogProvider.activeBodyPart ==
                                          dialogProvider.myBodyParts[index].name
                                      ? Colors.white
                                      : Color.fromRGBO(102, 51, 204, 1)),
                            ),
                            backgroundColor: dialogProvider.activeBodyPart ==
                                    dialogProvider.myBodyParts[index].name
                                ? Color.fromRGBO(102, 51, 204, 1)
                                : Colors.transparent,
                          ));
                    }
                  })),
            );
          }
          else {
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
                        child: showExercises[index]
                                    .namedTranslations!
                                    .english ==
                                null
                            ? Text(
                                '${showExercises[index].name}(${showExercises[index].bodyPart})')
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${showExercises[index].namedTranslations!.english}'),
                                  Text(
                                      '${showExercises[index].name}(${showExercises[index].bodyPart})')
                                ],
                              )),
                    Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                          child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              onPressed: () async {
                                if (!showExercises[index].isFavorite) {
                                  await dialogProvider.setFavoriteExercise(
                                      userPreferences!
                                              .getString('sessionKey') ??
                                          '',
                                      showExercises[index].id ?? -1,
                                      showExercises[index]);
                                } else {
                                  await dialogProvider.unsetFavoriteExercise(
                                      userPreferences!
                                              .getString('sessionKey') ??
                                          '',
                                      showExercises[index].id ?? -1,
                                      showExercises[index]);
                                }
                              },
                              icon: showExercises[index].isFavorite
                                  ? SvgPicture.asset(
                                      'assets/icons/liked.svg',
                                      width: 17.0,
                                      height: 17.0,
                                    )
                                  : SvgPicture.asset(
                                      'assets/icons/unliked.svg',
                                      width: 17.0,
                                      height: 17.0,
                                    )),
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
        itemCount: showExercises.length + 3);
  }
}
