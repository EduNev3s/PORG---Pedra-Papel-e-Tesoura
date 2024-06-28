
mensagem_play: string "Pressione 'space' para play"
erase_msn_play: string "                           "

mensagem_gameover: string "seu heroi morreu! Pressione 'space' para reiniciar"
erase_msn_gameover: string "                                                  "

mensagem_dificuldade1: string "Qual dificuldade deseja?"
erase_msn_dificuldade1: string "                        "

mensagem_dificuldade2: string "[0] facil [1] medio [2] dificil"
erase_msn_dificuldade2: string "                               "

mensagem_eraseAll: string "|--------------------------------------||                                      ||                                      ||                                      ||                                      ||                                      ||                                      ||                                      ||                                      ||                                      ||                                      ||                                      ||                                      ||                                      ||                                      ||                                      ||                                      ||                                      ||                                      ||                                      ||                                      ||                                      ||                                      ||                                      ||                                      ||                                      ||                                      ||                                      ||                                      ||--------------------------------------|"

posicao_heroi: var #1 ; variavel global para posição do herói
posicao_obejtivo: var#1 ; variavel global para posição do objetivo

Dir: var #1 ; 0-direita, 1-baixo, 2-esquerda, 3-cima 

Letra: var #1 ; variavel global para digLetra

Main: 

    call Inicializacao
    
    loop_main:
        ;call Inicializacao
    
        call Desenha_Heroi
        call Morreu_Heroi
        
        call Move_Heroi
        
        call Recoloca_Objetivo
        
        call Delay
        
    jmp loop_main
    
    loop_gameover:
    
        call Restart
    
    jmp loop_gameover
    
    
Inicializacao:

    push r0
    push r1
    
    ; começa com o herói direcionado para direita
    loadn r0, #0
    store Dir, r0
    
    loadn r1, #1122
    store  posicao_heroi, r1

    call Apaga_mapa
    call Primeira_Tela
    
    pop r1
    pop r0
    
    rts
    
    
Primeira_Tela:

    push r0
    push r1
    push r2
    push r3
    push r4
    
    loadn r0, #527 ;posição da mensagem na tela
    loadn r1, #mensagem_play 
    loadn r2, #0
    call Imprime
    
    call digLetra
    
    loadn r3, #Letra
    loadn r4, #' ' ; tecla para iniciar o jogo

    cmp r3, r4
    jeq qualDificuldade
    
        qualDificuldade:
            call Escolhe_dificuldade
    
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    
    rts
    
Escolhe_dificuldade:                  

    push r0                                
    push r1
    push r2
    
    call Apaga_mapa
    
    loadn r0, #527 ;posição da mensagem na tela
    loadn r1, #erase_msn_play
    loadn r2, #0
    call Imprime
            
    ; imprime mensagens para escolha da dificuldade
    loadn r0, #525 ;posição da mensagem na tela
    loadn r1, #mensagem_dificuldade1 
    loadn r2, #0
    call Imprime
            
    loadn r0, #605 ;posição da mensagem na tela
    loadn r1, #mensagem_dificuldade2 
    loadn r2, #0
    call Imprime
            
    call switch_dificuldade
    
    pop r2
    pop r1
    pop r0
    
    rts
        
    
switch_dificuldade:

    push r0 ; facil
    push r1 ; medio
    push r2 ; dificil
    push r3

    loadn r0, #'0'
    loadn r1, #'1'
    loadn r2, #'2'
    
    loop_escolha:
        inchar r3 ; recebe escolha de dificuldade
        cmp r3, r0 
        jeq selecionou_facil
        
        cmp r3, r1 
        jeq selecionou_medio
        
        cmp r3, r2 
        jeq selecionou_dificil
        
        jmp loop_escolha
        
    selecionou_facil:
        call JogoFacil
        jmp loop_main
       
    
    selecionou_medio:
        call JogoMedio
        jmp loop_main
        
    
    selecionou_dificil:
        call JogoDificil
        jmp loop_main 
        
    
    pop r3
    pop r2
    pop r1
    pop r0
    
    rts
    
