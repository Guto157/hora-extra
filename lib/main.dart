import 'package:flutter/material.dart';
void main() => runApp(MaterialApp(home: AppPrincipal(), debugShowCheckedModeBanner: false));
class AppPrincipal extends StatefulWidget { @override _AppPrincipalState createState() => _AppPrincipalState(); }
class _AppPrincipalState extends State<AppPrincipal> {
  int aba = 0;
  @override Widget build(BuildContext context) {
    return Scaffold(
      body: [TelaHoraExtra(), TelaVoltaFerias(), TelaRescisao()][aba],
      bottomNavigationBar: BottomNavigationBar(currentIndex: aba, onTap: (i)=>setState(()=>aba=i), selectedItemColor: Color(0xFF0F172A), items: [
        BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Hora Extra'),
        BottomNavigationBarItem(icon: Icon(Icons.beach_access), label: 'Volta Férias'),
        BottomNavigationBarItem(icon: Icon(Icons.exit_to_app), label: 'Rescisão'),
      ]),
    );
  }
}
class TelaHoraExtra extends StatefulWidget { @override _TelaHoraExtraState createState() => _TelaHoraExtraState(); }
class _TelaHoraExtraState extends State<TelaHoraExtra> {
  TextEditingController sCtrl = TextEditingController(); TextEditingController hCtrl = TextEditingController();
  double calc(double sal, double h, double p) => (sal<=0||h<=0)?0:(sal/220)*(1+p/100)*h;
  @override Widget build(BuildContext context) {
    double sal = double.tryParse(sCtrl.text.replaceAll(',', '.')) ?? 0; double h = double.tryParse(hCtrl.text.replaceAll(',', '.')) ?? 0;
    return Scaffold(backgroundColor: Color(0xFFF8FAFC), appBar: AppBar(title: Text('Hora Extra', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Color(0xFF0F172A), foregroundColor: Colors.white),
      body: SingleChildScrollView(padding: EdgeInsets.all(16), child: Column(children: [
        Card(child: Padding(padding: EdgeInsets.all(16), child: Column(children: [
          TextField(controller: sCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Salário R\$', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), onChanged: (_)=>setState((){})),
          SizedBox(height: 10),
          TextField(controller: hCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Qtd Horas', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), onChanged: (_)=>setState((){})),
        ]))),
        SizedBox(height: 15),
        resCard('50%', calc(sal,h,50), Colors.green), SizedBox(height: 8), resCard('70%', calc(sal,h,70), Colors.orange), SizedBox(height: 8), resCard('100%', calc(sal,h,100), Colors.red),
      ])),
    );
  }
  Widget resCard(String p, double v, Color c) =>
