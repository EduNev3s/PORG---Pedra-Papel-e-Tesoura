

; 3328 rosa (cor herói)          1101 0000
; 512 verde (cor mapa)           0010 0000

; Contantes

; variável para posição do herói
heroi_posicao: var #1
; variável para diração que o herói está indo
direcao: var #1 
; variável para guardar dificuldade [0]-fácil [1]-médio [2]-difícil
dificuldade: var #1
; variável que guarda a cor do mapa
cor_mapa : var #1
static cor_mapa + #0, #512 ; = cor verde

; Caractere do personagem para cima [0]
indo_cima : var #1
static indo_cima + #0, #'^'

; Caractere do personagem para baixo [1]
indo_baixo : var #1
static indo_baixo + #0, #'V'

; Caractere do personagem para esquerda [2]
indo_esquerda : var #1
static indo_esquerda + #0, #'<'

; Caractere do personagem para direita [3]
indo_direita : var #1
static indo_direita + #0, #'>'

; Frases
start: string "Pressione 'space' para inicializar"
game_over: string "Seu heroi morreu!"
mensagem: string "Qual dificuldade deseja jogar?"
escolhe_diff: string "[0]-facil [1]-medio [2]-dificil"
restart: string "Tente novamente! Consegue ir mais longe?"

EraseGameOver:      string "                 "
EraseRestart:       string "                                        "

; Função principal do jogo
Main:
    call Abertura
    call Desenha_mapa
    
    loop:
        ingame_loop:
            call Desenha_heroi
            call Morreu_heroi
            
            call Move_heroi
            call Desenha_obstaculo 
            
            call Delay
                
            jmp ingame_loop
            
        GameOver_loop:
            call Restart_Game 
            call Qualdiff
        
            jmp GameOver_loop
    
; Funções


Abertura:

    ; inicializa registradores
    push r0     
    push r1
    
    push r2
    ;push r3
    ;push r4
    
    ; reserva um espaço para o desenho do herói
    loadn r0, #1    
    store heroi_posicao, r1
    
    ; coloca herói na posicão inicial          
    loadn r0, #heroi_posicao
    loadn r1, #970
    
    call PrimPosHeroi
    
    ; herói começa indo para cima
    loadn r0, #0
    store direcao, r0
    
    ;-------------------
    ;loadn r2, #615
    ;loadn r3, #mensagem
    ;loadn r4, #0
    ;call Imprime
        
    ;loadn r2, #687
    ;loadn r3, #escolhe_diff
    ;loadn r4, #0
    ;call Imprime
    
    ;call Qualdiff
    ;-------------------
    loadn r2, #0
    store dificuldade, r2
    
    ; libera registradores
    ;pop r4
    ;pop r3
    pop r2 
    pop r1
    pop r0
    
    rts ; volta para a chamada


PrimPosHeroi:

    ; inicializa registradores
    push r0
    push r1
    push r2
    
    loadn r0, #heroi_posicao    ; r0 = &heroi_posicao
    loadn r1, #'}'              ; r1 = '}'
    loadi r2, r0                ; r2 = heroi_posicao
       
    ; imprime char contido em r1
    outchar r1, r2
        
    ; começa já com um obstáculo? 
    ; call desenha_obstaculo
    
    ; libera registradores
    pop r2
    pop r1
    pop r0
    
    rts ; volta para a chamada
    
Apaga_heroi:
    
    ; inicializa registradores
    push r0
    push r1
    push r2
        
    loadn   r0, #heroi_posicao  ; r0 = &heroi_posicao
    inc     r0                  ; r0++
    loadn   r1, #' '            ; r1 = ' '
    loadi   r2, r0              ; r2 = heroi_posicao
    
    outchar r1, r2
    
    ; libera registradores
    pop r2
    pop r1
    pop r0
    
    rts ; volta para a chamada
    
