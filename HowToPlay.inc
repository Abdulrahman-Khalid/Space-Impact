;-----------------MACROS-------------
HowToPlayMenu MACRO
mov ax,0600h 
mov bh,0Fh  ;changing the playmode color to Black
mov cx,0
mov dx,184FH
int 10h

MOV AH,13H    ;setup
MOV BH,0      ; page no
;------------------

MOV BL,0AH ;green COLOR
MOV DL,30D
MOV DH,5D
MOV BP,OFFSET top
MOV CX,11
INT 10H

MOV BL,0FH ;WHITE COLOR
MOV DL,15D
MOV DH,7D
MOV BP,OFFSET LINE1
MOV CX,49d
INT 10H

MOV DL,15D
MOV DH,9D
MOV BP,OFFSET LINE2
MOV CX,48d
INT 10H

MOV DL,12D
MOV DH,11D
MOV BP,OFFSET LINE3
MOV CX,57d
INT 10H  

MOV DL,16D
MOV DH,13D
MOV BP,OFFSET LINE4
MOV CX,42d
INT 10H  

MOV BL,0cH ;red COLOR
MOV DL,12D
MOV DH,15D
MOV BP,OFFSET LINE5
MOV CX,62d
INT 10H  

MOV DL,12D
MOV DH,17D
MOV BP,OFFSET LINE6
MOV CX,62d
INT 10H

MOV BL,0FH ;WHITE COLOR
MOV DL,20D
MOV DH,19D
MOV BP,OFFSET LINE7
MOV CX,37d
INT 10H

checklbl:
mov ah,1
int 16h
jz checklbl

mov ah,0
int 16h

;-----------Back to menu---------
cmp al,1BH
jz MainMenulbl
jne checklbl


           
ENDM HowToPlayMenu

