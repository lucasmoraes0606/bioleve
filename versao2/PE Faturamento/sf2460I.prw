#INCLUDE "RWMAKE.CH"

User Function Sf2460i() // incluido pelo assistente de conversao do AP5 IDE em 08/01/03

SetPrvt("CNUMPDV,MBANCO,MTIPO,MTIPOST,MDOC,VAR,REC")
SetPrvt("MCLI,MLOJA,MPRE,CH1,OBSERVACAO,OBSFLADIS,FRELAT")
SetPrvt("CNUMPDV,MTIPO2,VEND")
SetPrvt("MNUM,MSERIE")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria Variaveis 													  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

mbanco          := alias()
mtipo           := sc5->c5_tipop2
mtipost         := sc5->c5_pgtost
frelat          := sc5->c5_frelat
mdoc            := sf2->f2_doc
mcli            := sf2->f2_cliente
mloja           := sf2->f2_loja
mpre            := sf2->f2_serie
f2carga         := sf2->f2_carga
datfat          := sd2->d2_emissao
observacao      := sc5->c5_obscop
fretenf         := sc5->c5_frete
perc            := sc5->c5_comis1
dtsaida         := sc5->c5_dtsaida
placa           := sc5->c5_placa
Coord			:= sc5->c5_coord
GerSet			:= sc5->c5_gerset
GerNac			:= sc5->c5_gernac
Diretor			:= sc5->c5_diretor
vend1           := sc5->c5_vend1
emisnf          := sc5->c5_emisnf
obsbol          := sc5->c5_obsbol
equipe          := sc5->c5_equipe
astrad          := sc5->c5_astrad
Outdesc			:= sc5->c5_outdesc
desconto        := 0
geradata        := 0
xPesol          := 0
xPesob          := 0
xVolume         := 0
xParcela        := 0
_impst          := 0
_impipi         := 0
_vlrtitulo      := 0
_vlrsaldo       := 0
_vlrcruz		:= 0
mtipo2          := sc5->c5_tipop2
mnum            := se1->e1_num
mserie          := sf2->f2_serie

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inseri informacao nas tabelas de notas fiscais SD2 e SF2³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SD2")
DbSetOrder(3)
cvar := mdoc+mpre+mcli+mloja
DbSeek(xfilial()+cvar)
If SM0->M0_CODIGO $ "11/12/32" // fladis - Flamin Filial - Flamin Matriz - Serrana
	Do While sd2->d2_doc+sd2->d2_serie+sd2->d2_cliente+sd2->d2_loja == cvar .and. .not. eof()
		DbSelectArea("SB1")
		DbsetOrder(1)
		DbSeek(xfilial()+sd2->d2_cod)
		DBSELECTAREA("SC6")
		DBSETORDER(1)
		DBSEEK(XFILIAL()+SD2->D2_PEDIDO+SD2->D2_ITEMPV)
		DBSELECTAREA("SD2")
		RECLOCK("SD2")
		sd2->d2_vend1   := sc5->c5_vend1
		sd2->d2_nomprod := sc6->c6_descri
		sd2->d2_pesob   := sc6->c6_pesob
		SD2->D2_TABELA  := sc5->c5_tabela
		sd2->d2_emisnf  := emisnf
		sd2->d2_locvend := sc5->c5_locvend
		sd2->d2_opera   := sb1->b1_clasfis
		sd2->d2_regiao  := sc5->c5_regiao
		sd2->d2_equipe  := sc6->c6_equipe
		sd2->d2_coord 	:= sc6->c6_coord
		sd2->d2_gerset 	:= sc6->c6_gerset
		sd2->d2_gernac 	:= sc6->c6_gernac
		sd2->d2_diretor := sc6->c6_diretor
		sd2->d2_frelat  := frelat
		sc6->c6_datfat  := datfat
		sc6->c6_emisnf  := emisnf
		xPesol          := xPesol + sb1->b1_peso
		xPesob          := xPesob + sb1->b1_pesbru
		xVolume         := xVolume + sd2->d2_quant
		IF SC6->C6_PRODUTO $ '22152          /14129          '
			xParcela        := xParcela + 1
		ENDIF
		MSUNLOCK("SD2")
		DbSkip()
	Enddo
	DBSELECTAREA("SC5")
	RECLOCK("SC5")
	sc5->c5_datfat  := datfat
	MSUNLOCK("SC5")
	DbselectArea("SF2")
	RECLOCK("SF2")
	sf2->f2_pesob   := xPesob
	sf2->f2_dtsaida := dtsaida
	sf2->f2_especi1 := "Pacote"
	SF2->F2_REGIAO  := SC5->C5_REGIAO
	sf2->f2_volume1 := xVolume
	sf2->f2_regiao  := sc5->c5_regiao
	sf2->f2_locvend := sc5->c5_locvend
	sf2->f2_equipe  := equipe
	sf2->f2_vend1   := sc5->c5_vend1
	sf2->f2_frelat  := frelat
	sf2->f2_emisnf  := emisnf
	sf2->f2_pagto   := mtipo2
	sf2->f2_pgtost  := mtipost
	sf2->f2_tabela  := sc5->c5_tabela
	sf2->f2_freint  := sc5->c5_freint
	sf2->f2_outdesc := sc5->c5_outdesc
	sf2->f2_xpedido := sc5->c5_num
	sf2->f2_pedsfa	:= sc5->c5_pedsfa
	sf2->f2_descbol := sc5->c5_descbol
	sf2->f2_perc    := sc5->c5_perc
	sf2->f2_coord 	:= sc5->c5_coord
	sf2->f2_gerset 	:= sc5->c5_gerset
	sf2->f2_gernac 	:= sc5->c5_gernac
	sf2->f2_diretor := sc5->c5_diretor
	SF2->F2_XDESCAR := SC5->C5_XDESCAR
	SF2->F2_XPEDAG  := SC5->C5_XPEDAG
	SF2->F2_XDIARIA := SC5->C5_XDIARIA
	SF2->F2_NOMEMOT := SC5->C5_NOMEMOT
	SF2->F2_NOMECLI := SC5->C5_NOMECLI
	SF2->F2_XCHAPA	:= SC5->C5_XCHAPA
	SF2->F2_XPALETE	:= SC5->C5_XPALETE
	MSUNLOCK("SF2")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inseri informacao nas tabelas de Duplicatas SE1         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea("SE1")
	DbSetOrder(2)
	DbSeek(xfilial()+mcli+mloja+mpre+mdoc)
	_contparc       := 0
	While se1->e1_filial+se1->e1_cliente+se1->e1_loja+se1->e1_prefixo+se1->e1_num == xfilial()+mcli+mloja+mpre+mdoc .and. !eof()
		_contparc ++
		DbSkip()
	Enddo
	_impst          := sf2->f2_icmsret / _contparc
	_impipi         := sf2->f2_valipi / _contparc
	_valdesc        := sc5->c5_descbol / _contparc
	_vlrtitulo      := sc5->c5_totped / _contparc
	_vlrsaldo       := sc5->c5_totped / _contparc
	_vlrcruz		:= sc5->c5_totped / _contparc
	conout(round(_valdesc,2))
	If DbSeek(xfilial()+mcli+mloja+mpre+mdoc)
		rec             := recno()
		While se1->e1_filial+se1->e1_cliente+se1->e1_loja+se1->e1_prefixo+se1->e1_num == xfilial()+mcli+mloja+mpre+mdoc .and. !eof()
			RECLOCK("SE1")
			If SM0->M0_CODIGO <> "31"
				se1->e1_ch1     := se1->e1_vencrea
				se1->e1_obscop  := observacao
				se1->e1_frete   := fretenf
				se1->e1_valor   := se1->e1_valor
				se1->e1_saldo   := se1->e1_valor
				se1->e1_vlcruz  := se1->e1_valor
				se1->e1_valorst := _impst
				se1->e1_vlripi  := _impipi
				se1->e1_emisnf  := emisnf
				se1->e1_clifld  := sc5->c5_clifld
				se1->e1_astrad  := astrad
				se1->e1_equipe  := equipe
				SE1->e1_descont := _valdesc //desconto
				se1->e1_vend1   := vend1
				se1->e1_pagto   := mtipo
				se1->e1_pgtost  := mtipost
				se1->e1_carga   := f2carga
				se1->e1_hist    := mpre + mdoc + se1->e1_parcela + " " + subst(sa1->a1_nome,1,20)
				se1->e1_coord	:= coord
				se1->e1_gerset	:= GerSet
				se1->e1_gernac	:= GerNac
				se1->e1_diretor	:= Diretor
				se1->e1_outdesc := Outdesc
				se1->e1_ccusto  := sc6->c6_cc
				If SM0->M0_CODIGO $ "12" // FILIAL
					se1->e1_naturez := "0000000600"
					se1->e1_ctcre   := "40101010004"
				Else
					se1->e1_naturez := "0000000055"
					se1->e1_ctcre   := "40101010002"
				Endif
				If xParcela > 0
					se1->e1_parcela := "CP"
				Endif
				IF _valdesc > 0.00
					se1->e1_obsbol  := "CONCEDER DESCONTO DE R$: " + str(_valdesc,9,2) + " ATE O VENCIMENTO / " + obsbol
				endif
				DbSkip()
			endif
		Enddo
	Endif
