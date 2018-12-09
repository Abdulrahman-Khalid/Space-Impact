playertwowin macro
local checklbl

mov ax,0600h 
mov bh,0Fh  ;changing the playmode color to Black
mov cx,0
mov dx,184FH
int 10h

mov bp, offset pltwowin
mov al, 1
mov bh, 0
mov bl,1
mov cx,13d ; calculate message size.
mov dl,30d 
mov dh,09d 
push ds
pop es             
mov ah, 13h
int 10h
 
 mov bp, offset ship1R1
mov al, 1
mov bh, 0
mov bl,1
mov cx,2d ; calculate message size.
mov dl,30d 
mov dh,10d 
push ds
pop es             
mov ah, 13h
int 10h


mov bp, offset ship1R2
mov al, 1
mov bh, 0
mov bl,1
mov cx,7d ; calculate message size.
mov dl,30d 
mov dh,11d 
push ds
pop es             
mov ah, 13h
int 10h

mov bp, offset ship1R3
mov al, 1
mov bh, 0
mov bl,1
mov cx,8d ; calculate message size.
mov dl,30d 
mov dh,12d 
push ds
pop es             
mov ah, 13h
int 10h

mov bp, offset ship1R4
mov al, 1
mov bh, 0
mov bl,1
mov cx,10d ; calculate message size.
mov dl,30d 
mov dh,13d 
push ds
pop es             
mov ah, 13h
int 10h

mov bp, offset ship1R5
mov al, 1
mov bh, 0
mov bl,1
mov cx,8d ; calculate message size.
mov dl,30d 
mov dh,14d 
push ds
pop es             
mov ah, 13h
int 10h

mov bp, offset ship1R6
mov al, 1
mov bh, 0
mov bl,1
mov cx,7d ; calculate message size.
mov dl,30d 
mov dh,15d 
push ds
pop es             
mov ah, 13h
int 10h

mov bp, offset ship1R7
mov al, 1
mov bh, 0
mov bl,1
mov cx,2d ; calculate message size.
mov dl,30d 
mov dh,16d 
push ds
pop es             
mov ah, 13h
int 10h

mov ah,2
mov dh,12h
mov dl,23d
int 10h
   

mov dx,offset escmsg
mov ah,9
int 21h      


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
endm playertwowin
;------------------------------------------------------------------------
playeronewin macro

local checklbl

mov ax,0600h 
mov bh,0Fh  ;changing the playmode color to Black
mov cx,0
mov dx,184FH
int 10h

mov bp, offset plonewin
mov al, 1
mov bh, 0
mov bl,4
mov cx,13d ; calculate message size.
mov dl,30d 
mov dh,09d 
push ds
pop es             
mov ah, 13h
int 10h
 
 
 mov bp, offset ship1R1
mov al, 1
mov bh, 0
mov bl,4
mov cx,2d ; calculate message size.
mov dl,30d 
mov dh,10d 
push ds
pop es             
mov ah, 13h
int 10h


mov bp, offset ship1R2
mov al, 1
mov bh, 0
mov bl,4
mov cx,7d ; calculate message size.
mov dl,30d 
mov dh,11d 
push ds
pop es             
mov ah, 13h
int 10h

mov bp, offset ship1R3
mov al, 1
mov bh, 0
mov bl,4
mov cx,8d ; calculate message size.
mov dl,30d 
mov dh,12d 
push ds
pop es             
mov ah, 13h
int 10h

mov bp, offset ship1R4
mov al, 1
mov bh, 0
mov bl,4
mov cx,10d ; calculate message size.
mov dl,30d 
mov dh,13d 
push ds
pop es             
mov ah, 13h
int 10h

mov bp, offset ship1R5
mov al, 1
mov bh, 0
mov bl,4
mov cx,8d ; calculate message size.
mov dl,30d 
mov dh,14d 
push ds
pop es             
mov ah, 13h
int 10h

mov bp, offset ship1R6
mov al, 1
mov bh, 0
mov bl,4
mov cx,7d ; calculate message size.
mov dl,30d 
mov dh,15d 
push ds
pop es             
mov ah, 13h
int 10h

mov bp, offset ship1R7
mov al, 1
mov bh, 0
mov bl,4
mov cx,2d ; calculate message size.
mov dl,30d 
mov dh,16d 
push ds
pop es             
mov ah, 13h
int 10h











mov ah,2
mov dh,12h
mov dl,23d
int 10h
   
mov dx,offset escmsg
mov ah,9
int 21h          

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

endm playeronewin