JogoFacil:

    push r0
    push r1
    push r2
    
    loadn r0, #525 ;posição da mensagem na tela
    loadn r1, #erase_msn_dificuldade1
    loadn r2, #0
    call Imprime
    
    loadn r0, #605 ;posição da mensagem na tela
    loadn r1, #erase_msn_dificuldade2
    loadn r2, #0
    call Imprime

    call ImprimeTela_facil
    
    pop r2
    pop r1
    pop r0
    rts

JogoMedio:
    push r0
    push r1
    push r2
    
    loadn r0, #525 ;posição da mensagem na tela
    loadn r1, #erase_msn_dificuldade1
    loadn r2, #0
    call Imprime
    
    loadn r0, #605 ;posição da mensagem na tela
    loadn r1, #erase_msn_dificuldade2
    loadn r2, #0
    call Imprime

    call ImprimeTela_medio
    
    pop r2
    pop r1
    pop r0
    rts

JogoDificil:
    push r0
    push r1
    push r2
    
    loadn r0, #525 ;posição da mensagem na tela
    loadn r1, #erase_msn_dificuldade1
    loadn r2, #0
    call Imprime
    
    loadn r0, #605 ;posição da mensagem na tela
    loadn r1, #erase_msn_dificuldade2
    loadn r2, #0
    call Imprime

    call ImprimeTela_dificil
    
    pop r2
    pop r1
    pop r0
    rts


ImprimeTela_facil:
    
    push r1 ; endereço da string 
    push r2 ; cor da mensagem 
    push r6
    
    call Apaga_mapa
    
    loadn r1, #facilLinha00
    loadn r2, #512 ; verde
    loadn r6, #facilLinha00
    call ImprimeTela2
        
    pop r6    
    pop r2
    pop r1
        
    rts

ImprimeTela_medio:
    
    push r1 ; endereço da string 
    push r2 ; cor da mensagem 
    push r6
    
    call Apaga_mapa
        
    loadn r1, #medioLinha00
    loadn r2, #512 ; verde
    loadn r6, #medioLinha00
    call ImprimeTela2
        
    pop r6    
    pop r2
    pop r1
        
    rts

ImprimeTela_dificil:
    
    push r1 ; endereço da string 
    push r2 ; cor da mensagem 
    push r6
    
    call Apaga_mapa
    
    loadn r1, #dificilLinha00
    loadn r2, #512 ; verde
    loadn r6, #dificilLinha00
    call ImprimeTela2
        
    pop r6    
    pop r2
    pop r1
        
    rts

Imprime:
    push r0     ; Posição na tela para imprimir a string
    push r1     ; Endereço da string a ser impressa
    push r2     ; Cor da mensagem
    push r3
    push r4

    
    loadn r3, #'\0'

    LoopImprime:    
        loadi r4, r1
        cmp r4, r3
        jeq SaiImprime
        add r4, r2, r4
        outchar r4, r0
        inc r0
        inc r1
        jmp LoopImprime
        
    SaiImprime: 
        pop r4  
        pop r3
        pop r2
        pop r1
        pop r0
        
    rts
    
Apaga_mapa:
    
    push r0
    push r1
    push r2
    
    loadn r0, #0
    loadn r1, #mensagem_eraseAll
    loadn r2, #0
    call Imprime
    
    
    loadn r0, #525 ;posição da mensagem na tela
    loadn r1, #erase_msn_dificuldade1
    loadn r2, #0
    call Imprime
    
    loadn r0, #605 ;posição da mensagem na tela
    loadn r1, #erase_msn_dificuldade2
    loadn r2, #0
    call Imprime

    call ImprimeTela_mapa0
    
    pop r2
    pop r1
    pop r0
    rts
    
ImprimeTela_mapa0:

    push r1 ; endereço da string 
    push r2 ; cor da mensagem 
    push r6
    
    loadn r1, #mapa0Linha00
    loadn r2, #512 ; verde
    loadn r6, #mapa0Linha00
    call ImprimeTela2
        
    pop r6    
    pop r2
    pop r1
        
    rts
    
    
