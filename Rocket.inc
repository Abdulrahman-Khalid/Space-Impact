RocketExplode1 Macro        
local L5,L6,L6P2,L9,ExplodeOnRocket1,ExplodeOnWall1,ExplodeOnShip1,ret1,ExplodeOnShield1,DrawHeath1,Dead1,SkipShield1,HitBonus1,FireBonus1,CantAddMoreHearts1,DrawHeath3 
    ;--------------------Check if explode on the other ship's shield
    ;--------------------Check if explode on the other ship's shield
    mov ax, Shield2On
    cmp ax,0; off
    jz SkipShield1
    
    mov cx, 7 
    mov ax, Ship2Edges[0]
    sub al,0AH ;start of the shield
    L9:               
    cmp dx, ax
    jz ExplodeOnShield1                                               
    inc ah  ; increase y
    loop L9  
    SkipShield1:
    ;--------------------Check if explode on the other ship  
    mov di,0
    mov cx, 16
    L5:               
    cmp dx, Ship2Edges[di]
    jz ExplodeOnShip1 
    add di,2
    loop L5 
                                                
    ;-------------------Check if explode on wall           
    cmp dl,50H
    jz ExplodeOnWall1 
    
    mov di,0
    mov cx,Fire2Count
    ;--------------------Check if rocket hit another rocket >< 
    L6:
    cmp dx, Fire2Position[di]
    jz ExplodeOnRocket1
    add di,2
    loop L6 
    
    mov di,0
    mov cx,Fire2Count
    ;--------------------Check if rocket hit another rocket part2 [[imp]] > <
    L6P2:    
    mov ax, Fire2Position[di]
    dec ax
    cmp dx, ax
    jz ExplodeOnRocket1
    add di,2
    loop L6P2
    
    ;---------------------------Push False--------------------------------------  
    mov ax,0  
    push ax ;0 as false
    
    ;--------------------Check if hit the bonus---------------------------------
    mov ax, CheckCond
    cmp ax,1 ; not exist
    jz ret1
     
    mov ah, randheartpos
    mov al, 42d ;half the screen (x)
    cmp dx, ax
    jz HitBonus1 ;not exploded 
    jmp ret1
    ;---------------------------Hit Bonus Jump----------------------------------                                                                                            
    HitBonus1:
    mov CheckCond, 1
    cmp bonustype, 0 ;fire
    jz FireBonus1
    
    
    mov ax, HealthToRemoveIndex1 
    inc ax
    cmp ax, MaxHealthHearts 
    jz CantAddMoreHearts1      
    
    add HealthToRemoveIndex1, 1
    mov di, HealthToRemoveIndex1   
    mov Health1Power[di],2      
    
    ;-----xchang Health1Power[di] with Health1Power[di-1] so it white heart xchange it with red and draw white after it----------
    mov dh, Health1Power[di] 
    dec di       
    mov dl, Health1Power[di]
    mov Health1Power[di], dh
    inc di
    mov Health1Power[di], dl
    jmp DrawHeath3
    ;---------MAX HEARTS--------- 
    CantAddMoreHearts1: 
    mov di, HealthToRemoveIndex1   
    mov Health1Power[di],2
    jmp DrawHeath3
    ;--------------------------Fire Bonus Jump-----------------------------------
    FireBonus1:
    mov ax,MaxFireCount
    cmp ax,Fire1Count
    jz  ret1  
    add Fire1Count, 1 
    jmp ret1
    ;----------------------------------------------------------------------------
                   
    ;--------------------------Jumps--------------------------------------------- 
    ;--------------------------Shield--------------------------------------------
    ExplodeOnShield1:
    mov Fire1Position[si], 0000H ;deleted
    mov ax,1  
    push ax ;1 as true
    mov di, HealthToRemoveIndex2
    sub Health2Power[di],1 
    mov dh, Health2Power[di]
    cmp dh, 1
    jz DrawHeath1        
    sub HealthToRemoveIndex2, 1      
    jmp DrawHeath1
    ;--------------------------Ship---------------------------------------------
    ExplodeOnShip1:
    mov Fire1Position[si], 0000H ;deleted
    mov ax,1  
    push ax ;1 as true  
    ;--------------------Logic-------------------------
    mov di,HealthToRemoveIndex2 
    sub HealthToRemoveIndex2, 1 
    mov ax, HealthToRemoveIndex2
    cmp ax, 0FFFFH ;overflow (OtherShip Destroyed)
    jz Dead1       
    ;-------------------change last two hearts' power and give the last one zero power------
    mov dh, Health2Power[di]        
    mov Health2Power[di], 0
    dec di          
    mov Health2Power[di], dh 
    jmp DrawHeath1  
    
    Dead1:
    mov Health2Power[di], 0
    jmp DrawHeath1
    
    ;-------------------------Rocket--------------------------------------------         
    ExplodeOnRocket1:
    mov Fire1Position[si], 0000H ;deleted 
    mov Fire2Position[di], 0000H ;deleted
    mov ax,1  
    push ax ;1 as true
    jmp ret1 
    
    ExplodeOnWall1:
    mov Fire1Position[si], 0000H ;deleted
    mov ax,1  
    push ax ;1 as true
    jmp ret1
     
    DrawHeath1:
    mov ax,0600h
    mov bh,0CH ;Red heart for the second ship
    mov cx,1539H
    mov dx,1542H 
    int 10h   
    
    mov bx,0
    mov ah,2
    mov dx,1539H ;start of heart
    int 10h
    
    mov cx, HealthToRemoveIndex2
    cmp cx, 0FFFFH
    jz ret1
 
    inc cx     ;number of hearts
        
    mov ah,9   ;Display
    mov bh,0   ;Page 0
    mov al,03H ;Heart Symbol
    mov bl,09H ;Blue, black bg 
    int 10h                 
    
    mov di, HealthToRemoveIndex2
    mov dh, Health2Power[di]
    cmp dh, 2
    jz ret1
    ;---------------------draw white heart---------------
    mov bx,0
    mov ah,2
    mov dx,1539H ;start of heart
    add dx, HealthToRemoveIndex2 ;start of white heart
    int 10h                     
    
    mov ah,9   ;Display
    mov bh,0   ;Page 0
    mov al,03H ;Heart Symbol
    mov bl,0FH ;White, black bg
    mov cx,1   ;1 time 
    int 10h
    jmp ret1

    DrawHeath3:
    mov ax,0600h
    mov bh,09H ;blue heart for the second ship
    mov cx,1511H
    mov dx,151FH 
    int 10h   
    
    mov bx,0
    mov ah,2
    mov dx,1511H ;start of heart
    int 10h
    
    mov cx, HealthToRemoveIndex1
    cmp cx, 0FFFFH
    jz ret1
 
    inc cx     ;number of hearts
        
    mov ah,9   ;Display
    mov bh,0   ;Page 0
    mov al,03H ;Heart Symbol
    mov bl,0CH ;Red, black bg 
    int 10h                 
    
    mov di, HealthToRemoveIndex1
    mov dh, Health1Power[di]
    cmp dh, 2
    jz ret1
    ;---------------------draw white heart---------------
    mov bx,0
    mov ah,2
    mov dx,1511H ;start of heart
    add dx, HealthToRemoveIndex1 ;start of white heart
    int 10h                     
    
    mov ah,9   ;Display
    mov bh,0   ;Page 0
    mov al,03H ;Heart Symbol
    mov bl,0FH ;White, black bg
    mov cx,1   ;1 time 
    int 10h
    
    ret1:
    ;------------------------------------------------------------
    
