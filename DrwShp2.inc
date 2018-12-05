;-----------------MACROS------
DrawingShip2 MACRO

mov ax,0600h
mov bh,0A9H
mov cx,0046H
mov dx,074FH
int 10h
mov BX,00
           
       
;--------------Ship2Row1---------------
mov dx,si
mov ah,2
int 10h

mov ah,9
mov dx, offset Ship2R1
int 21h
;---------------------------------

;--------------Ship2Row2---------------
mov dx,si
inc dh
mov dl,49H
mov si,dx 
mov ah,2
int 10h

mov ah,9
mov dx, offset Ship2R2
int 21h
;--------------------------------

;--------------Ship2Row3---------------
mov dx,si
inc dh
mov dl,48H
mov si,dx 
mov ah,2
int 10h

mov ah,9
mov dx, offset Ship2R3
int 21h
;--------------------------------

;--------------Ship2Row4---------------
mov dx,si
inc dh
mov dl,46H
mov si,dx 
mov ah,2
int 10h

mov ah,9
mov dx, offset Ship2R4
int 21h
;--------------------------------

;--------------Ship2Row5---------------
mov dx,si
inc dh
mov dl,48H
mov si,dx 
mov ah,2
int 10h

mov ah,9
mov dx, offset Ship2R5
int 21h
;--------------------------------

;--------------Ship2Row6---------------
mov dx,si
inc dh
mov dl,49H
mov si,dx 
mov ah,2
int 10h

mov ah,9
mov dx, offset Ship2R6
int 21h
;--------------------------------

;--------------Ship2Row7---------------
mov dx,si
inc dh
mov dl,4EH
mov si,dx 
mov ah,2
int 10h

mov ah,9
mov dx, offset Ship2R7
int 21h
;--------------------------------

            
ENDM DrawingShip2              






