#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO4     � Autor � Lucas Pereira      � Data �  11/04/17   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


User Function MPINT30
Private cCadastro := "Clientes x Condcao de Pagamento"

Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","U_MPIT30_INC",0,3} ,;
             {"Alterar","U_MPIT30_ALT",0,4} ,;
             {"Excluir","AxDeleta",0,5},;
             {"Alt. Geral","U_MPINT72",0,3} }  // ADICIONADO POR J�LIO C�SAR - 03/04/2018
            
Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "MPB"

dbSelectArea("MPB")
dbSetOrder(1)
dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)
Return

// ADICIONADO POR J�LIO C�SAR - 03/04/2018
user function MPINT72()
	U_MPINT70(2, "Clientes X Condi��es de Pagamento")
return
// ---------------------------------------

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO4     � Autor � Lucas Pereira      � Data �  11/04/17   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


user function MPIT30_INC()
	Local nOpca := 0  
    Private  aButtons := {}
    Private cCadastro := "Cond.Pagamento" // t�tulo da tela                                                                     
    
    //adiciona botoes na Enchoice                       
     aAdd( aButtons, { "Cond.Pagamento", {||U_FiltroGeral('COND_PAG') }, "Cond.Pagamento", "Cond.Pagamento" })  
    
    dbSelectArea(cString)
    
    //AxInclui( cAlias, nReg, nOpc, aAcho, cFunc, aCpos, cTudoOk, lF3, cTransact, aButtons, aParam, aAuto, lVirtual, lMaximized, cTela, lPanelFin, oFather, aDim, uArea)  
    nOpca := AxInclui( cString, (cString)->(Recno()) ,3,,,,,,, aButtons) 
    
Return nOpca
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO4     � Autor � Lucas Pereira      � Data �  11/04/17   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
    
user function MPIT30_ALT()
	Local nOpca := 0  
    Private  aButtons := {}
    Private cCadastro := "Cond.Pagamento" // t�tulo da tela                                                                     
    Private aCpos	  := {"MPB_CLIENT","MPB_LOJA","MPB_NOME","MPB_COND"}

    //adiciona botoes na Enchoice                       
    aAdd( aButtons, { "Cond.Pagamento", {||U_FiltroGeral('COND_PAG') }, "Cond.Pagamento", "Cond.Pagamento" } )

    dbSelectArea(cString)
    
   //AxAltera(cAlias,nReg,nOpc ,aAcho ,aCpos,nColMens,cMensagem,cTudoOk,cTransact,cFunc, aButtons, aParam, aAuto, lVirtual, lMaximized, cTela,lPanelFin,oFather,aDim,uArea)
   nOpca := AxAltera(cString, (cString)->(Recno()) ,4 ,,aCpos,,,,,,aButtons)
     
Return nOpca
  

  /*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO4     � Autor � Lucas Pereira      � Data �  11/04/17   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

user function MPIT30_VLD(cCpo)
local rArea		:= getarea()
local lRet 		:= .T.
local cClient

IF cCpo == "MPB_CLIENT" .OR. cCpo == "MPB_LOJA" 
	cClient := M->(MPB_CLIENT+MPB_LOJA)
	IF INCLUI
		IF MPB->(dbseek(xfilial("MPB")+cClient))
			MSGINFO("Cliente ja cadastrado. Verifique!", "Registro Existente")
			lRet := .F.
		ENDIF
	ELSEIF ALTERA
		IF  cClient <> MPB->(MPB_CLIENT+MPB_LOJA) .and. MPB->(dbseek(xfilial("MPB")+cClient)) 
			MSGINFO("Cliente ja cadastrado. Verifique!", "Registro Existente")
			lRet := .F.
		ENDIF		
	ENDIF
ENDIF	
restarea(rArea)
RETURN(lRet)  
