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

// HORA EXTRA
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

// VOLTA FÉRIAS COM DATA
class TelaVoltaFerias extends StatefulWidget { @override _TelaVoltaFeriasState createState() => _TelaVoltaFeriasState(); }
class _TelaVoltaFeriasState extends State<TelaVoltaFerias> {
  TextEditingController salCtrl = TextEditingController(); TextEditingController adiantCtrl = TextEditingController();
  DateTime? dataSaiu; DateTime? dataVoltou;
  bool vendeu10 = false; bool teveAdiant = false; String diasTirados = '30 dias';

  Future<void> pickDate(bool isSaiu) async {
    DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030), locale: Locale('pt','BR'));
    if(picked!=null){ setState((){ if(isSaiu) dataSaiu=picked; else dataVoltou=picked; }); }
  }
  String fmt(DateTime? d){ if(d==null) return ''; return "${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}"; }

  @override Widget build(BuildContext context) {
    double sal = double.tryParse(salCtrl.text.replaceAll(',', '.')) ?? 0; double adiant = double.tryParse(adiantCtrl.text.replaceAll(',', '.')) ?? 0;
    int diasFerias = diasTirados=='30 dias'?30:20;
    double valorFeriasBase = sal + (sal/3); double abono = 0; double valorRecebidoFerias = valorFeriasBase;
    if(vendeu10){ abono = (sal/30)*10 + ((sal/30)*10)/3; valorRecebidoFerias = (sal/30)*20 + ((sal/30)*20)/3 + abono; }
    int diasTrabNoMes = 0; double salarioProp = 0;
    if(dataVoltou!=null){ int diasMes = DateTime(dataVoltou!.year, dataVoltou!.month+1, 0).day; diasTrabNoMes = diasMes - dataVoltou!.day + 1; salarioProp = (sal/30)*diasTrabNoMes; }
    double aReceber5Dia = salarioProp - (teveAdiant?adiant:0); if(aReceber5Dia<0) aReceber5Dia=0;
    return Scaffold(backgroundColor: Color(0xFFF8FAFC), appBar: AppBar(title: Text('Volta de Férias'), backgroundColor: Color(0xFF0F172A), foregroundColor: Colors.white),
      body: SingleChildScrollView(padding: EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Card(child: Padding(padding: EdgeInsets.all(16), child: Column(children: [
          TextField(controller: salCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Salário R\$ *', border: OutlineInputBorder()), onChanged: (_)=>setState((){})),
          SizedBox(height: 10),
          Row(children: [
            Expanded(child: InkWell(onTap: ()=>pickDate(true), child: InputDecorator(decoration: InputDecoration(labelText: 'Saiu de férias *', border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_today)), child: Text(fmt(dataSaiu).isEmpty?'Selecione':fmt(dataSaiu))))),
            SizedBox(width: 8),
            Expanded(child: InkWell(onTap: ()=>pickDate(false), child: InputDecorator(decoration: InputDecoration(labelText: 'Voltou *', border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_today)), child: Text(fmt(dataVoltou).isEmpty?'Selecione':fmt(dataVoltou))))),
          ]),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(value: diasTirados, items: ['30 dias','20 dias (vendeu 10)'].map((e)=>DropdownMenuItem(value:e, child:Text(e))).toList(), onChanged: (v)=>setState(()=>{diasTirados=v!, vendeu10=v.contains('20')}), decoration: InputDecoration(labelText: 'Quantos dias tirou?', border: OutlineInputBorder())),
          CheckboxListTile(title: Text('Vendeu 10 dias? (abono)'), value: vendeu10, onChanged: (v)=>setState(()=>vendeu10=v!)),
          CheckboxListTile(title: Text('Teve adiantamento na volta?'), value: teveAdiant, onChanged: (v)=>setState(()=>teveAdiant=v!)),
          if(teveAdiant) TextField(controller: adiantCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Valor adiantamento R\$', border: OutlineInputBorder()), onChanged: (_)=>setState((){})),
        ]))),
        SizedBox(height: 12),
        if(dataSaiu!=null && dataVoltou!=null && sal>0) Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xFF0F172A), borderRadius: BorderRadius.circular(15)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('FÉRIAS: $diasFerias dias | De ${fmt(dataSaiu)} até ${fmt(dataVoltou)}', style: TextStyle(color: Colors.white70, fontSize: 12)),
          Text('Valor férias + 1/3: R\$ ${valorRecebidoFerias.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(color: Colors.white, fontSize: 14)),
          if(vendeu10) Text('Abono 10 dias: R\$ ${abono.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(color: Colors.orangeAccent, fontSize: 12)),
          Divider(color: Colors.white24),
          Text('Voltou dia ${dataVoltou!.day} - trabalhou $diasTrabNoMes dias', style: TextStyle(color: Colors.white)),
          Text('Salário proporcional: R\$ ${salarioProp.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(color: Colors.white)),
          if(teveAdiant) Text('Menos adiantamento: - R\$ ${adiant.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(color: Colors.redAccent)),
          SizedBox(height: 8),
          Text('VAI RECEBER NO 5º DIA ÚTIL: R\$ ${aReceber5Dia.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(color: Color(0xFF22D3EE), fontSize: 20, fontWeight: FontWeight.w900)),
        ])),
      ])),
    );
  }
}

