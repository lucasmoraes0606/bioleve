//Bibliotecas
#Include "TOPCONN.CH"

/*------------------------------------------------------------------------------------------------------*
 | P.E.:  M460FIM                                                                                       |
 | Desc:  Gravação dos dados após gerar NF de Saída                                                     |
 | Links: http://tdn.totvs.com/pages/releaseview.action?pageId=6784180                                  |
 | O proceso deste ponto de entrada e para fazer a transferencia automatica para o armazem informado    |
 | no parametro mv_trfarm, dos produtos que forma faturados em uma determinada nota                     |
 | Links: http://tdn.totvs.com/pages/releaseview.action?pageId=6784180                                  |
 | WWW.RMLG.NET - WWW.R2SISTEMA.COM.BR                                                                  |
 *------------------------------------------------------------------------------------------------------*/
 
User Function M460FIM()

Local cArmtrans := GETMV("MV_ARMTRF")
Local aAreaGER  := GetArea()
Local aAreaSD2  := SD2->(GetArea())
Local alista    := {}
Local cEmpBk    := cEmpAnt    //Empresa
Local cEmpAtu   :=  "32" //somente para esta empresa

If SF2->F2_CLIENTE == '000192'

    If cEmpBk == cEmpAtu  //vai processar o pronto de entrada somente para empresa de Lindoia

        DbSelectArea("SD2")
        SD2->(DbSetorder(3))

        If SD2->(DbSeek(SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA)))

            While SD2->(!eof()) .And. SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA) == SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)

//            01,            02,        03,     04,               05,       06,      07,         08,            09,          10,        11
//CODIGO PRODUTO,CODIGO PRODUTO,QUANTIDADE,ARMAZEM,QTD SEG.UNID.MED.,RECNO SD2,SERIE NF,NUMERO NOTA,CODIGO CLIENTE,LOJA CLIENTE,NUM.ITEM NA NOTA

                aadd(alista,{SD2->D2_COD,SD2->D2_COD,SD2->D2_QUANT,SD2->D2_LOCAL,SD2->D2_QTSEGUM,SD2->(RECNO()),SD2->D2_SERIE,SD2->D2_DOC,SD2->D2_CLIENTE,SD2->D2_LOJA,SD2->D2_ITEM})

                SD2->(dbSkip())

            Enddo
        Else
            ApmsgInfo("Atenção, verifique com Administrador ","Não encontrou os itens da nota no SD2 não sera feita a transferência para o armazem de SBC, Serie+Nota+Cliente+Loja "+SF2->F2_SERIE+" "+SF2->F2_DOC+" "+SF2->F2_CLIENTE+" "+SF2->F2_LOJA)
        Endif

        U_MyMata261(alista,cArmtrans)

    Endif

ENDIF  

RestArea(aAreaSD2)
RestArea(aAreaGER)

Return
