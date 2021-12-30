// ignore_for_file: prefer_const_literals_to_create_immutables, non_constant_identifier_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hexcolor/hexcolor.dart';
import 'package:modolar_recipe/Styles/constants.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:modolar_recipe/Views/main_screen.dart';
// import 'package:modolar_recipe/Styles/constants.dart';
// import 'package:flutter/foundation.dart';
import 'package:modolar_recipe/Widgets/circle_image.dart';
import 'package:modolar_recipe/Widgets/buttons.dart';
import 'package:modolar_recipe/Widgets/ingredients.dart';
import 'package:modolar_recipe/Widgets/rating.dart';
import 'package:modolar_recipe/Widgets/recipes.dart';
import 'package:url_launcher/url_launcher.dart';

class FullViewScreen extends StatefulWidget {
  FullViewScreen({Key? key}) : super(key: key);

  static const String idScreen = "detail_recipe";
  String applicationId = "41ca25af",
      applicationKey = "ab51bad1b862188631ce612a9b1787a9";
  @override
  _FullViewScreenState createState() => _FullViewScreenState();
}

class _FullViewScreenState extends State<FullViewScreen> {
  bool editView = false;
  int _selectedIndex = 0;
  String ApplicationID = '1e2b1681',
      ApplicationKey = '47e224016bc268ada433484688f019cf';

  var url = '';
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final model = routeArgs['Model'];

    url = model.url;

    return Scaffold(
      backgroundColor: HexColor('#998fb3'),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            HeaderCard(model: model),
            InfoCard(model: model, editView: editView),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.local_dining),
            label: 'Recipe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Faivorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Edit',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:
            _selectedIndex == 1 ? Colors.red : Colors.purple, //amber[800],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          switch (index) {
            case 0:
              _launchURL(url);
              print('0 $index');
              break;
            case 1:
              print('1 $index');
              break;
            case 2:
              print('2 $index');

              setState(() {
                editView = !editView;
              });
              break;
          }
        },
      ),
    );
  }
}

class HeaderCard extends StatelessWidget {
  const HeaderCard({
    Key? key,
    required this.model,
  }) : super(key: key);

