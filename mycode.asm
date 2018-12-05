include DrwShp1.inc
include DrwShp2.inc
include Menu.inc
include Rocket.inc
.MODEL SMALL
;.386    
.STACK 64
.DATA
;-------------------Messages Appear to the user in the Main Menu-------------------
text1 db 'Space Impact','$'
text2 db 'Enter The Game','$'
text3 db 'How to Play','$'
text4 db 'Exit The Game','$'
;-------------------Messages Appear to the user in the Play Menu-------------------
text5 db 'To Return Back To The Main Menu Press ESC','$';if the user wants to end the game
Ship1Health db 'Health of Ship 1 :',03H,03H,03H,03H,03H,03H,03H,03H,03H,03H,'$' ; showing the health text of ship1
HealthToRemoveIndex1 dw 9 
Ship2Health db 'Health of Ship 2 :',03H,03H,03H,03H,03H,03H,03H,03H,03H,03H,'$' ; showing the health text of ship2
HealthToRemoveIndex2 dw 9
;--------------Ship1 Shapes--------------------------------------------------------
Ship1R1 db '**','$'
Ship1R2 db ' ** ***','$'
Ship1R3 db '  * ** *','$'
Ship1R4 db ' * **** **','$'
Ship1R5 db '  * ** *','$'
Ship1R6 db ' ** ***','$'
Ship1R7 db '**','$'
;--------------Ship2 Shapes--------------------------------------------------------
Ship2R1 db '**','$'
Ship2R2 db ' ** ***','$'
Ship2R3 db '  * ** *','$'
Ship2R4 db ' * **** **','$'
Ship2R5 db '  * ** *','$'
Ship2R6 db ' ** ***','$'
Ship2R7 db '**','$'  
;--------------Ship Edges----------------------------------------------------------
Ship1Edges dw ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,? ;16
Ship2Edges dw ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,? ;16
;--------------Fire Shape----------------------------------------------------------
Fire1Shape db 0AFH,'$'
Fire2Shape db 0AEH,'$'
;--------------Fire Position----------------------------------------------------------
Fire1Position dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;50
Fire1Count dw 50
Fire2Position dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;50    
Fire2Count dw 50

.CODE

MAIN PROC FAR
MOV AX,@DATA
MOV DS,AX         
;----------------Disable Cursor-----------------------------------
Mov ch, 32
Mov ah, 1
Int 10h
;----------------Main Menu----------------------------------------
MainMenulbl:
DrawingMainMenu

       
;--------------Changing the background to green-------------------
PlayMode:
mov ax,0600h 
mov bh,0A0h  ;changing the playmode color to green
mov cx,0
mov dx,184FH
int 10h

mov ax,0600h ;coloring the first half of the screen with red text
mov bh,1011b
mov cx,1500H
mov dx,1628H
int 10h
mov bx,0

mov ax,0600h ;coloring the second half of the screen with blue text
mov bh,0A9h
mov cx,1528H
mov dx,164FH
int 10h
mov bx,0

;----------------------------------------------------------------- 
;------------Intializing Ship 1 Position
mov dx,0000
mov ah,02
int 10h
mov di,dx ; taking coordinate of ship 1
;------------Intializing Ship 1 Edges 
mov Ship1Edges[0],dx
add dx, 0001H
mov Ship1Edges[2],dx
add dx, 0101H
mov Ship1Edges[4],dx 
add dx, 0002H
mov Ship1Edges[6],dx 
add dx, 0001H
mov Ship1Edges[8],dx
add dx, 0001H
mov Ship1Edges[10],dx 
add dx, 0101H
mov Ship1Edges[12],dx
add dx, 0101H
mov Ship1Edges[14],dx
add dx, 0001H
mov Ship1Edges[16],dx

sub dx,0002H
add dx,0100H
mov Ship1Edges[18],dx 
sub dx,0001H
add dx,0100H
mov Ship1Edges[20],dx
sub dx,0001H       
mov Ship1Edges[22],dx
sub dx,0001H       
mov Ship1Edges[24],dx
sub dx,0002H       
mov Ship1Edges[26],dx 
sub dx,0001H
add dx,0100H  
mov Ship1Edges[28],dx   
sub dx,0001H 
mov Ship1Edges[30],dx


;------------Intializing Ship 2 Position
mov dx,004EH
mov ah,02
int 10h
mov si,dx ; taking the coordinate of ship 2 

;------------Intializing Ship 2 Edges 
mov Ship2Edges[0],dx
sub dx, 0001H
mov Ship2Edges[2],dx
sub dx, 0001H
add dx, 0100H
mov Ship2Edges[4],dx 
sub dx, 0002H
mov Ship2Edges[6],dx 
sub dx, 0001H
mov Ship2Edges[8],dx
sub dx, 0001H
mov Ship2Edges[10],dx 
sub dx, 0001H  
add dx, 0100H
mov Ship2Edges[12],dx
sub dx, 0001H 
add dx, 0100H
mov Ship2Edges[14],dx
sub dx, 0001H
mov Ship2Edges[16],dx

