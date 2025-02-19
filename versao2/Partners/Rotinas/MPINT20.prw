#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"   
#include "totvs.ch"   
#INCLUDE "MSOBJECT.CH"

#DEFINE ENTER CHR(13)+CHR(10)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO4     º Autor ³ Lucas Pereira      º Data ³  11/04/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MPINT20
Private cCadastro := "Clientes x Tabelas de Preço"

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","U_MPIT20_INC",0,3} ,;
             {"Alterar","U_MPIT20_ALT",0,4} ,;
             {"Excluir","AxDeleta",0,5} ,;
             {"Alt. Geral","U_MPINT71",0,6} } // ADICIONADO POR JÚLIO CÉSAR - 03/04/2018
            
Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "MPA"

dbSelectArea("MPA")
dbSetOrder(1)

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)
Return

// ADICIONADO POR JÚLIO CÉSAR - 03/04/2018
user function MPINT71()
	U_MPINT70(1, "Clientes X Tabelas de Preço")
return
// ----------------------------------------
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO4     º Autor ³ Lucas Pereira      º Data ³  11/04/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

user function MPIT20_INC()
	Local nOpca := 0  
    Private  aButtons := {}
    Private cCadastro := "Tabelas de Preco" // título da tela                                                                     
    
    //adiciona botoes na Enchoice                       
    aAdd( aButtons, { "Tabela de Preço", {||U_FiltroGeral('TABELA_PRC') }, "Tabela de Preço", "Tabela de Preço" } ) 
    dbSelectArea(cString)
    
    //AxInclui( cAlias, nReg, nOpc, aAcho, cFunc, aCpos, cTudoOk, lF3, cTransact, aButtons, aParam, aAuto, lVirtual, lMaximized, cTela, lPanelFin, oFather, aDim, uArea)  
    nOpca := AxInclui( cString, MPA->(Recno()) ,3,,,,,,, aButtons) 
    
