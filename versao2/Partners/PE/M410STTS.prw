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

User Function M410STTS()
	Local _nOper := PARAMIXB[1]

	/*
	3 - Inclus�o
	4 - Altera��o
	5 - Exclus�o
	6 - C�pia
	7 - Devolu��o de Compras 
	*/
	If cvaltochar(_nOper) $ "346" //.AND. !L410AUTO
	//	IF MSGYESNO("Deseja iniciar avalia��o do pedido?")
			U_ValidPedGeral(SC5->C5_NUM)
	//	ENDIF



	
	EndIf

Return Nil