add dx,0102H
mov Ship2Edges[18],dx 
add dx,0101H
mov Ship2Edges[20],dx
add dx,0001H       
mov Ship2Edges[22],dx
add dx,0001H       
mov Ship2Edges[24],dx
add dx,0002H       
mov Ship2Edges[26],dx 
add dx,0101H 
mov Ship2Edges[28],dx   
add dx,0001H 
mov Ship2Edges[30],dx
        
lbltest:

check:
mov ah,1
int 16h
pushf
call NewFrame
popf 
jz check

mov ah,0
int 16h

;Check if it is up or down or fire for Ship 1
;--------------Down-------------
cmp al,73H
jz DownShip1
cmp al,53H ;capital S
jz DownShip1 
;---------------Up--------------
cmp al,77H
jz UpShip1
cmp al,57H ;capital W
jz UpShip1
;--------------Fire-------------
cmp al,63H
jz FireShip1
cmp al,43H ;capital C
jz FireShip1

;Check if it is up or down or fire for Ship 2
;--------------Down--------------
cmp al,6AH ;small j
jz DownShip2
cmp al,4AH ;capital J
jz DownShip2
;---------------Up---------------
cmp al,75H ;small u
jz UpShip2
cmp al,55H ;capital U
jz UpShip2
;-------------Fire---------------
cmp al,62H ;small b
jz FireShip2
cmp al,42H ;capital B
jz FireShip2
;-----------Back to menu---------
cmp al,1BH
jz MainMenulbl



jmp lbltest
;-----------------------moving ship1 down/up-----------------------
DownShip1:
;-------Clearing the ship 1 to change it the new postion (Downward Position)
mov bx,0
mov dx,di

cmp dh,0Dh ; check if ship 1 is very below so it willnot go more down
jz DontInc
inc dh 
add Ship1Edges[0],0100H
add Ship1Edges[2],0100H
add Ship1Edges[4],0100H 
add Ship1Edges[6],0100H 
add Ship1Edges[8],0100H
add Ship1Edges[10],0100H
add Ship1Edges[12],0100H
add Ship1Edges[14],0100H
add Ship1Edges[16],0100H
add Ship1Edges[18],0100H 
add Ship1Edges[20],0100H
add Ship1Edges[22],0100H
add Ship1Edges[24],0100H
add Ship1Edges[26],0100H   
add Ship1Edges[28],0100H   
add Ship1Edges[30],0100H
DontInc:
mov ah,02
int 10h 

mov di,dx

jmp lbltest


UpShip1:
;-------Clearing the ship 1 to change it the new postion (Upward Position)
mov bx,0
mov dx,di

cmp dh,00H
jz DontDec ; check if ship 1 is at the ceil of the screen so it willnot go more up
dec dh   
sub Ship1Edges[0],0100H
sub Ship1Edges[2],0100H
sub Ship1Edges[4],0100H 
sub Ship1Edges[6],0100H 
sub Ship1Edges[8],0100H
sub Ship1Edges[10],0100H
sub Ship1Edges[12],0100H
sub Ship1Edges[14],0100H
sub Ship1Edges[16],0100H
sub Ship1Edges[18],0100H 
sub Ship1Edges[20],0100H
sub Ship1Edges[22],0100H
sub Ship1Edges[24],0100H
sub Ship1Edges[26],0100H   
sub Ship1Edges[28],0100H   
sub Ship1Edges[30],0100H
DontDec:
mov ah,02
int 10h

mov di,dx

jmp lbltest                                                          
;--------------------Fire Ship 1----------------------------------
FireShip1:     
mov bx,0
mov cx, Fire1Count
l1:     
mov dx, Fire1Position[bx]
cmp dx,0
jz FoundEmpty1 
inc bx
loop l1
cmp cx,0
jz finish1 ;if there is no empty fire slot
 
FoundEmpty1:   
mov ax, Ship1Edges[16]
mov Fire1Position[bx], ax
finish1:
jmp lbltest

;------------------------------------------------------------------
;-----------------------moving ship2 down/up-----------------------
DownShip2:
;-------Clearing the ship 2 to change it the new postion (Downward Position)
mov BX,00
mov dx,si
mov dl,4EH

cmp dh,0Dh ; check if ship 1 is very below so it willnot go more down
jz DontInc2
inc dh 
add Ship2Edges[0],0100H
add Ship2Edges[2],0100H
add Ship2Edges[4],0100H 
add Ship2Edges[6],0100H 
add Ship2Edges[8],0100H
add Ship2Edges[10],0100H
add Ship2Edges[12],0100H
add Ship2Edges[14],0100H
add Ship2Edges[16],0100H
add Ship2Edges[18],0100H 
add Ship2Edges[20],0100H
add Ship2Edges[22],0100H
add Ship2Edges[24],0100H
add Ship2Edges[26],0100H   
add Ship2Edges[28],0100H   
add Ship2Edges[30],0100H
DontInc2:
mov ah,02
int 10h 

mov si,dx

jmp lbltest


