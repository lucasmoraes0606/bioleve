#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TRANSPR º Autor ³ WWW.R2SISTEMA.COM.BR º Data ³  01/10/24   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Transferencia de predido entre empresas                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
/*/
User function TRANSFPED()

	Private oDlgProd
	Private cPedido  := Space(06)


	Private aTrFilial 	:= TRFEMP()

	Private cJust		:= " "

	DEFINE MSDIALOG oDlgProd TITLE "Transferencia de pedidos entre filiais" FROM 0,0 TO 190,490 OF oDlgProd PIXEL
	@ 05, 10 SAY "Pedido: " of oDlgProd PIXEL
	@ 14, 10 MSGET cPedido PICTURE "@!" F3 "SC5" VALID !Vazio() .And. existcpo("SC5",cPedido,,,,.F.)  SIZE 60,10 PIXEL OF oDlgProd
	@ 29, 10 SAY "Filial:" of oDlgProd PIXEL
	@ 37, 10 COMBOBOX oJust VAR cJust ITEMS aTrFilial SIZE 130,10 PIXEL OF oDlgProd

	DEFINE SBUTTON FROM 80,160 TYPE 1  OF oDlgProd ACTION BioPed() ENABLE
	DEFINE SBUTTON FROM 80,190 TYPE 2  OF oDlgProd ACTION Close(oDlgProd) ENABLE

	ACTIVATE MSDIALOG oDlgProd CENTER


Return

//--------------------------
Static Function BioPed()
//------------------------

	Local nOpcX    := 3      //Seleciona o tipo da operacao (3-Inclusao / 4-Alteracao / 5-Exclusao)
	Local aCabec   := {}	//Cabecalho do pedido de vendas
	Local aItens   := {}	//Itens do pedido de vendas
	Local cNumPed  := ""	//Numero do Pedido

	Private lMsErroAuto    := .F.
	Private oApp_Ori 	   := oApp

	dbSelectArea("SC5")//Cabecalho pedido de vendas
	dbSetOrder(1)
	AA:=0
	If dbSeek(xFilial("SC5")+cPedido)

		AA:=0
        //PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT" TABLES "SC5","SC6","SA1","SA2","SB1","SB2","SF4"
        //RpcClearEnv() 
        //   cNumPed := GetSxeNum("SC5", "C5_NUM")
        //{"C5_NUM"    , cNumPed          ,Nil},; // Tipo do Pedido
        //{"C5_FILIAL" , Subs(cJust,1,2)  ,Nil},; //Empresa/Filial

		aCabec  :=   {{"C5_TIPO"   , SC5->C5_TIPO     ,Nil},; // Tipo do Pedido
		{"C5_CLIENTE", SC5->C5_CLIENTE  ,Nil},; // Codigo do Cliente
		{"C5_LOJACLI", SC5->C5_LOJACLI  ,Nil},; // Loja do Cliente
		{"C5_CLIENT" , SC5->C5_CLIENT   ,Nil},; // Codigo do Cliente para entrega
		{"C5_LOJAENT", SC5->C5_LOJAENT  ,Nil},; // Loja para entrega
		{"C5_TIPOCLI", SC5->C5_TIPOCLI  ,Nil},; // Tipo do Cliente
		{"C5_UFDEST" , SC5->C5_UFDEST   ,Nil},; // UF Destino
		{"C5_CONDPAG", SC5->C5_CONDPAG  ,Nil},; // Condicao de pgto   abaixo
		{"C5_VEND1"  , SC5->C5_VEND1    ,Nil},; // Vendedor
		{"C5_NATUREZ", SC5->C5_NATUREZ  ,Nil},; // Vendedor
		{"C5_MENNOTA", SC5->C5_MENNOTA  ,Nil},; // Mensagem pra nota com funcao FwCutOff para remover enter da string (Romulo 15.08.2018)
		{"C5_TPFRETE", SC5->C5_TPFRETE  ,Nil}} // Tipo de frete
        //		{"C5_TABELA" , SC5->C5_TABELA   ,Nil},; // Tabela
        //		{"C5_PEDCLI" , SC5->C5_PEDCLI   ,Nil},; // Numero pedido de compra do cliente
        //		{"C5_DATA"   , SC5->C5_DATA     ,Nil},; // Data da inclusao do pedido no sistema protheus
        //		{"C5_HORA"   , SC5->C5_HORA     ,Nil},; // Hora de Entrada do pedido no sistema
        //		{"C5_EMISNF" , SC5->C5_EMISNF   ,Nil},; // Emis NF do pedido
        //		{"C5_OBSFLA" , SC5->C5_OBSFLA   ,Nil},; // Mensagem pra nota com funcao FwCutOff para remover enter da string (Romulo 01.09.2020)
        //		{"C5_TIPOP2" , SC5->C5_TIPOP2   ,Nil},; // Tipo de operaracao pagamento
        //		{"C5_TIPO2"  , SC5->C5_TIPO2    ,Nil},; // Tipo de operaracao pagamento   -- incluido por alexandre 11/07/2014
        //		{"C5_TIPOP"  , SC5->C5_TIPOP    ,Nil},; // Tipo de operaracao pagamento   -- incluido por alexandre 11/07/2014
        //		{"C5_OBSCOP" , SC5->C5_OBSCOP   ,Nil},; // Tipo de opercaracao pagamento
        //		{"C5_CLIFLD" , SC5->C5_CLIFLD   ,Nil},;	// Empresa
        //		{"C5_PEDSFA" , SC5->C5_PEDSFA   ,Nil},; // Numero SFA
        //		{"C5_PERC"   , SC5->C5_PERC     ,Nil},; // Percentual do Pedido
        //		{"C5_INTEXT" , SC5->C5_INTEXT   ,Nil},;	// Origem do Pedido interno ou externo
        //		{"C5_FECENT" , SC5->C5_FECENT   ,Nil},; // Data de entrega colocada no apk
        //		{"C5_PESSOA" , SC5->C5_PESSOA   ,Nil},; // Tipo de pessoa
        //		{"C5_EMPFAT" , SC5->C5_EMPFAT   ,Nil},; // Empresa para Faturamento
        //		{"C5_DESCPON", SC5->C5_DESCPON  ,Nil},; // Tem desconto
        //		{"C5_AGEND"  , SC5->C5_AGEND    ,Nil}}  // Agendamento

		aa:=0

		RPCSetEnv("01",Subs(cJust,1,4),,,"FAT",,,,,,)
		dbSelectArea("SC5")//Cabecalho pedido de vendas
		cNumPed := GetSxeNum("SC5", "C5_NUM")

		//aCabec  :=   {{"C5_NUM"    , cNumPed          ,Nil}} // Numero Pedido
        //	aadd(aCabec, {{"C5_NUM"    	,cNumPed    	 , Nil}} 

        //RpcClearEnv()

		aa:=0
		dbSelectArea("SC6")	//Itens pedido de vendas
		dbSetOrder(1)
        
        //{"C6_FILIAL" 	,Subs(cJust,1,2) , Nil},; // Filial
        //{"C6_NUM"    	,cNumPed    	 , Nil},; // Numero do Pedido
		
        If dbSeek(xFilial("SC6")+cPedido)
			aa:=0
			While SC5->C5_NUM == SC6->C6_NUM
				aa:=0
				aadd(aItens, {{"C6_NUM"    	,cNumPed    	 , Nil},; // Numero do Pedido
    				{"C6_ITEM"   	,SC6->C6_ITEM	 , Nil},; // Numero do Item no Pedido
	    			{"C6_PRODUTO"	,SC6->C6_PRODUTO , Nil},; // Codigo do Produto
		    		{"C6_UM"	 	,SC6->C6_UM 	 , Nil},; // Unidade de Medida Primar.
			    	{"C6_QTDVEN" 	,SC6->C6_QTDVEN  , Nil},; // Quantidade Vendida
				    {"C6_TES"	 	,SC6->C6_TES     , Nil},; // Tipo de Entrada/Saida do Item
    				{"C6_LOCAL"  	,SC6->C6_LOCAL   , Nil},; // Almoxarifado
	    			{"C6_CLI"	 	,SC6->C6_CLI     , Nil},;
					{"C6_LOJA"	 	,SC6->C6_LOJA    , Nil},;
					{"C6_PRUNIT" 	,SC6->C6_PRCVEN  , Nil},; // Preco Unit.
		    		{"C6_PRCVEN" 	,SC6->C6_PRCVEN  , Nil},; // Preco Unit.
			    	{"C6_VALOR"  	,SC6->C6_VALOR   , Nil},; // Valor Tot.
				    {"C6_ENTREG" 	,SC6->C6_ENTREG  , Nil}}) // Data Entrega.
                    //				{"C6_OPER"   	,SC6->C6_OPER    , Nil},; // Unidade de Medida Primar.
                    //				{"C6_PRUNIT" 	,SC6->C6_PRUNIT  , Nil},; // Preco Unit.
                    //				{"C6_DESCRI" 	,SC6->C6_DESCRI  , Nil},; // Descricao
                    //				{"C6_PEDSFA" 	,SC6->C6_PEDSFA  , Nil}) // numero SFA
				SC6->(dbSkip())
				aa:=0
			Enddo
			// aa:=0
            //RPCSetEnv(Subs(cJust,1,2) , Subs(cJust,1,2),,,"FAT",,,,,,)
			aa:=0
			MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aCabec, aItens, nOpcX, .F.)

			If !lMsErroAuto
				ApmsgInfo("TUDO OK COM A TRANSFERENCIA "+cNumPed,"PEDIDO TRANSFERIDO ==="+cNumPed)
			Else
				ConOut("Erro na inclusao!")
				MOSTRAERRO()
			EndIf
			//   RESET ENVIRONMENT
		Else
			AA:=0
			ApmsgInfo("PEDIDO NÃO LOCALIZADO","PEDIDO-ITENS-SC6")
		Endif
		AA:=0
	Else
		AA:=0
		ApmsgInfo("PEDIDO NÃO LOCALIZADO","PEDIDO-CABECALHO-SC5")
	Endif
	AA:=0

	ApmsgInfo("OK","FIM")

Return(.t.)

//--------------------------
Static Function TRFEMP(aTrFilial)
//------------------------

	aSM0 := FWLoadSM0()

	aTrFilial	:=	{}

	cEmp01 	:= "" //Codigo Empresa
	cEmp02 	:= "" //Codigo Filial
	cEmp03 	:= "" //Nome Grupo
	cEmp04 	:= "" //Nome Filial
	nI		:=	0

	For nI := 1 To Len(aSM0)

		If cFilant <> aSM0[nI][2]

			//Adiciona um array com vários elementos
			aAdd(aTrFilial,Alltrim(aSM0[nI][2])+"/"+Alltrim(aSM0[nI][6])+"/"+Alltrim(aSM0[nI][7]))

		EndIf

	Next nI

Return(aTrFilial)
