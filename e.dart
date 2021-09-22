import 'package:flutter/material.dart';

class Employee{
  int id;
  String name;
  String location;
  Employee({required this.name,required this.location,required this.id});
  Map<String ,dynamic> toMap(){
    return {
      'name':name,'Location':location
    };
  }

}