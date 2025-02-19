#INCLUDE 'PROTHEUS.CH'
#INCLUDE "RWMAKE.CH"
#INCLUDE 'APWEBSRV.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TBICONN.CH'

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

User Function ValidPedGeral(cNumPed)
	local cExecRegra := alltrim( SuperGetMV('MV_XREGPED', .F., "3")) //0 nenhum, 1 Lindoia, 2 SBC e 3 Todos pedidos entra nas regras
	local rArea      := Getarea()
	private lOk        := .t.

//POSICIONA REGISTROS
	DBSELECTAREA("SC5")
	SC5->(DBSETORDER(1),DBSEEK(XFILIAL("SC5")+cNumPed))

	private cTabela     := SC5->C5_TABELA
	private cCliente    := SC5->(C5_CLIENTE+C5_LOJACLI)
	private cCondPag    := SC5->C5_CONDPAG

	SA1->(DBSETORDER(1),DBSEEK(XFILIAL("SA1")+cCliente))
	private cDescCli    := SA1->(A1_DESC+A1_DESCON1+A1_DESCON2+A1_DESCON3)
	private cCliDesc   := SA1->A1_DESCON4

	// PEGA DESCONTO DO CABEÇALHO
	private nDescCab := SC5->(C5_DESC1+C5_DESC2+C5_DESC3+C5_DESC4) + ROUN(SC5->(C5_DESCONT/C5_TOTPED*100),2) + ROUN(SC5->(C5_DESCBOL/C5_TOTPED*100),2) + ROUN(SC5->(C5_OUTDESC/C5_TOTPED*100),2)
	private nCabDesc :=  ROUN(SC5->(C5_DESCONT/C5_TOTPED*100),2)

	//PEGA DESCONTO DOS ITENS
	BEGINSQL alias "DESCITEM"
        SELECT ROUND(SUM(C6_VALDESC)/ CASE WHEN SUM(C6_PRUNIT) = 0 THEN 1 ELSE SUM(C6_PRUNIT) END *100,2) AS DESC_ITEM 
        FROM %Table:SC6%
        WHERE C6_NUM = %EXP:cNumPed% 
        AND %NOTDEL%
	ENDSQL
	private nDescItem := DESCITEM->DESC_ITEM
	DESCITEM->(dbclosearea())

	BeginSql Alias "DESCSC6"
        SELECT C6_NUM
        FROM %Table:SC6% SC6
        LEFT JOIN %Table:SC5% SC5 ON SC5.C5_NUM = SC6.C6_NUM AND SC5.%NOTDEL%
        LEFT JOIN %Table:DA1% DA1 ON DA1.DA1_CODPRO = SC6.C6_PRODUTO AND SC5.C5_TABELA = DA1.DA1_CODTAB AND DA1.%NOTDEL%
        WHERE C6_NUM = %EXP:cNumPed% 
        AND SC6.%NOTDEL%
        AND C6_VALOR < DA1_PRCVEN 
	EndSql
	private _DesccSC6 := DESCSC6->C6_NUM
	DESCSC6->(dbclosearea())

//VALIDA PARAMETRO BASICO DA REGRA
	if cExecRegra == "0"
		return()
	elseif cExecRegra <> "3"
		IF SC5->C5_EMISNF <> cExecRegra
			return()
		ENDIF
	endif

// 1 - VALIDA Financeiro
	if lOk
		ValidaFinanceiro(SC5->C5_NUM)
	endif
// 2 - VALIDA COMERCIAL
	if lOk
		ValidaComercial(SC5->C5_NUM)
	endif
// 3 - VALIDA LOGISTICA
	if lOk
		ValidaLogistica(SC5->C5_NUM)
	endif
// 4 - VALIDA CONTROLADORIA
	if lOk
		ValidaControladoria(SC5->C5_NUM)
	endif

