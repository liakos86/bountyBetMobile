
  import 'dart:io';
import 'dart:isolate';

void main() async{
    print(Isolate.current.debugName! + " start main");

    fetchStringFuture();//.then((value) => print("future end"));

    print(Isolate.current.debugName! +  " end main");
  }

  void fetchStringFuture() async{
    Future.delayed(Duration(seconds:3), ()=>{print(Isolate.current.debugName! + " hello from future")});

    //return "s";
  }

