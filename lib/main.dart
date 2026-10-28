import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: HoraExtraApp(), debugShowCheckedModeBanner: false));

class HoraExtraApp extends StatefulWidget {
  @override _HoraExtraAppState createState() => _HoraExtraAppState();
}

class _HoraExtraAppState extends State<HoraExtraApp> {
  TextEditingController salarioCtrl = TextEditingController();
  TextEditingController horasCtrl = TextEditingController();
  String porcentagemSel = '50%';
  List<String> porcentagens = ['50%', '70%', '100%'];

  double calcHora(double salario, double horas, double perc) {
    if (salario <= 0 || horas <= 0) return 0;
    double valorHora = salario / 220; // padrão CLT
    double valorExtra = valorHora * (1 + perc / 100);
    return valorExtra * horas;
  }

  @override
  Widget build(BuildContext context) {
    double salario = double.tryParse(salarioCtrl.text.replaceAll(',', '.')) ?? 0;
    double horas = double.tryParse(horasCtrl.text.replaceAll(',', '.')) ?? 0;
    
    double percSelNum = double.tryParse(porcentagemSel.replaceAll('%', '')) ?? 50;
    double valorSelecionado = calcHora(salario, horas, percSelNum);
    
    double valor50 = calcHora(salario, horas, 50);
    double valor70 = calcHora(salario, horas, 70);
    double valor100 = calcHora(salario, horas, 100);

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(title: Text('Hora Extra', style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true, backgroundColor: Color(0xFF0F172A), foregroundColor: Colors.white),
      body: SingleChildScrollView(padding: EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Card(elevation: 0, color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), child: Padding(padding: EdgeInsets.all(20), child: Column(children: [
          TextField(controller: salarioCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Salário (R\$)', prefixIcon: Icon(Icons.attach_money), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), onChanged: (_) => setState((){})),
          SizedBox(height: 15),
          TextField(controller: horasCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Qtd. de Horas Extras', prefixIcon: Icon(Icons.access_time), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), onChanged: (_) => setState((){})),
          SizedBox(height: 15),
          DropdownButtonFormField(value: porcentagemSel, items: porcentagens.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(), onChanged: (v) => setState(() => porcentagemSel = v!), decoration: InputDecoration(labelText: 'Porcentagem', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), borderRadius: BorderRadius.circular(12)),
        ]))),
        
        SizedBox(height: 20),
        
        Container(padding: EdgeInsets.all(20), decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E293B)]), borderRadius: BorderRadius.circular(20)),
          child: Column(children: [
            Text('VALOR DA EXTRA $porcentagemSel', style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1)),
            SizedBox(height: 5),
            Text('R\$ ${valorSelecionado.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900)),
            Text('${horas.toStringAsFixed(1)}h x R\$ ${(salario/220*(1+percSelNum/100)).toStringAsFixed(2)} /hora', style: TextStyle(color: Colors.white54, fontSize: 12)),
          ])),

        SizedBox(height: 20),
        Text('Comparativo automático', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
        SizedBox(height: 10),

        Row(children: [
          resultCard('50%', valor50, Colors.green, salario, horas),
          SizedBox(width: 10),
          resultCard('70%', valor70, Colors.orange, salario, horas),
          SizedBox(width: 10),
          resultCard('100%', valor100, Colors.red, salario, horas),
        ]),
        
        SizedBox(height: 20),
        Text('Cálculo: Salário / 220h = valor hora base. Ex: 50% = hora x 1,5', style: TextStyle(fontSize: 11, color: Colors.black38), textAlign: TextAlign.center),
      ])),
    );
  }

  Widget resultCard(String perc, double valor, Color cor, double salario, double horas) {
    return Expanded(child: Container(padding: EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: cor.withOpacity(0.3))),
      child: Column(children: [
        Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: cor, borderRadius: BorderRadius.circular(20)), child: Text(perc, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
        SizedBox(height: 10),
        Text('R\$', style: TextStyle(fontSize: 12, color: Colors.black45)),
        Text(valor.toStringAsFixed(2), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
        Divider(),
        Text('${horas}h', style: TextStyle(fontSize: 11, color: Colors.black45)),
      ])));
  }
}
