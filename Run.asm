include Rocket.inc
include Menu.inc   
include HowToPlay.inc
include thewinner.inc
.MODEL SMALL
;.386    
.STACK 64
.DATA
;-------------------Messages Appear to the user in the Main Menu-------------------
text1 db 'Space Impact','$'
text2 db 'Enter The Game','$'
text3 db 'How to Play','$'
text4 db 'Exit The Game','$'
;-------------------Messages Appear to the user in the How To Play Menu-------------------
top DB 'HOW TO PLAY'
LINE1 DB 'the game consists of 2 ships attacking each other '
LINE2 DB 'you can only win if you destroyed the other ship'
LINE3 DB 'a ship can move vertically and fire rockets on other ship '
LINE4 DB 'it can also use a shield to protect itself'
LINE5 DB '* player 1 moves with W and S , fires with C ,uses shield by X'
LINE6 DB '* player 2 moves with U and J , fires with B ,uses shield by N'
LINE7 DB 'Press ESC to go back to the main menu'
;-------------------Messages Appear to the user in the Play Menu-------------------
text5 db 'To Return Back To The Main Menu Press ESC','$';if the user wants to end the game
Ship1Health db 'Health of Ship 1 :',03H,03H,03H,03H,03H,03H,03H,03H,03H,03H,'$' ; showing the health text of ship1
Health1Power db 2,2,2,2,2,2,2,2,2,2,0,0,0,0,0
HealthToRemoveIndex1 dw 0009h
Ship2Health db 'Health of Ship 2 :',03H,03H,03H,03H,03H,03H,03H,03H,03H,03H,'$' ; showing the health text of ship2
Health2Power db 2,2,2,2,2,2,2,2,2,2,0,0,0,0,0
HealthToRemoveIndex2 dw 0009h  
MaxHealthHearts dw 000fh ;15
;-------------------Messages Appear to inform the user who won the game-------------------
plonewin db 'Player 1 win $'
pltwowin db 'Player 2 win $'
escmsg db 'ESC to go to the main menu $'
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
Ship2R2 db '*** ** ','$'
Ship2R3 db '* ** * ','$'
Ship2R4 db '** **** * ','$'
Ship2R5 db '* ** * ','$'
Ship2R6 db '*** ** ','$'
Ship2R7 db '**','$'         

;--------------Ship Edges----------------------------------------------------------
Ship1Edges dw ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,? ;16
Ship2Edges dw ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,? ;16
;--------------Fire Shape----------------------------------------------------------
Fire1Shape db 10H,'$'
Fire2Shape db 11H,'$'  

;--------------Fire Position----------------------------------------------------------
Fire1Position dw 0,0,0,0,0,0,0,0,0,0 ;10 (MaxFireCount)
Fire1Count dw 1
Fire2Position dw 0,0,0,0,0,0,0,0,0,0 ;10 (MaxFireCount)   
Fire2Count dw 1 
MaxFireCount dw 10
;-------------Random heart---------------------------------------------------------
randheartpos db 5 
drawsec   db 0 
removesec db 0
checkcond dw 1 ;1 draw/0 remove
bonustype db 1;1 heart 0 firepower                                                                                                        
;-------------Shield Shape---------------------------------------------------------        
Shield1Shape db 29H,'$'
Shield2Shape db 28H,'$'   
;-------------Shield On/Off--------------------------------------------------------
Shield1On dw 0   ;0 is off / 1 is on
Shield2On dw 0   
;------------Shield Position------------------------------------------------------- 
;-------Ship1Edges[0]+000AH 
;------- cx = 7 in the loop inc with 010AH
;-------Ship2Edges[0]-000AH 
;------- cx = 7 in the loop inc with 010AH
;-------------------Clear----------------------------------------------------------
TopLeft dw ?
BottomRight dw ?
Color db 0FH                                                                   
;----------------------------------------------------------------------------------
;----------------------Code--------------------------------------------------------
.CODE

