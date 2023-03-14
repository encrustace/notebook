import 'package:flutter/material.dart';
import 'package:notebook/utils/constants.dart' as constants;
import 'package:notebook/view/lenden.dart';
import 'package:notebook/utils/connection.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Connections _connections = Connections();
  var _selectedIndex = 2;
  final _widgetsList = [Container(), Container(), const Lenden()];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    //_connections.deleteDatabase("notebook");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetsList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.notes),
            label: 'Notes'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Arts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: 'Len Den',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: constants.selectedColor,
        onTap: (index){
          _onItemTapped(index);
        },),
    );
  }
}