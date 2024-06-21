

; 3328 rosa  (cor do herói)           1101 0000

; Contantes

; variável para posição do herói
heroi_posicao: var #1
; variável para diração que o herói está indo
direcao: var #1 

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
game_over: string "Seu herói morreu! Tente novamente!!"

; Função principal do jogo
Main:
    call Abertura
    call Draw_Map
    
    loop:
        ingame_loop:
            call Draw_Snake
            call Dead_Snake
            
            call Move_Snake
            call New_Obstacle 
            
            call Delay
                
            jmp ingame_loop
            
        GameOver_loop:
            call Restart_Game
        
            jmp GameOver_loop
    
; Funções


Abertura:

    ; inicializa registradores
    push r0     
    push r1
    
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
    
    ; libera registradores
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
    
    
    
    
    
; labirinto fácil  -> 4 chs de distância
tela1Linha0: string "----------------------------------------"
tela1Linha1: string "|                                      |"
tela1Linha2: string "|                                      |"
tela1Linha3: string "|                                      |"
tela1Linha4: string "|                                      |"
tela1Linha5: string "|                                      |"
tela1Linha6: string "|                                      |"
tela1Linha7: string "|                                      |"
tela1Linha8: string "|                                      |"
tela1Linha9: string "|                                      |"
tela1Linha10: string "|                                      |"
tela1Linha11: string "|                                      |"
tela1Linha12: string "|                                      |"
tela1Linha13: string "|                                      |"
tela1Linha14: string "|                                      |"
tela1Linha15: string "|                                      |"
tela1Linha16: string "|                                      |"
tela1Linha17: string "|                                      |"
tela1Linha18: string "|                                      |"
tela1Linha19: string "|                                      |"
tela1Linha20: string "|                                      |"
tela1Linha21: string "|                                      |"
tela1Linha22: string "|                                      |"
tela1Linha23: string "|                                      |"
tela1Linha24: string "|                                      |"
tela1Linha25: string "|                                      |"
tela1Linha26: string "|                                      |"
tela1Linha27: string "|                                      |"
tela1Linha28: string "|                                      |"
tela1Linha29: string "--------------------------------------- "


; labirinto médio -> 3 chs de distância
tela1Linha0: string "----------------------------------------"
tela1Linha1: string "|                                      |"
tela1Linha2: string "|                                      |"
tela1Linha3: string "|                                      |"
tela1Linha4: string "|                                      |"
tela1Linha5: string "|                                      |"
tela1Linha6: string "|                                      |"
tela1Linha7: string "|                                      |"
tela1Linha8: string "|                                      |"
tela1Linha9: string "|                                      |"
tela1Linha10: string "|                                      |"
tela1Linha11: string "|                                      |"
tela1Linha12: string "|                                      |"
tela1Linha13: string "|                                      |"
tela1Linha14: string "|                                      |"
tela1Linha15: string "|                                      |"
tela1Linha16: string "|                                      |"
tela1Linha17: string "|                                      |"
tela1Linha18: string "|                                      |"
tela1Linha19: string "|                                      |"
tela1Linha20: string "|                                      |"
tela1Linha21: string "|                                      |"
tela1Linha22: string "|                                      |"
tela1Linha23: string "|                                      |"
tela1Linha24: string "|                                      |"
tela1Linha25: string "|                                      |"
tela1Linha26: string "|                                      |"
tela1Linha27: string "|                                      |"
tela1Linha28: string "|                                      |"
tela1Linha29: string "--------------------------------------- "

; labirinto difícil -> 2 chs de distância
tela1Linha0: string "----------------------------------------"
tela1Linha1: string "|                                      |"
tela1Linha2: string "|                                      |"
tela1Linha3: string "|                                      |"
tela1Linha4: string "|                                      |"
tela1Linha5: string "|                                      |"
tela1Linha6: string "|                                      |"
tela1Linha7: string "|                                      |"
tela1Linha8: string "|                                      |"
tela1Linha9: string "|                                      |"
tela1Linha10: string "|                                      |"
tela1Linha11: string "|                                      |"
tela1Linha12: string "|                                      |"
tela1Linha13: string "|                                      |"
tela1Linha14: string "|                                      |"
tela1Linha15: string "|                                      |"
tela1Linha16: string "|                                      |"
tela1Linha17: string "|                                      |"
tela1Linha18: string "|                                      |"
tela1Linha19: string "|                                      |"
tela1Linha20: string "|                                      |"
tela1Linha21: string "|                                      |"
tela1Linha22: string "|                                      |"
tela1Linha23: string "|                                      |"
tela1Linha24: string "|                                      |"
tela1Linha25: string "|                                      |"
tela1Linha26: string "|                                      |"
tela1Linha27: string "|                                      |"
tela1Linha28: string "|                                      |"
tela1Linha29: string "--------------------------------------- "