endif

//----INICIO DE TRANSFERENCIA CONTROLE DE CHAPA E PALETE
DbSelectArea("SC5")
DbSetOrder(13)
DbSeek(xfilial()+mdoc)
IF SC5->C5_XCHAPA > 0 .OR. SC5->C5_XPALETE > 0	
dbSelectArea("SZ1")
			RecLock("SZ1",.T.)
			Z1_FILIAL	:=	xFilial("SZ1")																				
			Z1_COD 		:=	GETSXENUM("SZ1","Z1_COD")
			Z1_EMISNF	:=  SC5->C5_EMISNF                                                                                                       
			Z1_NOTA 	:=	SC5->C5_NOTA						
			Z1_CLIENTE	:=	SC5->C5_CLIENTE						
			Z1_NOMECLI	:=	SC5->C5_NOMECLI
  			Z1_TRANSP	:=	SC5->C5_TRANSP
			Z1_NOMEMOT	:=	SC5->C5_NOMEMOT
			Z1_DATFAT	:=	SC5->c5_datfat
			Z1_CHAENV	:=	SC5->C5_XCHAPA
			Z1_PALENV	:=	SC5->C5_XPALETE			
			Z1_FINALIZ 	:= 	"2"
MsUnlock("SZ1")
ENDIF 
//----FINAL DE TRANSFERENCIA CONTROLE DE CHAPA E PALETE
/*
//----INICIO DE TRANSFERENCIA CONTROLE DE PAGAMENTO 


DbSelectArea("SC5")
DbSetOrder(13)
DbSeek(xfilial()+mdoc)
IF SC5->C5_FREINT > 0 .OR. SC5->C5_XDESCAR > 0 .OR. SC5->C5_XPEDAG > 0 .OR. SC5->C5_XDIARIA > 0	
dbSelectArea("SZ3")
			RecLock("SZ3",.T.)
			Z3_FILIAL	:=	xFilial("SZ3")																				
			Z3_COD 		:=	GETSXENUM("SZ3","Z3_COD")
			Z3_NUM		:=	SC5->C5_NUM
			Z3_EMISNF	:=  SC5->C5_EMISNF						
			Z3_PEDSFA	:=	SC5->C5_PEDSFA                                                                                                       						
			Z3_CLIENTE	:=	SC5->C5_CLIENTE						
			Z3_NOMECLI	:=	SC5->C5_NOMECLI
			Z3_TRANSP	:=	SC5->C5_TRANSP
			Z3_NOMEMOT	:=	SC5->C5_NOMEMOT
			Z3_NOTA		:=	SC5->C5_NOTA
			Z3_DATFAT	:=	SC5->C5_DATFAT
			Z3_TOTPED	:=	SC5->C5_TOTPED
			Z3_FREINT	:=	SC5->C5_FREINT
			Z3_XDESCAR	:=	SC5->C5_XDESCAR
			Z3_XPEDAG	:=	SC5->C5_XPEDAG
			Z3_XDIARIA  :=  SC5->C5_XDIARIA
			Z3_FINALIZ 	:= 	"2"
			Z3_PGDFRET 	:=	SC5->C5_FREINT
MsUnlock("SZ3")
ENDIF
//----FINAL DE TRANSFERENCIA CONTROLE DE PAGAMENTO
*/
//----INICIO DE TRANSFERENCIA CONTROLE DE PAGAMENTO 