Return nOpca

 /*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO4     º Autor ³ Lucas Pereira      º Data ³  11/04/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
    
user function MPIT20_ALT()
	Local nOpca := 0  
    Private  aButtons := {}
    Private cCadastro := "Tabelas de Preco" // título da tela                                                                     
    Private aCpos	  := {"MPA_CLIENT","MPA_LOJA","MPA_NOME","MPA_TABELA"}

    //adiciona botoes na Enchoice                       
    aAdd( aButtons, { "Tabela de Preço", {||U_FiltroGeral('TABELA_PRC') }, "Tabela de Preço", "Tabela de Preço" } ) 

    dbSelectArea(cString)
    
   //AxAltera(cAlias,nReg,nOpc ,aAcho ,aCpos,nColMens,cMensagem,cTudoOk,cTransact,cFunc, aButtons, aParam, aAuto, lVirtual, lMaximized, cTela,lPanelFin,oFather,aDim,uArea)
   nOpca := AxAltera(cString, MPA->(Recno()) ,4 ,,aCpos,,,,,,aButtons)
  
 
    
Return nOpca
  
  
  
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO4     º Autor ³ Lucas Pereira      º Data ³  11/04/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

user function MPIT20_VLD(cCpo)
local rArea		:= getarea()
local lRet 		:= .T.
local cClient

IF cCpo == "MPA_CLIENT" .OR. cCpo == "MPA_LOJA" 
	cClient := M->(MPA_CLIENT+MPA_LOJA)
	IF INCLUI
		IF MPA->(dbseek(xfilial("MPA")+cClient))
			MSGINFO("Cliente ja cadastrado. Verifique!")
			lRet := .F.
		ENDIF
	ELSEIF ALTERA
		IF cClient <> MPA->(MPA_CLIENT+MPA_LOJA) .and.  MPA->(dbseek(xfilial("MPA")+cClient)) 
			MSGINFO("Cliente ja cadastrado. Verifique!")
			lRet := .F.
		ENDIF		
	ENDIF
ENDIF	
restarea(rArea)
RETURN(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  GRVENTDAD  º Autor ³ Lucas Pereira	     º Data ³  21/08/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Grava Registro de entidada para transação                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User function FiltroGeral(cTipo,nOpc)    
	local rArea				:= getarea() 
	
	private lExec           := .F.
	private cCod			:= Space(10) 
	private cDescri	  		:= Space(50)
	private aListFilter 	:= {}
	PRIVATE oOk 			:= LoadBitmap( GetResources(), "LBOK")
	PRIVATE oNo    			:= LoadBitmap( GetResources(), "LBNO") 
	Private cRet    		:= ""
	private nCombo			:= 2
	
	
	DadosFiltro(cTipo)
	MontaTela(cTipo)
	
	restarea(rArea) 
return cRet // ADICIONADO POR JÚLIO CÉSAR - 03/04/2018 (Apenas o cRet)
	
static function MontaTela(cTipo)
	local cHelp  := "1 - Irá adicionar os itens selecionados nos cadastros dos clientes, mantendo os já existentes."+ENTER;
					+"2 - Irá substituir os itens dos cadastros dos clientes pelos selecionados."+ENTER;
					+"3 - Irá remover (se econtrar) os itens selecionados dos cadastros dos clientes."
	private aTipos	  := {"1 - Adicionar", "2 - Substituir", "3 - Excluir"}
	
	  DEFINE MSDIALOG oDlgfilter TITLE "Filtro" FROM 000, 000  TO 300, 500 COLORS 0, 16777215 PIXEL
	     
	    @ 002, 002 GROUP oGroup2 TO 026, 246 PROMPT "Busca" OF oDlgfilter COLOR 0, 16777215 PIXEL  
	    @ 026, 002 GROUP oGroup1 TO 131, 246 PROMPT "Detalhes" OF oDlgfilter COLOR 0, 16777215 PIXEL
	    
	    @ 013, 005 SAY oSay1 PROMPT "Codigo:" SIZE 025, 007 OF oDlgfilter COLORS 0, 16777215 PIXEL  
	    oGetPesCod	:= TGet():New(010,031,{|u|IF(PCount()>0,cCod:=u,cCod)},oDlgfilter,60,10, '@!',{||DadosFiltro(cTipo)},,, /*oF14*/,,,.T.,,,,,,,,,,'cCod')
	    
	    @ 013, 097 SAY oSay2 PROMPT "Descricao" SIZE 025, 007 OF oDlgfilter COLORS 0, 16777215 PIXEL
	    oGetPesCod	:= TGet():New(010,126,{|u|IF(PCount()>0,cDescri:=u,cDescri)},oDlgfilter,116,10, '@!',{||DadosFiltro(cTipo)},,, /*oF14*/,,,.T.,,,,,,,,,,'cDescri')    
	    
	    @ 035, 005 LISTBOX oListFilter Fields HEADER "x","Codigo","Descricao" SIZE 237, 091 OF oDlgfilter PIXEL ColSizes 10,20,50   ;
	    ON dblClick(AlterChk(oListFilter:nAt))  
	    
	    oListFilter:SetArray(aListFilter)
	    oListFilter:bLine := {|| {;
	      iif(aListFilter[oListFilter:nAt,1],oOk,oNo),;
	      aListFilter[oListFilter:nAt,2],;
	      aListFilter[oListFilter:nAt,3];
	    }}
		oListFilter:bHeaderClick := {||Marca() } 
		
		@ 134, 10 COMBOBOX oCombo2 VAR nCombo ITEMS aTipos SIZE 60, 008 OF oDlgfilter PIXEL
		@ 134, 75 BUTTON oButton4 PROMPT "Ajuda?" SIZE 037, 012 OF oDlgfilter PIXEL action MsgInfo(cHelp, "Ajuda")
		
	    @ 134, 205 BUTTON oButton1 PROMPT "Ok" SIZE 037, 012 OF oDlgfilter PIXEL  action {|| Grava(cTipo, oCombo2:nAt) }
	    @ 134, 164 BUTTON oButton2 PROMPT "Cancela" SIZE 037, 012 OF oDlgfilter PIXEL action oDlgfilter:end()    
	    
	  ACTIVATE MSDIALOG oDlgfilter CENTERED 
	 
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
	if substr(cAtual, -1) != ';'  .And. !empty(cAtual)
		cAtual += ';'
	endif
	for nX := 1 to len(aItens)
		if aItens[nX]+';' $ cAtual
			cAtual := StrTran(cAtual, aItens[nX]+';', '')
		endif 
	next nX
