#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO4     บ Autor ณ Lucas Pereira      บ Data ณ  10/05/22   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ ponto de entrada meus pedidos tipo de opera็ใo             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function TK272WZD()
    local lRet      := .t. 
    local cNPed     := aCols[n,9]
    local nItemNf   := aCols[n,24]
    if msgyesno("Deseja Importar todos os itens da nota fical?")

        BEGINSQL alias "TMPTMKWZ"
            SELECT * FROM %TABLE:SD2%
            WHERE %NOTDEL%
            AND D2_FILIAL = %EXP:XFILIAL("SD2")%
            AND D2_PEDIDO = %EXP:Str(cNPed)%
            AND D2_ITEM <> %EXP:Str(nItemNf)%
        ENDSQL
        WHILE TMPTMKWZ->(!EOF())
            aLinha := {}
            aLinha := AClone(acols[n])
            aLinha[6]  := TMPTMKWZ->D2_COD
            aLinha[7]  := TMPTMKWZ->D2_NOMPROD
            aLinha[24] := TMPTMKWZ->D2_ITEM
            aadd(acols,aLinha)
            TMPTMKWZ->(DBSKIP())
        ENDDO
        TMPTMKWZ->(DBCLOSEAREA())        
    endif
return(lRet)