DbSelectArea("SF2")
DbSetOrder(1) //VERIFICAR SE FUNCIONA, CASO CONTRARIO CRIAR UM INDICE 18 (FILIAL + DOC)
DbSeek(xfilial()+mdoc)
IF SF2->F2_EMISNF = "2" .AND. SF2->F2_FREINT > 0 .OR. SF2->F2_XDESCAR > 0 .OR. SF2->F2_XPEDAG > 0 .OR. SF2->F2_XDIARIA > 0	.OR. SF2->F2_XCHAPA > 0 .OR. SF2->F2_XPALETE > 0	
dbSelectArea("SZ3")
			RecLock("SZ3",.T.)
			Z3_FILIAL	:=	xFilial("SZ3")																				
			Z3_COD 		:=	GETSXENUM("SZ3","Z3_COD")
			Z3_NUM		:=	SF2->F2_XPEDIDO
			Z3_EMISNF	:=  SF2->F2_EMISNF					
			Z3_PEDSFA	:=	SF2->F2_PEDSFA                                                                                                       						
			Z3_CLIENTE	:=	SF2->F2_CLIENTE						
			Z3_NOMECLI	:=	SF2->F2_NOMECLI
			Z3_TRANSP	:=	SF2->F2_TRANSP
			Z3_NOMEMOT	:=	SF2->F2_NOMEMOT
			Z3_NOTA		:=	SF2->F2_DOC
			Z3_DATFAT	:=	SF2->F2_EMISSAO
			Z3_TOTPED	:=	SF2->F2_VALBRUT
			Z3_FREINT	:=	SF2->F2_FREINT
			Z3_XDESCAR	:=	SF2->F2_XDESCAR
			Z3_XPEDAG	:=	SF2->F2_XPEDAG
			Z3_XDIARIA  :=  SF2->F2_XDIARIA
			Z3_FINALIZ 	:= 	"1"
			Z3_PGDFRET 	:=	SF2->F2_FREINT
			Z3_CARGA	:= 	SF2->F2_CARGA
			Z3_CHAENV	:=	SF2->F2_XCHAPA
			Z3_PALENV	:=  SF2->F2_XPALETE
			Z3_PBRUTO	:=	SF2->F2_PBRUTO
			Z3_VEICUL1	:=	SF2->F2_VEICUL1
			Z3_VOLUME1	:=	SF2->F2_VOLUME1
