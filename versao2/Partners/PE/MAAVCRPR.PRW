#Include 'Protheus.ch'
#Include "RWMAKE.CH"
#DEFINE ENTER CHR(13)+CHR(10)
/*
Exemplo de Ponto de Entrada para substituição de Regra
de Avaliação de Crédito.
PARAMIXB : 01 - Codigo do Cliente
02 - Loja do Cliente
03 - Valor da Operacao
04 - Moeda
05 - Pedido de Venda
*/
User Function MAAVCRPR()
	
	Local lRet 		:= .F.
	Local aArea 	:= GetArea()
	Local aDados 	:= PARAMIXB
	local lLiberou 	:= aDados[7]
	//local cCliente	:= aDados[1]
	local nVlrOper	:= aDados[3]
	//local FilialCor := xfilial("SC5")
	
	//local nNumDias := SuperGetMv("MV_RISCO"+SA1->A1_RISCO)

	//Local cSepNeg		:= If("|"$MV_CRNEG,"|",",")
	//Local cSepProv		:= If("|"$MVPROVIS,"|",",")
	//Local cSepRec		:= If("|"$MVRECANT,"|",",")

	if lLiberou
  	//	cMsg	:= "LIM - Pedido liberado automaticamente"
		RECLOCK("SC5",.F.)
			//SC5->C5_XVRLIBE := nVlrOper
			C5_XSTATUS  	:= "O"
			C5_BLQ      := ""
	//		C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
		MSUNLOCK()
		lRet := .t.
		Return lRet

	else

		if!EMPTY(SC5->C5_XVRLIBE) .AND. SC5->C5_TOTPED <= SC5->C5_XVRLIBE

			cMsg	:= "LIM - Pedido ja passou pela analise de credito"
			RECLOCK("SC5",.F.)
				C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
			MSUNLOCK()	
			lRet := .t.
			Return lRet
		endif


	endif



	restarea(aArea)
Return lRet



