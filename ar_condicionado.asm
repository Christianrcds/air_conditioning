.org 1000h

;usar saide led como 00h e saida 8 segmento como 08h
	mvi e, 00H	;váriavel de comparação com zero
	mvi a, 00H	;resetar as saidas
	mvi L, 00H	;registrador para aumento de temperatura, guarda o estado anterior para ver se teve mudanças
	mvi d, 00H	;registrador para diminuir de temperatura
	out 00h
	mvi h, 16	;guarda a temperatura

loop:			
;botao de liga e desliga
	in 00H	;carrega interupcoes liga/desliga
	cmp e		;comparacao com zero
	jnz turn_on	;se nao for zero quer dizer que uma das interrupcoes foi ativada
	jz turn_off	;desliga todas saidas e fecha o loop

return_turn_on:
;aumenta temperatura
	in  01H	;le interruptor de temperatura, aumenta toda vez que ocorre uma mudança nele
	cmp L
	jnz aumentar_temp	

return_inc_temp:		
;diminui temperatura	
	in  02H	;idem ao anterior mas para diminuri a temperatura
	cmp d
	jnz diminuir_temp	

return_dec_temp:
	mov a,b	; implementar
	out 08h
	jmp loop

turn_off:
;desliga todas as saidas
	out 00H
	out 0FH
	out 0EH
	jmp loop

turn_on:
;liga as LEDs e o visor de temperatura na temperatura anterior
	mvi c,FFH
	mov a,c
	out 00H
	mvi a,00H
	call load_numbers 
	jmp return_turn_on

aumentar_temp:
	mov l, a			;atualiza o registrador l com o valor atual do interruptor
	inr h 			;incrementa registrador da temperatura
	call load_numbers		;carrega a nova temperatura no visor
	jmp return_inc_temp

diminuir_temp:
;funcionalidade similar ao aumentar_temp mas decremente h
	mov d, a
	dcr h 
	call load_numbers
	jmp return_dec_temp

load_numbers:
;"switch case" para carregar o valor no interruptor
;obs: o programa atual so aceita valores entre [16,21] porem isso é facilmente aumentado adicionando mais opcoes nesta funcao
	mvi a, 16
	cmp h
	jz load_number_16
	mvi a, 17
	cmp h
	jz load_number_17
	mvi a, 18
	cmp h
	jz load_number_18
	mvi a, 19
	cmp h
	jz load_number_19
	mvi a, 20
	cmp h
	jz load_number_20
	mvi a, 21
	cmp h
	jz load_number_21
    mvi a, 22
	cmp h
	jz load_number_22
    mvi a, 23
	cmp h
	jz load_number_23
    mvi a, 24
	cmp h
	jz load_number_24
	ret

;funcoes para carregar os numeros nos displays 8 segmentos
load_number_16: 
	mvi a, 44H
	out 0EH
	mvi a, 7BH
	out 0FH
ret

load_number_17:
	mvi a, 44H
	out 0EH
	mvi a, 46H
	out 0FH
ret

load_number_18: 
	mvi a, 44H
	out 0EH
	mvi a, 7FH
	out 0FH
ret

load_number_19:
	mvi a, 44H
	out 0EH
	mvi a, 6FH
	out 0FH
ret

load_number_20: 
	mvi a, 3EH
	out 0EH
	mvi a, 77H
	out 0FH
ret

load_number_21:
	mvi a, 3EH
	out 0EH
	mvi a, 44H
	out 0FH
ret

load_number_22:
	mvi a, 3EH
	out 0EH
	mvi a, 3EH
	out 0FH
ret

load_number_23:
	mvi a, 3EH
	out 0EH
	mvi a, 6EH
	out 0FH
ret

load_number_24:
	mvi a, 3EH
	out 0EH
	mvi a, 4DH
	out 0FH
ret