Desenha_mapa:
    
    ; verifica qual dificuldade foi selecionada
    push r0 ; recebe qual foi selecionado
    push r1 ; 0-> fácil
    push r2 ; 1-> médio
    push r3 ; 2-> difícil

    
    ; r0 = número correspondente à dificuldade  
    loadn r0, #dificuldade 
    loadn r1, #0
    loadn r2, #1
    loadn r3, #2
     
    cmp r0, r1  
    jeq ImprimeTela_facil
    
    cmp r0, r2
    jeq ImprimeTela_medio
    
    cmp r0, r3
    jeq ImprimeTela_dificil 
    
    pop r3 
    pop r2 
    pop r1
    pop r0 
    rts
    
Move_heroi:
    
    push r0 ; Direção / posição herói
    push r1 ; inchar
    push r2 ; local helper
    push r3
    push r4
    
    ; Sincronização
    loadn   r0, #5000
    loadn   r1, #0
    mod     r0, r6, r0      ; r1 = r0 % r1 (Teste condições de contorno)
    cmp     r0, r1
    jne Move_End
    ; =============
    
    Bateu_obstaculo:
        ; bateu no obstáculo
        
        
    Spread_Move:
        loadn   r0, #heroi_posicao
        loadn   r1, #heroi_posicao
        loadn   r2, #1 
        
        add     r0, r0, r2      ; r0 = SnakePos[Size]
        
        dec     r2              ; r1 = SnakePos[Size-1]
        add     r1, r1, r2
        
        loadn   r4, #0
        
        Spread_Loop:
            loadi   r3, r1
            storei  r0, r3
            
            dec r0
            dec r1
            
            cmp r2, r4
            dec r2
            
            jne Spread_Loop 
    
    Muda_direcao:
        inchar  r1
        
        loadn r2, #100  ; char r4 = 'd'
        cmp r1, r2
        jeq Move_D
        
        loadn r2, #115  ; char r4 = 's'
        cmp r1, r2
        jeq Move_S
        
        loadn r2, #97   ; char r4 = 'a'
        cmp r1, r2
        jeq Move_A
        
        loadn r2, #119  ; char r4 = 'w'
        cmp r1, r2
        jeq Move_W      
        
        jmp Atualiza_direcao
    
        Move_D:
            loadn   r0, #0
            ; Impede de "ir pra trás"
            loadn   r1, #2
            load    r2, direcao
            cmp     r1, r2
            jeq     Move_Left
            
            store   direcao, r0
            jmp     Move_Right
        Move_S:
            loadn   r0, #1
            ; Impede de "ir pra trás"
            loadn   r1, #3
            load    r2, direcao
            cmp     r1, r2
            jeq     Move_Up
            
            store   direcao, r0
            jmp     Move_Down
        Move_A:
            loadn   r0, #2
            ; Impede de "ir pra trás"
            loadn   r1, #0
            load    r2, direcao
            cmp     r1, r2
            jeq     Move_Right
            
            store   direcao, r0
            jmp     Move_Left
        Move_W:
            loadn   r0, #3
            ; Impede de "ir pra trás"
            loadn   r1, #1
            load    r2, direcao
            cmp     r1, r2
            jeq     Move_Down
            
            store   direcao, r0
            jmp     Move_Up
    
    Atualiza_direcao:
        load    r0, direcao
                
        loadn   r2, #0
        cmp     r0, r2
        jeq     Move_Right
        
        loadn   r2, #1
        cmp     r0, r2
        jeq     Move_Down
        
        loadn   r2, #2
        cmp     r0, r2
        jeq     Move_Left
        
        loadn   r2, #3
        cmp     r0, r2
        jeq     Move_Up
        
        jmp Move_End
        
        Move_Right:
            loadn   r0, #heroi_posicao   ; r0 = &heroi_posicao
            loadi   r1, r0          ; r1 = heroi_posicao
            inc     r1              ; r1++
            storei  r0, r1
            
            jmp Move_End
                
        Move_Down:
            loadn   r0, #heroi_posicao   ; r0 = &heroi_posicao
            loadi   r1, r0          ; r1 = heroi_posicao
            loadn   r2, #40
            add     r1, r1, r2
            storei  r0, r1
            
            jmp Move_End
        
        Move_Left:
            loadn   r0, #heroi_posicao   ; r0 = &heroi_posicao
            loadi   r1, r0          ; r1 = heroi_posicao
            dec     r1              ; r1--
            storei  r0, r1
            
            jmp Move_End
        Move_Up:
            loadn   r0, #heroi_posicao   ; r0 = &heroi_posicao
            loadi   r1, r0          ; r1 = heroi_posicao
            loadn   r2, #40
            sub     r1, r1, r2
            storei  r0, r1
            
            jmp Move_End
    
    Move_End:
        pop r4
        pop r3
        pop r2
        pop r1
        pop r0

    rts