// 6 Pedio OK limpa campos de bloqueio
	IF lOk
		IF SC5->C5_XIMPRIM <> 'S' .and. POSICIONE("DA0",1,XFILIAL("DA0")+SC5->C5_TABELA,"DA0_XSEGUE") <> '005'
			lOk := .F.
			cMsg    := "PEDIDO LIBERADO MAS NAO IMPRESSO"
			reclock("SC5",.F.)
			C5_XSTATUS  := "N"
			C5_BLQ      := ""
			C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
			msunlock()
		ENDIF
	endif


// 6 Pedio OK limpa campos de bloqueio
	IF lOk
		cMsg    := "PEDIDO LIBERADO "
		reclock("SC5",.F.)
		C5_XSTATUS  := "O"
		C5_BLQ      := ""
		C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
		msunlock()
	endif
	restarea(rArea)
return()

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

Static function ValidaFinanceiro(cNumPed)
	LOCAL cTpBloq := ""

	if !(!Empty(SC5->C5_LIBEROK).And.Empty(SC5->C5_NOTA))
		Process_libAber(cNumPed)
	ENDIF

	cTpBloq := bloqPed(cNumPed,xFilial("SC5"))



	if cTpBloq == 'C' //credito
		lOk     := .f.
		cMsg	:= "LIM - Pedido nao atendendeu requisitos da analise de credito"
		RECLOCK("SC5",.F.)
		C5_XSTATUS  := "F"
		// C5_BLQ      := "1"
		C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
		MSUNLOCK()
	elseif cTpBloq == 'E' //estoque
		
		
		if SC5->C5_XLIBEST == 'L'
		
			cQuery := "UPDATE "
			cQuery += RetSqlName("SC9")+" "	
			cQuery += "SET C9_BLEST = ' ' "
			cQuery += " WHERE D_E_L_E_T_ <> '*' AND C9_BLCRED =  ' ' AND C9_BLEST = '02' "
			cQuery += " AND C9_PEDIDO = '"+SC5->C5_NUM+"'"
			nRet := TcSqlExec(cQuery)


			cMsg	:= "EST - Ja Liberado estoque (xLibEstoque)"
			RECLOCK("SC5",.F.)
				//C5_XSTATUS  	:= "O"
				C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
			MSUNLOCK()

		else	
	
			lOk     := .f.
			cMsg	:= "EST - Pedido possui itens sem estoque disponivel."
			RECLOCK("SC5",.F.)
				C5_XSTATUS  := "E"
				// C5_BLQ      := "1"
				C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
			MSUNLOCK()
		endif
	endif
return()

/*TESTE PARA NAO LIBERAR MAIS ESTOQUE
	if cTpBloq == 'C' //credito
		lOk     := .f.
		cMsg	:= "LIM - Pedido nao atendendeu requisitos da analise de credito"
		RECLOCK("SC5",.F.)
		C5_XSTATUS  := "F"
		// C5_BLQ      := "1"
		C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
		MSUNLOCK()
	endif
return()
/TESTE PARA NAO LIBERAR MAIS ESTOQUE*/




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

Static function ValidaComercial(cNumPed)

//VALIDAÇÃO DE TAELAS DE PREÇO DE ACORDO COM TABELA MPA  
	IF MPA->(DBSEEK(XFILIAL("MPA")+cCliente))
		if ! cTabela $ MPA->MPA_TABELA
			lOk     := .f.
			cMsg    := "COMERCIAL - Tabela de Preço nao encontrada na rotina Tabelas de Preço x Clientes"
			reclock("SC5",.F.)
			C5_XSTATUS  := "C"
			C5_BLQ      := "1"
			C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
			msunlock()
		endif
	ENDIF

//VALIDAÇÃO DE CONDIÇÃO DE PAGAMENTO DE ACORDO COM TABELA MPB  
	IF MPB->(DBSEEK(XFILIAL("MPB")+cCliente))
		if ! cCondPag $ MPB->MPB_COND
			lOk     := .f.
			cMsg    := "COMERCIAL - Condição de pagamentro nao encontrada na rotina Condição de Pagamento x Clientes"
			reclock("SC5",.F.)
			C5_XSTATUS  := "C"
			C5_BLQ      := "1"
			C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
			msunlock()
		endif
	ENDIF

