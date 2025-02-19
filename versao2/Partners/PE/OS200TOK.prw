#INCLUDE "PROTHEUS.CH"

User Function OM200OK()
    Local lRet := .T.

    Private cGetVlr := 0
    private aPedido := ParamIxb[1]
    PRIVATE aCarga  := ParamIxb[2]
    
    DEFINE MSDIALOG oDlgRatFrt TITLE "Rateio Frete p/ Pedido" FROM 000, 000  TO 080, 220 COLORS 0, 16777215 PIXEL
        @ 005, 069 BUTTON oButton1 PROMPT "Ok" SIZE 037, 012 OF oDlgRatFrt PIXEL   ACTION ExecRateio(cGetVlr)
        @ 021, 069 BUTTON oButton2 PROMPT "Cancela" SIZE 037, 012 OF oDlgRatFrt PIXEL  ACTION oDlgRatFrt:END()
        @ 006, 003 GROUP oGroup1 TO 032, 068 PROMPT "Valor" OF oDlgRatFrt COLOR 0, 16777215 PIXEL
        @ 015, 007 MSGET oGetVlr VAR cGetVlr SIZE 057, 010 OF oDlgRatFrt COLORS 0, 16777215 PIXEL picture "@E 999,999,999.99"
    ACTIVATE MSDIALOG oDlgRatFrt CENTERED

return(lRet) 


static function  ExecRateio(cGetVlr)
local x

    nTotNfe := 0 
    nQtdNfe := 0
    for x:=1 to len(aPedido)
        nTotNfe += aPedido[x,25]
        nQtdNfe++
    next x

    for x:=1 to len(aPedido) 
        nVlrNfe := aPedido[x,25]
        nVlrFrt := (nVlrNfe/nTotNfe)*cGetVlr 

        IF SC5->(DBSETORDER(1),DBSEEK(XFILIAL("SC5")+aPedido[X,5]))
            reclock("SC5",.F.)
                SC5->C5_FREINT := nVlrFrt
            msunlock()
        ENDIF
   // U_ValidCtr(aPedido)
    next x
    
    msginfo("Rateio Realizado!")
    oDlgRatFrt:END()

return()