Desenha_obstaculo:
    ; função para desenhar do obstáculo 
    rts
    
Morreu_heroi:
    loadn r0, #heroi_posicao
    loadi r1, r0
    
    ; Trombou na parede direita
    loadn r2, #40
    loadn r3, #39
    mod r2, r1, r2      ; r2 = r1 % r2 (Teste condições de contorno)
    cmp r2, r3
    jeq GameOver_Activate
    
    ; Trombou na parede esquerda
    loadn r2, #40
    loadn r3, #0
    mod r2, r1, r2      ; r2 = r1 % r2 (Teste condições de contorno)
    cmp r2, r3
    jeq GameOver_Activate
    
    ; Trombou na parede esquerda
    loadn r2, #40
    cmp r1, r2
    jle GameOver_Activate
    
    ; Trombou na parede esquerda
    loadn r2, #1160
    cmp r1, r2
    jgr GameOver_Activate
    
    ; Trombou na própria cobra
    Collision_Check:
        loadn   r2, #1
        loadn   r3, #1
        loadi   r4, r0          ; Posição da cabeça
        
        Collision_Loop:
            inc     r0
            loadi   r1, r0
            cmp r1, r4
            jeq GameOver_Activate
            
            dec r2
            cmp r2, r3
            jne Collision_Loop
        
    
    jmp Dead_Snake_End
    
    GameOver_Activate:
        
        loadn r0, #615
        loadn r1, #game_over
        loadn r2, #0
        call Imprime
        
        loadn r0, #687
        loadn r1, #restart 
        loadn r2, #0
        call Imprime
        
        loadn r0, #687
        loadn r1, #mensagem 
        loadn r2, #0
        call Imprime
        
        loadn r0, #727
        loadn r1, #escolhe_diff
        loadn r2, #0
        call Imprime
        
        jmp GameOver_loop
    
    Dead_Snake_End:
    
    rts

Desenha_heroi:
    push r0
    push r1
    push r2
    push r3 
    
    ; Sincronização
    loadn   r0, #1000
    loadn   r1, #0
    mod     r0, r6, r0      ; r1 = r0 % r1 (Teste condições de contorno)
    cmp     r0, r1
    jne Draw_End
    ; =============
    
    ;desenha obstáculo
    ;load    r0, FoodPos
    ;loadn   r1, #'*'
    ;outchar r1, r0
    
    loadn   r0, #heroi_posicao   ; r0 = & heroi_posicao
    loadn   r1, #'o'        ; r1 = '}'
    loadi   r2, r0          ; r2 = heroi_posicao
    outchar r1, r2          
    
    ;loadn   r0, #SnakePos   ; r0 = & SnakePos
    ;loadn   r1, #' '        ; r1 = ' '
    ;load    r3, SnakeSize   ; r3 = SnakeSize
    ;add     r0, r0, r3      ; r0 += SnakeSize
    ;loadi   r2, r0          ; r2 = SnakePos[SnakeSize]
    ;outchar r1, r2
    
    Draw_End:
        pop r3
        pop r2
        pop r1
        pop r0
    
    rts