MAIN PROC FAR
MOV AX,@DATA
MOV DS,AX         
MOV ES,AX        
;----------------Disable Cursor-----------------------------------
Mov ch, 32
Mov ah, 1
Int 10h
;----------------Main Menu----------------------------------------
MainMenulbl:
DrawingMainMenu

HowToPlay:
HowToPlayMenu


       
;--------------Changing the background to Black-------------------
PlayMode:

CALL ReIntialize ;--------------ReIntialize if one of the Players have quitted the game (wento to the min menu) then returned back

mov ax,0600h 
mov bh,0Fh  ;changing the playmode color to Black
mov cx,0
mov dx,184FH
int 10h

mov ax,0600h ;coloring the first half of the screen with red text
mov bh,0CH
mov cx,1400H
mov dx,1628H
int 10h
mov bx,0

mov ax,0600h ;coloring the second half of the screen with blue text
mov bh,09h
mov cx,1428H
mov dx,164FH
int 10h
mov bx,0

;----------positioning of the Health Bars of the Ships------------
mov dx,1400H
CALL DrawHorz

mov dx,1600H
CALL DrawHorz

mov dl,28h
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

      
;----------------------------------------------------------------- 
;------------Intializing Ship 1 Position
mov dx,0000
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

;------------Drawing Ship 1
CALL DrawShip1

;---------------------------------------------------------------------

;------------Intializing Ship 2 Position
mov dx,004FH 
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
                

;------------Drawing Ship 2
CALL DrawShip2
 
 ;----------Intializing powerup timing------                
 ;read time 
mov ah,2ch
int 21h    
;putting value of the drawing second
mov drawsec,dh
add drawsec,10d
;compare if the drawing second after the addition is bigger than 60
cmp drawsec,60d
jb lbltest
mov drawsec,0d               
        
lbltest:

check:             
    mov ah,1
    int 16h 
    pushf
;read time 
   mov ah,2ch
   int 21h                   
   mov ax, CheckCond
   cmp ax, 1
   jz DrawSecJmp 
;compare if it is the removing time        
   cmp dh,removesec
   jz remove   
   jmp endrandom
   
   DrawSecJmp:     
;compare if it is the drawing second       
   cmp dh,drawsec
   jnz endrandom
   ;jnz checktime
   call   powerup
;putting value of the removing second after drawing   
   mov al,drawsec 
   mov removesec,al
   add removesec,5
   mov drawsec,al
   add drawsec,10
   cmp drawsec,60d
   jb endrandom
   mov drawsec,0d  
;compare if the removing second after the addition is bigger than 60
   cmp removesec,60d 
   jb endrandom
   mov removesec,5
    
  ;jmp newtimevalue 
  
remove:
call powerup
;jmp checktime
endrandom:            

;----------------Making Delay----------------
mov cx,0H
mov dx,7A12H
mov ah,86H
int 15H
;--------------------------------------------
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
;---------------Left-------------
cmp al,61H ;small a
jz LeftShip1
cmp al,41H ;capital A
jz LeftShip1     
;---------------Right------------
cmp al,64H ;small d
jz RightShip1
cmp al,44H ;capital D
jz RightShip1
;--------------Fire-------------
cmp al,63H
jz FireShip1
cmp al,43H ;capital C
jz FireShip1
;--------------Shield-------------
cmp al,78H ;small x
jz ShieldShip1
cmp al,58H ;capital X
jz ShieldShip1

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
;---------------Left-------------
cmp al,68H ;small h
jz LeftShip2
cmp al,48H ;capital H
jz LeftShip2     
;---------------Right------------
cmp al,6BH ;small k
jz RightShip2
cmp al,4BH ;capital K
jz RightShip2 
;-------------Fire---------------
cmp al,62H ;small b
jz FireShip2
cmp al,42H ;capital B
jz FireShip2   
;--------------Shield-------------
cmp al,6EH ;small n
jz ShieldShip2
cmp al,4EH ;capital N
jz ShieldShip2              

