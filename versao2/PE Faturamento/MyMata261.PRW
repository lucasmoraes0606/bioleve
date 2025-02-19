#Include "protheus.ch"
#Include "rwmake.ch"
#Include "tbiconn.ch"

User Function MyMata261(alista,cArmtrans)

	Local aAuto 		:= {}
	Local aLinha 		:= {}
	Local ENDER01		:= criavar("D3_LOCALIZ")
	Local nOpcAuto 		:= 3
    Local MYaAreas 	    := GetArea()
    Local MYaAreaSD3    := SD3->(GetArea())
    Local MYaAreaSB1    := SB1->(GetArea())    
	Local nX
	Local _xcn 

	Private lMsErroAuto := .F.

//Cabecalho a Incluir
	aadd(aAuto,{GetSxeNum("SD3","D3_DOC"),dDataBase}) //Cabecalho

	for nX := 1 to len(alista) //step 2

		aLinha := {}
//Origem 
		SB1->(DbSeek(xFilial("SB1")+PadR(alista[nX][1], tamsx3('D3_COD') [1])))
		aadd(aLinha,{"ITEM",Strzero(nX,3),Nil})
		aadd(aLinha,{"D3_COD", alista[nX][1], Nil}) //Cod Produto origem
		aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida origem
		aadd(aLinha,{"D3_LOCAL", alista[nX][4], Nil}) //armazem origem
		aadd(aLinha,{"D3_LOCALIZ", ENDER01,Nil}) //Informar endereço origem

//Destino 
		SB1->(DbSeek(xFilial("SB1")+PadR(alista[nX][2], tamsx3('D3_COD') [1])))
		aadd(aLinha,{"D3_COD", alista[nX][2], Nil}) //cod produto destino
		aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida destino
		aadd(aLinha,{"D3_LOCAL", cArmtrans, Nil}) //armazem destino
		aadd(aLinha,{"D3_LOCALIZ", ENDER01,Nil}) //Informar endereço destino

		aadd(aLinha,{"D3_NUMSERI", "", Nil}) //Numero serie
		aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote Origem
		aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote origem
		aadd(aLinha,{"D3_DTVALID", '', Nil}) //data validade
		aadd(aLinha,{"D3_POTENCI", 0, Nil}) // Potencia
		aadd(aLinha,{"D3_QUANT", alista[nX][3], Nil}) //Quantidade
		aadd(aLinha,{"D3_QTSEGUM", alista[nX][5], Nil}) //Seg unidade medida
		aadd(aLinha,{"D3_ESTORNO", "", Nil}) //Estorno
		aadd(aLinha,{"D3_NUMSEQ", "", Nil}) // Numero sequencia D3_NUMSEQ

		aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote destino
		aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote destino
		aadd(aLinha,{"D3_DTVALID", '', Nil}) //validade lote destino
		aadd(aLinha,{"D3_ITEMGRD", "", Nil}) //Item Grade

		aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod origem
		aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod destino
//		aadd(aLinha,{"D3_XSD2REC", Alltrim(str(alista[nX][6])), Nil}) // recno do arquivo SD2

		aAdd(aAuto,aLinha)

	Next nX

	MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)

	if lMsErroAuto
		MostraErro()
	Else
		aAreaATU  := GetArea()
		aAreaSD3  := SD3->(GetArea())
		dbSelectarea("SD3")
		SD3->(dbSetorder(2))
		For _xcn := 1 to Len(alista)
			If SD3->(DbSeek(SD3->(D3_FILIAL+aAuto[1][1]+alista[_xcn][1])))
				If SD3->(!eof()) .And. SD3->(D3_FILIAL+aAuto[1][1])+alista[_xcn][1] == SD3->D3_FILIAL+SD3->D3_DOC+SD3->D3_COD
						If RecLock("SD3",.F.)

							D3_XSD2REC := alista[_xcn][7]+alista[_xcn][8]+alista[_xcn][9]+alista[_xcn][10]

							MsUnlock()
						Else
							ApmgInfo("Atenção","Registro Bloqueado SD3,"+ aAuto[1][1]+" - "+alista[nX][1])
						EndIf
					Endif
			Else
				ApmgInfo("Atenção","Registro não localizado no SD3, "+ aAuto[1][1]+" - "+alista[nX][1])
			Endif
		Next _xcn
		RestArea(aAreaATU)
		RestArea(aAreaSD3)
	EndIf

	RestArea(MYaAreas)
	RestArea(MYaAreaSD3)
	RestArea(MYaAreaSB1)

Return