return cAtual
  
static function Grava(cTipo, nOpcao) 
	local x
 	local cAlt := ""
 	cRet := ""
	for x:=1 to len(aListFilter)  
		if aListFilter[x,1]
	   	 	cRet += aListFilter[x,2]+";"	    
		endif
	next x    
	DO CASE
		CASE cTipo  ==  "TABELA_PRC" 
				if nOpcao == 1
					cAlt := addIn(M->MPA_TABELA, cRet)
				elseif nOpcao == 2
					cAlt := cRet
				elseif nOpcao == 3
					cAlt := removeFrom(M->MPA_TABELA, cRet)
				endif
			M->MPA_TABELA := cAlt
		CASE cTipo  ==  "COND_PAG" 
				if nOpcao == 1
					cAlt := addIn(M->MPB_COND, cRet)
				elseif nOpcao == 2
					cAlt := cRet
				elseif nOpcao == 3
					cAlt := removeFrom(M->MPB_COND, cRet)
				endif
			M->MPB_COND := cAlt
		CASE cTipo  ==  "VEND" 
				if nOpcao == 1
					cAlt := addIn(M->MPG_VEND, cRet)
				elseif nOpcao == 2
					cAlt := cRet
				elseif nOpcao == 3
					cAlt := removeFrom(M->MPG_VEND, cRet)
				endif
			M->MPG_VEND := cAlt
		CASE cTipo  ==  "TAGS" 
				if nOpcao == 1
					cAlt := addIn(M->MPJ_TAG, cRet)
				elseif nOpcao == 2
					cAlt := cRet
				elseif nOpcao == 3
					cAlt := removeFrom(M->MPJ_TAG, cRet)
				endif
			M->MPJ_TAG := cAlt
	ENDCASE    

oDlgfilter:end()

return(.F.) 



static function AlterChk(nPos)
	aListFilter[nPos,1] := !aListFilter[nPos,1]
    oListFilter:SetArray(aListFilter)
    oListFilter:bLine := {|| {;
      iif(aListFilter[oListFilter:nAt,1],oOk,oNo),;
      aListFilter[oListFilter:nAt,2],;
      aListFilter[oListFilter:nAt,3];
    }}
    oListFilter:refresh()
return()

static function Marca()	
	local x
	for x:=1 to len(aListFilter)
		aListFilter[x,1] := !aListFilter[x,1]
	next x
    oListFilter:SetArray(aListFilter)
    oListFilter:bLine := {|| {;
      iif(aListFilter[oListFilter:nAt,1],oOk,oNo),;
      aListFilter[oListFilter:nAt,2],;
      aListFilter[oListFilter:nAt,3];
    }}   
    oListFilter:refresh()
return()  