//VALIDA DESCONTO PONTUAL PARA ANALISE COMERCIAL

	if SC5->C5_DESCPON == '1'
		if (nDescCab) <= cDescCli
			lOk     := .f.
			cMsg    := "COMERCIAL - Solicitação de desconto não atendida"
			reclock("SC5",.F.)
			C5_XSTATUS  := "C"
			C5_BLQ      := "1"
			C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
			msunlock()
		Endif
	endif
return()

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

Static function ValidaLogistica(cNumPed)

	Local _ExcPed	:= GetNextAlias()
	Local nExcPed   := ""

	BeginSql Alias "ExcPed"
	SELECT C5_INTEXT, C5_EMISNF, C5_NUM, C5_EMISSAO, C5_CLIENTE, C5_NOMECLI, C5_TOTPED, C5_NOTA, C5_DATFAT, C5_TABELA, C5_TPFRETE, C5_PBRUTO
	FROM %Table:SC5% 
	WHERE D_E_L_E_T_ <> '*'
	AND C5_NOTA = ''
	AND C5_TPFRETE = 'C'
	AND C5_NUM = %EXP:cNumPed%
	ORDER BY C5_PBRUTO
	EndSql
	private nExcPed := ExcPed->C5_NUM
	ExcPed->(dbclosearea())

//Se o pedido for CIF e não for de tabelas pertencentes ao varejo a logística deverá informar o valor do frete

	IF !Empty(nExcPed)
		IF SC5->C5_TPFRETE == 'C' .AND. EMPTY(SC5->(C5_FRETE+C5_FREINT)) .and. POSICIONE("DA0",1,XFILIAL("DA0")+SC5->C5_TABELA,"DA0_XSEGUE") <> '005'
			lOk := .f.
			cMsg    := "LOGISTICA - Pedido CIF necessita de valor de Frete informado"
			reclock("SC5",.F.)
			C5_XSTATUS  := "L"
			// C5_BLQ      := "1"
			C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
			msunlock()
		ENDIF
	Endif

return()


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

Static function ValidaControladoria(cNumPed)