UpShip2:
mov BX,00
mov dx,si
mov dl,4EH

cmp dh,00H
jz DontDec2 ; check if ship 1 is at the ceil of the screen so it willnot go more up
dec dh    
sub Ship2Edges[0],0100H
sub Ship2Edges[2],0100H
sub Ship2Edges[4],0100H 
sub Ship2Edges[6],0100H 
sub Ship2Edges[8],0100H
sub Ship2Edges[10],0100H
sub Ship2Edges[12],0100H
sub Ship2Edges[14],0100H
sub Ship2Edges[16],0100H
sub Ship2Edges[18],0100H 
sub Ship2Edges[20],0100H
sub Ship2Edges[22],0100H
sub Ship2Edges[24],0100H
sub Ship2Edges[26],0100H   
sub Ship2Edges[28],0100H   
sub Ship2Edges[30],0100H
DontDec2:
mov ah,02
int 10h

mov si,dx         

jmp lbltest                                                                   
;-------------------------------------------------------------------
FireShip2:     
mov bx,0
mov cx, Fire2Count
l2:     
mov dx, Fire2Position[bx]
cmp dx,0
jz FoundEmpty2 
inc bx
loop l2
cmp cx,0
jz finish2 ;if there is no empty fire slot
 
FoundEmpty2:   
mov ax, Ship2Edges[16]
mov Fire2Position[bx], ax
finish2:
jmp lbltest



    
MAIN ENDP

;Drawing Ship 1

DrawShip1 PROC NEAR 
    DrawingShip1 
    sub di,600H
    ret
DrawShip1 endp

;Drawing Ship 2
DrawShip2 PROC NEAR 
    DrawingShip2 
    sub si,600H
    ret
DrawShip2 endp 

;Drawing Horizontal Line
DrawHorz PROC NEAR
    mov bp,80
    mov ah,2
    int 10H
    LoopHorz:
        mov cl,dl
        mov ch,dh
    
        mov ah,2
        mov dl,'-'
        int 21h
         
        mov dl,cl
        mov dh,ch
      
        inc dl
        mov ah,2
        int 10H
        
        dec bp
        cmp bp,00
    jnz LoopHorz
    ret
DrawHorz endp

NewFrame PROC NEAR
    ;--------------------Clear Frame-------------------
    mov ax,0600h
    mov bh,0A9H
    mov cx,0
    mov dx,1950H
    int 10h
    ;-------------------Draw Fire---------------------- 
    mov cx,Fire1Count
    mov bx, 0          ;intialization
    mov ah,2        ;draw char function and move cursor
    l3:                 
    mov dx, Fire1Position[bx]
    cmp dx,00
    jz DontDraw3
       
    cmp cx,0 
    jz finish3
        
    add Fire1Position[bx], 0001H ;move right towards the ship2
    mov dx, Fire1Position[bx]
    pusha                     
    ;------------------------------------------------------------
    RocketExplode1
    ;------------------------------------------------------------ 
    pop ax ;to get true or false
    cmp ax,1 ;don't draw if true                             
    popa
    jz DontDraw3
     
    int 10h  ;move cursor  
    mov dl, Fire1Shape ; >> shape         
    int 21h  ;draw char
    DontDraw3:
    add bx,2 ;because it's a word 
    finish3:       
    loop l3 
    
    mov cx,Fire2Count
    mov bx, 0          ;intialization
    mov ah,2        ;draw char function and move cursor
    l4:                 
    mov dx, Fire2Position[bx]
    cmp dx,00
    jz DontDraw4
       
    cmp cx,0 
    jz finish4
        
    sub Fire2Position[bx], 0001H ;move left towards the ship1  
    mov dx, Fire2Position[bx]
    pusha
    ;-----------------------------------------------------------                            
    RocketExplode2
    ;-----------------------------------------------------------
    pop ax ;to get true or false
    cmp ax,1 ;don't draw if true        
    popa
    jz DontDraw4
     
    int 10h  ;move cursor  
    mov dl, Fire2Shape ; << shape         
    int 21h  ;draw char
    DontDraw4:
    add bx,2 ;because it's a word 
    finish4:       
    loop l4    
    
    
    
    ;----------positioning of the Health Bars of the Ships------------
    mov dx,1400H
    CALL DrawHorz
    
    mov dx,1600H
    CALL DrawHorz
    
    mov dl,35h
    mov dh,15h
    mov ah,2
    int 10h         
           
    
    mov ah,9
    mov dx,offset Ship2Health
    int 21h 
    
    mov dl,00h
    mov dh,15h
    mov ah,2
    int 10h 
    
    mov ah,9
    mov dx,offset Ship1Health
    int 21h
    
    mov dl,00h
    mov dh,17h
    mov ah,2
    int 10h 
    
    mov ah,9
    mov dx,offset text5
    int 21h
    
    mov dl,00h
    mov dh,17h
    mov ah,2
    int 10h
    ;-----------draw ships----------------
    call DrawShip1
    call DrawShip2
    ret
NewFrame endp 



ExitGame:

end main