Desenha_Heroi:

    push r0
    push r1 
    push r2 
    push r3
    push r4
    
    loadn r0, #posicao_heroi
    
    ; define qual caractere será usado de acordo com a direção
    
    load r1, Dir
    
    loadn r2, #0    ; se está para direita
    cmp r1, r2
    jeq vai_direita
    
    loadn r2, #1
    cmp r1, r2
    jeq vai_baixo
    
    loadn r2, #2
    cmp r1, r2
    jeq vai_esquerda
    
    loadn r2, #3
    cmp r1, r2
    jeq vai_cima
    
    vai_direita:
        loadn r3, #'>'
        jmp ch_definido    
    
    vai_baixo:
        loadn r3, #'v'
        jmp ch_definido
    
    vai_esquerda:
        loadn r3, #'<'
        jmp ch_definido
    
    vai_cima:
        loadn r3, #'^'
        jmp ch_definido
        
    ch_definido:
    
    loadi r4, r0
    outchar r3, r4
    
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0

    rts
    
Morreu_Heroi:
    rts
    
Move_Heroi:
    rts
    
Recoloca_Objetivo:
    rts

Delay:
    rts

Restart:
    rts
 
;********************************************************
;                   DIGITE UMA LETRA
;********************************************************

digLetra:   ; Espera que uma tecla seja digitada e salva na variavel global "Letra"
    push fr     ; Protege o registrador de flags
    push r0
    push r1
    loadn r1, #255  ; Se nao digitar nada vem 255

   digLetra_Loop:
        inchar r0           ; Le o teclado, se nada for digitado = 255
        cmp r0, r1          ;compara r0 com 255
        jeq digLetra_Loop   ; Fica lendo ate' que digite uma tecla valida

    store Letra, r0         ; Salva a tecla na variavel global "Letra"

        ; Bloco novo para aguardar que o user solte a tecla pressionada!!
               digLetra_Loop2:  
                    inchar r0           ; Le o teclado, se nada for digitado = 255
                    cmp r0, r1          ;compara r0 com 255
                    jne digLetra_Loop2  ; Fica lendo ate' que digite uma tecla valida
                
    
    pop r1
    pop r0
    pop fr
    rts
    

;********************************************************
;                       IMPRIME TELA2
;********************************************************   

ImprimeTela2:   ;  Rotina de Impresao de Cenario na Tela Inteira
        ;  r1 = endereco onde comeca a primeira linha do Cenario
        ;  r2 = cor do Cenario para ser impresso

    push r0 ; protege o r3 na pilha para ser usado na subrotina
    push r1 ; protege o r1 na pilha para preservar seu valor
    push r2 ; protege o r1 na pilha para preservar seu valor
    push r3 ; protege o r3 na pilha para ser usado na subrotina
    push r4 ; protege o r4 na pilha para ser usado na subrotina
    push r5 ; protege o r5 na pilha para ser usado na subrotina
    push r6 ; protege o r6 na pilha para ser usado na subrotina

    loadn R0, #0    ; posicao inicial tem que ser o comeco da tela!
    loadn R3, #40   ; Incremento da posicao da tela!
    loadn R4, #41   ; incremento do ponteiro das linhas da tela
    loadn R5, #1200 ; Limite da tela!
    ;loadn R6, #tela1Linha0  ; Endereco onde comeca a primeira linha do cenario!!
    
   ImprimeTela2_Loop:
        call ImprimeStr2
        add r0, r0, r3      ; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
        add r1, r1, r4      ; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
        add r6, r6, r4      ; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
        cmp r0, r5          ; Compara r0 com 1200
        jne ImprimeTela2_Loop   ; Enquanto r0 < 1200

    pop r6  ; Resgata os valores dos registradores utilizados na Subrotina da Pilha
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts
                
;---------------------

;---------------------------    
;********************************************************
;                   IMPRIME STRING2
;********************************************************
    
