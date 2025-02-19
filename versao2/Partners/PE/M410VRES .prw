#INCLUDE 'PROTHEUS.CH'
#INCLUDE "RWMAKE.CH"
#include "protheus.ch"

#DEFINE ENTER CHR(13)+CHR(10)
/*/


?
Programa  M410ALOK   Autor  LUCAS PEREIRA      Data   15/06/18    
?
Descricao  Executado antes de iniciar a alterao do pedido de venda  
?
Uso                                                            		  
?


/*/

User Function M410VRES()
local lRet := .T.
	Proc_LibEmp(SC5->C5_NUM)
	//MotCanc()
return(lRet)


static function Proc_LibEmp(cNumPed)               

	private lMsErroAuto   

	aCabec := {}
	aItens := {} 
	dbselectarea("SC5")
	dbsetorder(1)
	dbseek(xfilial("SC5")+cNumPed)
	
	aAdd(aCabec,{"C5_FILIAL"          ,xfilial("SC5")  ,Nil})
	aAdd(aCabec,{"C5_NUM"             ,SC5->C5_NUM     ,Nil})

	dbselectarea("SC6")
	dbsetorder(1)      
	dbseek(xfilial("SC6")+cNumPed)   
	while SC6->(!EOF()) .AND. cNumPed == SC6->C6_NUM      
		aLinha := {}
		aadd(aLinha,{"LINPOS","C6_ITEM",SC6->C6_ITEM}) 
		//	aAdd(aLinha,{"C6_OPER" ,"01",nil}) 
		aAdd(aLinha,{"C6_QTDLIB",0,nil}) 
		aAdd(aLinha,{"C6_QTDEMP",0,nil}) 
		aadd(aLinha,{"AUTDELETA","N",Nil})   

		aadd(aItens,aLinha)
		SC6->(dbskip())
	ENDDO
	    
	MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCabec, aItens, 4) 
	
	If lMsErroAuto        
		Alert("Erro na alterao do pedido n - "+SC5->C5_NUM)     
	ENDIF
return()       





static Function MotCanc()
	local aItens		:= getMotiv()
    Local nComboBo1 	:= aItens[1]
	lExec := .f.
			
        DEFINE MSDIALOG oDlg TITLE "Motivo de cancelamento PEDIDO N - "+SC5->C5_NUM FROM 000, 000  TO 100, 400 COLORS 0, 16777215 PIXEL STYLE DS_MODALFRAME
		oDlg:lEscClose  := .F. 

        @ 010, 004 SAY oSay1 PROMPT "Motivo?" SIZE 034, 007 OF oDlg COLORS 0, 16777215 PIXEL  
        @ 010, 040 MSCOMBOBOX oComboBo1 VAR nComboBo1 ;
            ITEMS aItens;
            SIZE 157, 010 OF oDlg COLORS 0, 16777215 PIXEL  			 
        
        @ 030, 160 BUTTON oButton1 PROMPT "Ok" SIZE 037, 012 OF oDlg PIXEL ACTION {|| lExec := .t.,oDlg:END()}
    
        ACTIVATE MSDIALOG oDlg CENTERED
    if lExec    
        RecLock('SC5', .F.)
            SC5->C5_XMTCANC := padr(nComboBo1,100) +"| User: "+cUserName+"| Data: "+dtoc(date())
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
		where X5_TABELA = 'ZY'
		order by X5_CHAVE
	endsql
	
	while !(cTabela)->(eof())
		aAdd(aRet, (cTabela)->X5_CHAVE +"-"+(cTabela)->X5_DESCRI)
		(cTabela)->(dbSkip())
	enddo
	(cTabela)->(dbCloseArea())
	restArea(rArea)
return aRet

