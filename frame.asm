.model tiny
.code
.186
org 100h

Start:

; User input: x y (10 frame symbols) String
;mov dl, byte ptr cs:[80h]
;mov ah, 02h
;int 21h
; DEBUG^^^

mov bx, 82h

mov ax, 0h
call atoi
inc bx
mov dl, al
call atoi
inc bx
mov dh, al ; Start coordinates are in dx now: x=dl, y=dh

mov ax, 0h
call atoi
inc bx
push dx
mov dl, al
call atoi
inc bx
mov ah, al
mov al, dl 
pop dx       ; ax now contains frame dimensions: xf=al, yf=ah

mov byte ptr cs:[FrameX], al
mov byte ptr cs:[FrameY], ah

;mov ax, 4c00h
;int 21h


mov ax, bx

call PaintFrameCoordinates
sub dh, byte ptr cs:[FrameY]               ; Setting back top left corner position

add ax, 0Bh ; so it points to user message
call PrintText

mov ax, 4c00h               ; end program, return 0
int 21h


;/// FUNCTION ///
;   Name: PrintText
;   Prints text in the middle of frame
;   Entry:
;   Exit :
;   Destr:
;/// START ///
PrintText proc 
locals ll
mov bx, 0h
mov cx, 0h
mov cl, byte ptr cs:[FrameX]

push dx
mov dx, 0h

push bx 
mov bx, ax

llStringLength:
cmp byte ptr cs:[bx], 0Ah
je llEXITL
cmp byte ptr cs:[bx], 0Dh
je llEXITL
inc dl 
inc bx
jmp llStringLength

llEXITL: 
pop bx

;push ax 
;mov ah, 02h ; DEBUG
;int 21h
;pop ax

sub cl, dl 
and cl, 11111110b
shr cl, 1h             

pop dx

add cl, dl 

mov ch, byte ptr cs:[FrameY]
and ch, 11111110b
shr ch, 1h
add ch, dh
inc ch

push ax
mov al, cl
mov ah, ch
call GoDecartes
pop ax

llPrintLoop:

push dx
push bx
mov bx, ax
mov dl, byte ptr cs:[bx]
pop bx
mov byte ptr es:[bx], dl 
add bx, 2h
pop dx
inc ax 
push bx 
mov bx, ax
cmp byte ptr cs:[bx], 0Dh
pop bx

push ax
push dx 
push cx 
mov ah, 86h
mov cx, 3h
mov dx, 0D090h
int 15h
pop cx 
pop dx 
pop ax

jne llPrintLoop

ret 
endp

;/// END ///

;/// FUNCTION ///
;   Name: FrameAnimated
;   Adds animation to user's frame.
;   Entry: AL:AH - final size of the frame; (frameX, frameY??????)
;          DL:AH - coordinates of top left corner of the frame;
;          cs:cx - should point to the beggining of the framestyle argument
;   Exit : none
;   Destr: 
;/// START ///
FrameAnimated proc

mov si, 0h

mov al, FrameX 
mov ah, FrameY




; int 15h , func 86h to sleep 

endp





;/// END ///

;/// FUNCTION ///
;   Name: PaintFrameCoordinates
;   Paints al:ah rectangular frame. Coordinate of top left corner (dl, dh)
;   Entry:
;          cs:ax - points to the beggining of framestyle cmd argument;
;          dx - contains coordinates of top left corner
;   Exit : none
;   Destr: ax, bx, cx
;/// START ///
PaintFrameCoordinates proc

locals ll

mov bx, 0b800h
mov es, bx
mov bx, 0h

push ax
mov ax, dx
call GoDecartes
pop ax

push dx
push bx ; Stack: vptr -> corner 
mov bx, ax
mov dl, byte ptr cs:[bx]
pop bx ; Stack: corner
mov byte ptr es:[bx], dl
inc bx 
pop dx ; Stack: empty

push dx
push bx 
mov bx, ax
add bx, 9h
mov dl, byte ptr cs:[bx]
pop bx 
mov byte ptr es:[bx], dl 
pop dx
inc bx

mov cl, byte ptr cs:[FrameX]
mov ch, 0h
sub cl, 2h

llFillTop:
push dx
push bx 
mov bx, ax
add bx, 1h
mov dl, byte ptr cs:[bx]
pop bx 
mov byte ptr es:[bx], dl 
pop dx
inc bx 