;-----------Back to menu---------
cmp al,1BH
jz MainMenulbl



jmp lbltest
;-----------------------moving ship1--------------------------------
;-----------------------Down----------------------------------------
DownShip1:

mov dx, Ship1Edges[30]
cmp dh,13H ; check if ship 1 is very below so it willnot go more down
jz lbltest
;-----------------------Clear Old Position--------------------------
mov Color, 0CH ;red text, black bg 
mov dx, Ship1Edges[0]              
mov TopLeft, dx 
add dl, 0AH
mov BottomRight,dx
call Clear      
;------------------------End of Clear------------------------------- 
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

call DrawShip1

jmp lbltest

;-----------------------UP----------------------------------------
UpShip1:
mov dx, Ship1Edges[0]
cmp dh,00H ; check if ship 1 is very up so it willnot go more down
jz lbltest
;-----------------------Clear Old Position--------------------------
mov Color, 0CH ;red text, black bg 
mov dx, Ship1Edges[30]              
mov TopLeft, dx 
add dl, 0AH
mov BottomRight,dx
call Clear         
;------------------------End of Clear-------------------------------   
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

call DrawShip1

jmp lbltest
;-----------------------Left----------------------------------------
LeftShip1:
mov dx, Ship1Edges[0]
cmp dl,00H ; check if ship 1 is very up so it willnot go more down
jz lbltest
;-----------------------Clear Old Position--------------------------
mov Color, 0CH ;red text, black bg 
mov dx, Ship1Edges[0]
add dl, 0AH ;to reach start of the shield              
mov TopLeft, dx 
add dh, 06 ;to reach end of the shield
mov BottomRight,dx
call Clear         
;------------------------End of Clear-------------------------------   
sub Ship1Edges[0],0001H
sub Ship1Edges[2],0001H
sub Ship1Edges[4],0001H 
sub Ship1Edges[6],0001H 
sub Ship1Edges[8],0001H
sub Ship1Edges[10],0001H
sub Ship1Edges[12],0001H
sub Ship1Edges[14],0001H
sub Ship1Edges[16],0001H
sub Ship1Edges[18],0001H 
sub Ship1Edges[20],0001H
sub Ship1Edges[22],0001H
sub Ship1Edges[24],0001H
sub Ship1Edges[26],0001H   
sub Ship1Edges[28],0001H   
sub Ship1Edges[30],0001H          

call DrawShip1 

jmp lbltest
;-----------------------Right----------------------------------------
RightShip1:
mov dx, Ship1Edges[16]
inc dx ;for the shield
cmp dl,29H ; check if ship 1 is very right so it willnot go more right
jz lbltest
;-----------------------Clear Old Position--------------------------
mov Color, 0CH ;red text, black bg 
mov dx, Ship1Edges[0]              
mov TopLeft, dx 
mov dx, Ship1Edges[30]
mov BottomRight,dx
call Clear         
;------------------------End of Clear-------------------------------   
add Ship1Edges[0],0001H
add Ship1Edges[2],0001H
add Ship1Edges[4],0001H 
add Ship1Edges[6],0001H 
add Ship1Edges[8],0001H
add Ship1Edges[10],0001H
add Ship1Edges[12],0001H
add Ship1Edges[14],0001H
add Ship1Edges[16],0001H
add Ship1Edges[18],0001H 
add Ship1Edges[20],0001H
add Ship1Edges[22],0001H
add Ship1Edges[24],0001H
add Ship1Edges[26],0001H   
add Ship1Edges[28],0001H   
add Ship1Edges[30],0001H          

call DrawShip1 

jmp lbltest                                                         
;--------------------Fire Ship 1----------------------------------
FireShip1: 
mov Shield1On, 0 ;Remove Shield 
   