endm RocketExplode1

;-------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------

RocketExplode2 Macro         
local L7,L8,ExplodeOnWall2,ret2,ExplodeOnShield2,DrawHeath2,Dead2,SkipShield2,HitBonus2,FireBonus2,CantAddMoreHearts2,DrawHeath4 
     ;--------------------Check if explode on the other ship's shield
    mov ax, Shield1On
    cmp ax,0; off
    jz SkipShield2
    
    mov cx, 7 
    mov ax, Ship1Edges[0]
    add al,0AH ;start of the shield
    L8:               
    cmp dx, ax
    jz ExplodeOnShield2                                               
    inc ah  ; increase y
    loop L8           
    SkipShield2:
    ;--------------------Check if explode on the other ship's body      
    mov di,0
    mov cx, 16   
    L7:               
    cmp dx, Ship1Edges[di]
    jz ExplodeOnShip2 
    add di,2
    loop L7 
    
    ;-------------------Check if explode on wall           
    cmp dl,0FFH
    jz ExplodeOnWall2
    
    ;---------------------------Push False--------------------------------------  
    mov ax,0  
    push ax ;0 as false 
    
    ;--------------------Check if hit the bonus---------------------------------
    mov ax, CheckCond
    cmp ax,1 ; not exist
    jz ret2
     
    mov ah, randheartpos
    mov al, 42d ;half the screen (x)
    cmp dx, ax
    jz HitBonus2 ;not exploded 
    jmp ret2
                                                                      
    ;---------------------------Hit Bonus Jump----------------------------------                                                                                           
    HitBonus2: 
    mov CheckCond, 1
    cmp bonustype, 0 ;fire
    jz FireBonus2
    
    
    mov ax, HealthToRemoveIndex2 
    inc ax
    cmp ax, MaxHealthHearts 
    jz CantAddMoreHearts2      
    
    add HealthToRemoveIndex2, 1
    mov di, HealthToRemoveIndex2   
    mov Health2Power[di],2      
    
    ;-----xchang Health1Power[di] with Health1Power[di-1] so it white heart xchange it with red and draw white after it----------
    mov dh, Health2Power[di] 
    dec di       
    mov dl, Health2Power[di]
    mov Health2Power[di], dh
    inc di
    mov Health2Power[di], dl
    jmp DrawHeath4
    ;---------MAX HEARTS--------- 
    CantAddMoreHearts2: 
    mov di, HealthToRemoveIndex2   
    mov Health2Power[di],2
    jmp DrawHeath4
    ;--------------------------Fire Bonus Jump-----------------------------------
    FireBonus2:  
    mov ax,MaxFireCount
    cmp ax,Fire2Count
    jz  ret2
    add Fire2Count, 1
    jmp ret2
    ;----------------------------------------------------------------------------
    
    ;---------------------------jumps-------------------------------------------
    ExplodeOnShield2:
    mov Fire2Position[si], 0000H ;deleted
    mov ax,1  
    push ax ;1 as true
    mov di, HealthToRemoveIndex1
    sub Health1Power[di],1 
    mov dh, Health1Power[di]
    cmp dh, 1
    jz DrawHeath2        
    sub HealthToRemoveIndex1, 1      
    jmp DrawHeath2
    
    ExplodeOnShip2:
    mov Fire2Position[si], 0000H ;deleted
    mov ax,1  
    push ax ;1 as true  
    ;--------------------Logic-------------------------
    mov di,HealthToRemoveIndex1 
    sub HealthToRemoveIndex1, 1 
    mov ax, HealthToRemoveIndex1
    cmp ax, 0FFFFH ;overflow (OtherShip Destroyed)
    jz Dead2       
    ;-------------------change last two hearts' power and give the last one zero power------
    mov dh, Health1Power[di]        
    mov Health1Power[di], 0
    dec di          
    mov Health1Power[di], dh 
    jmp DrawHeath2
    
    Dead2:
    mov Health1Power[di], 0
    jmp DrawHeath2
    
    
    ExplodeOnWall2:
    mov Fire2Position[si], 0000H ;deleted
    mov ax,1  
    push ax ;1 as true
    jmp ret2
    
    
    DrawHeath2:
    mov ax,0600h
    mov bh,09H ;blue heart for the second ship
    mov cx,1511H
    mov dx,151FH 
    int 10h   
    
    mov bx,0
    mov ah,2
    mov dx,1511H ;start of heart
    int 10h
    
    mov cx, HealthToRemoveIndex1
    cmp cx, 0FFFFH
    jz ret2
 
    inc cx     ;number of hearts
        
    mov ah,9   ;Display
    mov bh,0   ;Page 0
    mov al,03H ;Heart Symbol
    mov bl,0CH ;Red, black bg 
    int 10h                 
    
    mov di, HealthToRemoveIndex1
    mov dh, Health1Power[di]
    cmp dh, 2
    jz ret2
    ;---------------------draw white heart---------------
    mov bx,0
    mov ah,2
    mov dx,1511H ;start of heart
    add dx, HealthToRemoveIndex1 ;start of white heart
    int 10h                     
    
    mov ah,9   ;Display
    mov bh,0   ;Page 0
    mov al,03H ;Heart Symbol
    mov bl,0FH ;White, black bg
    mov cx,1   ;1 time                                             
    int 10h
    jmp ret2
    
    DrawHeath4:
    mov ax,0600h
    mov bh,0CH ;Red heart for the second ship
    mov cx,1539H
    mov dx,1542H 
    int 10h   
    
    mov bx,0
    mov ah,2
    mov dx,1539H ;start of heart
    int 10h
    
    mov cx, HealthToRemoveIndex2
    cmp cx, 0FFFFH
    jz ret2
 
    inc cx     ;number of hearts
        
    mov ah,9   ;Display
    mov bh,0   ;Page 0
    mov al,03H ;Heart Symbol
    mov bl,09H ;Blue, black bg 
    int 10h                 
    
    mov di, HealthToRemoveIndex2
    mov dh, Health2Power[di]
    cmp dh, 2
    jz ret2
    ;---------------------draw white heart---------------
    mov bx,0
    mov ah,2
    mov dx,1539H ;start of heart
    add dx, HealthToRemoveIndex2 ;start of white heart
    int 10h                     
    
    mov ah,9   ;Display
    mov bh,0   ;Page 0
    mov al,03H ;Heart Symbol
    mov bl,0FH ;White, black bg
    mov cx,1   ;1 time 
    int 10h
    
    ret2:
    ;-----------------------------------------------------------                                                                                                                
endm RocketExplode2