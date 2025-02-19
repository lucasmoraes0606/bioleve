#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
--------------------------------------------------------------------------------------------------------
| P.E.:  MS520DEL                                                                                      |
| Desc:  Ponto de entrada antes de efetuar a exclusão do cabecalho da nota fiscal de saida (SF2)            |
| Estamos usando este ponto de entrada para fazer o estorno da movimentação/transferencia do ponto de  |
| M460FIM onde usamos para fazer a transferencia de mercadoria para o estoque de SBC, conforeme notas  |
| emitidas para SBC fazemos transferencia para armazem local em SBC conforme itens da nota.            |
| WWW.RMLG.NET - WWW.R2SISTEMA.COM.BR                                                                  |
--------------------------------------------------------------------------------------------------------
*/

User Function MS520DEL()

    Local xcEmpAtu      :=  "32" //somente para esta empresa
    Local xcEmpBk       := cEmpAnt    //Empresa
    Local _aAreas 	    := GetArea()
    Local _aAreaSD3	    := SD3->(GetArea())
    Local _aAreaSB1     := SB1->(GetArea())    
    Local _xlstor       := {}
    Local _xnDoc        := ""
	Local aAuto 		:= {}
	Local aLinha 		:= {}
	Local ENDER01		:= criavar("D3_LOCALIZ")
	Local nOpcAuto 		:= 6
	Local nX

	Private lMsErroAuto := .F.

    If SF2->F2_CLIENTE == '000192'
    
        If xcEmpBk == xcEmpAtu  //vai processar o pronto de entrada somente para empresa de Lindoia

            DbSelectArea("SD3")
            DbSetorder(18)   //D3_FILIAL+D3_XSD2REC

            If dbSeek(xFilial("SD3")+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA)

                _xnDoc  :=  SD3->D3_DOC

                aadd(_xlstor,{SD3->D3_COD,SD3->D3_COD,SD3->D3_QUANT,SD3->D3_LOCAL,SD3->D3_QTSEGUM,SD3->D3_XSD2REC})

                //Cabecalho a Incluir
                aadd(aAuto,{SD3->D3_DOC,SD3->D3_EMISSAO}) //Cabecalho

                for nX := 1 to len(_xlstor) //step 2

                    aLinha := {}
                    //Origem 
                    SB1->(DbSeek(xFilial("SB1")+PadR(_xlstor[nX][1], tamsx3('D3_COD') [1])))
                    aadd(aLinha,{"ITEM",Strzero(nX,3),Nil})
                    aadd(aLinha,{"D3_COD", _xlstor[nX][1], Nil}) //Cod Produto origem
                    aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida origem
                    aadd(aLinha,{"D3_LOCAL", _xlstor[nX][4], Nil}) //armazem origem
                    aadd(aLinha,{"D3_LOCALIZ", ENDER01,Nil}) //Informar endereço origem

                    aadd(aLinha,{"D3_NUMSERI", "", Nil}) //Numero serie
                    aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote Origem
                    aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote origem
                    aadd(aLinha,{"D3_DTVALID", '', Nil}) //data validade
                    aadd(aLinha,{"D3_POTENCI", 0, Nil}) // Potencia
                    aadd(aLinha,{"D3_QUANT", _xlstor[nX][3], Nil}) //Quantidade
                    aadd(aLinha,{"D3_QTSEGUM", _xlstor[nX][5], Nil}) //Seg unidade medida
                    aadd(aLinha,{"D3_ESTORNO", "", Nil}) //Estorno
                    aadd(aLinha,{"D3_NUMSEQ", "", Nil}) // Numero sequencia D3_NUMSEQ

                    aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote destino
                    aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote destino
                    aadd(aLinha,{"D3_DTVALID", '', Nil}) //validade lote destino
                    aadd(aLinha,{"D3_ITEMGRD", "", Nil}) //Item Grade
                    aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod origem
                    aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod destino

                    aAdd(aAuto,aLinha)

                Next nX

                MSExecAuto({|x,y| mata261(x,y)},aAuto,nOpcAuto)

                if lMsErroAuto
                    MostraErro()
                Endif
            Endif
       Endif
    Endif                
    RestArea(_aAreas)
    RestArea(_aAreaSD3)
    RestArea(_aAreaSB1)
   
return(.T.)
