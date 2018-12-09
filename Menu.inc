;-----------------MACROS------
DrawingMainMenu MACRO

mov ax,0600h
mov bh,0AH
mov cx,0
mov dx,084FH
int 10H
mov bx,0

mov dx,0820H ;Chaning the Cursor Position to type the sentences that should be displayed in the Main Menu
mov ah,2
int 10H

mov ah,9
mov dx,offset text1
int 21H

mov di,0B1FH

MainMenu:
;---------------Chaning the BackGround of The Other text
mov ax,0600h
mov bh,0FH
mov cx,0900H
mov dx,184FH
int 10H
mov bx,0

;----------------Determine what text will be highlighted----------------

mov ax,0600h
mov bh,0FCH
mov cx,di
add di,0DH
mov dx,di
int 10H
mov bx,0
sub di,0DH


mov dx,0B1FH;Chaning the cursor to type the 2nd Line
mov ah,2
int 10h

mov ah,9
mov dx,offset text2
int 21H


mov dx,0C20H;Chaning the cursor to type the 2nd Line
mov ah,2
int 10h

mov ah,9
mov dx,offset text3
int 21H


mov dx,0D1FH;Chaning the cursor to type the 2nd Line
mov ah,2
int 10h

mov ah,9
mov dx,offset text4
int 21H

;-----------Check the Pressed button from the Keyboard to determine what would be shown : PlayMode or it will terminate the program
CheckMode:
mov ah,1
int 16H
jz CheckMode

mov ah,0
int 16H


cmp ah,50H;if the pressed key is down arrow
jz DownArrow 
cmp ah,48H;if the pressed key is up arrow
jz UpArrow

cmp ax,1C0DH
jz CheckWhatIsPressed

jmp MainMenu

DownArrow:
cmp di,0D00H
jge MainMenu
add di,0100H
jmp MainMenu

UpArrow:
cmp di,0B1FH
jle MainMenu
sub di,0100H
jmp MainMenu

CheckWhatIsPressed:


cmp di,0C1FH
je HowToPlay ;-----------will go to Play Mode
jl PlayMode  ;-----------will go to How To Play Window
jg ExitGame  ;-----------will exit the game

            
ENDM DrawingMainMenu              






