import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/space_model.dart';

class PlanetProvider extends ChangeNotifier {
  List<Planet> planetList = [];
  List<Planet> favouriteList = [];
  List likedList = [];
  int currentIndex=0;
  int select=0;

  Future<List> jsonParsing() async {
    String json = await rootBundle.loadString('assets/json/data.json');//assets
    List data = jsonDecode(json);
    return data;
  }

  Future<void> fromList() async {
    List data = await jsonParsing();
    planetList = data.map((e) => Planet.fromJson(e),).toList();
    notifyListeners();
  }

  void changeScreen(int num)
  {
    currentIndex=num;
    notifyListeners();
  }
  Future<void> removeLiked(int index,String name)
  async {
    favouriteList.removeAt(index);
    for(int i=0;i<likedList.length;i++)
    {
      if(likedList[i]==name)
      {
        likedList.removeAt(i);
      }
    }
    for(int i=0;i<planetList.length;i++)
    {
      if(planetList[i].name==favouriteList[index].name)
      {
        planetList[i].like=false;
      }
    }

    String data="";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for(int i=0;i<likedList.length;i++)
    {
      data=data+'-'+likedList[i];
    }
    prefs.setString('items', data);
    notifyListeners();
  }
  Future<void> likedImage(int index)
  async {
    planetList[index].like=!planetList[index].like;
    if(planetList[index].like==true)
    {
      String? data;
      String name;
      favouriteList.add(planetList[index]);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      data= prefs.getString('items');
      if(data==null)
      {
        name=planetList[index].name;
      }else
      {
        name=data+'-'+planetList[index].name;
      }
      await prefs.setString('items', name);
      data= prefs.getString('items');
      print('============================$data============');
      print('==========${favouriteList.length}');
    }else
    {
      for(int i=0;i<favouriteList.length;i++)
      {
        if(favouriteList[i].name==planetList[index].name)
        {
          favouriteList.removeAt(i);
        }
      }
      for(int i=0;i<likedList.length;i++)
      {
        if(likedList[i]==planetList[index].name)
        {
          likedList.removeAt(i);
        }
      }
      String name="";
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      for(int i=0;i<likedList.length;i++)
      {
        name=name+'-'+likedList[i];
      }
      prefs.setString('items', name);
    }
    notifyListeners();
  }

  Future<void> loadImage()
  async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data= prefs.getString('items')??"";
    print('============================$data============');
    likedList = data!.split("-");
    print(likedList);
    for(int i=0;i<likedList.length;i++)
    {
      for(int j=0;j<planetList.length;j++)
      {
        if(likedList[i]==planetList[j].name)
        {
          planetList[j].like=true;
          favouriteList.add(planetList[j]);
        }
      }
    }

  }
  PlanetProvider() {
    fromList();
    loadImage();
  }
}