ImprimeStr2:    ;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
    push r0 ; protege o r0 na pilha para preservar seu valor
    push r1 ; protege o r1 na pilha para preservar seu valor
    push r2 ; protege o r1 na pilha para preservar seu valor
    push r3 ; protege o r3 na pilha para ser usado na subrotina
    push r4 ; protege o r4 na pilha para ser usado na subrotina
    push r5 ; protege o r5 na pilha para ser usado na subrotina
    push r6 ; protege o r6 na pilha para ser usado na subrotina
    
    
    loadn r3, #'\0' ; Criterio de parada
    loadn r5, #' '  ; Espaco em Branco

   ImprimeStr2_Loop:    
        loadi r4, r1
        cmp r4, r3      ; If (Char == \0)  vai Embora
        jeq ImprimeStr2_Sai
        cmp r4, r5      ; If (Char == ' ')  vai Pula outchar do espaco para na apagar outros caracteres
        jeq ImprimeStr2_Skip
        add r4, r2, r4  ; Soma a Cor
        outchar r4, r0  ; Imprime o caractere na tela
        storei r6, r4
   ImprimeStr2_Skip:
        inc r0          ; Incrementa a posicao na tela
        inc r1          ; Incrementa o ponteiro da String
        inc r6          ; Incrementa o ponteiro da String da Tela 0
        jmp ImprimeStr2_Loop
    
   ImprimeStr2_Sai: 
    pop r6  ; Resgata os valores dos registradores utilizados na Subrotina da Pilha
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

    
; labirinto fácil  -> 4 chs de distância
facilLinha00: string "|--------------------------------------|"
facilLinha01: string "|         |                   |        |"
facilLinha02: string "|         |                   |        |"
facilLinha03: string "|         |                   |        |"
facilLinha04: string "|    |    |    |----|    |----|        |"
facilLinha05: string "|    |    |    |    |    |    |    |---|"
facilLinha06: string "|    |    |    |    |    |    |        |"
facilLinha07: string "|    |    |    |    |    |    |        |"
facilLinha08: string "|    |    |    |    |    |    |        |"
facilLinha09: string "|    |    |    |    |    |    |        |"
facilLinha10: string "|    |    |    |    |    |    |    |   |"
facilLinha11: string "|    |         |    |         |    |   |"
facilLinha12: string "|    |         |    |         |    |   |"
facilLinha13: string "|    |         |    |         |    |   |"
facilLinha14: string "|    |         |    |         |    |   |"
facilLinha15: string "|    |    |----|    |    |    |----|   |"
facilLinha16: string "|    |         |         |             |"
facilLinha17: string "|    |         |         |             |"
facilLinha18: string "|    |         |         |             |"
facilLinha19: string "|    |         |         |             |"
facilLinha20: string "|    |----|    |---------|---------|   |"
facilLinha21: string "|         |                        |   |"
facilLinha22: string "|         |                        |   |"
facilLinha23: string "|         |                        |   |"
facilLinha24: string "|         |                        |   |"
facilLinha25: string "|----|    |--------------|----|    |---|"
facilLinha26: string "|                        |             |"
facilLinha27: string "|                        |             |"
facilLinha28: string "|                        |             |"
facilLinha29: string "|----------------------------------|---|"


; labirinto médio -> 3 chs de distância
medioLinha00: string "|--------------------------------------|"
medioLinha01: string "|           |   |                      |"
medioLinha02: string "|           |   |                      |"
medioLinha03: string "|           |   |                      |"
medioLinha04: string "|   |-------|   |   |---------------|  |"
medioLinha05: string "|       |       |               |      |"
medioLinha06: string "|       |       |               |      |"
medioLinha07: string "|       |       |               |      |"
medioLinha08: string "|---|   |   |---------------|   |   |--|"
medioLinha09: string "|           |                   |      |"
medioLinha10: string "|           |                   |      |"
medioLinha11: string "|           |                   |      |"
medioLinha12: string "|   |-------|   |   |-----------|---|  |"
medioLinha13: string "|               |   |           |      |"
medioLinha14: string "|               |   |           |      |"
medioLinha15: string "|               |   |           |      |"
medioLinha16: string "|-----------|   |---|   |---|   |   |--|"
medioLinha17: string "|           |       |   |   |          |"
medioLinha18: string "|           |       |   |   |          |"
medioLinha19: string "|           |       |   |   |          |"
medioLinha20: string "|   |   |---|---|   |   |   |-------|  |"
medioLinha21: string "|   |           |   |       |   |      |"
medioLinha22: string "|   |           |   |       |   |      |"
medioLinha23: string "|   |           |   |       |   |      |"
medioLinha24: string "|---|---|---|   |   |---|---|   |---|  |"
medioLinha25: string "|   |   |   |   |   |   |   |   |   |  |"
medioLinha26: string "|       |       |       |       |      |"
medioLinha27: string "|                                      |"
medioLinha28: string "|                                      |"
medioLinha29: string "|--------------------------------------|"

