#Include "PROTHEUS.CH"
#define ENTER Chr(13)+Chr(10)
//--------------------------------------------------------------
/*/CRIADO POR JÚLIO CÉSAR                                                    
 
 	Fonte criado para realizar alteração geral nas rotinas de Vinculos de cliente
                                                                                                       
@since 03/04/2018                                                   
/*/                                                             
//--------------------------------------------------------------

User Function MPINT70(nOp, cTitulo)    
	local cTexto := "Alterando: "+cTitulo
	local cTitle := "Alteração Geral: "+cTitulo
	local cHelp  := "1 - Irá adicionar os itens selecionados nos cadastros dos clientes, mantendo os já existentes."+ENTER;
					+"2 - Irá substituir os itens dos cadastros dos clientes pelos selecionados."+ENTER;
					+"3 - Irá remover (se econtrar) os itens selecionados dos cadastros dos clientes."
	private cDados := ""
	private oListCli
	private aClientes := {}
	private lCanAply  := .F.
	private aTipos	  := {"1 - Adicionar", "2 - Substituir", "3 - Excluir"}
	private nCombo
	
  DEFINE MSDIALOG oDlg1 TITLE cTitle FROM 000, 000  TO 275, 580 COLORS 0, 16777215 PIXEL

   	@ 002, 002 GROUP oGroup1 TO 137, 164 PROMPT "Clientes a serem alterados" OF oDlg1 COLOR 0, 16777215 PIXEL
    
	    @ 010, 004 LISTBOX oListCli Fields HEADER "Codigo","Descricao" SIZE 159, 108 OF oGroup1 PIXEL ColSizes 20,50
		    
	    @ 123, 102 BUTTON oButton1 PROMPT "Limpar" SIZE 029, 012 OF oGroup1 PIXEL action removeAll(oListCli, aClientes)
	    @ 123, 133 BUTTON oButton2 PROMPT "Incluir" SIZE 029, 012 OF oGroup1 PIXEL action FiltroGeral()
	    
    @ 002, 168 GROUP oGroup2 TO 047, 291 PROMPT "Alterações" OF oDlg1 COLOR 0, 16777215 PIXEL
	    @ 010, 170 SAY oSay1 PROMPT cTexto SIZE 117, 008 OF oGroup2 COLORS 0, 16777215 PIXEL
	    @ 020, 170 SAY oSay2 PROMPT "Selecine os itens." SIZE 117, 008 OF oGroup2 COLORS 0, 16777215 PIXEL
	    
	    @ 033, 171 MSGET oDados VAR cDados SIZE 071, 010 OF oGroup2 COLORS 0, 16777215 PIXEL WHEN .F.
	    @ 033, 243 BUTTON oButton3 PROMPT "Buscar" SIZE 029, 012 OF oGroup2 PIXEL action BuscaDados(nOp)
	   
	@ 49, 168 GROUP oGroup3 TO 100, 291 PROMPT "Tipo de alteração" OF oDlg1 COLOR 0, 16777215 PIXEL
		@ 60, 170 SAY oSay3 PROMPT "Selecione o tipo de alteração que deseja fazer." SIZE 117, 008 OF oGroup3 COLORS 0, 16777215 PIXEL
		@ 70, 170 COMBOBOX oCombo1 VAR nCombo ITEMS aTipos SIZE 117, 008 OF oGroup3 PIXEL
		@ 86, 260 BUTTON oButton4 PROMPT "Ajuda?" SIZE 029, 012 OF oGroup3 PIXEL action MsgInfo(cHelp, "Ajuda")
	
	@ 123, 261 BUTTON oButton5 PROMPT "Aplicar" SIZE 029, 012 OF oDlg1 PIXEL action AplicarAlt(nOp, oCombo1:nAt)
	@ 123, 230 BUTTON oButton6 PROMPT "Cancelar" SIZE 029, 012 OF oDlg1 PIXEL action oDlg1:end()

	refreshList(oListCli, aClientes)

  ACTIVATE MSDIALOG oDlg1 CENTERED

Return

