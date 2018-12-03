include Ship1Draw.inc
include Ship2Draw.inc
include MainMenuV2.inc
include Shields.inc
.MODEL SMALL
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
Ship2Health db 'Health of Ship 2 :',03H,03H,03H,03H,03H,03H,03H,03H,03H,03H,'$' ; showing the health text of ship2
;--------------Ship1 Shapes--------------------------------------------------------
Ship1R1 db '**','$'
Ship1R2 db ' ** ***','$'
Ship1R3 db '  * ** *','$'
Ship1R4 db ' * **** **','$'
Ship1R5 db '  * ** *','$'
Ship1R6 db ' ** ***','$'
Ship1R7 db '**','$'
;--------------Ship1 Shapes--------------------------------------------------------
Ship2R1 db '**','$'
Ship2R2 db '*** ** ','$'
Ship2R3 db '* ** * ','$'
Ship2R4 db '** **** * ','$'
Ship2R5 db '* ** * ','$'
Ship2R6 db '*** ** ','$'
Ship2R7 db '**','$'

.CODE

MAIN PROC FAR
MOV AX,@DATA
MOV DS,AX
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
mov bh,0ACh
mov cx,1500H
mov dx,1628H
int 10h
mov bx,0

mov ax,0600h ;coloring the first half of the screen with blue text
mov bh,0A9h
mov cx,1528H
mov dx,164FH
int 10h
mov bx,0
;-----------------------------------------------------------------        
;----------positioning of the Health Bars of the Ships------------
mov dx,1500H
CALL DrawHorz

mov dx,1700H
CALL DrawHorz

mov dl,35h
mov dh,16h
mov ah,2
int 10h         
       

mov ah,9
mov dx,offset Ship2Health
int 21h 

mov dl,00h
mov dh,16h
mov ah,2
int 10h 

mov ah,9
mov dx,offset Ship1Health
int 21h

mov dl,00h
mov dh,18h
mov ah,2
int 10h 

mov ah,9
mov dx,offset text5
int 21h

mov dl,00h
mov dh,18h
mov ah,2
int 10h 
;-------------------Draw Shields
mov dl,24h
mov dh,05h
mov ah,2
int 10h 

DrawingShields

;----------------------------------------------------------------- 
;------------Intializing Ship 1 Position
mov dx,0000
mov ah,02
int 10h
mov di,dx ; taking coordinate of ship 1

;------------Drawing Ship 1
CALL DrawShip1
;------------Intializing Ship 2 Position
mov dx,004EH
mov ah,02
int 10h
mov si,dx ; taking the coordinate of ship 2

;------------Drawing Ship 2
CALL DrawShip2


        
lbltest:

check:
mov ah,1
int 16h
jz check

mov ah,0
int 16h

;Check if it is up or down for Ship 1
cmp al,73H
jz DownShip1
cmp al,77H
jz UpShip1
;Check if it is up or down for Ship 2
cmp al,6AH
jz DownShip2
cmp al,75H
jz UpShip2
cmp al,1BH
jz MainMenulbl



jmp lbltest
;-----------------------moving ship1 down/up-----------------------
DownShip1:
;-------Clearing the ship 1 to change it the new postion (Downward Position)
mov ax,0600h
mov bh,0ACh
mov cx,0
mov dx,1300H
int 10h
mov bx,0
mov dx,di

cmp dh,0Dh ; check if ship 1 is very below so it willnot go more down
jz DontInc
inc dh
DontInc:
mov ah,02
int 10h 

mov di,dx
;-------------------Draw Ship 1 with the New Position-------------
CALL DrawShip1

jmp lbltest


UpShip1:
;-------Clearing the ship 1 to change it the new postion (Upward Position)
mov ax,0600h
mov bh,0ACh
mov cx,0
mov dx,1300H
int 10h
mov bx,0
mov dx,di

cmp dh,00H
jz DontDec ; check if ship 1 is at the ceil of the screen so it willnot go more up
dec dh
DontDec:
mov ah,02
int 10h

mov di,dx
;-------------------Draw Ship 1 with the New Position-------------
CALL DrawShip1

jmp lbltest
;------------------------------------------------------------------
;-----------------------moving ship2 down/up-----------------------
DownShip2:
;-------Clearing the ship 2 to change it the new postion (Downward Position)
mov ax,0600h
mov bh,0A9H
mov cx,0046H
mov dx,134FH
int 10h
mov BX,00
mov dx,si
mov dl,4EH

cmp dh,0Dh ; check if ship 1 is very below so it willnot go more down
jz DontInc2
inc dh
DontInc2:
mov ah,02
int 10h 

mov si,dx
;-------------------Draw Ship 1 with the New Position-------------
CALL DrawShip2

jmp lbltest


UpShip2:
;-------Clearing the ship 2 to change it the new postion (Upward Position)
mov ax,0600h
mov bh,0A9H
mov cx,0046H
mov dx,134FH
int 10h
mov BX,00
mov dx,si
mov dl,4EH

cmp dh,00H
jz DontDec2 ; check if ship 1 is at the ceil of the screen so it willnot go more up
dec dh
DontDec2:
mov ah,02
int 10h

mov si,dx         
;-------------------Draw Ship 2 with the New Position-------------
CALL DrawShip2

jmp lbltest                                                                   
;-------------------------------------------------------------------




    
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

DrawShields PROC NEAR
    
    ret
DrawShields endp

ExitGame:

end main