MsUnlock("SZ3")
ENDIF

DbSelectArea("SF2")
DbSetOrder(1) //VERIFICAR SE FUNCIONA, CASO CONTRARIO CRIAR UM INDICE 18 (FILIAL + DOC)
DbSeek(xfilial()+mdoc)
IF SF2->F2_EMISNF = "1" .AND. SF2->F2_FREINT > 0 .OR. SF2->F2_XDESCAR > 0 .OR. SF2->F2_XPEDAG > 0 .OR. SF2->F2_XDIARIA > 0	.OR. SF2->F2_XCHAPA > 0 .OR. SF2->F2_XPALETE > 0	
dbSelectArea("SZ3")
			RecLock("SZ3",.T.)
			Z3_FILIAL	:=	xFilial("SZ3")																				
			Z3_COD 		:=	GETSXENUM("SZ3","Z3_COD")
			Z3_NUM		:=	SF2->F2_XPEDIDO
			Z3_EMISNF	:=  SF2->F2_EMISNF					
			Z3_PEDSFA	:=	SF2->F2_PEDSFA                                                                                                       						
			Z3_CLIENTE	:=	SF2->F2_CLIENTE						
			Z3_NOMECLI	:=	SF2->F2_NOMECLI
			Z3_TRANSP	:=	SF2->F2_TRANSP
			Z3_NOMEMOT	:=	SF2->F2_NOMEMOT
			Z3_NOTA		:=	SF2->F2_DOC
			Z3_DATFAT	:=	SF2->F2_EMISSAO
			Z3_TOTPED	:=	SF2->F2_VALBRUT
			Z3_FREINT	:=	SF2->F2_FREINT
			Z3_XDESCAR	:=	SF2->F2_XDESCAR
			Z3_XPEDAG	:=	SF2->F2_XPEDAG
			Z3_XDIARIA  :=  SF2->F2_XDIARIA
			Z3_FINALIZ 	:= 	"2"
			Z3_PGDFRET 	:=	SF2->F2_FREINT
			Z3_CARGA	:= 	SF2->F2_CARGA
			Z3_CHAENV	:=	SF2->F2_XCHAPA
			Z3_PALENV	:=  SF2->F2_XPALETE
			Z3_PBRUTO	:=	SF2->F2_PBRUTO
			Z3_VEICUL1	:=	SF2->F2_VEICUL1
			Z3_VOLUME1	:=	SF2->F2_VOLUME1
MsUnlock("SZ3")
ENDIF
//----FINAL DE TRANSFERENCIA CONTROLE DE PAGAMENTO


//----INICIO DE CONTROLE DE CANHOTOS
DbSelectArea("SC5")
DbSetOrder(13)
DbSeek(xfilial()+mdoc)
dbSelectArea("SZ7")
			RecLock("SZ7",.T.)
			Z7_FILIAL	:=	xFilial("SZ7")																				
			Z7_NOTA		:=	SC5->C5_NOTA
			Z7_CLIENTE	:=	SC5->C5_CLIENTE						                                                                                                       											
			Z7_NOMECLI	:=	SC5->C5_NOMECLI
			Z7_EMISSAO	:=	SC5->C5_DATFAT
			Z7_TRANSP	:=	SC5->C5_TRANSP
			Z7_NOMEMOT	:=	SC5->C5_NOMEMOT
			Z7_EMISNF	:=  SC5->C5_EMISNF

MsUnlock("SZ7") 
//----FINAL DE CONTROLE DE CANHOTOS


DbSelectArea(mbanco)
Return(NIL)