static function AplicarAlt(nOp, nCombo)
	local nX, nCount := nCount2 := 0
	local aRet       := {0, 0}
	local aInsert 	 := {}
	local cAlt		 := ""
	if Empty(aClientes)
		alert('Nenhum cliente selecionado.')
		return
	endif
	if Empty(cDados)
		if !msgYesNo('Atenção! Você está aplicando uma alteração com dados em branco! Tem certeza que quer limpar os dados cadastrados?', 'ATENÇÃO')
			return
		endif
	endif
	do case
		case nOp == 1	// TABELA DE PREÇO
			dbselectarea('MPA')
			dbsetorder(1)
			for nX := 1 to len(aClientes)
				if dbseek(xFilial('MPA')+ aClientes[nX,1] + aClientes[nX,3])
					if RecLock('MPA', .F.)
						do case
							case nCombo == 1
								cAlt := addIn(MPA->MPA_TABELA, cDados)
							case nCombo == 2
								cAlt := cDados
							case nCombo == 3
								cAlt := removeFrom(MPA->MPA_TABELA, cDados)
						endcase
						Replace MPA->MPA_TABELA with cAlt
						Replace MPA->MPA_XMPTRA with 'A'
						MsUnlock()
						nCount2++
					else
						nCount++
					endif
				else
					aAdd(aInsert, {;
						xFilial("MPA"),;
						aClientes[nX, 1],;
						aClientes[nX, 3],;
						aClientes[nX, 2],;
						cDados})
					nCount++
				endif
			next nX
		case nOp == 2	// CONDIÇÃO DE PAGAMENTO
			dbselectarea('MPB')
			dbsetorder(1)
			for nX := 1 to len(aClientes)
				if dbseek(xFilial('MPB')+ aClientes[nX,1] + aClientes[nX,3])
					if RecLock('MPB', .F.)
						do case
							case nCombo == 1
								cAlt := addIn(MPB->MPB_COND, cDados)
							case nCombo == 2
								cAlt := cDados
							case nCombo == 3
								cAlt := removeFrom(MPB->MPB_COND, cDados)
						endcase
						Replace MPB->MPB_COND with cAlt
						Replace MPB->MPB_XMPTRA with "A"
						MsUnlock()
						nCount2++
					else
						nCount++
					endif
				else
					aAdd(aInsert, {;
						xFilial("MPB"),;
						aClientes[nX, 1],;
						aClientes[nX, 3],;
						aClientes[nX, 2],;
						cDados})
					nCount++
				endif
			next nX
		case nOp == 3	// VENDEDORES
			dbselectarea('MPG')
			dbsetorder(1)
			for nX := 1 to len(aClientes)
				if dbseek(xFilial('MPG')+ aClientes[nX,1] + aClientes[nX,3])
					if RecLock('MPG', .F.)
						do case
							case nCombo == 1
								cAlt := addIn(MPG->MPG_VEND, cDados)
							case nCombo == 2
								cAlt := cDados
							case nCombo == 3
								cAlt := removeFrom(MPG->MPG_VEND, cDados)
						endcase
						Replace MPG->MPG_VEND with cAlt
						Replace MPG->MPG_XMPTRA with 'A'
						MsUnlock()
						nCount2++
					else
						nCount++
					endif
				else
					aAdd(aInsert, {;
						xFilial("MPG"),;
						aClientes[nX, 1],;
						aClientes[nX, 3],;
						aClientes[nX, 2],;
						cDados})
					nCount++
				endif
			next nX
	case nOp == 4	// TAGS
			dbselectarea('MPJ')
			dbsetorder(1)
			for nX := 1 to len(aClientes)
				if dbseek(xFilial('MPJ')+ aClientes[nX,1] + aClientes[nX,3])
					if RecLock('MPJ', .F.)
						do case
							case nCombo == 1
								cAlt := addIn(MPJ->MPJ_TAG, cDados)
							case nCombo == 2
								cAlt := cDados
							case nCombo == 3
								cAlt := removeFrom(MPJ->MPJ_TAG, cDados)
						endcase
						Replace MPJ->MPJ_TAG with cAlt
						Replace MPJ->MPJ_XMPTRA with 'A'
						MsUnlock()
						nCount2++
					else
						nCount++
					endif
				else
					aAdd(aInsert, {;
						xFilial("MPJ"),;
						aClientes[nX, 1],;
						aClientes[nX, 3],;
						aClientes[nX, 2],;
						cDados})
					nCount++
				endif
			next nX
		otherwise
		alert('ERRO')
	endcase
	cEndMsg := cValToChar(nCount2) + ' cadastros(s) alterado(s).'
	if nCount > 0		
		if msgYesNo('Deseja inserir os cadastros que não foram encontrados?', 'Cadastrar Dados não Encontrados')
			aRet := inserir(nOp, aInsert)
			cEndMsg += CHR(13)+cValToChar(aRet[1]) + ' cadastro(s) inserido(s).'
		endif
		nCount += aRet[2] - aRet[1]
	endif
	cEndMsg += CHR(13)+cValToChar(nCount) + ' erro(s).'
	msgalert(cEndMsg, 'Alteração Finalizada')
return
// BUSCAR CLIENTES