push dx
push bx
mov bx, ax
add bx, 9h
mov dl, byte ptr cs:[bx]
pop bx
mov byte ptr es:[bx], dl
pop dx
inc bx
;push dx
;push bx 
;mov bx, ax
;add bx, 1h
;mov dl, byte ptr cs:[bx]
;pop bx 
;mov byte ptr es:[bx], dl
;pop dx
;inc bx 
;
;push dx
;push bx 
;mov bx, ax
;add bx, 9h
;mov dl, byte ptr cs:[bx]
;pop bx
;mov byte ptr es:[bx], dl 
;pop dx
;inc bx  

loop llFillTop

push dx
push bx
mov bx, ax
add bx, 2h
mov dl, byte ptr cs:[bx]
pop bx
mov byte ptr es:[bx], dl 
pop dx
inc bx 

push dx
push bx
mov bx, ax
add bx, 9h
mov dl, byte ptr cs:[bx]
pop bx
mov byte ptr es:[bx], dl
pop dx
inc bx  


inc dh ; next line


; MIDDLE: 

mov cl, byte ptr cs:[FrameY]
mov ch, 0h
sub cl, 2h

llFillMiddleFrame:

mov bx, 0h
push ax
mov ax, dx
call GoDecartes
pop ax

push dx
push bx
mov bx, ax
add bx, 3h
mov dl, byte ptr cs:[bx]
pop bx 
mov byte ptr es:[bx], dl
pop dx
inc bx 

push dx
push bx
mov bx, ax
add bx, 9h
mov dl, byte ptr cs:[bx]
pop bx
mov byte ptr es:[bx], dl
pop dx
inc bx

push cx 
mov cl, byte ptr cs:[FrameX]
mov ch, 0h
sub cl, 2h

llFillMiddleLine:

push dx
push bx 
mov bx, ax
add bx, 4h
mov dl, byte ptr cs:[bx]
pop bx 
mov byte ptr es:[bx], dl 
pop dx
inc bx 

push dx
push bx
mov bx, ax
add bx, 9h
mov dl, byte ptr cs:[bx]
pop bx 
mov byte ptr es:[bx], dl
pop dx
inc bx

loop llFillMiddleLine

pop cx

push dx
push bx 
mov bx, ax
add bx, 5h
mov dl, byte ptr cs:[bx]
pop bx 
mov byte ptr es:[bx], dl 
pop dx
inc bx 

push dx
push bx 
mov bx, ax
add bx, 9h
mov dl, byte ptr cs:[bx]
pop bx
mov byte ptr es:[bx], dl 
pop dx
inc bx

inc dh

loop llFillMiddleFrame

; BOTTOM:

mov bx, 0h
push ax
mov ax, dx
call GoDecartes
pop ax

push dx
push bx
mov bx, ax
add bx, 6h
mov dl, byte ptr cs:[bx]
pop bx
mov byte ptr es:[bx], dl 
pop dx
inc bx 

push dx
push bx 
mov bx, ax
add bx, 9h
mov dl, byte ptr cs:[bx]
pop bx
mov byte ptr es:[bx], dl
pop dx
inc bx

mov cl, byte ptr cs:[FrameX]
mov ch, 0h
sub cl, 2h

llFillBottomLine:

push dx
push bx 
mov bx, ax
add bx, 7h
mov dl, byte ptr cs:[bx]
pop bx 
mov byte ptr es:[bx], dl 
pop dx
inc bx 

push dx
push bx
mov bx, ax
add bx, 9h
mov dl, byte ptr cs:[bx]
pop bx
mov byte ptr es:[bx], dl
pop dx
inc bx

loop llFillBottomLine

push dx
push bx
mov bx, ax
add bx, 8h
mov dl, byte ptr cs:[bx]
pop bx 
mov byte ptr es:[bx], dl 
pop dx
inc bx 

push dx
push bx 
mov bx, ax
add bx, 9h
mov dl, byte ptr cs:[bx]
pop bx 
mov byte ptr es:[bx], dl 
pop dx
inc bx

ret
endp
;/// END ///

;/// FUNCTION /// (mini)
;
;   NAME: GoDecartes
;
;   Moves bx pointer to (x, y) in video memory
;
;   Entry: AL - x, AH - y
;   Exit : Increase BX
;   Destr: none
;/// START ///
GoDecartes proc
push dx
mov dl, al ; X
mov dh, 0h
shl dx, 1h
add bx, dx

mov dl, ah
mov dh, 0
imul dx, dx, 50h
add bx, dx
add bx, dx
pop dx
ret
endp
;/// END ///

;/// FUNCTION ///
;   Name: atoi
;   Converts string to 1 word integer (255 is its max value)
;   Entry: es:bx - start of the string
;   Exit : al - converted integer
;   Destr: ax, bx, cx
;/// START ///
; 0 ASCII code is 30h
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

FrameX db 0h
FrameY db 0h


end Start