mov bx,0
mov cx, Fire1Count
l1:     
mov dx, Fire1Position[bx]
cmp dx,0
jz FoundEmpty1 
add bx,2
loop l1

jmp lbltest ;if there is no empty fire slot
 
FoundEmpty1:   
mov ax, Ship1Edges[16]
mov Fire1Position[bx], ax                                            
;--------------------Clear Shield 1-------------------------------   
mov Shield1On, 0000H ;OFF 

jmp lbltest
;---------------------Shield Ship 1 On/Off------------------------
ShieldShip1:
mov bx, Shield1On
cmp bx,0
jz ChangeOn1
mov Shield1On, 0000H ;OFF 

jmp lbltest

ChangeOn1:
mov Shield1On, 0001H ;ON   

jmp lbltest

;------------------------------------------------------------------
;-----------------------moving ship2 ------------------------------ 
;-----------------------DOWN---------------------------------------
DownShip2:

mov dx, Ship2Edges[30]
cmp dh,13h ; check if ship 2 is very below so it willnot go more down
jz lbltest               
;-----------------------Clear Old Position--------------------------
mov Color, 09H ;Blue text, black bg 
mov dx, Ship2Edges[0]              
mov BottomRight, dx 
sub dl, 0AH
mov TopLeft,dx
call Clear                 
;------------------------End of Clear------------------------------- 
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

call DrawShip2 

jmp lbltest

;-----------------------UP----------------------------------------
UpShip2:

mov dx, Ship2Edges[0]
cmp dh,00h ; check if ship 1 is very high so it will not go more up
jz lbltest                     
;-----------------------Clear Old Position--------------------------
mov Color, 09H ;Blue text, black bg 
mov dx, Ship2Edges[30]              
mov BottomRight, dx 
sub dl, 0AH
mov TopLeft,dx
call Clear          
;------------------------End of Clear-------------------------------    
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
         
call DrawShip2

jmp lbltest
;-----------------------Left----------------------------------------
LeftShip2:
mov dx, Ship2Edges[16]
dec dx ;for the shield
cmp dl,2BH ; check if ship 2 is very left so it willnot go more left
jz lbltest
;-----------------------Clear Old Position--------------------------
mov Color, 09H ;red text, black bg 
mov dx, Ship2Edges[0]              
mov TopLeft, dx 
mov dx, Ship2Edges[30]
mov BottomRight,dx
call Clear          
;------------------------End of Clear-------------------------------   
sub Ship2Edges[0],0001H
sub Ship2Edges[2],0001H
sub Ship2Edges[4],0001H 
sub Ship2Edges[6],0001H 
sub Ship2Edges[8],0001H
sub Ship2Edges[10],0001H
sub Ship2Edges[12],0001H
sub Ship2Edges[14],0001H
sub Ship2Edges[16],0001H
sub Ship2Edges[18],0001H 
sub Ship2Edges[20],0001H
sub Ship2Edges[22],0001H
sub Ship2Edges[24],0001H
sub Ship2Edges[26],0001H   
sub Ship2Edges[28],0001H   
sub Ship2Edges[30],0001H          

call DrawShip2 

jmp lbltest                                          
;-----------------------Right----------------------------------------
RightShip2:
mov dx, Ship2Edges[0]
cmp dl,4FH ; check if ship 2 is very right so it willnot go more right
jz lbltest 
;-----------------------Clear Old Position--------------------------
mov Color, 09H ;red text, black bg 
mov dx, Ship2Edges[0]
sub dl, 0AH ;to reach start of the shield              
mov TopLeft, dx 
add dh, 06 ;to reach end of the shield
mov BottomRight,dx
call Clear        
;------------------------End of Clear-------------------------------   
add Ship2Edges[0],0001H
add Ship2Edges[2],0001H
add Ship2Edges[4],0001H 
add Ship2Edges[6],0001H 
add Ship2Edges[8],0001H
add Ship2Edges[10],0001H
add Ship2Edges[12],0001H
add Ship2Edges[14],0001H
add Ship2Edges[16],0001H
add Ship2Edges[18],0001H 
add Ship2Edges[20],0001H
add Ship2Edges[22],0001H
add Ship2Edges[24],0001H
add Ship2Edges[26],0001H   
add Ship2Edges[28],0001H   
add Ship2Edges[30],0001H          