; labirinto difícil -> 2 chs de distância
dificilLinha00: string "|--------------|-----------|--------|--|"
dificilLinha01: string "|              |           |        |  |"
dificilLinha02: string "|              |           |        |  |"
dificilLinha03: string "|  |--------|  |  |-----|  |-----|  |  |"
dificilLinha04: string "|  |           |  |     |  |        |  |"
dificilLinha05: string "|  |           |  |     |  |        |  |"
dificilLinha06: string "|  |-----------|  |  |--|  |  |-----|  |"
dificilLinha07: string "|                 |        |  |        |"
dificilLinha08: string "|                 |        |  |        |"
dificilLinha09: string "|--------|--------|-----|  |  |--|  |  |"
dificilLinha10: string "|        |                 |  |     |  |"
dificilLinha11: string "|        |                 |  |     |  |"
dificilLinha12: string "|  |--|  |--------|  |-----|  |  |--|  |"
dificilLinha13: string "|  |  |           |  |        |  |     |"
dificilLinha14: string "|  |  |           |  |        |  |     |"
dificilLinha15: string "|  |  |--------|  |  |  |-----|  |  |--|"
dificilLinha16: string "|  |                 |           |  |  |"
dificilLinha17: string "|  |                 |           |  |  |"
dificilLinha18: string "|  |--------|--------|-----------|  |  |"
dificilLinha19: string "|           |                       |  |"
dificilLinha20: string "|           |                       |  |"
dificilLinha21: string "|  |  |-----|-----|  |--------------|  |"
dificilLinha22: string "|  |  |           |  |                 |"
dificilLinha23: string "|  |  |           |  |                 |"
dificilLinha24: string "|  |  |  |--|  |  |  |  |-----------|  |"
dificilLinha25: string "|  |        |  |     |  |           |  |"
dificilLinha26: string "|  |        |  |     |  |           |  |"
dificilLinha27: string "|--|  |-----|  |-----|  |  |--------|  |"
dificilLinha28: string "|           |           |              |"
dificilLinha29: string "|-----------|-----------|--------------|"

; tela entre os mapas
mapa0Linha00: string "|--------------------------------------|"
mapa0Linha01: string "|                                      |"
mapa0Linha02: string "|                                      |"
mapa0Linha03: string "|                                      |"
mapa0Linha04: string "|                                      |"
mapa0Linha05: string "|                                      |"
mapa0Linha06: string "|                                      |"
mapa0Linha07: string "|                                      |"
mapa0Linha08: string "|                                      |"
mapa0Linha09: string "|                                      |"
mapa0Linha10: string "|                                      |"
mapa0Linha11: string "|                                      |"
mapa0Linha12: string "|                                      |"
mapa0Linha13: string "|                                      |"
mapa0Linha14: string "|                                      |"
mapa0Linha15: string "|                                      |"
mapa0Linha16: string "|                                      |"
mapa0Linha17: string "|                                      |"
mapa0Linha18: string "|                                      |"
mapa0Linha19: string "|                                      |"
mapa0Linha20: string "|                                      |"
mapa0Linha21: string "|                                      |"
mapa0Linha22: string "|                                      |"
mapa0Linha23: string "|                                      |"
mapa0Linha24: string "|                                      |"
mapa0Linha25: string "|                                      |"
mapa0Linha26: string "|                                      |"
mapa0Linha27: string "|                                      |"
mapa0Linha28: string "|                                      |"
mapa0Linha29: string "|--------------------------------------|"
