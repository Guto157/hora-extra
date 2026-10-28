import 'package:flutter/material.dart';
void main() => runApp(MaterialApp(home: HoraExtraApp(), debugShowCheckedModeBanner: false));
class HoraExtraApp extends StatefulWidget { @override _HoraExtraAppState createState() => _HoraExtraAppState(); }
class _HoraExtraAppState extends State<HoraExtraApp> {
  TextEditingController salarioCtrl = TextEditingController();
  TextEditingController horasCtrl = TextEditingController();
  double calc(double sal, double h, double perc) {
    if (sal<=0||h<=0) return 0;
    return (sal/220)*(1+perc/100)*h;
  }
  @override Widget build(BuildContext context) {
    double sal = double.tryParse(salarioCtrl.text.replaceAll(',', '.')) ?? 0;
    double h = double.tryParse(horasCtrl.text.replaceAll(',', '.')) ?? 0;
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(title: Text('Calculadora de Hora Extra', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), centerTitle: true, backgroundColor: Color(0xFF0F172A), foregroundColor: Colors.white),
      body: SingleChildScrollView(padding: EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Card(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), child: Padding(padding: EdgeInsets.all(20), child: Column(children: [
          TextField(controller: salarioCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Salário (R\$)', hintText: 'Ex: 2500', prefixIcon: Icon(Icons.attach_money), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), onChanged: (_)=>setState((){})),
          SizedBox(height: 15),
          TextField(controller: horasCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Qtd. Horas Extras', hintText: 'Ex: 10', prefixIcon: Icon(Icons.access_time), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), onChanged: (_)=>setState((){})),
        ]))),
        SizedBox(height: 20),
        resultCard('50%', calc(sal,h,50), Colors.green, 'Hora + 50%'),
        SizedBox(height: 10),
        resultCard('70%', calc(sal,h,70), Colors.orange, 'Hora + 70%'),
        SizedBox(height: 10),
        resultCard('100%', calc(sal,h,100), Colors.redAccent, 'Hora + 100%'),
      ])),
    );
  }
  Widget resultCard(String p, double v, Color c, String d) => Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]), child: Row(children: [Container(width:60,height:60,decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(12)), child: Center(child: Text(p, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)))), SizedBox(width:15), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(d, style: TextStyle(fontSize: 12, color: Colors.black54)), Text('R\$ ${v.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900))])), Icon(Icons.check_circle, color: v>0?c:Colors.black12)]));
}
