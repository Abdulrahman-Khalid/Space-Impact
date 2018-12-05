RocketExplode1 Macro         
local L5,L6,ExplodeOnRocket1,ExplodeOnWall1,ExplodeOnShip1,PushFalse1,ret1
    ;--------------------Check if explode on the other ship  
    mov di,0
    mov cx, 16
    L5:               
    cmp dx, Ship2Edges[di]
    je ExplodeOnShip1 
    add di,2
    loop L5 
    
    ;-------------------Check if explode on wall           
    cmp dl,0
    je ExplodeOnWall1 
    
    mov di,0
    mov cx,Fire2Count
    ;--------------------Check if rocket hit another rocket 
    L6:
    cmp dx, Fire2Position[di]
    je ExplodeOnRocket1
    add di,2
    loop L6 
    cmp cx,0
    jz PushFalse1 ; to skip the deletion
    
    ExplodeOnShip1:
    mov Fire1Position[bx], 0000H ;deleted
    mov ax,1  
    push ax ;1 as true
    mov di,HealthToRemoveIndex2
    mov Ship2Health[di],'$'       
    sub HealthToRemoveIndex2, 1
    jmp ret1
             
    ExplodeOnRocket1:
    mov Fire1Position[bx], 0000H ;deleted
    mov ax,1  
    push ax ;1 as true
    jmp ret1 
    
    ExplodeOnWall1:
    mov Fire1Position[bx], 0000H ;deleted
    mov Fire2Position[di], 0000H ;deleted
    mov ax,1  
    push ax ;1 as true
    jmp ret1
    PushFalse1:  
    mov ax,0  
    push ax ;0 as false 
    ret1:
endm RocketExplode1
;-------------------------------------------------------------------------------------------
RocketExplode2 Macro         
local L7,L8,ExplodeOnRocket2,ExplodeOnWall2,ExplodeOnShip2,PushFalse2,ret2
 
    ;--------------------Check if explode on the other ship      
    mov di,0
    mov cx, 16   
    L7:               
    cmp dx, Ship1Edges[di]
    je ExplodeOnShip2 
    add di,2
    loop L7 
    
    ;-------------------Check if explode on wall           
    cmp dl,50
    je ExplodeOnWall2
    
    mov di,0
    mov cx,Fire1Count 
    ;-------------------Check if explode on Rocket  
    L8:
    cmp dx, Fire1Position[di]
    je ExplodeOnRocket2
    add di,2
    loop L8 
    cmp cx,0
    jz PushFalse2 ; to skip the deletion
    
    ExplodeOnShip2:
    mov Fire2Position[bx], 0000H ;deleted
    mov ax,1  
    push ax ;1 as true
    mov di,HealthToRemoveIndex1
    mov Ship1Health[di],'$'       
    sub HealthToRemoveIndex1, 1
    jmp ret2
             
    ExplodeOnRocket2:
    mov Fire1Position[bx], 0000H ;deleted
    mov Fire1Position[di], 0000H ;deleted
    mov ax,1  
    push ax ;1 as true
    jmp ret2 
    
    ExplodeOnWall2:
    mov Fire1Position[bx], 0000H ;deleted
    mov ax,1  
    push ax ;1 as true
    jmp ret2
    
    PushFalse2:  
    mov ax,0  
    push ax ;0 as false 
    ret2: 

endm RocketExplode2