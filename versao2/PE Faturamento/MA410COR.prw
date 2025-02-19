#INCLUDE 'PROTHEUS.CH'
#INCLUDE "RWMAKE.CH"
#include "protheus.ch"

#DEFINE ENTER CHR(13)+CHR(10)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM410ALOK  บ Autor ณ LUCAS PEREIRA     บ Data ณ  15/06/18    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Executado antes de iniciar a altera็ใo do pedido de venda  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                     		  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function MA410COR()

    aCores := { {"Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ)",'BR_VERDE' },;		//Pedido em Aberto
			   { "!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ).and.(C5_XSTATUS=='O'.or.empty(C5_XSTATUS))",'BR_AMARELO'},;
			    { "(C5_NOTA <> 'XXXXXXXXX' .and. !Empty(C5_NOTA)).Or.C5_LIBEROK=='E' .And. Empty(C5_BLQ)" ,'BR_VERMELHO'},;	    //Pedido Encerrado
			    { "C5_NOTA =='XXXXXXXXX'",'BR_CANCEL'},;        //Pedido cancelado
			    { "C5_XSTATUS=='C'",'BR_PRETO'},;	      //Pedido Bloquedo Comercial
				{ "C5_XSTATUS=='T'",'BR_BRANCO'},;	      //Pedido Bloquedo Controladoria
				{ "C5_XSTATUS=='F'",'BR_VIOLETA'},;	      //Pedido Bloquedo financeiro
				{ "C5_XSTATUS=='E'",'BR_MARROM'},;	      //Pedido Bloquedo estoque
				{ "C5_XSTATUS=='L'",'BR_VERDE_ESCURO'},;  //Pedido Bloquedo Logistica
				{ "C5_XSTATUS=='N'",'BR_PINK'},;  		  //Pedido Bloquedo Liberado mas nao impresso
				{ "C5_BLQ == '1'",'BR_AZUL'},;	          //Pedido Bloquedo por regra
			    { "C5_BLQ == '2'",'BR_LARANJA'}}          //Pedido Bloquedo por verba
				
return(aCores)
