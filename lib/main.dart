import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: HoraExtraApp(), debugShowCheckedModeBanner: false));

class HoraExtraApp extends StatefulWidget {
  @override _HoraExtraAppState createState() => _HoraExtraAppState();
}

class _HoraExtraAppState extends State<HoraExtraApp> {
  TextEditingController salarioCtrl = TextEditingController(text: '');
  TextEditingController horasCtrl = TextEditingController(text: '');

  double calcHora(double salario, double horas, double perc) {
    if (salario <= 0 || horas <= 0) return 0;
    double valorHora = salario / 220;
    return valorHora * (1 + perc / 100) * horas;
  }

  @override
  Widget build(BuildContext context) {
    double salario = double.tryParse(salarioCtrl.text.replaceAll(',', '.')) ?? 0;
    double horas = double.tryParse(horasCtrl.text.replaceAll(',', '.')) ?? 0;
    
    double v50 = calcHora(salario, horas, 50);
    double v70 = calcHora(salario, horas, 70);
    double v100 = calcHora(salario, horas, 100);

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(title: Text('Calculadora de Hora Extra', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), centerTitle: true, backgroundColor: Color(0xFF0F172A), foregroundColor: Colors.white),
      body: SingleChildScrollView(padding: EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Card(elevation: 0, color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), child: Padding(padding: EdgeInsets.all(20), child: Column(children: [
          TextField(controller: salarioCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Salário (R\$)', hintText: 'Ex: 2500', prefixIcon: Icon(Icons.attach_money), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), onChanged: (_) => setState((){})),
          SizedBox(height: 15),
          TextField(controller: horasCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Qtd. de Horas Extras', hintText: 'Ex: 10', prefixIcon: Icon(Icons.access_time), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), onChanged: (_) => setState((){})),
        ]))),
        
        SizedBox(height: 20),
        
        Text('RESULTADOS', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.black54, fontSize: 12)),
        SizedBox(height: 10),

        resultCard('50%', v50, Colors.green, 'Hora + 50%'),
        SizedBox(height: 10),
        resultCard('70%', v70, Colors.orange, 'Hora + 70%'),
        SizedBox(height: 10),
        resultCard('100%', v100, Colors.redAccent, 'Hora + 100%'),
        
        SizedBox(height: 25),
        Container(padding: EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black12)), child: Column(children: [
          Text('Como calcula?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          SizedBox(height: 5),
          Text('Salário ÷ 220 = valor da hora base. Depois soma a % e multiplica pelas horas.', style: TextStyle(fontSize: 11, color: Colors.black54), textAlign: TextAlign.center),
          if (salario > 0) Padding(padding: EdgeInsets.only(top: 8), child: Text('Sua hora base: R\$ ${(salario/220).toStringAsFixed(2)}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)))),
        ])),
      ])),
    );
  }

  Widget resultCard(String perc, double
