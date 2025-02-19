#INCLUDE 'PROTHEUS.CH'
#INCLUDE "RWMAKE.CH"
#include "protheus.ch"

#DEFINE ENTER CHR(13)+CHR(10)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  XlibEstoque  º Autor ³ LUCAS PEREIRA   º Data ³  22/09/22    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Liberação de estoque manual							      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                     		  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function XlibEstoque()
	local lTransparent	:= .F.	
	local oFont2  		:= TFont():New("Goudy Old Style",,020,,.T.,,,,,.F.,.F.) 
	local oFont1  		:= TFont():New("MS Sans Serif",,011,,.F.,,,,,.F.,.F.)
	local oFont3  		:= TFont():New("MS Sans Serif",,013,,.T.,,,,,.F.,.F.)
	
	Private oOk		  	:= LoadBitmap(GetResources(), "WFCHK")
	Private oNo		  	:= LoadBitmap(GetResources(), "WFUNCHK") 

	Private aPedsBlq	:= RetPedsBlq()

	oDlgMonitor := MSDialog():New(0,0,475, 1000,'Liberação de Estoque',,,,/*nOr(WS_VISIBLE,WS_POPUP)*/,CLR_BLACK,CLR_WHITE,,,.T.,,,,lTransparent)
	//oTButClose	:= TBtnBmp2():New( 00, 980   ,30,30,'close1.png',,,,{||oDlgMonitor:end() },oDlgMonitor ,,,.T. )
	//oSay4		:= TSay():New(  005	, 210	,{||"Liberação de Estoque"}	, oDlgMonitor,,oFont2,,,,.T.,8421504,,500,15)

	
	oBrowse := TCBrowse():New( 03 , 03, 495, 210,, {'x','Pedido','Pedido SFA','Cliente','Nome'},{10,20,20,20,50}, oDlgMonitor,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
 

	oBrowse:SetArray(aPedsBlq)
	oBrowse:bLine := {||{ If(aPedsBlq[oBrowse:nAt,01],oOK,oNO),;
								aPedsBlq[oBrowse:nAt,02],;
								aPedsBlq[oBrowse:nAt,03],;
								aPedsBlq[oBrowse:nAt,04],;
								aPedsBlq[oBrowse:nAt,05]} }

	oBrowse:bHeaderClick := {|o, nCol| Marca(1) }
	oBrowse:bLDblClick 	:= {|| Marca(2,oBrowse:nAt) }


	oTButton1 	:= TButton():New( 220 , 350, "Lib. Manual" ,oDlgMonitor,{||  Processa({|| LibManual()},"Liberando Pedidos...") , oDlgMonitor:end()  }	, 65,12,,,.F.,.T.,.F.,,.F.,,,.F. )	
	oTButton1 	:= TButton():New( 220 , 430, "Sair" ,oDlgMonitor,{|| oDlgMonitor:end()  }	, 65,12,,,.F.,.T.,.F.,,.F.,,,.F. )	

	oDlgMonitor:Activate(,,,.T.,{||.T.},,{||} )
return()


static function Marca(nOpc,nPos)
	local x
	if nOpc == 1
		for x:=1 to len(aPedsBlq)
			aPedsBlq[x,1] := !aPedsBlq[x,1]
		next x
	else	
		aPedsBlq[nPos,1] := !aPedsBlq[nPos,1]
	endif

	oBrowse:SetArray(aPedsBlq)
	oBrowse:bLine := {||{ If(aPedsBlq[oBrowse:nAt,01],oOK,oNO),;
								aPedsBlq[oBrowse:nAt,02],;
								aPedsBlq[oBrowse:nAt,03],;
								aPedsBlq[oBrowse:nAt,04],;
								aPedsBlq[oBrowse:nAt,05]} }
	oBrowse:refresh()

return()



Static Function RetPedsBlq()
	local aRet := {}
	local cTabela := GetNextAlias()

	BEGINSQL alias cTabela
		SELECT DISTINCT C9_PEDIDO  FROM %TABLE:SC9% SC9
		WHERE SC9.%NOTDEL%
		AND C9_FILIAL = '00'
		AND C9_BLEST = '02'
		AND C9_BLCRED =  ' '
	ENDSQL
	WHILE (cTabela)->(!EOF())

		IF SC5->(DBSETORDER(1),DBSEEK(XFILIAL("SC5")+(cTabela)->C9_PEDIDO))
			AADD(aRet,{	.T.,;
						(cTabela)->C9_PEDIDO,;
						SC5->C5_PEDSFA,;
						SC5->C5_CLIENTE,;
						SC5->C5_NOMECLI;
			})
		ENDIF
		(cTabela)->(DBSKIP())
	ENDDO
	(cTabela)->(DBCLOSEAREA())

	if empty(aRet)
		aadd(aRet,{.f.,"","","",""})
	endif
Return(aRet)



static function LibManual()
	local x

	procregua(len(aPedsBlq))
	for x:=1 to len(aPedsBlq)
		if aPedsBlq[x,1]
			
			if empty(aPedsBlq[x,2])
				return()
			endif

			cNumSc5 := aPedsBlq[x,2]
			
			incproc("Pedido "+ cNumSc5)

			IF SC5->(DBSETORDER(1),DBSEEK(XFILIAL("SC5")+cNumSc5))
				/*cQuery := "UPDATE "
				cQuery += RetSqlName("SC9")+" "	
				cQuery += "SET C9_BLEST = ' ' "
				cQuery += " WHERE D_E_L_E_T_ <> '*' AND C9_BLEST = '02' "
				cQuery += " AND C9_PEDIDO = '"+cNumSc5+"'"
				nRet := TcSqlExec(cQuery)*/


				cMsg	:= "EST - Estoque liberado manualmente (xLibEstoque)"
				RECLOCK("SC5",.F.)
					//C5_XSTATUS  	:= "O"
					C5_XLIBEST	:= 'L'
					C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
				MSUNLOCK()

				U_ValidPedGeral(SC5->C5_NUM)
			endif
		endif
	next x

	 
return()
