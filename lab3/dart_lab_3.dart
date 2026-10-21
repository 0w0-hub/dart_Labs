import 'dart:async';
import 'dart:convert';
import 'dart:io';

class Vehicle{
  String brand;
  int year;
  Vehicle(this.brand,this.year);
  void startEngine() => print("Khởi động phương tiện...");
}

class Car extends Vehicle{
  bool isElectric = false;
  Car(this.isElectric,super.brand,super.year);
  
  Car.tesla(int year) : super("Tesla",year){
    isElectric = true;
  }

  @override
  void startEngine(){
    if(isElectric)
      print("Khởi động Electirc Car...");
    else 
      print("Khởi động non-Electirc Car...");
  }
}

void main(){
  Car xe = new Car(false,"Toyota",2021);
  xe.startEngine();

  Car tesla = new Car.tesla(2022);
  tesla.startEngine();
}