  final RecipeModel model;

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final UID = routeArgs['UID'];
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 25.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CircleButton(
                  color: HexColor('##785ac7'),
                  icon: Icons.star,
                  callback: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => RateRecipe(),
                    );
                  },
                ),
                CircleButton(
                  color: HexColor('##785ac7'),
                  icon: Icons.keyboard_arrow_left,
                  callback: () => {
                    Navigator.of(context).pushNamed(
                      MainScreen.idScreen,
                      arguments: {'UID': UID},
                    ),
                  },
                ),
              ],
            ),
          ),
          //TODO Need to figure out how to do overlapping oversized photos so we can follow the design
          Stack(
            //            overflow: Overflow.clip,
            // children: <Widget>[
            clipBehavior: Clip.hardEdge,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  right: 25.0,
                ),
                child: Center(
                  child: CircleNetworkImage(
                    imageURL: model.image,
                    radius: 250.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatefulWidget {
  const InfoCard({Key? key, required this.model, required this.editView})
      : super(key: key);
  final RecipeModel model;
  final bool editView;
  @override
  _InfoCardState createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  TextEditingController txtController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final instructions = [
      'do A',
      'do B',
      'asfasdfs dafasdf  as dfasfsdafasdfasfasdf s dafasdf  as dfasfs dafasdf asfasdfs dafasdf  as dfasfsdafasdf'
    ];
    List<IngredientCard> ingredientsList = List.generate(
      widget.model.ingredients.length,
      (int i) => IngredientCard(
        edit: widget.editView,
        name: widget.model.ingredients[i].name,
        quantity: widget.model.ingredients[i].quantity.toString(),
        unit: widget.model.ingredients[i].unit,
      ),
    );
    List<Animal> ingredientComp = [];
    return Expanded(
      flex: 2,
      child: Container(
        padding: EdgeInsets.only(
          left: 25.0,
          right: 25.0,
          top: 30.0,
        ),
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(50.0),
          ),
        ),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.model.name,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Quicksand",
                  ),
                ),
                if (widget.model.cookingTime != 0.0)
                  Row(
                    children: <Widget>[
                      Text(
                        widget.model.cookingTime.toInt().toString(),
                        style: TextStyle(
                          fontFamily: "Quicksand",
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFBFBFBF),
                        ),
                      ),
                      Icon(Icons.timer, color: Color(0xFFBFBFBF), size: 30),
                    ],
                  )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Ingredients',
              style: TextStyle(
                color: Color(0xff909090),
                fontWeight: FontWeight.w700,
                fontFamily: "Quicksand",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: ingredientsList,
            ),
            if (widget.editView)
              Row(
                children: <Widget>[
                  // search
                  Expanded(
                    child: TextField(
                      controller: txtController,
                      decoration: InputDecoration(
                          hintText: "Start Typeing Ingrideint name",
                          hintStyle: TextStyle(
                            fontSize: 18,
                          )),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  InkWell(
                    onTap: () async {
                      if (txtController.text.isNotEmpty) {
                        print('in search damn!');
                        await fetchIngredients(
                          txtController.text,
                          ingredientComp,
                        );
                        setState(() {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AddIngredient(
                                  model: widget.model, options: ingredientComp);
                            },
                          );
                        });
                      } else {}
                    },
                    child: Icon(Icons.search, color: Colors.black),
                  ),
                ],
              ),
            SizedBox(
              height: 20,
            ),
            // if (widget.model.instructions.isEmpty)
            if (instructions.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Additional Instructions',
                    style: TextStyle(
                      color: Color(0xff909090),
                      fontWeight: FontWeight.w700,
                      fontFamily: "Quicksand",
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      for (String s in instructions)
                        StepEntry(text: s, edit: widget.editView),
                      if (widget.editView)
                        IconButton(
                          icon: const Icon(Icons.add),
                          tooltip: 'add instruction',
                          onPressed: () {
                            setState(() {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AddInstruction(model: widget.model);
                                  });
                            });
                          },
                        ),
                    ],
                  )
                ],
              ),
            SizedBox(
              height: 20,
            ),
            if (widget.editView)
              TextButton.icon(
                // style: ButtonStyle(
                //     textStyle: TextStyle(
                //   color: Colors.black,
                // )),
                onPressed: () {
                  // Respond to button press
                },
                icon: Icon(Icons.save, size: 30),
                label: Text("SUBMIT"),
              ),
          ],
        ),
      ),
    );
  }

  Future<List<Animal>> fetchIngredients(
      String query, List<Animal> ingredientComp) async {
    String applicationId = "2051cf6b",
        applicationKey = "23b5c49d42ef07d39fb68e1b6e04bf42";
    String queryUrl =
        "https://api.edamam.com/auto-complete?app_id=1e2b1681&app_key=47e224016bc268ada433484688f019cf&q=$query";
    // 'https://api.edamam.com/search?q=$query&app_id=$applicationId&app_key=$applicationKey';
    final response = await http.get(Uri.parse(queryUrl));

    if (response.statusCode == 200) {
      // recipes.clear();
      List<String> jsonData = jsonDecode(response.body).cast<String>();
      int i = 0;
      jsonData.forEach(
        (ingredient) {
          ingredientComp.add(Animal(
            id: ++i,
            name: ingredient,
          ));
        },
      );

      return ingredientComp;
    } else {
      throw Exception(
          'Failed to load ingredients. response statusCode = ${response.statusCode}');
    }
  }
}

class Animal {
  final int id;
  final String name;

  Animal({
    required this.id,
    required this.name,
  });

  @override
  String toString() {
    String data = '''
    id: $id,
    name: $name,
    ''';
    return '{\n$data}';
  }
}

class AddIngredient extends StatefulWidget {
  AddIngredient({Key? key, required this.model, required this.options})
      : super(key: key);
  final RecipeModel model;
  List<Animal> options;

