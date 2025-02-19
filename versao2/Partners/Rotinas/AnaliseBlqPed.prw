#INCLUDE 'PROTHEUS.CH'
#INCLUDE "RWMAKE.CH"
#include "protheus.ch"

#DEFINE ENTER CHR(13)+CHR(10)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ValidPedGeral  º Autor ³ LUCAS PEREIRA   º Data ³  16/12/21  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Executado validação apos alteração do pedido de venda      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                     		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function AnaliseBlqPed()
	local lTransparent	:= .F.	
    local cTxtMonitor   := SC5->C5_MOTBLQ
	//monta tela
	local oFont2  		:= TFont():New("Goudy Old Style",,020,,.T.,,,,,.F.,.F.) 
	local oFont1  		:= TFont():New("MS Sans Serif",,011,,.F.,,,,,.F.,.F.)
	local oFont3  		:= TFont():New("MS Sans Serif",,013,,.T.,,,,,.F.,.F.)

	local cStatus		:= SC5->C5_XSTATUS
	Private nFrete := 0
	Private nDesconto := 0
	Private nTotalPed := 0


	if cStatus == " "
		cDescStatus	:= "Bloquedo Comercial"
		cImagStatus	:= "BR_VERDE"
	elseif cStatus == "C"
		cDescStatus	:= "Bloquedo Comercial"
		cImagStatus	:= "BR_PRETO"
	elseif cStatus == "N"
		cDescStatus	:= "Ped. Lib. mas nao imp."
		cImagStatus	:= "BR_PINK"
	elseif cStatus == "T"
		cDescStatus	:= "Bloquedo Controladoria"
		cImagStatus	:= "BR_BRANCO"
	elseif cStatus == "F"
		cDescStatus	:= "Bloquedo financeiro"
		cImagStatus	:= "BR_VIOLETA"
	elseif cStatus == "E"
		cDescStatus	:= "Bloquedo Estoque"
		cImagStatus	:= "BR_MARROM"
	elseif cStatus == "L"
		cDescStatus	:= "Bloquedo Logistica"
		cImagStatus	:= "BR_VERDE_ESCURO"
	elseif SC5->C5_NOTA == 'XXXXXXXXX'
		cDescStatus	:= "Bloquedo Cancelado"
		cImagStatus	:= "BR_CANCEL"
	elseif EMPTY(cStatus) .OR. cStatus == "O"
		cDescStatus	:= "Pedido Liberado"
		cImagStatus	:= "BR_AMARELO"
	elseif !EMPTY(SC5->C5_NOTA) 
		cDescStatus	:= "Pedido Faturado"
		cImagStatus	:= "BR_VERMELHO"
	endif


	oDlgMonitor := MSDialog():New(0,0,475, 1000,'Analise Pedido',,,,nOr(WS_VISIBLE,WS_POPUP),CLR_BLACK,CLR_WHITE,,,.T.,,,,lTransparent)
    oTButClose	:= TBtnBmp2():New( 00, 980   ,30,30,'close1.png',,,,{||oDlgMonitor:end() },oDlgMonitor ,,,.T. )
	oSay4		:= TSay():New(  005	, 210	,{||"Analise Pedido"}	, oDlgMonitor,,oFont2,,,,.T.,8421504,,500,15) 	
	
	oGroup1		:= TGroup():New(25,05,200,160,'Detalhes Pedido',oDlgMonitor,,,.T.)
	oSay4		:= TSay():New(  035	, 10	,{|| "Numero   " }	, oDlgMonitor,,oFont3,,,,.T.,8421504,,500,10) 
	oSay4		:= TSay():New(  050	, 10	,{|| "Cliente  " }	, oDlgMonitor,,oFont3,,,,.T.,8421504,,500,10) 
	oSay4		:= TSay():New(  070	, 10	,{|| "Vendedor " }	, oDlgMonitor,,oFont3,,,,.T.,8421504,,500,10) 
	oSay4		:= TSay():New(  080	, 10	,{|| "Tabela   " }	, oDlgMonitor,,oFont3,,,,.T.,8421504,,500,10) 
	oSay4		:= TSay():New(  090	, 10	,{|| "Cond.Pag " }	, oDlgMonitor,,oFont3,,,,.T.,8421504,,500,10) 
	oSay4		:= TSay():New(  100	, 10	,{|| "Emissao  " }	, oDlgMonitor,,oFont3,,,,.T.,8421504,,500,10) 
	oSay4		:= TSay():New(  110	, 10	,{|| "Frete    " }	, oDlgMonitor,,oFont3,,,,.T.,8421504,,500,10)
    oSay4		:= TSay():New(  120	, 10	,{|| "Desconto " }	, oDlgMonitor,,oFont3,,,,.T.,8421504,,500,10)
	oSay4		:= TSay():New(  130	, 10	,{|| "Valor.Ped" }	, oDlgMonitor,,oFont3,,,,.T.,8421504,,500,10)
	
	oSay4		:= TSay():New(  035	, 50	,{|| ": "+SC5->C5_NUM }	, oDlgMonitor,,oFont1,,,,.T.,8421504,,100,15) 
	oSay4		:= TSay():New(  050	, 50	,{|| ": "+SC5->(C5_CLIENTE)+'-'+POSICIONE("SA1",1,XFILIAL("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI),substring("A1_NOME",1,20))}	, oDlgMonitor,,oFont1,,,,.T.,8421504,,110,10) 
	//oSay4		:= TSay():New(  060	, 10	,{|| ": "+POSICIONE("SA1",1,XFILIAL("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI),substring("A1_NOME",16,15) )}	, oDlgMonitor,,oFont1,,,,.T.,8421504,,110,10) 
	oSay4		:= TSay():New(  070	, 50	,{|| ": "+SC5->C5_VEND1+'-'+POSICIONE("SA3",1,XFILIAL("SA3")+SC5->C5_VEND1,"A3_NOME") }								, oDlgMonitor,,oFont1,,,,.T.,8421504,,110,10) 
	oSay4		:= TSay():New(  080	, 50	,{|| ": "+SC5->C5_TABELA+'-'+POSICIONE("DA0",1,XFILIAL("DA0")+SC5->C5_TABELA,"DA0_DESCRI") }							, oDlgMonitor,,oFont1,,,,.T.,8421504,,110,10) 
	oSay4		:= TSay():New(  090	, 50	,{|| ": "+SC5->C5_CONDPAG+'-'+POSICIONE("SE4",1,XFILIAL("SE4")+SC5->C5_CONDPAG,"E4_DESCRI") }						, oDlgMonitor,,oFont1,,,,.T.,8421504,,110,10) 
	oSay4		:= TSay():New(  100	, 50	,{|| ": "+DTOC(SC5->C5_EMISSAO) }																					, oDlgMonitor,,oFont1,,,,.T.,8421504,,110,10) 
	oSay4		:= TSay():New(  110	, 50	,{|| ": "+transform(SC5->(C5_FRETE+C5_FREINT),"@E 999,999,999.99") }													, oDlgMonitor,,oFont1,,,,.T.,8421504,,110,10) 
	oSay4		:= TSay():New(  120	, 50	,{|| ": "+transform((RetDescont(SC5->C5_NUM)+ SC5->C5_DESCONT + SC5->C5_PDESCAB + SC5->C5_DESCBOL + SC5->C5_OUTDESC),"@E 999,999,999.99") }													, oDlgMonitor,,oFont1,,,,.T.,8421504,,110,10) 
	oSay4		:= TSay():New(  130	, 50	,{|| ": "+transform(RetTotPed(SC5->C5_NUM),"@E 999,999,999.99") }													, oDlgMonitor,,oFont1,,,,.T.,8421504,,110,10) 

	nFrete := SC5->(C5_FRETE+C5_FREINT)
	nDesconto := RetDescont(SC5->C5_NUM)+ SC5->C5_DESCONT + SC5->C5_PDESCAB + SC5->C5_DESCBOL + SC5->C5_OUTDESC
	nTotalPed := RetTotPed(SC5->C5_NUM)

	oTBitmap1 	:= TBitmap():New(180,50,027,011,,cImagStatus,.T.,oDlgMonitor,{|| },,.F.,.F.,,,.F.,,.T.,,.F.)
	oSay4		:= TSay():New(  180	, 60	,{||cDescStatus}	, oDlgMonitor,,oFont1,,,,.T.,8421504,,500,15) 


	
	oGroup1		:= TGroup():New(210,05,240,160,'Opções',oDlgMonitor,,,.T.)
	oTButton1 	:= TButton():New( 220 , 90, "Sair" ,oDlgMonitor,{|| oDlgMonitor:end()  }	, 65,12,,,.F.,.T.,.F.,,.F.,,,.F. )	
	oTButton1 	:= TButton():New( 220 , 15, "Lib. Manual" ,oDlgMonitor,{|| LibManual()  }	, 65,12,,,.F.,.T.,.F.,,.F.,,,.F. )	
//	oTButton1 	:= TButton():New( 250 , 15, "Blq. Manual" ,oDlgMonitor,{|| BlqManual()  }	, 65,12,,,.F.,.T.,.F.,,.F.,,,.F. )	

	//oTButRefr	:= TBtnBmp2():New( 340 , 15   ,55,55,'refresh2.png'		,,,,{||Self:DataMonitor(self:aSincron[nPos,2])  },Self:oDlgMonitor ,,,.T. )	

	oGroup1:= TGroup():New(25,165,240,495,'Historico',oDlgMonitor,,,.T.)
	oTMget1 	:= TMultiget():New(35,170,{|u|if(Pcount()>0,cTxtMonitor :=u,cTxtMonitor)},  oDlgMonitor,320,195,,,,,,.T.)
	
	oDlgMonitor:Activate(,,,.T.,{||.T.},,{||} )
return()

static function LibManual() 
	local cUserLibPed := SUPERGETMV("X_LIBPED",.T.,"000000")

	IF RetCodUsr() $ cUserLibPed 
//		ALERT("ATENÇÃO!"+ENTER+"Rotina destinada a liberação manual para usuarios contidos no parametro X_LIBPED.")

		IF msgyesno("Deseja realizar a liberação manual do Pedido?")
			cMsg := "LIBMAN - Pedido liberado VIA ROTINA MANUAL."
			reclock("SC5",.F.)
				
				C5_XGRFRE  	:= nFrete
				C5_XGRDESC 	:= nDesconto
				C5_XGRTOTP 	:= nTotalPed
				C5_DATLIB	:= dDataBase
				C5_USERLIB	:= cUserName
				//C5_XGRTES  	:= RetTes(SC5->C5_NUM) 
				C5_XIMPRIM	:= ""
				C5_XSTATUS	:= "O"
				C5_BLQ      := ""
				C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
			msunlock()

		//	MsgInfo("Pedido Liberado!")
		
			oDlgMonitor:End()

		ENDIF
	ELSE
		Msginfo("Usuario sem permissao para acessar a rotina. Solicite a inclusao no parametro X_LIBPED.")
	ENDIF
return()
/*

static function BlqManual() 
	local cUserLibPed := SUPERGETMV("X_LIBPED",.T.,"000000")

	IF RetCodUsr() $ cUserLibPed 

		IF msgyesno("Deseja realizar o bloqueio manual do Pedido?")
			cMsg := "CONTROLADORIA - Pedido bloqueado VIA ROTINA MANUAL."
			reclock("SC5",.F.)
				C5_XIMPRIM	:= "S"
				C5_XSTATUS	:= "T"
				C5_BLQ      := "1"
				C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
			msunlock()

			MsgInfo("Pedido Bloqueado!")
		ENDIF
	ELSE
		Msginfo("Usuario sem permissao para acessar a rotina. Solicite a inclusao no parametro X_LIBPED.")
	ENDIF
return()

*/


static function RetDescont(cNumPed)
	local nDescItem := 0
    BEGINSQL alias "DESCITEM"  
        SELECT ROUND(SUM(C6_VALDESC)/ CASE WHEN SUM(C6_PRUNIT) = 0 THEN 1 ELSE SUM(C6_PRUNIT) END *100,2) AS DESC_ITEM 
        FROM %Table:SC6% 
		WHERE C6_NUM = %EXP:cNumPed% 
        AND %NOTDEL%
    ENDSQL
    nDescItem := DESCITEM->DESC_ITEM
    DESCITEM->(dbclosearea())

return(nDescItem)



static function RetTotPed(cNumPed)
    BEGINSQL alias "ITENSPED"  
        SELECT SUM(C6_VALOR) AS TOT_PED 
        FROM %Table:SC6% 
        WHERE C6_NUM = %EXP:cNumPed% 
        AND %NOTDEL%
    ENDSQL
    nTotPed := ITENSPED->TOT_PED
    ITENSPED->(dbclosearea())
return(nTotPed)

static function RetTes(cNumPed)
	local nDescItem := 0
    BEGINSQL alias "CODTES"  
        SELECT DISTINCT C6_TES
        FROM %Table:SC6% 
		WHERE C6_NUM = %EXP:cNumPed% 
        AND %NOTDEL%
    ENDSQL
    nCodTes := CODTES->C6_TES
    CODTES->(dbclosearea())
return(nCodTes)
