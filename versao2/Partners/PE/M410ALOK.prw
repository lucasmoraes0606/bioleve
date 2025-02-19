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

User Function M410ALOK()
local lRet := .T.
local cUserMaster := SUPERGETMV("X_USRMAST",.T.,"000000")

IF RetCodUsr() $ cUserMaster .and. !EMPTY(SC5->C5_XIMPRIM) 
	MSGINFO("Pedido Impresso! Usuario master cadastrado no parametro X_USRMAST")

	IF msgyesno("Deseja limpar o bloqueio de impress�o do pedido?")
		cMsg := "IMPRESSAO - Pedido liberado para altera��o."
		reclock("SC5",.F.)
			C5_XIMPRIM	:= " "
			C5_MOTBLQ   := C5_MOTBLQ + DTOC(DATE())+"-"+TIME()+ " | " +PADR(cMsg,170) + " | " + cUserName + ENTER
		msunlock()
	ENDIF

	RETURN(lRet)
ENDIF

if ! EMPTY(SC5->C5_XIMPRIM) 
	msginfo("Impossivel alterar pedidos ja impresso. "+ENTER+;
	"Apenas usuarios master incluidos no parametro X_USRMAST podem prosseguir.")
	lRet := .f.
endif

return(lRet)
