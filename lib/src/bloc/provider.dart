import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/login_bloc.dart';



class Provider extends InheritedWidget{
  static Provider _instancia;

  // Crear factory
  factory Provider({Key key,Widget child}){
    if(_instancia == null){
      _instancia = new Provider._internal(key: key,child: child);
    }
    return _instancia;
  }

  //Constructor privado
  Provider._internal({Key key, Widget child})
  : super(key: key,child: child);

  // Aqui se pierde la informacion cuando se restaura la aplicacion
  final loginBloc = LoginBloc();
  
  /*Provider({Key key, Widget child})
  : super(key: key,child: child);*/

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of (BuildContext context){
    return (context.inheritFromWidgetOfExactType(Provider) as Provider).loginBloc;
  }

}