call DrawShip2 

jmp lbltest                         
;-------------------------------------------------------------------
FireShip2:
      
mov Shield2On, 0 ;Remove Shield
mov bx,0
mov cx, Fire2Count
l2:     
mov dx, Fire2Position[bx]
cmp dx,0
jz FoundEmpty2 
add bx,2
loop l2
jmp lbltest ;if there is no empty fire slot
 
FoundEmpty2:   
mov ax, Ship2Edges[16]
mov Fire2Position[bx], ax
;--------------------Clear Shield 2-------------------------------   
mov Shield2On, 0000H ;OFF 

jmp lbltest

;---------------------Shield Ship 2 On/Off------------------------
ShieldShip2:
mov bx, Shield2On
cmp bx,0
jz ChangeOn2
mov Shield2On, 0000H ;OFF 

jmp lbltest

ChangeOn2:
mov Shield2On, 0001H ;ON   

jmp lbltest
   
MAIN ENDP
;------------------------------------------------------------------------------END MAIN-----------------------------------------------------
;Drawing Ship 1

DrawShip1 PROC NEAR
    ;--------------------------Clear Old Position--------------------- 
    mov ax,0600h
    mov bh,0CH
    mov cx,Ship1Edges[0]
    mov dx,Ship1Edges[30]
    add dl,09H
    int 10h
    mov BX,00
    
    ;--------intialize cx with first * top left----
    mov cx,Ship1Edges[0]
    ;--------------Ship1Row1---------------
    mov dx,cx
    mov ah,2
    int 10h
    
    mov ah,9
    mov dx, offset Ship1R1
    int 21h
    ;---------------------------------
    
    ;--------------Ship1Row2---------------
    inc ch 
    mov dx,cx
    mov ah,2
    int 10h
    
    mov ah,9
    mov dx, offset Ship1R2
    int 21h
    ;--------------------------------
    
    ;--------------Ship1Row3---------------
    inc ch 
    mov dx,cx
    mov ah,2
    int 10h
    
    mov ah,9
    mov dx, offset Ship1R3
    int 21h
    ;--------------------------------
    
    ;--------------Ship1Row4---------------
    inc ch 
    mov dx,cx
    mov ah,2
    int 10h
    
    mov ah,9
    mov dx, offset Ship1R4
    int 21h
    ;--------------------------------
    
    ;--------------Ship1Row5---------------
    inc ch 
    mov dx,cx
    mov ah,2
    int 10h
    
    mov ah,9
    mov dx, offset Ship1R5
    int 21h
    ;--------------------------------
    
    ;--------------Ship1Row6---------------
    inc ch 
    mov dx,cx 
    mov ah,2
    int 10h
    
    mov ah,9
    mov dx, offset Ship1R6
    int 21h
    ;--------------------------------
    
    ;--------------Ship1Row7---------------
    inc ch 
    mov dx,cx 
    mov ah,2
    int 10h
    
    mov ah,9
    mov dx, offset Ship1R7
    int 21h
    ;--------------------------------
    ret
DrawShip1 endp