  @override
  State<AddIngredient> createState() => _AddIngredientState();
}

class _AddIngredientState extends State<AddIngredient> {
  TextEditingController txtController = TextEditingController();
  bool autoComplete = true;
  List<Animal> selected = [];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('Add Ingredient'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: <Widget>[
              // MultiSelectDialogField(
              // items: _animals
              //     .map((animal) =>
              //         MultiSelectItem<Animal>(animal, animal.name))
              //     .toList(),
              //   onConfirm: (values) {
              //     print(values.toString());
              //   },
              //   // items: _animals.map((e) => MultiSelectItem(e, e.name)).toList(),
              //   // listType: MultiSelectListType.CHIP,
              //   // onConfirm: (values) {
              //   //   _selectedAnimals = values;
              //   // },
              // ),
              MultiSelectBottomSheetField(
                initialChildSize: 0.4,
                listType: MultiSelectListType.CHIP,
                searchable: true,
                buttonText: Text("Choose ingredient"),
                title: Text("Ingredients"),
                items: widget.options
                    .map((ingredient) =>
                        MultiSelectItem<Animal>(ingredient, ingredient.name))
                    .toList(),
                onConfirm: (values) {
                  print('save to DB the values ${values.toString()}');
                  selected.addAll(values as List<Animal>);
                },
                chipDisplay: MultiSelectChipDisplay(
                  onTap: (value) {
                    setState(() {
                      selected.remove(value);
                    });
                  },
                ),
              ),
              (selected == null || selected.isEmpty)
                  ? Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "None selected",
                        style: TextStyle(color: Colors.black54),
                      ))
                  : Container(),
            ],
          ),
        ),
      ),
      actions: [
        RaisedButton(
            child: Text("Add"),
            onPressed: () {
              List<String> ingredientNames = [];
              for (Animal element in selected) {
                ingredientNames.add(element.name);
              }
              widget.model.addSubs(ingredientNames);
              Navigator.pop(context);
            })
      ],
    );
  }
}

class AddInstruction extends StatelessWidget {
  AddInstruction({Key? key, required this.model}) : super(key: key);
  RecipeModel model;

  TextEditingController txtController = TextEditingController();
  // final String name;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('Add Instruction'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: txtController,
                decoration: InputDecoration(
                  labelText: 'Instruction',
                  icon: Icon(Icons.account_box),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        RaisedButton(
            child: Text("Add"),
            onPressed: () {
              if (txtController.text.isNotEmpty)
                model.instructions.add(txtController.text);
              // push to fire base
            })
      ],
    );
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class StepEntry extends StatefulWidget {
  final String text;
  final bool initialStep;
  final bool edit;
  const StepEntry(
      {required this.text, this.initialStep: false, required this.edit});

  @override
  State<StepEntry> createState() => _StepEntryState();
}

class _StepEntryState extends State<StepEntry> {
  bool removed = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 25,
        left: 10.0,
        top: 0.0,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Expanded(
              //   flex: 1,
              //   child: Container(
              //     width: 5.0,
              //     height: initialStep ? 0 : 40,
              //     decoration: BoxDecoration(
              //       color: HexColor('#F9AF9C'),
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //   ),
              // ),
              Expanded(
                flex: 69,
                child: SizedBox(
                  height: 10.0,
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              widget.edit
                  ? IconButton(
                      icon: removed
                          ? const Icon(Icons.add)
                          : const Icon(Icons.cancel),
                      tooltip: 'delete instruction',
                      onPressed: () {
                        setState(() {
                          removed = !removed;
                        });
                      },
                    )
                  : Container(
                      height: 5.0,
                      width: 5.0,
                      decoration: BoxDecoration(
                        color: HexColor('##785ac7'),
                        shape: BoxShape.rectangle,
                      ),
                    ),
              SizedBox(
                width: 20.0,
              ),
              Flexible(
                child: Text(
                  widget.text,
                  style: removed ? deletedStyle : kIngredientsNameStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
