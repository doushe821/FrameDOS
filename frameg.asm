.model tiny 
.code 
.186
org 100h

Start:

mov bx, 82h

call atoi           ; getting frame coordinates (x,y)
mov dl, al 
inc bx 
call atoi 
mov dh, al 
inc bx

mov dx, ax 

call atoi           ; getting frame size
mov al, cl 
inc bx
call atoi 
mov ah, al 
mov al, cl 

call PrintFrameDecartes




mov ax, 4c00h
int 21h

;/// FUCNTION ///
;   Name: PrintFrameDecartes
;   Prints frame on given coordinates, uses function GoDecartes, which sets BX (considering BX = 0)
;   to (DL, DH) point of video memory (ES = 0b800h).
;   Entry: CS:BX - points on framestyle arg in cmd (arg 5).
;          DL:DH - (x,y) of top left corner
;          AL:AH - x and y sizes of the frame
;   Exit : none
;   Destr: CX (used as counter), DI, ES
;   
;/// START ///
PrintFrameDecartes proc 

locals ll 

    mov bx, 0b800h ; for convinience 
    mov es, bx 
    mov di, 0h

    ; Top line: 
    call GoDecartes 

    ; cs:[bx]->es:[di]
    
    mov cl, al 
    mov al, byte ptr cs:[bx]
    stosb
    add bx, 9h 
    mov al, byte ptr cs:[bx]
    stosb
    sub bx, 9h
    mov al, cl

    mov ch, 0h

llFillTopLine:

    mov ch, al 
    inc bx
    mov al, byte ptr cs:[bx]
    stosb
    add bx, 8h 
    mov al, byte ptr cs:[bx]
    stosb 
    mov al, ch 
    mov ch, 0h 
    sub bx, 9h

loop llFillTopLine

    mov ch, al 
    add bx, 2h
    mov al, byte ptr cs:[bx]
    stosb
    add bx, 7h 
    mov al, byte ptr cs:[bx]
    stosb 
    mov al, ch 
    mov ch, 0h 
    sub bx, 9h


    ; Middle line: 

    


ret 
endp 

;/// END /// 

;/// FUNCTION /// (mini)
;
;   NAME: GoDecartes
;
;   Moves bx pointer to (x, y) in video memory. Sets DI to 0
;
;   Entry: DL - x, DH - y
;   Exit : Increase DI
;   Destr: none
;/// START ///
GoDecartes proc

mov di, 0h

; X:
push ax 
mov al, dl 
mov ah, 0h 
shl ax, 1h
add di, ax

; Y:
mov al, dh 
mov ah, 0
imul ax, ax, 50h 
shl ax, 1h
add di, ax
pop ax

ret
endp
;/// END ///

;/// FUNCTION ///
;   Name: atoi
;   Converts string to 1 word integer (255 is its max value)
;   Entry: ES:BX - start of the string
;   Exit : AL - converted integer
;   Destr: AX, BX
;
;   NOTE: 0 ASCII code is 30h
;
;/// START ///
atoi proc 

locals ll

    mov ax, 0h
    push dx

    llNEXTDIGIT:
    cmp byte ptr cs:[bx], 0Dh
    je llEXIT
    cmp byte ptr cs:[bx], 20h
    je llEXIT

    imul ax, ax, 0Ah
    mov dl, 30h
    add al, byte ptr cs:[bx]
    sub al, dl
    inc bx
    jmp llNEXTDIGIT

    llEXIT:
    pop dx

ret
endp
;/// END ///



end Start