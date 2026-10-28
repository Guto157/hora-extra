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
    return Scaffold(backgroundColor: Color(0xFFF8FAFC), appBar: AppBar(title: Text('Hora Extra'), backgroundColor: Color(0xFF0F172A), foregroundColor: Colors.white),
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
  Widget resCard(String p, double v, Color c) => Container(padding: EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Row(children: [Container(width:55,height:55,decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(10)), child: Center(child: Text(p, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)))), SizedBox(width: 12), Text('R\$ ${v.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))]));
}
class TelaVoltaFerias extends StatefulWidget { @override _TelaVoltaFeriasState createState() => _TelaVoltaFeriasState(); }
class _TelaVoltaFeriasState extends State<TelaVoltaFerias> {
  TextEditingController salCtrl = TextEditingController(); TextEditingController diaVoltaCtrl = TextEditingController(); TextEditingController diasMesCtrl = TextEditingController(text: '30'); TextEditingController adiantCtrl = TextEditingController(); bool teveAdiant = false; String tipoPag = 'Só pagamento';
  @override Widget build(BuildContext context) {
    double sal = double.tryParse(salCtrl.text.replaceAll(',', '.')) ?? 0; int diaVolta = int.tryParse(diaVoltaCtrl.text) ?? 0; int diasMes = int.tryParse(diasMesCtrl.text) ?? 30; double adiant = double.tryParse(adiantCtrl.text.replaceAll(',', '.')) ?? 0;
    int diasTrab = 0; if(diaVolta>0 && diaVolta<=diasMes){ diasTrab = diasMes - diaVolta + 1; }
    double salarioProp = diasTrab>0 ? (sal / 30) * diasTrab : 0; double aReceber = salarioProp; if(tipoPag=='Com adiantamento'){ aReceber = salarioProp - adiant; if(aReceber<0) aReceber=0; }
    return Scaffold(backgroundColor: Color(0xFFF8FAFC), appBar: AppBar(title: Text('Volta de Férias - Manual'), backgroundColor: Color(0xFF0F172A), foregroundColor: Colors.white),
      body: SingleChildScrollView(padding: EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Card(child: Padding(padding: EdgeInsets.all(16), child: Column(children: [
          TextField(controller: salCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Salário R\$ *', border: OutlineInputBorder()), onChanged: (_)=>setState((){})),
          SizedBox(height: 10),
          Row(children: [Expanded(child: TextField(controller: diaVoltaCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Voltei dia * ex:22', border: OutlineInputBorder()), onChanged: (_)=>setState((){}))), SizedBox(width: 10), Expanded(child: TextField(controller: diasMesCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Dias mês 30/31', border: OutlineInputBorder()), onChanged: (_)=>setState((){}))) ]),
          CheckboxListTile(title: Text('Teve adiantamento?'), value: teveAdiant, onChanged: (v)=>setState(()=>teveAdiant=v!)),
          if(teveAdiant) TextField(controller: adiantCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Valor adiantamento R\$', border: OutlineInputBorder()), onChanged: (_)=>setState((){})),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(value: tipoPag, items: ['Só pagamento','Com adiantamento'].map((e)=>DropdownMenuItem(value:e, child:Text(e))).toList(), onChanged: (v)=>setState(()=>tipoPag=v!), decoration: InputDecoration(labelText: 'Tipo pagamento 5º dia', border: OutlineInputBorder())),
        ]))),
        SizedBox(height: 15),
        if(diaVolta>0 && sal>0) Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xFF0F172A), borderRadius: BorderRadius.circular(15)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Dias trabalhados: $diasTrab dias', style: TextStyle(color: Colors.white)),
          Text('Salário proporcional: R\$ ${salarioProp.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(color: Colors.white, fontSize: 16)),
          if(teveAdiant) Text('Adiantamento: - R\$ ${adiant.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(color: Colors.orangeAccent)),
          Divider(color: Colors.white24),
          Text('VAI RECEBER: R\$ ${aReceber.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(color: Color(0xFF22D3EE), fontSize: 20, fontWeight: FontWeight.w900)),
        ])),
      ])),
    );
  }
}
class TelaRescisao extends StatefulWidget { @override _TelaRescisaoState createState() => _TelaRescisaoState(); }
class _TelaRescisaoState extends State<TelaRescisao> {
  TextEditingController salCtrl = TextEditingController(); 
  TextEditingController admCtrl = TextEditingController(); // NOVO
  TextEditingController demCtrl = TextEditingController(); // NOVO
  TextEditingController diasCtrl = TextEditingController(); 
  TextEditingController fgtsCtrl = TextEditingController(); bool temFeriasVencidas = false; String motivo = 'Sem justa causa';