static function DadosFiltro(cTipo)   

	DO CASE
		CASE cTipo  ==  "TABELA_PRC"       
			cQuery := " SELECT DA0_CODTAB AS COD, DA0_DESCRI AS DESCRI "
			cQuery += " FROM "+RETSQLNAME("DA0")+" DA0 "
			cQuery += " WHERE DA0.D_E_L_E_T_ <> '*'  "
	  		cQuery += " AND DA0_FILIAL =  '"+XFILIAL("DA0")+"'"
			cQuery += " AND DA0_DATATE >=  '"+DTOS(dDatabase)+"'"
			cQuery += " AND DA0_ATIVO <>  '2' "

			IF !EMPTY(cCod)		
				cQuery += " AND DA0_CODTAB LIKE '%"+ALLTRIM(cCod)+"%'"
			ENDIF
			IF !EMPTY(cDescri)
				cQuery += " AND DA0_DESCRI LIKE '%"+ALLTRIM(cDescri)+"%'" 
			ENDIF	
			//Traz somente TABELAS integradas
			//cQuery += " AND DA0_CODTAB IN (SELECT MP1_IDPROT FROM "+RETSQLNAME("MP1")+" WHERE MP1_TPREG = 'TABPR_CAB' AND MP1_IDPROT = DA0_CODTAB AND MP1_STATUS = 'I')"
	
			
			cQuery += " ORDER BY DA0_CODTAB, DA0_DESCRI"
			  	
		CASE cTipo  ==  "COND_PAG"     
			cQuery := " SELECT E4_CODIGO AS COD, E4_DESCRI AS DESCRI "
			cQuery += " FROM "+RETSQLNAME("SE4")+" SE4 "
			cQuery += " WHERE SE4.D_E_L_E_T_ <> '*'  "
	  		cQuery += " AND E4_FILIAL =  '"+XFILIAL("SE4")+"'"
			cQuery += " AND E4_MSBLQL <>  '2' "
			
			IF !EMPTY(cCod)		
				cQuery += " AND E4_CODIGO LIKE '%"+ALLTRIM(cCod)+"%'"
			ENDIF
			IF !EMPTY(cDescri)
				cQuery += " AND E4_DESCRI LIKE '%"+ALLTRIM(cDescri)+"%'" 
			ENDIF
			
			//Traz somente CONDICAO integrados
			//cQuery += " AND E4_CODIGO IN (SELECT MP1_IDPROT FROM "+RETSQLNAME("MP1")+" WHERE MP1_TPREG = 'COND_PAG' AND MP1_IDPROT = E4_CODIGO AND MP1_STATUS = 'I')"
	
			cQuery += " ORDER BY E4_CODIGO, E4_DESCRI"	
	
	CASE cTipo  ==  "VEND"     
			cQuery := " SELECT A3_COD AS COD, A3_NOME AS DESCRI "
			cQuery += " FROM "+RETSQLNAME("SA3")+" SA3 "
			cQuery += " WHERE SA3.D_E_L_E_T_ <> '*'  "
	  		cQuery += " AND A3_FILIAL =  '"+XFILIAL("SA3")+"'"
			
			IF !EMPTY(cCod)		
				cQuery += " AND A3_COD LIKE '%"+ALLTRIM(cCod)+"%'"
			ENDIF
			IF !EMPTY(cDescri)
				cQuery += " AND A3_NOME LIKE '%"+ALLTRIM(cDescri)+"%'" 
			ENDIF	
			//Traz somente vendedores integrados
			cQuery += " AND A3_COD IN (SELECT MP1_IDPROT FROM "+RETSQLNAME("MP1")+" WHERE MP1_TPREG = 'VEND' AND MP1_IDPROT = A3_COD AND MP1_STATUS = 'I')"
		
	CASE cTipo  ==  "TAGS"     
			cQuery := " SELECT MPI_TAG AS COD, MPI_DESCRI AS DESCRI "
			cQuery += " FROM "+RETSQLNAME("MPI")+" MPI "
			cQuery += " WHERE MPI.D_E_L_E_T_ <> '*'  "
	  		cQuery += " AND MPI_FILIAL =  '"+XFILIAL("MPI")+"'"
			
			IF !EMPTY(cCod)		
				cQuery += " AND MPI_TAG LIKE '%"+ALLTRIM(cCod)+"%'"
			ENDIF
			IF !EMPTY(cDescri)
				cQuery += " AND MPI_DESCRI LIKE '%"+ALLTRIM(cDescri)+"%'" 
			ENDIF	
			//Traz somente TAGS integrados
			cQuery += " AND MPI_TAG IN (SELECT MP1_IDPROT FROM "+RETSQLNAME("MP1")+" WHERE MP1_TPREG = 'TAGS' AND MP1_IDPROT = MPI_TAG AND MP1_STATUS = 'I')"
		
	ENDCASE
	
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.) 
	aListFilter := {}
	WHILE TMP->(!EOF())
		AADD(aListFilter,{.F.,TMP->COD, TMP->DESCRI} )    
		TMP->(DBSKIP())
	ENDDO
	TMP->(DBCLOSEAREA())
	
	
	if empty(aListFilter)
		aadd(aListFilter,{.F.,"",""}) 
	endif    
	
	if type("oListFilter")<> "U"
	    oListFilter:SetArray(aListFilter)
	    oListFilter:bLine := {|| {;
	      iif(aListFilter[oListFilter:nAt,1],oOk,oNo),;
	      aListFilter[oListFilter:nAt,2],;
	      aListFilter[oListFilter:nAt,3];
	    }}   
	    oListFilter:refresh()
	endif
return()
