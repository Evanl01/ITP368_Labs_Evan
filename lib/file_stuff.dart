import "dart:io";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:path_provider/path_provider.dart";


void main() // FS
{ runApp( FileStuff () );
}

class FileStuff extends StatelessWidget
{
  FileStuff({super.key});

  Widget build( BuildContext context )
  { return MaterialApp
    ( title: "file stuff - barrett",
      home: FileStuffHome(),
    );
  }
}

class FileStuffHome extends StatelessWidget
{
   FileStuffHome({super.key});

   String contents = "Default content";

  @override
  Widget build( BuildContext context ) 
  { 
    Future<String> mainDirPath = whereAmI();
    print(mainDirPath);
    // String contents = readFile();
    // writeFile();
    return Scaffold
    ( appBar: AppBar( title: Text("file stuff - barrett") ),
      body: Text(contents),
    );
  }

  Future<String> whereAmI() async
  {
    Directory mainDir = await getApplicationDocumentsDirectory();
    String mainDirPath = mainDir.path;
    print("mainDirPath is $mainDirPath");
    return mainDirPath;
  }
  
  // String readFile()
  // {
  //   String myStuff = "C:\\Users\\Barry-Standard\\Documents\\courses\\USC\\ITP-368\\workFlutter";
  //   String filePath = "$myStuff/things.txt";
  //   File fodder = File(filePath);
  //   String contents = fodder.readAsStringSync();
  //   print(contents);
  //   return contents;
  // }
  //
  // void writeFile()
  // { String myStuff = "C:\\Users\\Barry-Standard\\Documents\\courses\\USC\\ITP-368\\workFlutter";
  //   String filePath = "$myStuff/otherStuff.txt";
  //   File fodder = File(filePath);
  //   fodder.writeAsStringSync("put this in the file");
  // }
}