static function inserir(nOp, aDados)
	local nX
	local nI := 0
	local nE := 0
	if nOp == 1
		for nX := 1 to len(aDados)
			if RecLock('MPA', .T.)
				MPA->MPA_FILIAL	 := aDados[nX, 1]
				MPA->MPA_CLIENT  := aDados[nX, 2]
				MPA->MPA_LOJA    := aDados[nX, 3]
				MPA->MPA_NOME	 := aDados[nX, 4]
				MPA->MPA_TABELA  := aDados[nX, 5]
				MPA->MPA_XMPTRAN := 'A'
				MsUnlock()
				nI++
			else
				nE++
			endif
		next nX
	elseif nOp == 2
		for nX := 1 to len(aDados)
			if RecLock('MPB', .T.)
				MPB->MPB_FILIAL	 := aDados[nX, 1]
				MPB->MPB_CLIENT  := aDados[nX, 2]
				MPB->MPB_LOJA    := aDados[nX, 3]
				MPB->MPB_NOME	 := aDados[nX, 4]
				MPB->MPB_COND    := aDados[nX, 5]
				MPB->MPB_XMPTRA  := 'A'
				MsUnlock()
				nI++
			else
				nE++
			endif
		next nX
	elseif nOp == 3
		for nX := 1 to len(aDados)
			if RecLock('MPG', .T.)
				MPG->MPG_FILIAL	 := aDados[nX, 1]
				MPG->MPG_CLIENT  := aDados[nX, 2]
				MPG->MPG_LOJA    := aDados[nX, 3]
				MPG->MPG_NOME	 := aDados[nX, 4]
				MPG->MPG_VEND    := aDados[nX, 5]
				MPG->MPG_XMPTRA  := 'A'
				MsUnlock()
				nI++
			else
				nE++
			endif
		next nX
	elseif nOp == 4
		for nX := 1 to len(aDados)
			if RecLock('MPJ', .T.)
				MPJ->MPJ_FILIAL	 := aDados[nX, 1]
				MPJ->MPJ_CLIENT  := aDados[nX, 2]
				MPJ->MPJ_LOJA    := aDados[nX, 3]
				MPJ->MPJ_NOME	 := aDados[nX, 4]
				MPJ->MPJ_TAG     := aDados[nX, 5]
				MPJ->MPJ_XMPTRA  := 'A'
				MsUnlock()
				nI++
			else
				nE++
			endif
		next nX
	endif
return {nI, nE}

static function BuscaDados(nOp)
	do case
		case nOp == 1	//Tabelas de preço
			cDados := consulta('TABELA_PRC')
		case nOp == 2
			cDados := consulta('COND_PAG')
		case nOp == 3
			cDados := consulta('VEND')
		case nOp == 4
			cDados := consulta('TAGS')
	endcase
	oDados:Refresh()
return