;Drawing Ship 2
DrawShip2 PROC NEAR
    ;---------Clear New Position----------- 
    mov ax,0600h
    mov bh,09H 
    mov cx, Ship2Edges[0]
    sub cl, 09H
    mov dx, Ship2Edges[30]
    int 10h
    mov BX,00           
           
    ;--------------Ship2Row1---------------
    mov dx,Ship2Edges[2]
    mov ah,2
    int 10h
    
    mov ah,9
    mov dx, offset Ship2R1
    int 21h
    ;---------------------------------
    
    ;--------------Ship2Row2---------------
    mov dx,Ship2Edges[10]
    mov ah,2
    int 10h
    
    mov ah,9
    mov dx, offset Ship2R2
    int 21h
    ;--------------------------------
    
    ;--------------Ship2Row3---------------
    mov dx,Ship2Edges[12] 
    mov ah,2
    int 10h
    
    mov ah,9
    mov dx, offset Ship2R3
    int 21h
    ;--------------------------------       
    
    ;--------------Ship2Row4---------------
    mov dx,Ship2Edges[16] 
    mov ah,2
    int 10h
    
    mov ah,9
    mov dx, offset Ship2R4
    int 21h
    ;--------------------------------
    
    ;--------------Ship2Row5---------------
    mov dx,Ship2Edges[18] 
    mov ah,2
    int 10h
    
    mov ah,9
    mov dx, offset Ship2R5
    int 21h
    ;--------------------------------
    
    ;--------------Ship2Row6---------------
    mov dx,Ship2Edges[20] 
    mov ah,2
    int 10h
    
    mov ah,9
    mov dx, offset Ship2R6
    int 21h
    ;--------------------------------
    
    ;--------------Ship2Row7---------------
    mov dx,Ship2Edges[28] 
    mov ah,2
    int 10h
    
    mov ah,9
    mov dx, offset Ship2R7
    int 21h
    ;-------------------------------- 
    ret
DrawShip2 endp

;drawing the random heart
powerup      proc      near   
    cmp checkcond,0
    jz remove1  
    mov checkcond,0
    mov cx,9
    mov ah,0
    mov al,dl
    mov bp,dx
    mov dx,00h
    div cx
    mov randheartpos,dl 
    add randheartpos,3
    mov ax,0
    mov bx,0
    mov dx,0
    mov cx,0
    mov ah,2
    mov dl,42d
    mov dh,randheartpos  
    int 10h 
    mov dx,bp 
    mov cx,2
    mov ah,0
    mov al,dl
    mov dx,00h
    div cx 
    mov bonustype,dl
    cmp dl,0
    jz firepo        
            
    mov ah,9 ;Display
    mov bh,0 ;Page 0
    mov al,03h ;Letter heart
    mov cx,1h ;1 time
    mov bl,0Ah ;Green (A) on Black(0) background
    int 10h
    jmp retpowerup 
firepo:    
    
    mov ah,9 ;Display
    mov bh,0 ;Page 0
    mov al,0adh ;Letter !
    mov cx,1h ;1 time
    mov bl,0Ah ;Green (A) on Black(0) background
    int 10h
    jmp retpowerup
    
remove1: 
    mov checkcond,1
    mov bx,0    
    mov ah,2  
    int 10h
      
    mov ax,0600h
    mov bh,07
    mov dl,42d
    mov dh,randheartpos
    mov cx,dx
    int 10h 
    
    retpowerup:
    ret