;----------------------------------
Delay:
    push r0
    
    inc r6
    loadn r0, #60000
    cmp r6, r0
    jgr Reset_Timer
    
    jmp Timer_End
    
    Reset_Timer:
        loadn r6, #0
    Timer_End:      
        pop r0
    
    rts
    
Delay2: ; Delay para desenhar o cenário sem bugar
    push r0
    
    inc r6
    loadn r0, #1
    cmp r6, r0
    jgr Reset_Timer
    
    jmp Timer_End
    
    Reset_Timer:
        loadn r6, #0
    Timer_End:      
        pop r0
    
    rts

Restart_Game:
    inchar  r0
    loadn   r1, #' '
    
    cmp r0, r1
    jeq Restart_Activate
    
    jmp Restart_End
    
    Restart_Activate:
        loadn r0, #615
        loadn r1, #EraseGameOver
        loadn r2, #0
        call Imprime
        
        loadn r0, #687
        loadn r1, #EraseRestart
        loadn r2, #0
        call Imprime
    
        call Apaga_heroi
        call Abertura
 
        jmp ingame_loop
        
    Restart_End:
    
    rts

Qualdiff:
    ;push r0
    ;push r1
    push r2
    push r3

    inchar  r0
    loadn   r1, #0 ; facil
    loadn   r2, #1 ; medio
    loadn   r3, #2 ; dificil
    
    cmp r0, r1
    jeq modo_facil
    
    cmp r0, r2
    jeq modo_medio
    
    cmp r0, r3
    jeq modo_dificil
    
    modo_facil:
        store dificuldade, r1
        jmp fim_Qualdiff
    modo_medio:
        store dificuldade, r2
        jmp fim_Qualdiff
    modo_dificil:
        store dificuldade, r3
        jmp fim_Qualdiff
        
fim_Qualdiff:
    pop r3
    pop r2
    ;pop r1
    ;pop r0
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
    
;********************************************************
;                       IMPRIME TELA
;********************************************************   

ImprimeTela_facil:    ;  Rotina de Impresao de Cenario na Tela Inteira
        ;  r1 = endereco onde comeca a primeira linha do Cenario
        ;  r2 = cor do Cenario para ser impresso

    push r0 ; protege o r3 na pilha para ser usado na subrotina
    push r1 ; protege o r1 na pilha para preservar seu valor
    push r2 ; protege o r1 na pilha para preservar seu valor
    push r3 ; protege o r3 na pilha para ser usado na subrotina
    push r4 ; protege o r4 na pilha para ser usado na subrotina
    push r5 ; protege o r4 na pilha para ser usado na subrotina

    loadn r0, #0    ; posicao inicial tem que ser o comeco da tela!
    loadn r1 , #tela1Linha0    ; MAPA FÁCIL
    loadn r2 , #cor_mapa ; carrega cor do mapa
    loadn r3, #40   ; Incremento da posicao da tela!
    loadn r4, #41   ; incremento do ponteiro das linhas da tela
    loadn r5, #1200 ; Limite da tela!
    
   ImprimeTela_Loop:
        call ImprimeStr
        add r0, r0, r3      ; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
        add r1, r1, r4      ; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
        cmp r0, r5          ; Compara r0 com 1200
        jne ImprimeTela_Loop    ; Enquanto r0 < 1200

    pop r5  ; Resgata os valores dos registradores utilizados na Subrotina da Pilha
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts
    