//VALIDAÇÃO DE DESCONTO CONTROLADORIA

	//PEGA DESCONTO DO CABEÇALHO

	
	If  (SC5->C5_XGRFRE  + SC5->C5_XGRDESC + SC5->C5_XGRTOTP) = 0  .or. ;
		SC5->C5_XGRFRE <> SC5->C5_FRETE + SC5->C5_FREINT .OR. ;
		SC5->C5_XGRDESC <> RetDescont(SC5->C5_NUM)+ SC5->C5_DESCONT + SC5->C5_PDESCAB + SC5->C5_DESCBOL + SC5->C5_OUTDESC .OR. ;
		SC5->C5_XGRTOTP <> RetTotPed(SC5->C5_NUM)



		iF SC5->(C5_DESC1+C5_DESC2+C5_DESC3+C5_DESC4+C5_DESCONT+C5_DESCBOL+C5_OUTDESC) > 0
			nPerDesc := POSICIONE("DA0",1,XFILIAL("DA0")+SC5->C5_TABELA,"DA0_DESC1")

			If cDescCli > 0
				IF alltrim(SC5->C5_TIPOP2) $ '|R$|PIX|DA|'
					cDescCli += 3
					cCliDesc += 3
				ENDIF
				if nDescCab > cDescCli .and. nDescCab > nPerDesc
				//if (nDescCab+nDescItem) > cDescCli
					lOk     := .f.
					cMsg    := "CONTROLADORIA - Pedido possui desconto  informado maior que do cadastro do cliente ou da tabela de preço"
					reclock("SC5",.F.)
					C5_XSTATUS  := "T"
					C5_BLQ      := "1"
					C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
					msunlock()
				endif
			Elseif cCliDesc > 0
				IF alltrim(SC5->C5_TIPOP2) $ '|R$|PIX|DA|'
					cCliDesc += 3
				ENDIF
				if nCabDesc > cCliDesc .and. nDescCab > nPerDesc 
				//if (nCabDesc+nDescItem) > cCliDesc
					lOk     := .f.
					cMsg    := "CONTROLADORIA - Pedido possui desconto informado maior que do cadastro do cliente ou da tabela de preço"
					reclock("SC5",.F.)
					C5_XSTATUS  := "T"
					C5_BLQ      := "1"
					C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
					msunlock()
				endif
			elseif cDescCli .or. cCliDesc = 0
				IF alltrim(SC5->C5_TIPOP2) $ '|R$|PIX|DA|' .AND. nPerDesc = 0
						nPerDesc += 3
				ENDIF
				if nDescCab  > nPerDesc //Se o valor de desconto informado for maior de um % determinado dentro da tabela o pedido terá que ser avaliado pela controladoria.
					lOk     := .f.
					cMsg    := "CONTROLADORIA - Pedido possui Valor de Desconto informado maior que informado na tabela"
					reclock("SC5",.F.)
					C5_XSTATUS  := "T"
					C5_BLQ      := "1"
					C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
					msunlock()
				endif
			Endif
		endif


	//PEGA DESCONTO NO ITEM

		if !EMPTY(_DesccSC6) .and. cTabela <> '010' // inserido a tabela 010 para poder pegar a regra de desconto criada pelo romulo da controladoria em 26/01/2026 para os casos de galão
			lOk     := .f.
			cMsg    := "CONTROLADORIA - Pedido possui valor de item menor que a tabela informada"
			reclock("SC5",.F.)
			C5_XSTATUS  := "T"
			C5_BLQ      := "1"
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
			lOk     := .f.
			cMsg    := "CONTROLADORIA - TES informado precisa de avaliação"
			reclock("SC5",.F.)
			C5_XSTATUS  := "T"
			C5_BLQ      := "1"
			C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
			msunlock()
		ENDIF
		DESCITEM->(dbclosearea())

		//Se o valor do frete informado for maior de um % determinado dentro da tabela o pedido terá que ser avaliado pela controladoria.
		nVlrFrt := SC5->(C5_FRETE+C5_FREINT)
		nPerFrt := POSICIONE("DA0",1,XFILIAL("DA0")+SC5->C5_TABELA,"DA0_XPFRETE")
		nTotPed := SC5->C5_TOTPED
		if (nVlrFrt/nTotPed)*100 > nPerFrt
			lOk     := .f.
			cMsg    := "CONTROLADORIA - Pedido possui Valor de Frete informado maior que informado na tabela"
			reclock("SC5",.F.)
			C5_XSTATUS  := "T"
			C5_BLQ      := "1"
			C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,100) + " | " + cUserName + ENTER
			msunlock()

		endif
	EndIf	
return()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Divisor				                                            																     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

