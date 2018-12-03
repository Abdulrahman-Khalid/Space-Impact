;-----------------MACROS------
DrawingShields MACRO

local LoopShield1
local LoopShield2
local LoopShield3
local LoopShield4
local LoopShield5 

mov bp,4
    mov dx,072BH
    mov ah,2
    int 10H
    LoopShield1:
        mov cl,dl
        mov ch,dh
    
        mov ah,2
        mov dl,'#'
        int 21h
         
        mov dl,cl
        mov dh,ch
      
        inc dl
        mov ah,2
        int 10H
        
        dec bp
        cmp bp,00
    jnz LoopShield1
    
    mov bp,3
    mov dl,2BH
    mov ah,2
    int 10h
    LoopShield2:
        mov cl,dl
        mov ch,dh
    
        mov ah,2
        mov dl,'#'
        int 21h
         
        mov dl,cl
        mov dh,ch
      
        inc dh
        mov ah,2
        int 10H
        
        dec bp
        cmp bp,0
    jnz LoopShield2
    
    mov bp,4
    LoopShield3:
        mov cl,dl
        mov ch,dh
    
        mov ah,2
        mov dl,'#'
        int 21h
         
        mov dl,cl
        mov dh,ch
      
        dec dl
        mov ah,2
        int 10H
        
        dec bp
        cmp bp,00
    jnz LoopShield3
    
    mov bp,3
    LoopShield4:
        mov cl,dl
        mov ch,dh
    
        mov ah,2
        mov dl,'#'
        int 21h
         
        mov dl,cl
        mov dh,ch
      
        inc dh
        mov ah,2
        int 10H
        
        dec bp
        cmp bp,00
    jnz LoopShield4 
    
    
     mov bp,4
    LoopShield5:
        mov cl,dl
        mov ch,dh
    
        mov ah,2
        mov dl,'#'
        int 21h
         
        mov dl,cl
        mov dh,ch
      
        dec dl
        mov ah,2
        int 10H
        
        dec bp
        cmp bp,00
    jnz LoopShield5
            
ENDM DrawingShields              






