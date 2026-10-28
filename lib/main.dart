// SUBSTITUI SÓ A CLASSE TelaVoltaFerias POR ESSA AQUI NO SEU main.dart:

class TelaVoltaFerias extends StatefulWidget { @override _TelaVoltaFeriasState createState() => _TelaVoltaFeriasState(); }
class _TelaVoltaFeriasState extends State<TelaVoltaFerias> {
  TextEditingController salCtrl = TextEditingController(); TextEditingController adiantCtrl = TextEditingController();
  DateTime? dataSaiu; DateTime? dataVoltou;
  bool vendeu10 = false; bool teveAdiant = false; String fechamento = '20';
  Future<void> pickDate(bool isSaiu) async { DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030)); if(picked!=null){ setState((){ if(isSaiu) dataSaiu=picked; else dataVoltou=picked; }); } }
  String fmt(DateTime? d){ if(d==null) return ''; return "${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}"; }
  @override Widget build(BuildContext context) {
    double sal = double.tryParse(salCtrl.text.replaceAll(',', '.')) ?? 0; double adiant = double.tryParse(adiantCtrl.text.replaceAll(',', '.')) ?? 0; int fech = int.tryParse(fechamento) ?? 20;
    int diasFora = 0; double valorFerias = 0; double abono = 0;
    if(dataSaiu!=null && dataVoltou!=null){ diasFora = dataVoltou!.difference(dataSaiu!).inDays; if(diasFora<0) diasFora=0; valorFerias = (sal/30)*diasFora + ((sal/30)*diasFora)/3; if(vendeu10){ abono = (sal/30)*10 + ((sal/30)*10)/3; } }
    int diasTrabNoMes = 0; double salarioProp = 0; String obsFechamento = "";
    if(dataVoltou!=null){
      int diasMes = DateTime(dataVoltou!.year, dataVoltou!.month+1, 0).day; int fechReal = fech > diasMes ? diasMes : fech;
      if(dataVoltou!.day <= fechReal){ diasTrabNoMes = fechReal - dataVoltou!.day + 1; salarioProp = (sal/30)*diasTrabNoMes; obsFechamento = "Ponto fecha dia $fechReal, voltou dia ${dataVoltou!.day} = $diasTrabNoMes dias neste fechamento"; }
      else { diasTrabNoMes = 0; salarioProp = 0; int proxDias = (diasMes - dataVoltou!.day + 1) + fechReal; obsFechamento = "ATENÇÃO: Voltou dia ${dataVoltou!.day} DEPOIS do fechamento ($fechReal). Neste 5º dia = R\$ 0,00. Próximo = $proxDias dias = R\$ ${((sal/30)*proxDias).toStringAsFixed(2)}"; }
    }
    double aReceber5Dia = salarioProp - (teveAdiant?adiant:0); if(aReceber5Dia<0) aReceber5Dia=0;
    return Scaffold(backgroundColor: Color(0xFFF8FAFC), appBar: AppBar(title: Text('Volta de Férias - Dias Corridos'), backgroundColor: Color(0xFF0F172A), foregroundColor: Colors.white),
      body: SingleChildScrollView(padding: EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Card(child: Padding(padding: EdgeInsets.all(16), child: Column(children: [
          TextField(controller: salCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Salário R\$ *', border: OutlineInputBorder()), onChanged: (_)=>setState((){})),
          SizedBox(height: 8),
          Row(children: [Expanded(child: InkWell(onTap: ()=>pickDate(true), child: InputDecorator(decoration: InputDecoration(labelText: 'Saí de férias *', border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_today)), child: Text(fmt(dataSaiu).isEmpty?'Selecione':fmt(dataSaiu))))), SizedBox(width: 8), Expanded(child: InkWell(onTap: ()=>pickDate(false), child: InputDecorator(decoration: InputDecoration(labelText: 'Voltei *', border: OutlineInputBorder(), suffixIcon: Icon(Icons.calendar_today)), child: Text(fmt(dataVoltou).isEmpty?'Selecione':fmt(dataVoltou)))))]),
          SizedBox(height: 8),
          Row(children: [Expanded(child: DropdownButtonFormField<String>(value: fechamento, items: ['5','10','15','20','25','30'].map((e)=>DropdownMenuItem(value:e, child:Text('Fecha dia $e'))).toList(), onChanged: (v)=>setState(()=>fechamento=v!), decoration: InputDecoration(labelText: 'Fechamento ponto', border: OutlineInputBorder()))), SizedBox(width: 8), Expanded(child: CheckboxListTile(title: Text('Vendeu 10 dias?'), value: vendeu10, onChanged: (v)=>setState(()=>vendeu10=v!))) ]),
          CheckboxListTile(title: Text('Teve adiantamento?'), value: teveAdiant, onChanged: (v)=>setState(()=>teveAdiant=v!)),
          if(teveAdiant) TextField(controller: adiantCtrl, keyboardType: TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: 'Adiantamento R\$', border: OutlineInputBorder()), onChanged: (_)=>setState((){})),
        ]))),
        SizedBox(height: 12),
        if(dataSaiu!=null && dataVoltou!=null && sal>0) Container(padding: EdgeInsets.all(16), decoration: BoxDecoration(color: Color(0xFF0F172A), borderRadius: BorderRadius.circular(15)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Ficou $diasFora dias de férias (de ${fmt(dataSaiu)} até ${fmt(dataVoltou)})', style: TextStyle(color: Color(0xFF22D3EE), fontWeight: FontWeight.bold)),
          Text('Valor férias + 1/3 desses $diasFora dias: R\$ ${valorFerias.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(color: Colors.white, fontSize: 13)),
          if(vendeu10) Text('Abono 10 dias: + R\$ ${abono.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(color: Colors.orangeAccent, fontSize: 12)),
          Divider(color: Colors.white24),
          Text(obsFechamento, style: TextStyle(color: Colors.orangeAccent, fontSize: 11)),
          Text('Salário proporcional neste fechamento: R\$ ${salarioProp.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(color: Colors.white)),
          SizedBox(height: 8),
          Text('VAI RECEBER NO 5º DIA: R\$ ${aReceber5Dia.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(color: Color(0xFF22D3EE), fontSize: 20, fontWeight: FontWeight.w900)),
        ])),
      ])),
    );
  }
}
