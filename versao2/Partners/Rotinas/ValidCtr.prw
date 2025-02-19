#INCLUDE 'PROTHEUS.CH'
#INCLUDE "RWMAKE.CH"
#INCLUDE 'APWEBSRV.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'

#DEFINE ENTER CHR(13)+CHR(10)

// FIZEMOS ESSA SEPARAÇÃO PARA A ANALISE DO OMS, POIS A ANALISE SERÁ DEPOIS DO RATEIO DO FRETE.

User function ValidCtr(cNumPed)

//VALIDAÇÃO DE DESCONTO CONTROLADORIA

	//PEGA DESCONTO DO CABEÇALHO

	If  (SC5->C5_XGRFRE  + SC5->C5_XGRDESC + SC5->C5_XGRTOTP) = 0  .or. SC5->C5_XGRFRE <> SC5->C5_FRETE + SC5->C5_FREINT .OR. SC5->C5_XGRDESC <> RetDescont(SC5->C5_NUM)+ SC5->C5_DESCONT + SC5->C5_PDESCAB + SC5->C5_DESCBOL + SC5->C5_OUTDESC .OR. SC5->C5_XGRTOTP <> RetTotPed(SC5->C5_NUM)

		if (nDescCab+nDescItem) > cDescCli
			//lOk     := .f.
			cMsg    := "CONTROLADORIA - Pedido possui desconto informado maior que do cadastro do cliente"
			reclock("SC5",.F.)
			C5_XSTATUS  := "T"
			//  C5_BLQ      := "1"
			C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
			msunlock()
		endif

		//PEGA DESCONTO NO ITEM

		if !EMPTY(_DesccSC6)
			//lOk     := .f.
			cMsg    := "CONTROLADORIA - Pedido possui valor de item menor que a tabela informada"
			reclock("SC5",.F.)
			C5_XSTATUS  := "T"
			// C5_BLQ      := "1"
			C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
			msunlock()
		endif

//Se o pedido conter alguma TES determinada em uma listagem ele tem que ser avaliado pela controladoria.

		BEGINSQL alias "DESCITEM"
        SELECT F4_XAVALIA  AVALIA 
        FROM %Table:SC6%  SC6
        INNER JOIN %Table:SF4%   SF4 ON SF4.%NOTDEL% 
            AND F4_FILIAL = %EXP:XFILIAL("SF4")% 
            AND F4_CODIGO = C6_TES 
        WHERE C6_NUM = %EXP:cNumPed% 
        AND SC6.%NOTDEL%
        AND F4_XAVALIA = 'S'
		ENDSQL
		IF DESCITEM->(!EOF())
		//	lOk     := .f.
			cMsg    := "CONTROLADORIA - TES informado precisa de avaliação"
			reclock("SC5",.F.)
			C5_XSTATUS  := "T"
			//C5_BLQ      := "1"
			C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
			msunlock()
		ENDIF
		DESCITEM->(dbclosearea())

		//Se o valor do frete informado for maior de um % determinado dentro da tabela o pedido terá que ser avaliado pela controladoria.
		nVlrFrt := SC5->(C5_FRETE+C5_FREINT)
		nPerFrt := POSICIONE("DA0",1,XFILIAL("DA0")+SC5->C5_TABELA,"DA0_XPFRETE")
		nTotPed := SC5->C5_TOTPED
		if (nVlrFrt/nTotPed)*100 > nPerFrt
		//	lOk     := .f.
			cMsg    := "CONTROLADORIA - Pedido possui Valor de Frete informado maior que informado na tabela"
			reclock("SC5",.F.)
			C5_XSTATUS  := "T"
			// C5_BLQ      := "1"
			C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
			msunlock()
    	endif
	
    else

		cMsg    := "PEDIDO LIBERADO PELO OMS "
		reclock("SC5",.F.)
		C5_XSTATUS  := "O"
		C5_BLQ      := ""
		C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
		msunlock()
	Endif

return()

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