static function FiltroGeral()   
	local rArea				:= getarea()
	local aRet				:= {}
	local nLin				:= 0
	local nDist				:= 20
	aRet 					:= tamSX3('A1_COD')
	private lExec           := .F.
	private cCod			:= Space(aRet[1]) 
	private cDescri	  		:= Space(20)
	private cAteCod 		:= Space(aRet[1])
	private cEstados		:= Space(50)
	private cMun			:= Space(50)
	private cVend			:= Space(50)
	private cCoordenador	:= Space(50)
	private cGerSetorial	:= Space(50)
	private cGerNacional	:= Space(50)
	private cDiretor		:= Space(50)
	private cRamo			:= Space(50)
	private cSegment		:= Space(50)
	private	cGrpVen			:= Space(50)
	private cGrpTrib		:= Space(50)
	private aListFilter 	:= {}
	private aListSel		:= {}
	
	DadosFiltro()
	
	DEFINE MSDIALOG oDlg TITLE "Filtro Geral" FROM 000, 000  TO 430, 800 COLORS 0, 16777215 PIXEL
		@ 001, 085 GROUP oGroup2 TO 190, 223 PROMPT "Busca" OF oDlg COLOR 0, 16777215 PIXEL
		    @ 193, 090 SAY oSay10 PROMPT "Duplo clique seleciona o item"		SIZE 100, 007 OF oDlg COLORS 0, 16777215 PIXEL
		    @ 008, 088 LISTBOX oListFilter Fields HEADER "Codigo","Descricao" 	SIZE 130, 176 OF oGroup2 PIXEL ColSizes 20,50   ;
		    	ON dblClick(eval({|| addSelected(aListFilter, oListFilter:nAt, aListSel), refreshList(oListSelect, aListSel)}))
		    
		    refreshList(oListFilter, aListFilter)
		    
	    @ 001, 248 GROUP oGroup3 TO 190, 386 PROMPT "Selecionados" OF oDlg COLOR 0, 16777215 PIXEL
		   	@ 193, 253 SAY oSay11 PROMPT "Duplo clique remove o item"		SIZE 100, 007 OF oDlg COLORS 0, 16777215 PIXEL
		    @ 008, 251 LISTBOX oListSelect Fields HEADER "Codigo","Descricao" SIZE 130, 176 OF oGroup3 PIXEL ColSizes 20,50   ;
		   		ON dblClick(eval({|| removeSelected(aListSel, oListSelect:nAt), refreshList(oListSelect, aListSel)}))
		
		   	refreshList(oListSelect, aListSel)
		   
		   //------
	    @ 001, 002 GROUP oGroup1 TO 207, 080 PROMPT "Filtros" OF oDlg COLOR 0, 16777215 PIXEL    
		    
		    nLin := 10
		
		    @ nLin, 008 SAY oSay4 PROMPT "Vendedores" 		SIZE 070, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
		    @ nLin+8, 008 MSGET oVend VAR cVend		SIZE 060, 010 OF oGroup1 COLORS 0, 16777215 PIXEL WHEN .F.  
		    @ nLin+8, 068 BUTTON oButton10 	PROMPT "?"	 	SIZE 05, 012 OF oGroup1 PIXEL Action consulta("VENDEDOR")
		    
			nLin += nDist
    
		    @ nLin, 008 SAY oSay6 PROMPT "Coordenador" 	SIZE 070, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
		    @ nLin+8, 008 MSGET oGrpven VAR cCoordenador	SIZE 060, 010 OF oGroup1 COLORS 0, 16777215 PIXEL WHEN .F.  
		    @ nLin+8, 068 BUTTON oButton9 	PROMPT "?"	 	SIZE 05, 012  OF oGroup1 PIXEL Action consulta("COORDENADOR")
		    
		    nLin += nDist
    
		    @ nLin, 008 SAY oSay6 PROMPT "Gerente Setorial" 	SIZE 070, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
		    @ nLin+8, 008 MSGET oGrpTrib VAR cGerSetorial		SIZE 060, 010 OF oGroup1 COLORS 0, 16777215 PIXEL WHEN .F.  
		    @ nLin+8, 068 BUTTON oButton12 	PROMPT "?"	 	SIZE 05, 012  OF oGroup1 PIXEL Action consulta("GERSETORIAL")

		    nLin += nDist
    
		    @ nLin, 008 SAY oSay6 PROMPT "Gerente Nacinal" 	SIZE 070, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
		    @ nLin+8, 008 MSGET oGrpven VAR cGerNacional			SIZE 060, 010 OF oGroup1 COLORS 0, 16777215 PIXEL WHEN .F.  
		    @ nLin+8, 068 BUTTON oButton9 	PROMPT "?"	 	SIZE 05, 012  OF oGroup1 PIXEL Action consulta("GERNACIOAL")
		    
		    nLin += nDist
    
		    @ nLin, 008 SAY oSay6 PROMPT "Diretor" 	SIZE 070, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
		    @ nLin+8, 008 MSGET oGrpTrib VAR cDiretor			SIZE 060, 010 OF oGroup1 COLORS 0, 16777215 PIXEL WHEN .F.  
		    @ nLin+8, 068 BUTTON oButton12 	PROMPT "?"	 	SIZE 05, 012  OF oGroup1 PIXEL Action consulta("DIRETOR")

		    nLin += nDist
			
		    @ nLin, 008 SAY oSay4 PROMPT "Estados" 			SIZE 040, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
		    @ nLin+8, 008 MSGET oEstados VAR cEstados		SIZE 060, 010 OF oGroup1 COLORS 0, 16777215 PIXEL WHEN .F.  
		    @ nLin+8, 068 BUTTON oButton7 	PROMPT "?"	 	SIZE 05, 012 OF oGroup1 PIXEL Action consulta("ESTADO")
		    
		    nLin += nDist
		    
		    @ nLin, 008 SAY oSay5 PROMPT "Municipios" 		SIZE 040, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
		    @ nLin+8, 008 MSGET oMun VAR cMun				SIZE 060, 010 OF oGroup1 COLORS 0, 16777215 PIXEL WHEN .F.   
		    @ nLin+8, 068 BUTTON oButton8 	PROMPT "?"	 	SIZE 05, 012  OF oGroup1 PIXEL Action consulta("CIDADE")
		    
		    nLin += nDist
    
		    @ nLin, 008 SAY oSay6 PROMPT "Segmento" 		SIZE 070, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
		    @ nLin+8, 008 MSGET oSegment VAR cSegment			SIZE 060, 010 OF oGroup1 COLORS 0, 16777215 PIXEL WHEN .F.  
		    @ nLin+8, 068 BUTTON oButton13 	PROMPT "?"	 	SIZE 05, 012  OF oGroup1 PIXEL Action consulta("SEGMENTO")
		    


		    @ 186, 40 BUTTON oButton1 PROMPT "Buscar" 		SIZE 037, 012 OF oDlg PIXEL action {||DadosFiltro()}
		    
		   //------
		    @ 060, 224 BUTTON oButton1 PROMPT "Todos >" 	SIZE 023, 012 OF oDlg PIXEL action {|| addAll(aListFilter, aListSel), refreshList(oListSelect, aListSel)}
		    @ 104, 224 BUTTON oButton6 PROMPT "Limpar" 		SIZE 023, 012 OF oDlg PIXEL action {|| removeAll(oListSelected, aListSel)}
		    
		    @ 200, 350 BUTTON oButton3 PROMPT "Confirmar" 	SIZE 037, 012 OF oDlg PIXEL action {|| lExec  := .T. , oDlg:end() }
		    @ 200, 310 BUTTON oButton4 PROMPT "Cancelar" 	SIZE 037, 012 OF oDlg PIXEL action oDlg:end()

	   ACTIVATE MSDIALOG oDlg CENTERED
	  
	  
	if lExec   
		aClientes := aListSel 
		refreshList(oListCli, aClientes)
	endif  
	
	restarea(rArea)  
return() 