powerup endp 

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
    ;------------------------ random heart checks ---------------    
  
    ;-------------------Clear Old Fires' Position----------
    mov cx,Fire1Count
    mov bx, 0          ;intialization
    LoopForFire1:                 
    mov dx, Fire1Position[bx]
    cmp dx,0 ; check if empty 
    jz SkipLoopForFire1
    ;-------------------Clear Old Position------------------
    mov Color, 0CH
    mov TopLeft, dx
    mov BottomRight, dx          
    call Clear  
    SkipLoopForFire1:       
                     
    add bx, 2 ;because it's word
    loop LoopForFire1
    
    mov cx,Fire2Count
    mov bx, 0          ;intialization
    LoopForFire2:                 
    mov dx, Fire2Position[bx]
    cmp dx,0 ; check if empty 
    jz SkipLoopForFire2
    ;-------------------Clear Old Position------------------
    mov Color, 09H
    mov TopLeft, dx
    mov BottomRight, dx          
    call Clear 
    SkipLoopForFire2:                       
    
    add bx, 2 ;because it's word
    loop LoopForFire2 
    ;-------------------Draw Front *------------------------
    mov bx,0 
    mov ah,2
    mov dx,Ship1Edges[16]
    int 10h
    mov dl,'*'
    int 21h
    
    mov bx,0 
    mov ah,2
    mov dx,Ship2Edges[16]
    int 10h
    mov dl,'*'
    int 21h
    ;--------------------Clear Shield 1-------------------------------  
    mov ax, 0600H
    mov bh, 0CH
    mov cx, Ship1Edges[0]
    add cx, 000AH ;start of the shield   
    mov dx,cx
    add dx,0600H
    int 10h     
    ;-------------------Draw Shield 1---------------------------------   
    mov ax, Shield1On
    cmp ax,0
    jz SkipDrawFront1
    
    ;-------------------Drawing Shield--------------------  
    mov ah, 2 ;move cursor and draw char         
    mov bx,0
    
    mov cx,7            
    mov bp, Ship1Edges[0]
    add bp, 000AH
    LDrawShield1NewFrame: 
    
    mov dx, bp
    int 10h
    mov dl, Shield1Shape    
    int 21h   
    add bp, 0100H    
    
    loop LDrawShield1NewFrame
    
    
    SkipDrawFront1:    
    ;--------------------Clear Shield 2-------------------------------  
    mov ax, 0600H
    mov bh, 09H
    mov cx, Ship2Edges[0]
    sub cx, 000AH ;start of the shield   
    mov dx,cx
    add dx,0600H
    int 10h
    ;-------------------Draw Shield 1------------------------ 
    mov ax, Shield2On
    cmp ax,0
    jz SkipDrawFront2
    
    ;-------------------Drawing Shield--------------------  
    mov ah, 2 ;move cursor and draw char         
    mov bx,0
    
    mov cx,7            
    mov bp, Ship2Edges[0]
    sub bp, 000AH
    LDrawShield2NewFrame: 
    
    mov dx, bp
    int 10h
    mov dl, Shield2Shape    
    int 21h   
    add bp, 0100H    
    
    loop LDrawShield2NewFrame
    
    SkipDrawFront2:
    ;-------------------Draw Fire For Ship 1-------------------- 
    mov Color, 0CH ; red text with black background
    mov cx,Fire1Count
    mov si, 0          ;intialization
    mov ah,2        ;draw char function and move cursor
    l3:                 
    mov dx, Fire1Position[si]
    cmp dx,00
    jz DontDraw3
       
    cmp cx,0 
    jz finish3
    
    add Fire1Position[si], 0001H ;move right towards the ship2
    mov dx, Fire1Position[si] 
    pusha 
                       
    ;----Check if rocket explode or not ax:1 true (exploded)-----
    RocketExplode1
    ;------------------------------------------------------------ 
    
    pop ax ;to get true or false
    cmp ax,1 ;don't draw if true                             
    popa
    jz DontDraw3
    ;--------------------Clear-----------------------------------
    mov TopLeft, dx
    mov BottomRight, dx          
    call Clear
    ;--------------------Draw in new Position-------------------
    mov bx,0 
    int 10h  ;move cursor                                      
    mov dl, Fire1Shape ; >> shape         
    int 21h  ;draw char
    DontDraw3:
    add si,2 ;because it's a word 
    finish3:       
    loop l3 
    
    
    ;---------------------Draw Fire For Ship 2-------------------
    mov Color, 09H     ; blue text with black background
    mov cx,Fire2Count
    mov si, 0          ;intialization
    mov ah,2           ;draw char function and move cursor
    l4:                 
    mov dx, Fire2Position[si]
    cmp dx,00
    jz DontDraw4
       
    cmp cx,0 
    jz finish4
    
    sub Fire2Position[si], 0001H ;move left towards the ship1  
    mov dx, Fire2Position[si]
    pusha 
    
    ;----Check if rocket explode or not ax:1 true (exploded)----                            
    RocketExplode2
    ;-----------------------------------------------------------    
    
    pop ax ;to get true or false
    cmp ax,1 ;don't draw if true        
    popa
    jz DontDraw4
    ;--------------------Clear-----------------------------------
    mov TopLeft, dx
    mov BottomRight, dx          
    call Clear
    ;--------------------Draw in new Position------------------- 
    mov bx,0 
    int 10h  ;move cursor   
    mov dl, Fire2Shape ; << shape         
    int 21h  ;draw char
    DontDraw4:
    add si,2 ;because it's a word 
    finish4:       
    loop l4    
    
    ;----------------Check if one of the two ships have been destroyed
    cmp HealthToRemoveIndex2,0FFFFH
    jz Player1Winner
    
    cmp HealthToRemoveIndex1,0FFFFH
    jz Player2Winner
    jne CompleteTheGame
    
    Player1Winner:
    call ReIntialize ;-------Reinitialize the game
    playeronewin
    
    Player2Winner:
    call ReIntialize ;-------Reinitialize the game 
    playertwowin
    
    CompleteTheGame:
    
    ret
