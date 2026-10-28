import 'package:flutter/material.dart';
void main() => runApp(MaterialApp(home: AppPrincipal(), debugShowCheckedModeBanner: false));

class AppPrincipal extends StatefulWidget { @override _AppPrincipalState createState() => _AppPrincipalState(); }
class _AppPrincipalState extends State<AppPrincipal> {
  int aba = 0;
  @override Widget build(BuildContext context) {
    return Scaffold(
      body: [TelaHoraExtra(), TelaVoltaFerias(), TelaRescisao()][aba],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: aba,
        onTap: (i)=>setState(()=>aba=i),
        selectedItemColor: Color(0xFF0F172A),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Hora Extra'),
          BottomNavigationBarItem(icon: Icon(Icons.beach_access), label: 'Volta Férias'),
          BottomNavigationBarItem(icon: Icon(Icons.exit_to_app), label: 'Rescisão'),
        ],
      ),
    );
  }
}

// ABA 1 - HORA EXTRA (sem lista)
class TelaHoraExtra extends StatefulWidget { @override _TelaHoraExtraState createState() => _TelaHoraExtraState(); }
class _TelaHoraExtraState extends State<TelaHoraExtra> {
  TextEditingController sCtrl = TextEditingController();
  TextEditingController hCtrl = TextEditingController();
  double calc(double sal, double h, double p) => (sal<=0||h<=0)?0:(sal/220)*(1+p/100)*h;
  @override Widget build(BuildContext context) {
    double sal = double.tryParse(sCtrl.text.replaceAll(',', '.')) ?? 0;
    double h = double.tryParse(hCtrl.text.replaceAll(',', '.')) ?? 0;
    return Scaffold(backgroundColor: Color(0xFFF8FAFC), appBar: AppBar(title: Text('Hora Extra', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Color(0xFF0F172A), foregroundColor: Colors.white),
      body: SingleChildScrollView(padding: EdgeInsets.all(16), child: Column(children: [
        Card(child: Padding(padding: EdgeInsets.all(16), child: Column(children: [
          TextField(controller: sCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Salário R\$', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), onChanged: (_)=>setState((){})),
          SizedBox(height: 10),
          TextField(controller: hCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Qtd Horas', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), onChanged: (_)=>setState((){})),
        ]))),
        SizedBox(height: 15),
        resCard('50%', calc(sal,h,50), Colors.green),
        SizedBox(height: 8), resCard('70%', calc(sal,h,70), Colors.orange),
        SizedBox(height: 8), resCard('100%', calc(sal,h,100), Colors.red),
      ])),
    );
  }
  Widget resCard(String p, double v, Color c) => Container(padding: EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Row(children: [Container(width:55,height:55,decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(10)), child: Center(child: Text(p, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)))), SizedBox(width: 12), Text('R\$ ${v.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))]));
}

// ABA 2 - VOLTA DE FERIAS
class TelaVoltaFerias extends StatefulWidget { @override _TelaVoltaFeriasState createState() => _TelaVoltaFeriasState(); }
class _TelaVoltaFeriasState extends State<TelaVoltaFerias> {
  TextEditingController salCtrl = TextEditingController();
  TextEditingController diaVoltaCtrl = TextEditingController(text: '28');
  TextEditingController diasMesCtrl = TextEditingController(text: '30');
  TextEditingController adiantCtrl = TextEditingController();
  bool teveAdiant = false;
  bool soPagamento = true; // true = so pagamento 5o dia util, false = teve adiantamento
  @override Widget build(BuildContext context) {
    double sal = double.tryParse(salCtrl.text.replaceAll(',', '.')) ?? 0;
    int diaVolta = int.tryParse(diaVoltaCtrl.text) ?? 28;
    int diasMes = int.tryParse(diasMesCtrl.text) ?? 30;
    double adiant = double.tryParse(adiantCtrl.text.replaceAll(',', '.')) ?? 0;
    if (teveAdiant && adiant==0 && sal>0) adiant = sal * 0.4;

    int diasTrab = (diasMes - diaVolta + 1).clamp(0, 31);
    double salarioProp = (sal / 30) * diasTrab;
    double aReceber = soPagamento ? salarioProp : (salarioProp - adiant).clamp(0, double.infinity);

    return Scaffold(backgroundColor: Color(0xFFF8FAFC), appBar: AppBar(title: Text('Volta de Férias', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Color(0xFF0F172A), foregroundColor: Colors.white),
      body: SingleChildScrollView(padding: EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Card(child: Padding(padding: EdgeInsets.all(16), child: Column(children: [
          TextField(controller: salCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Salário R\$', border: OutlineInputBorder()), onChanged: (_)=>setState((){})),
          SizedBox(height: 10),
          Row(children: [
            Expanded(child: TextField(controller: diaVoltaCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Voltei dia', border: OutlineInputBorder()), onChanged: (_)=>setState((){}))),
            SizedBox(width: 10),
            Expanded(child: TextField(controller: diasMesCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Dias no mês', hintText: '30 ou 31', border: OutlineInputBorder()), onChanged: (_)=>setState((){}))),
          ]),
          SizedBox(height: 10),
          SwitchListTile(title: Text('Teve adiantamento?'), value: teveAdiant, onChanged: (v)=>setState(()=>teveAdiant=v)),
          if(teveAdiant) TextField(controller: adiantCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Valor adiantamento (deixe vazio p/ 40%)', border: OutlineInputBorder()), onChanged: (_)=>setState((){})),
          SizedBox(height: 10),
          SegmentedButton<bool>(segments: [ButtonSegment(value: true, label: Text('Só pagamento')), ButtonSegment(value: false, label: Text('Com adiantamento'))], selected: {soPagamento}, onSelectionChanged: (s)=>setState(()=>soPagamento=s.first)),
        ]))),
        SizedBox(height: 15),
        Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xFF0F172A), borderRadius: BorderRadius.circular(15)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Resultado - Pagamento 5º dia útil', style: TextStyle(color: Colors.white70)),
          SizedBox(height: 8),
          Text('Dias trabalhados: $diasTrab dias ($diaVolta a $diasMes)', style: TextStyle(color: Colors.white)),
          SizedBox(height: 4),
          Text('Salário proporcional: R\$ ${salarioProp.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(color: Colors.white, fontSize: 16)),
          if(teveAdiant) Text('Adiantamento: - R\$ ${adiant.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(color: Colors.orangeAccent)),
          Divider(color: Colors.white24),
          Text('VAI RECEBER: R\$ ${aReceber.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(color: Color(0xFF22D3EE), fontSize: 22, fontWeight: FontWeight.w900)),
        ])),
      ])),
    );
  }
}

// ABA 3 - RESCISAO
class TelaRescisao extends StatefulWidget { @override _TelaRescisaoState createState() => _TelaRescisaoState(); }
class _TelaRescisaoState extends State<TelaRescisao> {
  TextEditingController salCtrl = TextEditingController();
  TextEditingController diasCtrl = TextEditingController(text: '15');
  TextEditingController meses13Ctrl = TextEditingController(text: '8');
  TextEditingController mesesFeriasCtrl = TextEditingController(text: '6');
  TextEditingController fgtsCtrl = TextEditingController(text: '5000');
  bool temFeriasVencidas = false;
  String motivo = 'Sem justa causa';
  @override Widget build(BuildContext context) {
    double sal = double.tryParse(salCtrl.text.replaceAll(',', '.')) ?? 0;
    int dias = int.tryParse(diasCtrl.text) ?? 0;
    int m13 = int.tryParse(meses13Ctrl.text) ?? 0;
    int mFer = int.tryParse(mesesFeriasCtrl.text) ?? 0;
    double fgtsSaldo = double.tryParse(fgtsCtrl.text.replaceAll(',', '.')) ?? 0;

    double saldoSal = (sal/30)*dias;
    double decimoTerceiro = (sal/12)*m13;
    double feriasProp = (sal/12)*mFer;
    double tercoFeriasProp = feriasProp/3;
    double feriasVenc = temFeriasVencidas ? sal : 0;
    double tercoVenc = temFeriasVencidas ? sal/3 : 0;
    double fgtsMes = sal*0.08;
    double multa = (fgtsSaldo + fgtsMes) * 0.4;
    double total = saldoSal + decimoTerceiro + feriasProp + tercoFeriasProp + feriasVenc + tercoVenc + multa;

    return Scaffold(backgroundColor: Color(0xFFF8FAFC), appBar: AppBar(title: Text('Rescisão', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Color(0xFF0F172A), foregroundColor: Colors.white),
      body: SingleChildScrollView(padding: EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Card(child: Padding(padding: EdgeInsets.all(16), child: Column(children: [
          TextField(controller: salCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Salário R\$', border: OutlineInputBorder()), onChanged: (_)=>setState((){})),
          SizedBox(height: 8),
          TextField(controller: diasCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Saldo dias trabalhados no mês', border: OutlineInputBorder()), onChanged: (_)=>setState((){})),
          SizedBox(height: 8),
          Row(children: [
            Expanded(child: TextField(controller: meses13Ctrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Meses 13º', border: OutlineInputBorder()), onChanged: (_)=>setState((){}))),
            SizedBox(width: 8),
            Expanded(child: TextField(controller: mesesFeriasCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Meses férias prop.', border: OutlineInputBorder()), onChanged: (_)=>setState((){}))),
          ]),
          CheckboxListTile(title: Text('Tem férias vencidas?'), value: temFeriasVencidas, onChanged: (v)=>setState(()=>temFeriasVencidas=v!)),
          DropdownButtonFormField<String>(value: motivo, items: ['Sem justa causa','Pedido demissão','Justa causa','Término contrato'].map((e)=>DropdownMenuItem(value:e, child:Text(e))).toList(), onChanged: (v)=>setState(()=>motivo=v!), decoration: InputDecoration(labelText: 'Motivo', border: OutlineInputBorder())),
          SizedBox(height: 8),
          TextField(controller: fgtsCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Saldo FGTS manual R\$', hintText: 'Ex: 5000', border: OutlineInputBorder()), onChanged: (_)=>setState((){})),
        ]))),
        SizedBox(height: 12),
        itemRes('Saldo salário ($dias dias)', saldoSal),
        itemRes('13º proporcional ($m13/12)', decimoTerceiro),
        itemRes('Férias prop. ($mFer/12)', feriasProp),
        itemRes('1/3 férias prop.', tercoFeriasProp),
        if(temFeriasVencidas) itemRes('Férias vencidas', feriasVenc),
        if(temFeriasVencidas) itemRes('1/3 férias vencidas', tercoVenc),
        itemRes('FGTS do mês (8%)', fgtsMes, cor: Colors.blueGrey),
        itemRes('Multa 40% FGTS (Saldo R\$ ${fgtsSaldo.toStringAsFixed(0)} + mês)', multa, cor: Colors.deepOrange, bold: true),
        SizedBox(height: 10),
        Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xFF0F172A), borderRadius: BorderRadius.circular(12)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('TOTAL RESCISÃO', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)), Text('R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(color: Color(0xFF22D3EE), fontSize: 20, fontWeight: FontWeight.w900))])),
        if(motivo=='Pedido demissão') Padding(padding: EdgeInsets.only(top:8), child: Text('Obs: Pedido de demissão não tem multa 40% nem saque FGTS integral. Desconsiderar multa acima.', style: TextStyle(color: Colors.red, fontSize: 12))),
      ])),
    );
  }
  Widget itemRes(String t, double v, {Color cor=Colors.black87, bool bold=false}) => Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(t, style: TextStyle(fontSize: 13)), Text('R\$ ${v.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(fontWeight: bold?FontWeight.w900:FontWeight.bold, color: cor))]));
}