static function DadosFiltro()   	
   
	cQuery := "	SELECT A1_LOJA AS LOJA, A1_COD+A1_LOJA AS COD, A1_NOME AS DESCRI FROM "+RETSQLNAME("SA1")+" SA1
	cQuery += "	WHERE SA1.D_E_L_E_T_ <> '*'
		
	IF !EMPTY(cEstados)
		cQuery += " AND A1_EST IN ("+ALLTRIM(cEstados)+")" 
	ENDIF
	
	IF !EMPTY(cMun)
		cQuery += " AND A1_COD_MUN IN ("+ALLTRIM(cMun)+")" 
	ENDIF
	
	IF !EMPTY(cGrpVen)
		cQuery += " AND A1_GRPVEN IN ("+ALLTRIM(cGrpven)+")" 
	ENDIF
	
	IF !EMPTY(cVend)
		cQuery += " AND A1_VEND IN ("+ALLTRIM(cVend)+")" 
	ENDIF
	
	IF !EMPTY(cRamo)
		cQuery += " AND A1_SATIV1 IN ("+ALLTRIM(cRamo)+")" 
	ENDIF
	
	IF !EMPTY(cGrpTrib)
		cQuery += " AND A1_GRPTRIB IN ("+ALLTRIM(cGrpTrib)+")" 
	ENDIF
	
	IF !EMPTY(cSegment)
		cQuery += " AND A1_CODSEG IN ("+ALLTRIM(cSegment)+")" 
	ENDIF


	IF !EMPTY(cCoordenador)
		cQuery += " AND A1_COORD IN ("+ALLTRIM(cCoordenador)+")" 
	ENDIF

	IF !EMPTY(cGerSetorial)
		cQuery += " AND A1_GERSET IN ("+ALLTRIM(cGerSetorial)+")" 
	ENDIF

	IF !EMPTY(cGerNacional)
		cQuery += " AND A1_GERNAC IN ("+ALLTRIM(cGerNacional)+")" 
	ENDIF

	IF !EMPTY(cDiretor)
		cQuery += " AND A1_DIRETOR IN ("+ALLTRIM(cDiretor)+")" 
	ENDIF

	
	cQuery += " ORDER BY A1_COD, A1_NOME" 
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.) 
	aListFilter := {}
	WHILE TMP->(!EOF())
		AADD(aListFilter,{TMP->COD, TMP->DESCRI, TMP->LOJA})    
		TMP->(DBSKIP())
	ENDDO
	TMP->(DBCLOSEAREA())
	
	if type("oListFilter")<> "U"
		refreshList(oListFilter, aListFilter)
	endif
return()

static function addAll(aList1, aList2)
	local nX, nY, nOp
	for nX := 1 to len(aList1)
		for nY := 1 to len(aList2)
			if aList1[nX, 1] == aList2[nY, 1]
				nOp := 1
				exit
			endif
		next nY
		if nOp != 1
			aAdd(aList2, aList1[nX])
		endif
		nOp := 0
	next nX
return()

static function removeAll(oList, aList)
	aList := {}
	refreshList(oList, aList)
return()

static function refreshList(oList, aDados)
	oList:SetArray(aDados)
	if empty(aDados)
		oList:bLine := {|| {;
		"",;
		"";
		}}
	else 
	    oList:bLine := {|| {;
	      aDados[oList:nAt,1],;
	      aDados[oList:nAt,2];
	    }}
    endif   
    oList:refresh()
return

static function consulta(cTipo)
	local rArea				:= getarea() 

	private lExec           := .F.
	private cCodigo			:= Space(10) 
	private cDesc	  		:= Space(50)
	private aListCon	 	:= {}
	private aListSelCon		:= {}
	PRIVATE oOk 			:= LoadBitmap( GetResources(), "LBOK")
	PRIVATE oNo    			:= LoadBitmap( GetResources(), "LBNO") 
	Private cRet    		:= ""
	
	DadosCon(cTipo)
	MontaCon(cTipo)

	restarea(rArea)
return cRet