static function Process_libAber(cNumPed)
	dbSelectArea("SC6")
	DBSetOrder(1)
	MsSeek( xFilial("SC6") + cNumPed )

	nValTot := 0
	While !EOF() .And. SC6->C6_NUM == cNumPed .And. SC6->C6_FILIAL == xFilial("SC6")
		nValTot += SC6->C6_VALOR

		dbSelectArea("SF4")
		dBSetOrder(1)
		MsSeek( xFilial("SF4") + SC6->C6_TES )

		If RecLock("SC5")
			nQtdLib := SC6->C6_QTDVEN
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Recalcula a Quantidade Liberada                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RecLock("SC6") //Forca a atualizacao do Buffer no Top
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Libera por Item de Pedido                                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Begin Transaction
                /*
                ±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
                ±±³Funcao    ³MaLibDoFat³ Autor ³Eduardo Riera          ³ Data ³09.03.99 ³±±
                ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
                ±±³Descri+.o ³Liberacao dos Itens de Pedido de Venda                      ³±±
                ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
                ±±³Retorno   ³ExpN1: Quantidade Liberada                                  ³±±
                ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
                ±±³Transacao ³Nao possui controle de Transacao a rotina chamadora deve    ³±±
                ±±³          ³controlar a Transacao e os Locks                            ³±±
                ±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
                ±±³Parametros³ExpN1: Registro do SC6                                      ³±±
                ±±³          ³ExpN2: Quantidade a Liberar                                 ³±±
                ±±³          ³ExpL3: Bloqueio de Credito                                  ³±±
                ±±³          ³ExpL4: Bloqueio de Estoque                                  ³±±
                ±±³          ³ExpL5: Avaliacao de Credito                                 ³±±
                ±±³          ³ExpL6: Avaliacao de Estoque                                 ³±±
                ±±³          ³ExpL7: Permite Liberacao Parcial                            ³±±
                ±±³          ³ExpL8: Tranfere Locais automaticamente                      ³±±
                ±±³          ³ExpA9: Empenhos ( Caso seja informado nao efetua a gravacao ³±±
                ±±³          ³       apenas avalia ).                                    ³±±
                ±±³          ³ExpbA: CodBlock a ser avaliado na gravacao do SC9           ³±±
                ±±³          ³ExpAB: Array com Empenhos previamente escolhidos            ³±±
                ±±³          ³       (impede selecao dos empenhos pelas rotinas)          ³±±
                ±±³          ³ExpLC: Indica se apenas esta trocando lotes do SC9          ³±±
                ±±³          ³ExpND: Valor a ser adicionado ao limite de credito          ³±±
                ±±³          ³ExpNE: Quantidade a Liberar - segunda UM                    ³±±
                */

				MaLibDoFat(SC6->(RecNo()),@nQtdLib,.F.,.F.,.T.,.T.,.F.,.F.) // primeiro Lucas
				//MaLibDoFat(SC6->(RecNo()),@nQtdLib,.F.,.T.,.F.,.T.,.F.,.F.) // Lucas 11.02.2022
				//MaLibDoFat(SC6->(RecNo()),@nQtdLib,.F.,.F.,.F.,.F.,.F.,.F.) // original Lucas nao avalia
				//MaLibDoFat(SC6->(RecNo()),@nQtdLib,.T.,.T.,.T.,.T.,.F.,.F.) // primeiro Lucas
			End Transaction
		EndIf
		SC6->(MsUnLock())
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza o Flag do Pedido de Venda                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Begin Transaction
			SC6->(MaLiberOk({cNumPed},.F.))
		End Transaction
		dbSelectArea("SC6")
		dbSkip()
	End
	SC6->(dbCloseArea())


return()


static function bloqPed(nPedido,cFil)
	LOCAL blqEst
	LOCAL BlqCre
	local cRet

//Verifica credito
	cQuery := " select DISTINCT "
	cQuery += " CASE WHEN C9_BLCRED = '' "
	cQuery += " THEN 'L' else 'C' end as C9_BLCRED "
	cQuery += " from "+RETSQLNAME("SC9")+" SC9 "
	cQuery += " WHERE SC9.D_E_L_E_T_ <> '*'
	cQuery += " AND C9_PEDIDO = '"+nPedido+"'"
	cQuery += " and C9_BLCRED <> '10' "

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.)

	DBSELECTAREA("TMP")
	BlqCre :=  TMP->C9_BLCRED
	TMP->(dbclosearea())

//Verifica credito
	cQuery := " select DISTINCT "
	cQuery += " CASE WHEN C9_BLEST = '' "
	cQuery += " THEN 'L' else 'E' end as C9_BLEST  "
	cQuery += " from "+RETSQLNAME("SC9")+" SC9 "
	cQuery += " WHERE SC9.D_E_L_E_T_ <> '*'
	cQuery += " AND C9_PEDIDO = '"+nPedido+"'"
	cQuery += " AND C9_FILIAL = '"+cFil+"'"
	cQuery += " and C9_BLEST <> '10' "

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.)

	DBSELECTAREA("TMP")
	blqEst := TMP->C9_BLEST
	TMP->(dbclosearea())

	if BlqCre == 'C'
		cRet := BlqCre
	elseif blqEst == 'E'
		cRet := blqEst
	else
		cRet := 'L'
	endif

RETURN(cRet)

//=====================================================================================

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
