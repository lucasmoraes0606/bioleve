#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma MS520DEL ºAutor ³Lucas Moraes º Data ³ 21/06/24 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc. ³ Ponto de Entrada na exclusao apos nota fiscal º±±
±±º ³ º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso ³ AP º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MS520DEL
local lRet := .T.
	if empty(SF2->F2_XMTCANC)
		NFCanc()
	endif
return(lRet)

static Function NFCanc()
	local aItens		:= getMotiv()
    Local nComboBo1 	:= aItens[1]
	lExec := .f.
			
        DEFINE MSDIALOG oDlg TITLE "Motivo de Cancelamento NF N - "+SF2->F2_DOC FROM 000, 000  TO 100, 400 COLORS 0, 16777215 PIXEL STYLE DS_MODALFRAME
		oDlg:lEscClose  := .F. 

        @ 010, 004 SAY oSay1 PROMPT "Motivo?" SIZE 034, 007 OF oDlg COLORS 0, 16777215 PIXEL  
        @ 010, 040 MSCOMBOBOX oComboBo1 VAR nComboBo1 ;
            ITEMS aItens;
            SIZE 157, 010 OF oDlg COLORS 0, 16777215 PIXEL  			 
        
        @ 030, 160 BUTTON oButton1 PROMPT "Ok" SIZE 037, 012 OF oDlg PIXEL ACTION {|| lExec := .t.,oDlg:END()}
    
        ACTIVATE MSDIALOG oDlg CENTERED
    if lExec    
        RecLock('SF2', .F.)
            SF2->F2_XMTCANC := padr(nComboBo1,100) +"| User: "+cUserName+"| Data: "+dtoc(date())
        MsUnlock()
        msgInfo('Motivo gravado.')
    ENDIF 
RETURN(.T.)

static function getMotiv()
	local aRet := {}
	local cTabela := GetNextAlias()
	local rArea	:= getArea()
	
	beginSQL alias cTabela
		select X5_CHAVE, X5_DESCRI from %table:SX5%
		where X5_TABELA = 'ZD'
		order by X5_CHAVE
	endsql
	
	while !(cTabela)->(eof())
		aAdd(aRet, (cTabela)->X5_CHAVE +"-"+(cTabela)->X5_DESCRI)
		(cTabela)->(dbSkip())
	enddo
	(cTabela)->(dbCloseArea())
	restArea(rArea)
return aRet