// RESCISÃO COM DATA
class TelaRescisao extends StatefulWidget { @override _TelaRescisaoState createState() => _TelaRescisaoState(); }
class _TelaRescisaoState extends State<TelaRescisao> {
  TextEditingController salCtrl = TextEditingController(); TextEditingController diasCtrl = TextEditingController(); TextEditingController fgtsCtrl = TextEditingController(); TextEditingController qtdVencCtrl = TextEditingController(text: '0');
  DateTime? dataAdm; DateTime? dataDem;
  bool naoSeiFgts = false; String motivo = 'Sem justa causa';

  Future<void> pickDate(bool isAdm) async {
    DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2030), locale: Locale('pt','BR'));
    if(picked!=null){ setState((){ if(isAdm) dataAdm=picked; else dataDem=picked; }); }
  }
  String fmt(DateTime? d){ if(d==null) return ''; return "${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}"; }
  int calcMeses13(DateTime dem){ int meses = dem.month - 1; if(dem.day >= 15) meses += 1; if(meses>12) meses=12; if(meses<0) meses=0; return meses; }
  int calcMesesFerias(DateTime adm, DateTime dem){ DateTime ultimoAniv = DateTime(dem.year, adm.month, adm.day); if(ultimoAniv.isAfter(dem)){ ultimoAniv = DateTime(dem.year-1, adm.month, adm.day);} int totalMeses = (dem.year - ultimoAniv.year)*12 + (dem.month - ultimoAniv.month); if(dem.day >= 15) totalMeses += 1; if(totalMeses>12) totalMeses=12; if(totalMeses<0) totalMeses=0; return totalMeses; }
  int calcMesesTotaisFGTS(DateTime adm, DateTime dem){ int m = (dem.year-adm.year)*12 + (dem.month-adm.month); if(dem.day>=15) m+=1; return m; }

  @override Widget build(BuildContext context) {
    double sal = double.tryParse(salCtrl.text.replaceAll(',', '.')) ?? 0; int dias = int.tryParse(diasCtrl.text) ?? 0; double fgtsSaldo = double.tryParse(fgtsCtrl.text.replaceAll(',', '.')) ?? 0; int qtdVenc = int.tryParse(qtdVencCtrl.text) ?? 0;
    int m13=0; int mFer=0; int mesesFgtsBase=0;
    if(dataDem!=null){ m13 = calcMeses13(dataDem!); } if(dataAdm!=null && dataDem!=null){ mFer = calcMesesFerias(dataAdm!, dataDem!); mesesFgtsBase = calcMesesTotaisFGTS(dataAdm!, dataDem!); }
    double baseFgtsCalculada = mesesFgtsBase * sal * 0.08;
    double fgtsParaMulta = naoSeiFgts ? baseFgtsCalculada : fgtsSaldo;
    double saldoSal = (sal/30)*dias; double decimo = (sal/12)*m13; double feriasProp = (sal/12)*mFer; double tercoProp = feriasProp/3; double feriasVenc = sal * qtdVenc; double tercoVenc = (sal/3) * qtdVenc; double fgtsMes = sal*0.08; double multa = (fgtsParaMulta + fgtsMes) * 0.4; double total = saldoSal + decimo + feriasProp + tercoProp + feriasVenc + tercoVenc + multa;
    if(motivo=='Pedido demissão' || motivo=='Justa causa'){ multa=0; total = saldoSal + decimo + feriasProp + tercoProp + feriasVenc + tercoVenc; }
    return Scaffold(backgroundColor: Color(0xFFF8FAFC), appBar: AppBar(title: Text('Rescisão - Por Data'), backgroundColor: Color(0xFF0F172A), foregroundColor: Colors.white),
      body: SingleChildScrollView(padding: EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Card(child: Padding(padding: EdgeInsets.all(16), child: Column(children: [
          TextField(controller: salCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Salário R\$ *', border: OutlineInputBorder()), onChanged: (_)=>setState((){})),
          SizedBox(height: 8),
          Row(children: [
            Expanded(child: InkWell(onTap: ()=>pickDate(true), child: InputDecorator(decoration: InputDecoration(labelText: 'Admissão *', border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_today)), child: Text(fmt(dataAdm).isEmpty?'Selecione':fmt(dataAdm))))),
            SizedBox(width: 8),
            Expanded(child: InkWell(onTap: ()=>pickDate(false), child: InputDecorator(decoration: InputDecoration(labelText: 'Demissão *', border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_today)), child: Text(fmt(dataDem).isEmpty?'Selecione':fmt(dataDem))))),
          ]),
          SizedBox(height: 8),
          if(dataAdm!=null && dataDem!=null) Container(padding: EdgeInsets.all(8), decoration: BoxDecoration(color: Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(8)), child: Text('Calculado: $m13 meses 13º | $mFer meses férias | $mesesFgtsBase meses FGTS = R\$ ${baseFgtsCalculada.toStringAsFixed(0)}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
          SizedBox(height: 8),
          Row(children: [Expanded(child: TextField(controller: diasCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Saldo dias *', border: OutlineInputBorder()), onChanged: (_)=>setState((){}))), SizedBox(width: 8), Expanded(child: TextField(controller: qtdVencCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Qtd férias vencidas', border: OutlineInputBorder()), onChanged: (_)=>setState((){}))) ]),
          SizedBox(height: 8),
          DropdownButtonFormField<String>(value: motivo, items: ['Sem justa causa','Pedido demissão','Justa causa','Término contrato'].map((e)=>DropdownMenuItem(value:e, child:Text(e))).toList(), onChanged: (v)=>setState(()=>motivo=v!), decoration: InputDecoration(labelText: 'Motivo', border: OutlineInputBorder())),
          CheckboxListTile(title: Text('Não sei meu FGTS - calcular base'), value: naoSeiFgts, onChanged: (v)=>setState(()=>naoSeiFgts=v!)),
          if(!naoSeiFgts) TextField(controller: fgtsCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Saldo FGTS no CAIXA R\$', border: OutlineInputBorder()), onChanged: (_)=>setState((){})),
        ]))),
        SizedBox(height: 12),
        itemRes('Saldo salário', saldoSal), itemRes('13º proporcional ($m13/12)', decimo), itemRes('Férias prop. ($mFer/12)', feriasProp), itemRes('1/3 férias prop.', tercoProp), if(qtdVenc>0) itemRes('Férias vencidas ($qtdVenc x)', feriasVenc), if(qtdVenc>0) itemRes('1/3 vencidas', tercoVenc), itemRes('FGTS mês 8%', fgtsMes), if(multa>0) itemRes('Multa 40% FGTS', multa),
        SizedBox(height: 10),
        Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xFF0F172A), borderRadius: BorderRadius.circular(12)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('TOTAL ESTIMADO', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)), Text('R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(color: Color(0xFF22D3EE), fontSize: 20, fontWeight: FontWeight.w900))])),
      ])),
    );
  }
  Widget itemRes(String t, double v) => Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text(t, style: TextStyle(fontSize: 12))), Text('R\$ ${v.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))]));
}
