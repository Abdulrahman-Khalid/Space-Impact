;-----------------MACROS------
DrawingShip1 MACRO

mov ax,0600h
mov bh,0ACH
mov cx,0000H
mov dx,1309H
int 10h
mov BX,00

;--------------Ship1Row1---------------
mov dx,di
mov ah,2
int 10h

mov ah,9
mov dx, offset Ship1R1
int 21h
;---------------------------------

;--------------Ship1Row2---------------
mov dx,di
inc dh
mov di,dx 
mov ah,2
int 10h

mov ah,9
mov dx, offset Ship1R2
int 21h
;--------------------------------

;--------------Ship1Row3---------------
mov dx,di
inc dh
mov di,dx 
mov ah,2
int 10h

mov ah,9
mov dx, offset Ship1R3
int 21h
;--------------------------------

;--------------Ship1Row4---------------
mov dx,di
inc dh
mov di,dx 
mov ah,2
int 10h

mov ah,9
mov dx, offset Ship1R4
int 21h
;--------------------------------

;--------------Ship1Row5---------------
mov dx,di
inc dh
mov di,dx 
mov ah,2
int 10h

mov ah,9
mov dx, offset Ship1R5
int 21h
;--------------------------------

;--------------Ship1Row6---------------
mov dx,di
inc dh
mov di,dx 
mov ah,2
int 10h

mov ah,9
mov dx, offset Ship1R6
int 21h
;--------------------------------

;--------------Ship1Row7---------------
mov dx,di
inc dh
mov di,dx 
mov ah,2
int 10h

mov ah,9
mov dx, offset Ship1R7
int 21h
;--------------------------------
            
ENDM DrawShip1              