#include "protheus.ch"

User Function DATAPED()

Local DtEntrega
Local EntrCorreta

//DtEntrega := SC5->C5_EMISSAO + 2

If DOW(DDATABASE) = 6   // conta o dia da semana no caso 6 =Sabado
	DtEntrega := DDATABASE + 4
ElseIf DOW(DDATABASE) = 7    // conta o dia da semana no caso 6 = Domingo
	DtEntrega := DDATABASE + 3
Else
	DtEntrega := DDATABASE + 2
Endif

EntrCorreta := DataValida(DtEntrega,.T.)

Return(EntrCorreta)