static function DadosCon(cTipo)   
	DO CASE
		CASE cTipo  ==  "CIDADE"   
			cQuery := " SELECT CC2_CODMUN AS COD, CC2_EST+'-'+CC2_MUN AS DESCRI FROM "+RETSQLNAME("CC2")+" CC2 "
			cQuery += " WHERE CC2.D_E_L_E_T_ <> '*' "
			IF !EMPTY(cEstados)
				cQuery += " AND CC2_EST IN ("+ALLTRIM(cEstados)+")"
			ENDIF
			IF !EMPTY(cCodigo)		
				cQuery += " AND CC2_CODMUN LIKE '%"+ALLTRIM(cCodigo)+"%'"
			ENDIF
			IF !EMPTY(cDesc)
				cQuery += " AND CC2_MUN LIKE '%"+ALLTRIM(cDesc)+"%'" 
			ENDIF			
			cQuery += " ORDER BY CC2_EST, CC2_MUN"
			
		CASE cTipo  ==  "ESTADO" 
			cQuery := "SELECT X5_CHAVE AS COD, X5_DESCRI AS DESCRI FROM "+RETSQLNAME("SX5")+" SX5  "
			cQuery += " WHERE SX5.D_E_L_E_T_ <> '*'  "
			cQuery += " AND X5_TABELA = '12'  " 
			cQuery += " AND X5_FILIAL = '"+XFILIAL("SX5")+"'  "    
			
			IF !EMPTY(cCodigo)		
				cQuery += " AND X5_CHAVE LIKE '%"+ALLTRIM(cCodigo)+"%'"
			ENDIF         
			
			IF !EMPTY(cDesc)
				cQuery += " AND X5_DESCRI LIKE '%"+ALLTRIM(cDesc)+"%'"      
			ENDIF
			cQuery += " ORDER BY X5_CHAVE, X5_DESCRI"
			
		CASE cTipo  ==  "GRPVEN" 
			cQuery := "	SELECT ACY_GRPVEN AS COD, ACY_DESCRI AS DESCRI FROM "+RETSQLNAME("ACY")+" ACY  "
			cQuery += " WHERE ACY.D_E_L_E_T_ <> '*'  "  
			IF !EMPTY(cCodigo)		
				cQuery += " AND ACY_GRPVEN LIKE '%"+ALLTRIM(cCodigo)+"%'"
			ENDIF
			IF !EMPTY(cDesc)
				cQuery += " AND ACY_DESCRI LIKE '%"+ALLTRIM(cDesc)+"%'" 
			ENDIF		
			cQuery += " ORDER BY ACY_GRPVEN, ACY_DESCRI"
			
		CASE cTipo  ==  "GRPTRIB" 
			cQuery := "	SELECT DISTINCT A1_GRPTRIB AS COD, '' AS DESCRI FROM "+RETSQLNAME("SA1")+" SA1  "
			cQuery += " WHERE SA1.D_E_L_E_T_ <> '*'  "  
			IF !EMPTY(cCodigo)		
				cQuery += " AND A1_GRPTRIB LIKE '%"+ALLTRIM(cCodigo)+"%'"
			ENDIF
			cQuery += " ORDER BY A1_GRPTRIB"
			
		CASE cTipo  $ "|VENDEDOR|COORDENADOR|GERSETORIAL|GERNACIOAL|DIRETOR|"     
	
			cQuery := " select DISTINCT A3_COD AS COD ,A3_NOME  AS DESCRI "
			cQuery += " FROM "+RETSQLNAME("SA3")+" SA3   "
			cQuery += " WHERE SA3.D_E_L_E_T_ <> '*' "
				
			IF !EMPTY(cCodigo)		
				cQuery += " AND A3_COD LIKE '%"+ALLTRIM(cCodigo)+"%'"
			ENDIF
			IF !EMPTY(cDesc)
				cQuery += " AND A3_NOME LIKE '%"+ALLTRIM(cDesc)+"%'" 
			ENDIF			
			cQuery += " ORDER BY A3_COD, A3_NOME"
			
		CASE cTipo  ==  "RMATIVIDADE" 
			cQuery := "SELECT X5_CHAVE AS COD, X5_DESCRI AS DESCRI FROM "+RETSQLNAME("SX5")+" SX5  "
			cQuery += " WHERE SX5.D_E_L_E_T_ <> '*'  "
			cQuery += " AND X5_TABELA = 'T3'  " 
			cQuery += " AND X5_FILIAL = '"+XFILIAL("SX5")+"'  "        
			
			IF !EMPTY(cCodigo)		
				cQuery += " AND X5_CHAVE LIKE '%"+ALLTRIM(cCodigo)+"%'"
			ENDIF         
			
			IF !EMPTY(cDesc)
				cQuery += " AND X5_DESCRI LIKE '%"+ALLTRIM(cDesc)+"%'"      
			ENDIF	
			cQuery += " ORDER BY X5_CHAVE, X5_DESCRI"

		CASE cTipo  ==  "TABELA_PRC"       
			cQuery := " SELECT DA0_CODTAB AS COD, DA0_DESCRI AS DESCRI "
			cQuery += " FROM "+RETSQLNAME("DA0")+" DA0 "
			cQuery += " WHERE DA0.D_E_L_E_T_ <> '*'  "
	  		cQuery += " AND DA0_FILIAL =  '"+XFILIAL("DA0")+"'"
			cQuery += " AND DA0_DATATE >=  '"+DTOS(dDatabase)+"'"
			cQuery += " AND DA0_ATIVO <>  '2' "

			IF !EMPTY(cCodigo)		
				cQuery += " AND DA0_CODTAB LIKE '%"+ALLTRIM(cCodigo)+"%'"
			ENDIF
			IF !EMPTY(cDesc)
				cQuery += " AND DA0_DESCRI LIKE '%"+ALLTRIM(cDesc)+"%'" 
			ENDIF	
			
		CASE cTipo  ==  "COND_PAG"     
			cQuery := " SELECT E4_CODIGO AS COD, E4_DESCRI AS DESCRI "
			cQuery += " FROM "+RETSQLNAME("SE4")+" SE4 "
			cQuery += " WHERE SE4.D_E_L_E_T_ <> '*'  "
	  		cQuery += " AND E4_FILIAL =  '"+XFILIAL("SE4")+"'"
			cQuery += " AND E4_MSBLQL <>  '2' "
			
			IF !EMPTY(cCodigo)		
				cQuery += " AND E4_CODIGO LIKE '%"+ALLTRIM(cCodigo)+"%'"
			ENDIF
			IF !EMPTY(cDesc)
				cQuery += " AND E4_DESCRI LIKE '%"+ALLTRIM(cDesc)+"%'" 
			ENDIF
			
		CASE cTipo  ==  "VEND"     
			cQuery := " SELECT A3_COD AS COD, A3_NOME AS DESCRI "
			cQuery += " FROM "+RETSQLNAME("SA3")+" SA3 "
			cQuery += " WHERE SA3.D_E_L_E_T_ <> '*'  "
	  		cQuery += " AND A3_FILIAL =  '"+XFILIAL("SA3")+"'"
			
			IF !EMPTY(cCodigo)		
				cQuery += " AND A3_COD LIKE '%"+ALLTRIM(cCodigo)+"%'"
			ENDIF
			IF !EMPTY(cDesc)
				cQuery += " AND A3_NOME LIKE '%"+ALLTRIM(cDesc)+"%'" 
			ENDIF	
			//Traz somente vendedores integrados
			//cQuery += " AND A3_COD IN (SELECT MP1_IDPROT FROM "+RETSQLNAME("MP1")+" WHERE MP1_TPREG = 'VEND' AND MP1_IDPROT = A3_COD AND MP1_STATUS = 'I')"
			
		CASE cTipo  ==  "TAGS"     
			cQuery := " SELECT MPI_TAG AS COD, MPI_DESCRI AS DESCRI "
			cQuery += " FROM "+RETSQLNAME("MPI")+" MPI "
			cQuery += " WHERE MPI.D_E_L_E_T_ <> '*'  "
	  		cQuery += " AND MPI_FILIAL =  '"+XFILIAL("MPI")+"'"
			
			IF !EMPTY(cCodigo)		
				cQuery += " AND MPI_TAG LIKE '%"+ALLTRIM(cCodigo)+"%'"
			ENDIF
			IF !EMPTY(cDesc)
				cQuery += " AND MPI_DESCRI LIKE '%"+ALLTRIM(cDesc)+"%'" 
			ENDIF	
			//Traz somente TAGS integrados
			cQuery += " AND MPI_TAG IN (SELECT MP1_IDPROT FROM "+RETSQLNAME("MP1")+" WHERE MP1_TPREG = 'TAGS' AND MP1_IDPROT = MPI_TAG AND MP1_STATUS = 'I')"

		CASE cTipo  ==  "SEGMENTO"     
			cQuery := " SELECT AOV_CODSEG AS COD, AOV_DESSEG AS DESCRI "
			cQuery += " FROM "+RETSQLNAME("AOV")+" AOV "
			cQuery += " WHERE AOV.D_E_L_E_T_ <> '*'  "
	  		cQuery += " AND AOV_FILIAL =  '"+XFILIAL("AOV")+"'"
			
			IF !EMPTY(cCodigo)		
				cQuery += " AND AOV_CODSEG LIKE '%"+ALLTRIM(cCodigo)+"%'"
			ENDIF
			IF !EMPTY(cDesc)
				cQuery += " AND AOV_DESSEG LIKE '%"+ALLTRIM(cDesc)+"%'" 
			ENDIF	





					
	ENDCASE
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.) 
	aListCon := {}
	WHILE TMP->(!EOF())
		if !empty(TMP->COD) .Or. !empty(TMP->DESCRI)
			AADD(aListCon,{TMP->COD, TMP->DESCRI} )  
		endif  
		TMP->(DBSKIP())
	ENDDO
	TMP->(DBCLOSEAREA()) 
	
	if type("oList1")<> "U"
		refreshList(oList1, aListCon)
	endif
