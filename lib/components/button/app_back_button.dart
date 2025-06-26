import 'package:flutter/material.dart';

AppBackButton(context ,{VoidCallback? onPress}){
    return IconButton(
        onPressed: () {
          onPress ?? Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back_ios));
  }