ImprimeTela_medio:    ;  Rotina de Impresao de Cenario na Tela Inteira
        ;  r1 = endereco onde comeca a primeira linha do Cenario
        ;  r2 = cor do Cenario para ser impresso

    push r0 ; protege o r3 na pilha para ser usado na subrotina
    push r1 ; protege o r1 na pilha para preservar seu valor
    push r2 ; protege o r1 na pilha para preservar seu valor
    push r3 ; protege o r3 na pilha para ser usado na subrotina
    push r4 ; protege o r4 na pilha para ser usado na subrotina
    push r5 ; protege o r4 na pilha para ser usado na subrotina

    loadn r0, #0    ; posicao inicial tem que ser o comeco da tela!
    loadn r1 , #tela2Linha0    ; MAPA FÁCIL
    loadn r2 , #cor_mapa ; carrega cor do mapa
    loadn r3, #40   ; Incremento da posicao da tela!
    loadn r4, #41   ; incremento do ponteiro das linhas da tela
    loadn R5, #1200 ; Limite da tela!
    
   ImprimeTela_Loop:
        call ImprimeStr
        add r0, r0, r3      ; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
        add r1, r1, r4      ; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
        cmp r0, r5          ; Compara r0 com 1200
        jne ImprimeTela_Loop    ; Enquanto r0 < 1200

    pop r5  ; Resgata os valores dos registradores utilizados na Subrotina da Pilha
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts
    
ImprimeTela_dificil:    ;  Rotina de Impresao de Cenario na Tela Inteira
        ;  r1 = endereco onde comeca a primeira linha do Cenario
        ;  r2 = cor do Cenario para ser impresso

    push r0 ; protege o r3 na pilha para ser usado na subrotina
    push r1 ; protege o r1 na pilha para preservar seu valor
    push r2 ; protege o r1 na pilha para preservar seu valor
    push r3 ; protege o r3 na pilha para ser usado na subrotina
    push r4 ; protege o r4 na pilha para ser usado na subrotina
    push r5 ; protege o r4 na pilha para ser usado na subrotina

    loadn r0, #0    ; posicao inicial tem que ser o comeco da tela!
    loadn r1 , #tela3Linha0    ; MAPA FÁCIL
    loadn r2 , #cor_mapa ; carrega cor do mapa
    loadn r3, #40   ; Incremento da posicao da tela!
    loadn r4, #41   ; incremento do ponteiro das linhas da tela
    loadn R5, #1200 ; Limite da tela!
    
   ImprimeTela_Loop:
        call ImprimeStr
        add r0, r0, r3      ; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
        add r1, r1, r4      ; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
        cmp r0, r5          ; Compara r0 com 1200
        jne ImprimeTela_Loop    ; Enquanto r0 < 1200

    pop r5  ; Resgata os valores dos registradores utilizados na Subrotina da Pilha
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts
                   
;********************************************************
;                   IMPRIME STRING
;********************************************************
 
;  Rotina de Impresao de Mensagens:    
; r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  
; r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   
; Obs: a mensagem sera' impressa ate' encontrar "/0"  
 
ImprimeStr: 
    push r0 ; protege o r0 na pilha para preservar seu valor
    push r1 ; protege o r1 na pilha para preservar seu valor
    push r2 ; protege o r1 na pilha para preservar seu valor
    push r3 ; protege o r3 na pilha para ser usado na subrotina
    push r4 ; protege o r4 na pilha para ser usado na subrotina
    
    loadn r3, #'\0' ; Criterio de parada

   ImprimeStr_Loop: 
        loadi r4, r1
        cmp r4, r3      ; If (Char == \0)  vai Embora
        jeq ImprimeStr_Sai
        add r4, r2, r4  ; Soma a Cor
        outchar r4, r0  ; Imprime o caractere na tela
        inc r0          ; Incrementa a posicao na tela
        inc r1          ; Incrementa o ponteiro da String
        jmp ImprimeStr_Loop
    
   ImprimeStr_Sai:  
    pop r4  ; Resgata os valores dos registradores utilizados na Subrotina da Pilha
    pop r3
    pop r2
    pop r1
    pop r0
    rts
    
;------------------------   
    
    
    
