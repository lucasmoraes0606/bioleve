#INCLUDE 'PROTHEUS.CH'
#INCLUDE "RWMAKE.CH"
#include "protheus.ch"

#DEFINE ENTER CHR(13)+CHR(10)
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M410ALOK  � Autor � LUCAS PEREIRA     � Data �  15/06/18    ���
�������������������������������������������������������������������������͹��
���Descricao � Executado antes de iniciar a altera��o do pedido de venda  ���
�������������������������������������������������������������������������͹��
���Uso       �                                                     		  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MA410LEG()

    aLegenda := { {'ENABLE'         ,"Pedido em aberto"},;              
                  {'DISABLE'        ,"Pedido encerrado"},;              
                  {'BR_AMARELO'     ,"Pedido Liberado" },; 
                  {'BR_PINK'        ,"Pedido Liberado mas nao impresso" },; 
                  {'BR_AZUL'        ,"Pedido Bloqueado por Regra" },; 
                  {'BR_LARANJA'     ,"Pedido Bloqueado por Verba" },;
                  {'BR_PRETO'       ,"Pedido Bloqueado Comercial" },;
                  {'BR_BRANCO'      ,"Pedido Bloqueado Controladoria" },;
                  {'BR_VIOLETA'     ,"Pedido Bloqueado Financeiro" },;
                  {'BR_MARROM'      ,"Pedido Bloqueado Estoque" },;
                  {'BR_VERDE_ESCURO',"Pedido Bloqueado Logistica" },;
                  {'BR_CANCEL'      ,"Pedido Cancelado" };
                  }

return(aLegenda)