  DateTime? parseData(String s){
    try{
      s=s.replaceAll('/', '').replaceAll('-', '').trim();
      if(s.length!=8) return null;
      int d=int.parse(s.substring(0,2)); int m=int.parse(s.substring(2,4)); int a=int.parse(s.substring(4,8));
      return DateTime(a,m,d);
    }catch(e){ return null; }
  }
  int calcMeses13(DateTime dem){
    int meses = dem.month - 1;
    if(dem.day >= 15) meses += 1;
    if(meses>12) meses=12; if(meses<0) meses=0;
    return meses;
  }
  int calcMesesFerias(DateTime adm, DateTime dem){
    // meses desde o ultimo aniversario de admissao
    DateTime ultimoAniv = DateTime(dem.year, adm.month, adm.day);
    if(ultimoAniv.isAfter(dem)){
      ultimoAniv = DateTime(dem.year-1, adm.month, adm.day);
    }
    int totalMeses = (dem.year - ultimoAniv.year)*12 + (dem.month - ultimoAniv.month);
    if(dem.day >= 15) totalMeses += 1;
    if(totalMeses>12) totalMeses=12;
    if(totalMeses<0) totalMeses=0;
    return totalMeses;
  }

  @override Widget build(BuildContext context) {
    double sal = double.tryParse(salCtrl.text.replaceAll(',', '.')) ?? 0; int dias = int.tryParse(diasCtrl.text) ?? 0; double fgtsSaldo = double.tryParse(fgtsCtrl.text.replaceAll(',', '.')) ?? 0;
    DateTime? adm = parseData(admCtrl.text); DateTime? dem = parseData(demCtrl.text);
    int m13=0; int mFer=0;
    if(dem!=null){ m13 = calcMeses13(dem); }
    if(adm!=null && dem!=null){ mFer = calcMesesFerias(adm, dem); }

    double saldoSal = (sal/30)*dias; double decimo = (sal/12)*m13; double feriasProp = (sal/12)*mFer; double tercoProp = feriasProp/3; double feriasVenc = temFeriasVencidas ? sal : 0; double tercoVenc = temFeriasVencidas ? sal/3 : 0; double fgtsMes = sal*0.08; double multa = (fgtsSaldo + fgtsMes) * 0.4; double total = saldoSal + decimo + feriasProp + tercoProp + feriasVenc + tercoVenc + multa;
    return Scaffold(backgroundColor: Color(0xFFF8FAFC), appBar: AppBar(title: Text('Rescisão - Por Data'), backgroundColor: Color(0xFF0F172A), foregroundColor: Colors.white),
      body: SingleChildScrollView(padding: EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Card(child: Padding(padding: EdgeInsets.all(16), child: Column(children: [
          TextField(controller: salCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Salário R\$ *', border: OutlineInputBorder()), onChanged: (_)=>setState((){})),
          SizedBox(height: 8),
          Row(children: [
            Expanded(child: TextField(controller: admCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Admissão * DD/MM/AAAA', hintText: '10022023', border: OutlineInputBorder()), onChanged: (_)=>setState((){}))),
            SizedBox(width: 8),
            Expanded(child: TextField(controller: demCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Demissão * DD/MM/AAAA', hintText: '28102025', border: OutlineInputBorder()), onChanged: (_)=>setState((){}))),
          ]),
          SizedBox(height: 8),
          if(adm!=null && dem!=null) Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(8)), child: Text('Calculado: $m13 meses de 13º e $mFer meses de férias (regra 15 dias)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
          SizedBox(height: 8),
          TextField(controller: diasCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Saldo dias trabalhados no mês da demissão *', border: OutlineInputBorder()), onChanged: (_)=>setState((){})),
          CheckboxListTile(title: Text('Tem férias vencidas?'), value: temFeriasVencidas, onChanged: (v)=>setState(()=>temFeriasVencidas=v!)),
          DropdownButtonFormField<String>(value: motivo, items: ['Sem justa causa','Pedido demissão','Justa causa','Término contrato'].map((e)=>DropdownMenuItem(value:e, child:Text(e))).toList(), onChanged: (v)=>setState(()=>motivo=v!), decoration: InputDecoration(labelText: 'Motivo', border: OutlineInputBorder())),
          SizedBox(height: 8),
          TextField(controller: fgtsCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Saldo FGTS manual R\$ *', border: OutlineInputBorder()), onChanged: (_)=>setState((){})),
        ]))),
        SizedBox(height: 12),
        itemRes('Saldo salário', saldoSal), itemRes('13º proporcional ($m13/12)', decimo), itemRes('Férias prop. ($mFer/12)', feriasProp), itemRes('1/3 férias prop.', tercoProp), if(temFeriasVencidas) itemRes('Férias vencidas', feriasVenc), if(temFeriasVencidas) itemRes('1/3 vencidas', tercoVenc), itemRes('FGTS mês 8%', fgtsMes), itemRes('Multa 40% FGTS', multa),
        SizedBox(height: 10),
        Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xFF0F172A), borderRadius: BorderRadius.circular(12)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('TOTAL', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)), Text('R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(color: Color(0xFF22D3EE), fontSize: 20, fontWeight: FontWeight.w900))])),
      ])),
    );
  }
  Widget itemRes(String t, double v) => Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(t, style: TextStyle(fontSize: 13)), Text('R\$ ${v.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(fontWeight: FontWeight.bold))]));
}