; labirinto fácil  -> 4 chs de distância
tela1Linha0: string "----------------------------------------"
tela1Linha1: string "|......................................|"
tela1Linha2: string "|......................................|"
tela1Linha3: string "|......................................|"
tela1Linha4: string "|......................................|"
tela1Linha5: string "|......................................|"
tela1Linha6: string "|......................................|"
tela1Linha7: string "|......................................|"
tela1Linha8: string "|......................................|"
tela1Linha9: string "|......................................|"
tela1Linha10: string "|......................................|"
tela1Linha11: string "|......................................|"
tela1Linha12: string "|......................................|"
tela1Linha13: string "|......................................|"
tela1Linha14: string "|......................................|"
tela1Linha15: string "|......................................|"
tela1Linha16: string "|..............-------------...........|"
tela1Linha17: string "|......................................|"
tela1Linha18: string "|......................................|"
tela1Linha19: string "|......................................|"
tela1Linha20: string "|......................................|"
tela1Linha21: string "|......................................|"
tela1Linha22: string "|......................................|"
tela1Linha23: string "|......................................|"
tela1Linha24: string "|......................................|"
tela1Linha25: string "|......................................|"
tela1Linha26: string "|......................................|"
tela1Linha27: string "|......................................|"
tela1Linha28: string "|......................................|"
tela1Linha29: string "--------------------------------------- "


; labirinto médio -> 3 chs de distância
tela2Linha0: string "----------------------------------------"
tela2Linha1: string "|......................................|"
tela2Linha2: string "|......................................|"
tela2Linha3: string "|......................................|"
tela2Linha4: string "|......................................|"
tela2Linha5: string "|......................................|"
tela2Linha6: string "|......................................|"
tela2Linha7: string "|......................................|"
tela2Linha8: string "|......................................|"
tela2Linha9: string "|......................................|"
tela2Linha10: string "|......................................|"
tela2Linha11: string "|......................................|"
tela2Linha12: string "|......................................|"
tela2Linha13: string "|......................................|"
tela2Linha14: string "|......................................|"
tela2Linha15: string "|......................................|"
tela2Linha16: string "|......................................|"
tela2Linha17: string "|......................................|"
tela2Linha18: string "|......................................|"
tela2Linha19: string "|......................................|"
tela2Linha20: string "|......................................|"
tela2Linha21: string "|......................................|"
tela2Linha22: string "|......................................|"
tela2Linha23: string "|......................................|"
tela2Linha24: string "|......................................|"
tela2Linha25: string "|......................................|"
tela2Linha26: string "|......................................|"
tela2Linha27: string "|......................................|"
tela2Linha28: string "|......................................|"
tela2Linha29: string "--------------------------------------- "

; labirinto difícil -> 2 chs de distância
tela3Linha0: string "----------------------------------------"
tela3Linha1: string "|......................................|"
tela3Linha2: string "|......................................|"
tela3Linha3: string "|......................................|"
tela3Linha4: string "|......................................|"
tela3Linha5: string "|......................................|"
tela3Linha6: string "|......................................|"
tela3Linha7: string "|......................................|"
tela3Linha8: string "|......................................|"
tela3Linha9: string "|......................................|"
tela3Linha10: string "|......................................|"
tela3Linha11: string "|......................................|"
tela3Linha12: string "|......................................|"
tela3Linha13: string "|......................................|"
tela3Linha14: string "|......................................|"
tela3Linha15: string "|......................................|"
tela3Linha16: string "|......................................|"
tela3Linha17: string "|......................................|"
tela3Linha18: string "|......................................|"
tela3Linha19: string "|......................................|"
tela3Linha20: string "|......................................|"
tela3Linha21: string "|......................................|"
tela3Linha22: string "|......................................|"
tela3Linha23: string "|......................................|"
tela3Linha24: string "|......................................|"
tela3Linha25: string "|......................................|"
tela3Linha26: string "|......................................|"
tela3Linha27: string "|......................................|"
tela3Linha28: string "|......................................|"
tela3Linha29: string "--------------------------------------- "