return

static function MontaCon(cTipo)

  DEFINE MSDIALOG oDlgfilter TITLE "Filtro" FROM 000, 000  TO 300, 800 COLORS 0, 16777215 PIXEL
	     
	    @ 002, 002 GROUP oGroup2 TO 026, 246 PROMPT "Busca" OF oDlgfilter COLOR 0, 16777215 PIXEL  
	    @ 026, 002 GROUP oGroup1 TO 131, 246 PROMPT "Detalhes" OF oDlgfilter COLOR 0, 16777215 PIXEL
	    @ 002, 248 GROUP oGroup1 TO 131, 400 PROMPT "Selecionados" OF oDlgfilter COLOR 0, 16777215 PIXEL
	    
	    @ 013, 005 SAY oSay1 PROMPT "Codigo:" SIZE 025, 007 OF oDlgfilter COLORS 0, 16777215 PIXEL  
	    oGetPesCod	:= TGet():New(010,031,{|u|IF(PCount()>0,cCodigo:=u,cCodigo)},oDlgfilter,60,10, '@!',{||DadosCon(cTipo)},,, /*oF14*/,,,.T.,,,,,,,,,,'cCodigo')
	    
	    @ 013, 097 SAY oSay2 PROMPT "Descricao" SIZE 025, 007 OF oDlgfilter COLORS 0, 16777215 PIXEL
	    oGetPesCod	:= TGet():New(010,126,{|u|IF(PCount()>0,cDesc:=u,cDesc)},oDlgfilter,116,10, '@!',{||DadosCon(cTipo)},,, /*oF14*/,,,.T.,,,,,,,,,,'cDesc')    
	    
	    @ 035, 005 LISTBOX oList1 Fields HEADER "Codigo","Descricao" SIZE 237, 091 OF oDlgfilter PIXEL ColSizes 10,20,50   ;
	    ON dblClick(eval({|| addSelected(aListCon, oList1:nAt, aListSelCon), refreshList(oList2, aListSelCon)}))  
	    
	    refreshList(oList1, aListCon)
		
		@ 013, 253 SAY oSay1 PROMPT "Clique duas vezes sobre um item para removê-lo" SIZE 150, 007 OF oDlgfilter COLORS 0, 16777215 PIXEL
		
		@ 035, 253 LISTBOX oList2 Fields HEADER "Codigo","Descricao" SIZE 142, 091 OF oDlgfilter PIXEL ColSizes 10,20,50   ;
	    ON dblClick(eval({|| removeSelected(aListSelCon, oList2:nAt), refreshList(oList2, aListSelCon)}))
	
	    refreshList(oList2, aListSelCon)
	    
	    @ 134, 210 BUTTON oButton3 PROMPT "Todos >" SIZE 037, 012 OF oDlgfilter PIXEL  action {|| addAll(aListCon, aListSelCon), refreshList(oList2, aListSelCon) }
	    @ 134, 249 BUTTON oButton3 PROMPT "< Limpa" SIZE 037, 012 OF oDlgfilter PIXEL  action {|| removeAll(oList2, aListSelCon), refreshList(oList2, aListSelCon) }
	    
	    @ 134, 361 BUTTON oButton1 PROMPT "Ok" SIZE 037, 012 OF oDlgfilter PIXEL  action {|| Grava(cTipo), oDlgfilter:end() }
	    @ 134, 320 BUTTON oButton2 PROMPT "Cancela" SIZE 037, 012 OF oDlgfilter PIXEL action oDlgfilter:end()    
	    
	  ACTIVATE MSDIALOG oDlgfilter CENTERED
