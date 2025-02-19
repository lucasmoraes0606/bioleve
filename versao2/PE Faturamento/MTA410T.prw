#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
User Function MTA410T()

	Local aArea := GetArea()
	IF SM0->M0_CODIGO $ "12/31/32"
		IF INCLUI
			U_TotPed(SC5->C5_NUM)
			RestArea(aArea)

//		U_ValidPedGeral(SC5->C5_NUM)
//		RestArea(aArea)
			
		ElseIF ALTERA

			IF FWIsInCallStack("MATA410") //esta função esta perguntando se na pilha de execução passou pelo MATA410

				U_TotPed(SC5->C5_NUM)
				RestArea(aArea)

			ENDIF
		EndIF
	Endif

Return .t.

User Function TotPed(cNumPed)

	Local aArea := GetArea()
	nItem 		:= 0
	nValIcmSt 	:= 0
	nDesconto 	:= 0
	nNrItem		:= 0
	nVlrTotal 	:= 0.00
	nVlrMerc	:= 0.00
	nTotDesc 	:= 0.00
	nTotST		:= 0.00
	nIPI 		:= 0.00
	nICM 		:= 0.00
	nValIcm 	:= 0.00
	nValIpi 	:= 0.00
	nTotIpi 	:= 0.00
	nTotIcms 	:= 0.00
	nTotDesp 	:= 0.00
	nTotFrete 	:= 0.00
	nTotalNF 	:= 0.00
	nTotSeguro 	:= 0.00
	nTotMerc 	:= 0.00
	nTotIcmSol 	:= 0.00
	nPesoBruto 	:= 0.00
	nVolume     := 0

	If !SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+cNumPed))
		RestArea(aArea)
		Return .f.
	Endif

	MaFisIni(SC5->C5_CLIENTE,; 				// 01-Codigo Cliente/Fornecedor
	SC5->C5_LOJACLI,; 						// 02-Loja do Cliente/Fornecedor
	"C",; 									// 03-C:Cliente , F:Fornecedor
	SC5->C5_TIPO,; 							// 04-Tipo da NF
	SC5->C5_TIPOCLI,; 						// 05-Tipo do Cliente/Fornecedor
	MaFisRelImp("MTR700",{"SC5","SC6"}),; 	// 06-Relacao de Impostos que suportados no arquivo
	,; 										// 07-Tipo de complemento
	,; 										// 08-Permite Incluir Impostos no Rodape .T./.F.
	"SB1",; 								// 09-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
	"MTR700")								// 10-Nome da rotina que esta utilizando a funcao

	If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+cNumPed))
		While !Eof() .And. SC6->C6_FILIAL = xFilial("SC6") .And. SC6->C6_NUM == cNumPed
			nNritem+=1
			dbSkip()
		Enddo
	Endif

	If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+cNumPed))
		While SC6->(!Eof()) .And. xFilial("SC6")==SC6->C6_FILIAL .And. SC6->C6_NUM == cNumPed
			nItem ++
			MaFisAdd(SC6->C6_PRODUTO,; 	// 01-Codigo do Produto ( Obrigatorio )
			SC6->C6_TES,; 				// 02-Codigo do TES ( Opcional )
			SC6->C6_QTDVEN,; 			// 03-Quantidade ( Obrigatorio )
			SC6->C6_PRCVEN,; 			// 04-Preco Unitario ( Obrigatorio )
			nDesconto,; 				// 05-Valor do Desconto ( Opcional )
			nil,; 						// 06-Numero da NF Original ( Devolucao/Benef )
			nil,; 						// 07-Serie da NF Original ( Devolucao/Benef )
			nil,; 						// 08-RecNo da NF Original no arq SD1/SD2
			SC5->C5_FRETE/nNritem,; 	// 09-Valor do Frete do Item ( Opcional )
			SC5->C5_DESPESA/nNritem,; 	// 10-Valor da Despesa do item ( Opcional )
			SC5->C5_SEGURO/nNritem,; 	// 11-Valor do Seguro do item ( Opcional )
			0,; 						// 12-Valor do Frete Autonomo ( Opcional )
			SC6->C6_Valor+nDesconto,; 	// 13-Valor da Mercadoria ( Obrigatorio )
			0,; 						// 14-Valor da Embalagem ( Opcional )
			0,; 						// 15-RecNo do SB1
			0) 							// 16-RecNo do SF4
			nIPI 		:= MaFisRet(nItem,"IT_ALIQIPI")
			nICM 		:= MaFisRet(nItem,"IT_ALIQICM")
			nValIcm 	:= MaFisRet(nItem,"IT_VALICM")
			nValIpi 	:= MaFisRet(nItem,"IT_VALIPI")
			_nValSol 	:= MaFisRet(1,"NF_VALSOL" )
			nTotIpi		:= MaFisRet(, 'NF_VALIPI')
			nTotIcms 	:= MaFisRet(, 'NF_VALICM' )
			nTotDesp 	:= MaFisRet(, 'NF_DESPESA' )
			nTotFrete 	:= MaFisRet(, 'NF_FRETE' )
			nTotalNF 	:= MaFisRet(, 'NF_TOTAL' )
			nTotSeguro 	:= MaFisRet(, 'NF_SEGURO' )
			nTotST      := MaFisRet(, 'NF_VALIMP')
			aValIVA 	:= MaFisRet(,"NF_VALIMP")
			nTotMerc 	:= MaFisRet(,"NF_TOTAL")
			nTotIcmSol 	:= MaFisRet(nItem, 'NF_VALSOL' )
			nPesoBruto 	:= nPesoBruto + SC6->C6_PESOB
			nVolume 	:= nVolume + SC6->C6_QTDVEN
			SC6->(DbSkip())

		EndDo
		nVlrMerc 	:= Round(nTotMerc - _nValSol - nTotIpi,2)
		nVlrTotal 	:= Round(nTotMerc + nTotSeguro + nTotDesp - nTotDesc,2)
 	Endif

	RECLOCK("SC5")
	SC5->C5_TOTMERC := Round( nVlrMerc, 2 )
	SC5->C5_TOTPED  := Round( nVlrTotal, 2 )
	SC5->C5_PBRUTO  := Round( nPesoBruto, 2 )
	SC5->C5_VOLUME1 := Round( nVolume, 0 )
	MsUnlock("SC5")

	if c5_condPAG <> 'BNF'
		if C5_TIPOP2 $ 'BO    '
			IF SC5->C5_DESCBOL = 0.00
				dbSelectArea("SA1")
				dbSetOrder(1)
				dbSeek(XFILIAL()+SC5->C5_CLIENTE)
				RECLOCK("SC5")
				SC5->C5_DESCBOL := (nVlrTotal * (SA1->A1_DESCON1 / 100))
				SC5->C5_OUTDESC := 0.00
				MsUnlock("SC5")
			Endif
		Else
			IF SC5->C5_OUTDESC = 0.00
				dbSelectArea("SA1")
				dbSetOrder(1)
				dbSeek(XFILIAL()+SC5->C5_CLIENTE)
				RECLOCK("SC5")
				SC5->C5_OUTDESC := (nVlrTotal * (SA1->A1_DESCON2 / 100))
				SC5->C5_DESCBOL := 0.00
				MsUnlock("SC5")
			Endif
		Endif
	Endif

	RestArea(aArea)
	MaFisEnd() //Termino
Return .f.
