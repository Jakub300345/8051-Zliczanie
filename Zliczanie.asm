org 0

mov DPTR, #seg7 	 	;Inicjalizacja wskaźnika DPTR adresem tablicy seg7

mov R7, #0 		;Inicjalizacja R7 na 0

szesnascie: 		;Inicjalizacja R5 na 1 i R6 na 6
    mov R5, #1
    mov R6, #6

loop:			;Pętla główna:
    cjne R7, #0, odcisniety 	;sprawdzamy czy przycisk został odciśnięty jeżeli nie to przechodzimy do etykiety "odciśniety"
    jnb P2.0, wcisniety	;sprawdzamy czy przycisk został wciśnięty jeżeli tak to przechodzimy do etykiety "wcisniety"

loop2:
    sjmp display 		;przechodzimy do etykiety "display"

wcisniety:
    call delay		;wywołujemy opóźnienie
    mov R7, #1		;ustawiamy zmienną pomocniczą która usprawni sprawdzanie aktywności przycisku 
    mov A, R6		;Wrzucamy wartość z R6 do akumulatora 
    jz zeroWdziesiatkach	;jeżeli wartość akumulatora będzie równe 0 to przechdozimy do etykiety "zeroWdziesiatkach"
    dec R6			;dekrementujemy wartość R6
    sjmp loop		;wracamy do "loop"

odcisniety:
    jnb P2.0,  loop2		;sprwadzamy czy przycisk jest wciśnięty jeżeli tak to wracamy do "loop2"
    call delay		;wywołujemy opóźnienie 
    jnb P2.0,  loop2		;sprwadzamy czy przycisk jest wciśnięty jeżeli tak to wracamy do "loop2"
    mov R7, #0		;ustawiamy R0 na 0
    sjmp loop2		;wracamy do "loop 2"

zeroWdziesiatkach:				
    mov A, R5		;Wrzucamy wartość z R5 do akumulatora 
    jz szesnascie		;jeżeli wartość akumulatora będzie równe 0 to przechdozimy do etykiety "szesnascie"
    mov R5, #0		;ustawiamy R5 na 0
    mov R6, #9		;ustawiamy R6 na 9
    sjmp loop		;wracamy do "loop"    

display:			;etykieta służąca do wyświetlania multipleksowanego
    mov A, R6
    movc A,@A+DPTR	 
    mov P1, #1		;wybranie jedności części wyświetlacza
    mov P0, A		;wyświetlenie liczby
    mov P0, #255		;reset
    mov P1, #0		;reset
    mov A, R5
    movc A,@A+DPTR
    mov P1, #2		;wybranie dziesiątek części wyświetlacza
    mov P0, A 		;wyświetlenie liczby
    mov P0, #255		;reset
    mov P1, #0		;reset
    sjmp loop

delay:
    mov R0,#4
sk2:    
    mov R1,#255
sk1:    
    djnz R1, sk1
    djnz R0, sk2
ret

seg7: db 0xC0,0xF9,0xA4,0xb0,0x99,0x92,0x82,0xD8,0x80,0x90
END
