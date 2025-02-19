//Bibliotecas
#Include 'Protheus.ch'
#Include 'RwMake.ch'
#DEFINE ENTER CHR(13)+CHR(10)

/*------------------------------------------------------------------------------------------------------*
 | P.E.:  MTA455P                                                                                       |
 | Desc:  Validação de liberação de estoque Manual                                                      |
 | Links: http://tdn.totvs.com/pages/releaseview.action?pageId=6784411                                  |
 *------------------------------------------------------------------------------------------------------*/
 
User Function MTA455P()

    Local aArea   := GetArea()
    Local aAreaC9 := SC9->(GetArea())
    Local aAreaC6 := SC6->(GetArea())
    Local aAreaC5 := SC5->(GetArea())
    Local lRet := .T.
	Local cNumSc5 := SC5->C5_NUM

	//Limpa estoque
	cQuery := "UPDATE "
	cQuery += RetSqlName("SC9")+" "	
	cQuery += "SET C9_BLEST = ' ' "
	cQuery += " WHERE D_E_L_E_T_ <> '*' AND C9_BLEST = '02' "
	cQuery += " AND C9_PEDIDO = '"+cNumSc5+"'"
	nRet := TcSqlExec(cQuery)

  		cMsg	:= "EST - Estoque liberado manualmente"
		RECLOCK("SC5",.F.)
			C5_XSTATUS  	:= "O"
			C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
		MSUNLOCK()

	RestArea(aAreaC5)
	RestArea(aAreaC6)
	//RestArea(aAreaC5)
	RestArea(aArea)

Return lRet

User Function MTA455I()
	U_ValidPedGeral(SC5->C5_NUM)
return()