return(.F.)

static function addSelected(aList1, nPos, aList2)
	local nX
	if empty(aList1)
		return
	endif
	for nX := 1 to len(aList2)
		if aList2[nX, 1] == aList1[nPos, 1]
			return
		endif
	next nX
	aAdd(aList2, aList1[nPos])
return

//Remove uma Opção
static function removeSelected(aList, nPos)
	if empty(aList) .Or. nPos > len(aList)
		return
	endif
	aDel(aList, nPos)
	iif(len(aList) > 1, aSize(aList, (len(aList)-1)), aList := {})
return

//Grava as opções selecionadas
static function Grava(cTipo) 
	local x
	
	if alltrim(cTipo) $ "TABELA_PRC|COND_PAG|VEND|TAGS|"
	 	for x:=1 to len(aListSelCon)  
	 		cRet += aListSelCon[x,1]+";"	    
		next x    
	else	
	 	for x:=1 to len(aListSelCon)  
		   	 cRet += "'"+aListSelCon[x,1]+"',"	    
		next x   
		 
		IF !EMPTY(cRet)
			cRet := SUBSTR(ALLTRIM(cRet),1,LEN(ALLTRIM(cRet))-1)
		ENDIF
	endif
	
	DO CASE
		CASE cTipo  ==  "ESTADO" 
			cEstados := cRet
		CASE cTipo  ==  "CIDADE" 
			cMun 	 := cRet
		CASE cTipo  == "GRPVEN"
			cGrpven  := cRet
		CASE cTipo  == "GRPTRIB"
			cGrpTrib := cRet
		CASE cTipo  == "VENDEDOR"
			cVend 	 := cRet
		CASE cTipo  == "RMATIVIDADE"
			cRamo 	 := cRet
		CASE cTipo  == "SEGMENTO"
			cSegment 	 := cRet
		CASE cTipo  == "COORDENADOR"
			cCoordenador := cRet
		CASE cTipo  == "GERSETORIAL"
			cGerSetorial := cRet
		CASE cTipo  == "GERNACIOAL"
			cGerNacional := cRet
		CASE cTipo  == "DIRETOR"
			cDiretor := cRet	
	ENDCASE    

return(.F.) 

//Atualização dos dados do cliente
static function addIn(cBase, cNovo)
	local cAtual := alltrim(cBase)
	local aItens := StrTokArr(cNovo, ';')
	local nX
	if substr(cAtual, -1) != ';' .And. !empty(cAtual)
		cAtual += ';'
	endif
	for nX := 1 to len(aItens)
		if !(aItens[nX] $ cAtual)
			cAtual += aItens[nX]+';'
		endif 
	next nX
return cAtual

static function removeFrom(cBase, cNovo)
	local cAtual := alltrim(cBase)
	local aItens := StrTokArr(cNovo, ';')
	local nX
	if substr(cAtual, -1) != ';' .And. !empty(cAtual)
		cAtual += ';'
	endif
	for nX := 1 to len(aItens)
		if aItens[nX]+';' $ cAtual
			cAtual := StrTran(cAtual, aItens[nX]+';', '')
		endif 
	next nX
return cAtual
