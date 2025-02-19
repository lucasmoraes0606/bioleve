//#INCLUDE "PROTHEUS.CH"
//#INCLUDE "RWMAKE.CH"

/* EXEMPLO
aadd(aRotina,{'TEXTO DO BOTÃO','NOME DA FUNÇÃO' , 0 , 3,0,NIL})   
		1		2		  3   4 5 6	

ONDE:Parametros do array a Rotina:

1. Nome a aparecer no cabecalho
2. Nome da Rotina associada    
3. Reservado                        

4. Tipo de Transação a ser efetuada:     
	1 - Pesquisa e Posiciona em um Banco de Dados      
	2 - Simplesmente Mostra os Campos                  
	3 - Inclui registros no Bancos de Dados            
	4 - Altera o registro corrente                     
	5 - Remove o registro corrente do Banco de Dados

5. Nivel de acesso                                   
6. Habilita Menu Funcional
*/

User Function MA410MNU()

	//INICIO ALTERAÇÃO LUCAS PEREIRA PARTNERS
	nPosPreNota := aScan(aRotina,{|x|AllTrim(x[2]) == "Ma410PvNfs"})
	aRotina[nPosPreNota,2] := "U_xMa410PvNfs"
	//FIM ALTERAÇÃO LUCAS PEREIRA PARTNERS


	aadd(aRotina,{'Pre Nota','U_RFATR05()' , 0 , 6,0,NIL})
	aadd(aRotina,{'Folha Garrafao','U_RFATR07()' , 0 , 6,0,NIL})
	aadd(aRotina,{'Folha Descartavel','U_RFATR06()' , 0 , 6,0,NIL})
	aadd(aRotina,{'Recibo Frete','U_RFATR09()' , 0 , 6,0,NIL})
	aadd(aRotina,{'Lib. Credito','MATA450()' , 0 , 6,0,NIL})
	//aadd(aRotina,{'Lib. Estoque','MATA455()' , 0 , 6,0,NIL})
	aadd(aRotina,{'NFE Sefaz','SPEDNFE()' , 0 , 6,0,NIL})
	aadd(aRotina,{'Bom / Ped','U_FATNF001()' , 0 , 6,0,NIL})
	aadd(aRotina,{"Transf.Pedido", "U_TRANSFPED", 0 , 3, 0, NIL}) //incluido 17/10/24 - Roberto Carlos

	//INICIO ALTERAÇÃO LUCAS PEREIRA PARTNERS
	aadd(aRotina,{'Analise Bloqueio','U_AnaliseBlqPed()' , 0 , 6,0,NIL})
	aadd(aRotina,{'Lib.Estoque(x)','u_XlibEstoque()' , 0 , 6,0,NIL})
	//FIM ALTERAÇÃO LUCAS PEREIRA PARTNERS

Return

//INICIO ALTERAÇÃO LUCAS PEREIRA PARTNERS
USER FUNCTION xMa410PvNfs
	if SC5->C5_XSTATUS == 'O'
		Ma410PvNfs()
	else
		MSGINFO("Impossivel continuar para status do pedido. Verifique Analise de bloqueios.","")
	ENDIF
return()
//FIM ALTERAÇÃO LUCAS PEREIRA PARTNERS