NewFrame endp              

Clear proc near
    pusha  
    mov ax, 0600H
    mov bh, Color
    mov cx, TopLeft
    mov dx, BottomRight
    int 10h 
    popa
    ret 
Clear endp

DrawShield1 proc near
    ;-------------------Draw Shield--------------------  
    mov ah, 2 ;move cursor and draw char         
    mov bx,0
    
    mov dx, Shield1On
    cmp dx, 0 ;OFF
    jz DontDrawShield1
    
    mov cx,7            
    mov bp, Ship1Edges[0]
    add bp, 000AH
    LDrawShield1: 
    
    mov dx, bp
    int 10h
    mov dl, Shield1Shape    
    int 21h   
    add bp, 0100H    
    
    loop LDrawShield1 
    
    DontDrawShield1:
    ret
DrawShield1 endp    

DrawShield2 proc near
    ;-------------------Draw Shield--------------------  
    mov ah, 2 ;move cursor and draw char
    mov bx,0
    
    mov dx, Shield2On
    cmp dx, 0 ;OFF
    jz DontDrawShield2
    
    mov cx,7
    mov bp, Ship2Edges[0]
    sub bp, 000AH
    LDrawShield2: 
    
    mov dx, bp
    int 10h
    mov dl, Shield2Shape 
    int 21h   
    add bp, 0100H 
    
    loop LDrawShield2
    
    DontDrawShield2: 
    ret
DrawShield2 endp


ReIntialize proc near
    ;-----------------------Reintializng the HeartIndex-----------------
    MOV HealthToRemoveIndex1,0009h
    MOV HealthToRemoveIndex2,0009h
    
    
    ;-----------------------Reintializng the Firepower of eachship-----------------
    mov cx,MaxFireCount
    mov bx,0
    IntializeFB:
    mov Fire1Position[bx],0
    mov Fire2Position[bx],0
    add bx,2
    loop IntializeFB
    ;-----------------------Reintializng the Shields to be OFF-----------------
    mov Shield1On,0
    mov Shield2On,0
    
    
    ;-----------------------Reintializng the Healthpower of eachship-----------------
    mov cx, 10
    mov bx,0
    IntializeHP:
    mov Health1Power[bx],2
    mov Health2Power[bx],2 
    inc bx
    loop IntializeHP  
    
    mov cx, MaxHealthHearts
    sub cx, 10   ;5 if maxfirecount = 15
    IntializeHPContinue:
    mov Health1Power[bx],0
    mov Health2Power[bx],0 
    inc bx
    loop IntializeHPContinue
    
    ret
ReIntialize endp


ExitGame:
mov ah,04CH ;DOS "terminate" function
int 21h
end main