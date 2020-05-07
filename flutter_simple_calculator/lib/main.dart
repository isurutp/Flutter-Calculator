import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttersimplecalculator/history.dart';

void main(){
  runApp(Calculator());
}

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      home: MySplash(),
    );
  }
}

class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 7,
      backgroundColor: Colors.black,
      image: Image.asset('assets/splash10.gif'),
      loaderColor: Colors.white,
      photoSize: 250,
      navigateAfterSeconds: SimpleCalculator("0"),
    );
  }
}

class SimpleCalculator extends StatefulWidget {
  final String setEquation ;
  @override
  _SimpleCalculatorState createState() => _SimpleCalculatorState(this.setEquation);
  SimpleCalculator(this.setEquation);
}

class _SimpleCalculatorState extends State<SimpleCalculator> {

  String equation = "0";
  String result = "0";
  String expression = "";
  double equationFontSize = 40.0;
  double resultFontSize = 50.0;

  _SimpleCalculatorState(this.equation);

  createHistory(){
    DocumentReference documentReference = Firestore.instance.collection("MyHistory").document(equation);

    Map<String, String> history = {
      "historyTitle": equation,
      "historyResult": result
    };

    documentReference.setData(history).whenComplete((){
      print("$equation = $result Created");
    });
  }

  buttonPressed(String buttonText){
    setState(() {
      if(buttonText == "C"){
        equation = "0";
        result = "0";
        equationFontSize = 40.0;
        resultFontSize = 50.0;
      }

      else if(buttonText == "◷"){
        print("Open History");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HistoryList()
            ));
      }

      else if(buttonText == "⌫"){
        equationFontSize = 50.0;
        resultFontSize = 40.0;
        //will get all the characters except the last one
        //if it becomes null, then change the value to 0
        equation = equation.substring(0, equation.length - 1);
        if(equation == ""){
          equation = "0";
        }
      }

      else if(buttonText == "="){
        equationFontSize = 40.0;
        resultFontSize = 50.0;

        //assign equation value to "expression" in order to prepare the equation for calculation
        expression = equation;
        //replace multiplication sign and division sign with * and /
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');

        //do the calculation using math expression solver package
        //if the equation is not correct show 'error' message
        try{
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
          if (equation != "0") {
            createHistory();
          }
        }catch(e){
          result = "error";
        }
      }

      else{
        equationFontSize = 50.0;
        resultFontSize = 40.0;
        if(equation == "0"){
          equation = buttonText;
        }else {
          equation = equation + buttonText;
        }
      }
    });
  }

  Widget actionButton(String buttonText, double buttonHeight, Color buttonColor, Color borderColor){
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
      child: FlatButton(
          color: buttonColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80.0),
              side: BorderSide(
                  color: borderColor,
                  width: 1.0,
                  style: BorderStyle.solid
              )
          ),
          padding: EdgeInsets.all(16.0),
          onPressed: () => buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.normal,
                color: Colors.white
            ),
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[

          SizedBox(
            height: 110,
          ),

          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Text(equation, style: TextStyle(fontSize: equationFontSize, color: Colors.white),),
          ),

          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
            child: Text(result, style: TextStyle(fontSize: resultFontSize, color: Colors.white),),
          ),

          Expanded(
            child: Divider(),
          ),

          Container(
            width: MediaQuery.of(context).size.width * 1.0,
            child: Table(
              children: [
                TableRow(
                    children: [
                      actionButton("◷", 1, Colors.grey[700], Colors.grey[900]),
                      actionButton("C", 1, Colors.grey[700], Colors.grey[900]),
                      actionButton("⌫", 1, Colors.grey[700] , Colors.grey[900]),
                      actionButton("÷", 1, Colors.orange[700], Colors.grey[900]),
                    ]
                ),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * .75, //75% of the screen size
                child: Table(
                  children: [

                    TableRow(
                        children: [
                          actionButton("7", 1, Colors.black38, Colors.grey[700]),
                          actionButton("8", 1, Colors.black38, Colors.grey[700]),
                          actionButton("9", 1, Colors.black38, Colors.grey[700]),
                        ]
                    ),

                    TableRow(
                        children: [
                          actionButton("4", 1, Colors.black38, Colors.grey[700]),
                          actionButton("5", 1, Colors.black38, Colors.grey[700]),
                          actionButton("6", 1, Colors.black38, Colors.grey[700]),
                        ]
                    ),

                    TableRow(
                        children: [
                          actionButton("1", 1, Colors.black38, Colors.grey[700]),
                          actionButton("2", 1, Colors.black38, Colors.grey[700]),
                          actionButton("3", 1, Colors.black38, Colors.grey[700]),
                        ]
                    ),

                    TableRow(
                        children: [
                          actionButton(".", 1, Colors.black38, Colors.grey[700]),
                          actionButton("0", 1, Colors.black38, Colors.grey[700]),
                          actionButton("00", 1, Colors.black38, Colors.grey[700]),
                        ]
                    ),
                  ],
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width * 0.25,
                child: Table(
                  children: [
                    TableRow(
                        children: [
                          actionButton("×", 1, Colors.orange[700], Colors.grey[900]),
                        ]
                    ),

                    TableRow(
                        children: [
                          actionButton("-", 1, Colors.orange[700], Colors.grey[900]),
                        ]
                    ),

                    TableRow(
                        children: [
                          actionButton("+", 1, Colors.orange[700], Colors.grey[900]),
                        ]
                    ),

                    TableRow(
                        children: [
                          actionButton("=", 1, Colors.cyan[900], Colors.grey[900]),
                        ]
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
