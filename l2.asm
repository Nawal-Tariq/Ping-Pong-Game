[org 0x0100]

message: db '##'
length: dw 1
char: db 'o'      ; Character to move
attr: db 0x0E    ; Yellow on black attribute
start_x: dw 40    ; Starting X position (column)
start_y: dw 12    ; Starting Y position (row)
dir_x: db 1       ; X direction (1: right, -1: left)
dir_y: db 1       ; Y direction (1: down, -1: up)

paddle1_y: dw 12  ; Middle position of the left paddle
paddle2_y: dw 12  ; Middle position of the right paddle

score1: dw 0      ; Score for player 1 (left)
score2: dw 0      ; Score for player 2 (right)
win_score: dw 5   ; Pre-set number of points to win
is_paused: db 0   ; Pause flag (0: not paused, 1: paused)
; Strings to print at the top
right_player: db 'Right Player', 0
left_player: db 'Left Player', 0

; Strings to print at the bottom
string1: db '                       Nawal   23F-0776', 0
string2: db '                       Warisha 23F-0534', 0

start:
main_loop:
    ; Initialize the game
    call clrscr
    mov ax, message
    push ax
    push word [length]
    call print
    mov ax, message
    push ax
    push word [length]
    call print1
    mov ax, message
    push ax
    push word [length]
    call print2
    mov ax, message
    push ax
    push word [length]
    call print3
    call print_bottom_strings
    call erase_paddles
    call draw_paddles
    call update_pos
    call draw_char
    call delay
    call delay
    call delay
    call delay
    call delay
    call delay
    call delay
    call erase_char
    call check_keys
    call update_score
call print_top_strings
    call display_score
    call check_win

    jmp main_loop

clrscr:
    push es
    push ax
    push di
    mov ax, 0xb800
    mov es, ax ; point es to video base
    mov di, 0 ; point di to top left column
nextloc:
    mov word [es:di], 0x0720 ; clear next char on screen
    add di, 2 ; move to next screen location
    cmp di, 4000 ; has the whole screen cleared
    jne nextloc ; if no clear next position
    pop di
    pop ax
    pop es
    ret

print:
    push bp
    mov bp, sp
    push ax
    push es
    push si
    push di
    mov ax, 0xb800
    mov es, ax
    mov si, [bp+6]
    mov di, 0
    mov ah, 0x0B
next1:
    mov al, [si]
    mov [es:di], ax
    add di, 2
    cmp di, 160
    jne next1
    pop di
    pop si
    pop es
    pop ax
    pop bp
    ret 4

print1:
    push bp
    mov bp, sp
    push ax
    push es
    push si
    push di
    mov ax, 0xb800
    mov es, ax
    mov si, [bp+6]
    mov di, 3840
    mov ah, 0x0B
next2:
    mov al, [si]
    mov [es:di], ax
    add di, 2
    cmp di, 4000
    jne next2
    pop di
    pop si
    pop es
    pop ax
    pop bp
    ret 4

print2:
    push bp
    mov bp, sp
    push ax
    push es
    push si
    push di
    mov ax, 0xb800
    mov es, ax
    mov si, [bp+6]
    mov di, 0
    mov ah, 0x0B
next3:
    mov al, [si]
    mov [es:di], ax
    add di, 160
    cmp di, 3840
    jne next3
    pop di
    pop si
    pop es
    pop ax
    pop bp
    ret 4

print3:
    push bp
    mov bp, sp
    push ax
    push es
    push si
    push di
    mov ax, 0xb800
    mov es, ax
    mov si, [bp+6]
    mov di, 158
    mov ah, 0x0B
next4:
    mov al, [si]
    mov [es:di], ax
    add di, 160
    cmp di, 3998
    jne next4
    pop di
    pop si
    pop es
    pop ax
    pop bp
    ret 4

draw_paddles:
    ; Draw left paddle
    mov cx, 3
    mov ax, [paddle1_y]
    sub ax, 1
draw_left_paddle:
    push ax
    push cx
    mov dh, al
    mov dl, 1
    call draw_paddle_segment
    pop cx
    pop ax
    inc ax
    loop draw_left_paddle

    ; Draw right paddle
    mov cx, 3
    mov ax, [paddle2_y]
    sub ax, 1
draw_right_paddle:
    push ax
    push cx
    mov dh, al
    mov dl, 78
    call draw_paddle_segment
    pop cx
    pop ax
    inc ax
    loop draw_right_paddle

    ret

erase_paddles:
    ; Erase left paddle
    mov cx, 3
    mov ax, [paddle1_y]
    sub ax, 1
erase_left_paddle:
    push ax
    push cx
    mov dh, al
    mov dl, 1
    call erase_paddle_segment
    pop cx
    pop ax
    inc ax
    loop erase_left_paddle

    ; Erase right paddle
    mov cx, 3
    mov ax, [paddle2_y]
    sub ax, 1
erase_right_paddle:
    push ax
    push cx
    mov dh, al
    mov dl, 78
    call erase_paddle_segment
    pop cx
    pop ax
    inc ax
    loop erase_right_paddle

    ret

draw_paddle_segment:
    push ax
    push bx
    push cx
    push dx

    mov ah, 0x02       ; Set cursor position
    mov bh, 0x00       ; Page number
    int 0x10           ; BIOS video interrupt

    mov ah, 0x09       ; Write character at cursor
    mov al, '|'        ; Paddle character
    mov bl, 0x0E       ; Attribute (yellow on black)
    mov cx, 1          ; Write once
    int 0x10           ; BIOS video interrupt

    pop dx
    pop cx
    pop bx
    pop ax
    ret

erase_paddle_segment:
    push ax
    push bx
    push cx
    push dx

    mov ah, 0x02       ; Set cursor position
    mov bh, 0x00       ; Page number
    int 0x10           ; BIOS video interrupt

    mov ah, 0x09       ; Write space to erase
    mov al, ' '        ; Space character
    mov bl, 0x0E       ; Attribute (yellow on black)
    mov cx, 1          ; Write once
    int 0x10           ; BIOS video interrupt

    pop dx
    pop cx
    pop bx
    pop ax
    ret

check_keys:
    mov ah, 0x01
    int 0x16
    jz no_key

    mov ah, 0x00
    int 0x16

    cmp al, 'W'
    je move_paddle1_up
    cmp al, 'S'
    je move_paddle1_down
    cmp ah, 0x48
    je move_paddle2_up
    cmp ah, 0x50
    je move_paddle2_down
    cmp al, 'P'
    je toggle_pause

no_key:
    ret

move_paddle1_up:
    mov ax, [paddle1_y]
    cmp ax, 1
    jle no_key
    dec ax
    mov [paddle1_y], ax
    ret

move_paddle1_down:
    mov ax, [paddle1_y]
    cmp ax, 23
    jge no_key
    inc ax
    mov [paddle1_y], ax
    ret

move_paddle2_up:
    mov ax, [paddle2_y]
    cmp ax, 1
    jle no_key
    dec ax
    mov [paddle2_y], ax
    ret

move_paddle2_down:
    mov ax, [paddle2_y]
    cmp ax, 23
    jge no_key
    inc ax
    mov [paddle2_y], ax
    ret

toggle_pause:
    mov al, [is_paused]
    xor al, 1
    mov [is_paused], al
    ret

; Subroutine: Draw Character
draw_char:
    push ax
    push bx
    push cx
    push dx

    mov ah, 0x02       ; Set cursor position
    mov bh, 0x00       ; Page number
    mov dh, [start_y]  ; Row
    mov dl, [start_x]  ; Column
    int 0x10           ; BIOS video interrupt

    mov ah, 0x09       ; Write character at cursor
    mov al, [char]     ; Character to display
    mov bl, [attr]     ; Attribute
    mov cx, 1          ; Write once
    int 0x10           ; BIOS video interrupt

    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Subroutine: Erase Character
erase_char:
    push ax
    push bx
    push cx
    push dx

    mov ah, 0x02       ; Set cursor position
    mov bh, 0x00       ; Page number
    mov dh, [start_y]  ; Row
    mov dl, [start_x]  ; Column
    int 0x10           ; BIOS video interrupt

    mov ah, 0x09       ; Write space to erase
    mov al, ' '        ; Space character
    mov bl, [attr]     ; Attribute
    mov cx, 1          ; Write once
    int 0x10           ; BIOS video interrupt

    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Subroutine: Update Position
update_pos:
    cmp byte [is_paused], 1
    je no_update

    mov al, [dir_x]
    add [start_x], al
    mov al, [dir_y]
    add [start_y], al

    ; Check for collision with screen boundaries
    cmp byte [start_x], 0
    jl change_dir_x_left
    cmp byte [start_x], 79
    jg change_dir_x_right
    cmp byte [start_y], 0
    jl change_dir_y_top
    cmp byte [start_y], 24
    jg change_dir_y_bottom

    ; Check for collision with paddles
    mov ax, [start_x]
    cmp ax, 2
    jl check_left_paddle
    cmp ax, 77
    jg check_right_paddle

no_update:
    ret

change_dir_x_left:
    neg byte [dir_x]
    ret

change_dir_x_right:
    neg byte [dir_x]
    ret

change_dir_y_top:
    neg byte [dir_y]
    ret

change_dir_y_bottom:
    neg byte [dir_y]
    ret
change_dir_bottom_left:
    ; Handle the bottom-left corner specifically
    neg byte [dir_x]
    neg byte [dir_y]
    ret
check_left_paddle:
    mov ax, [start_y]
    mov bx, [paddle1_y]
    sub bx, 1
    cmp ax, bx
    jl no_collision
    add bx, 2
    cmp ax, bx
    jg no_collision
    ; Collision with left paddle
    neg byte [dir_x]
    ret

check_right_paddle:
    mov ax, [start_y]
    mov bx, [paddle2_y]
    sub bx, 1
    cmp ax, bx
    jl no_collision
    add bx, 2
    cmp ax, bx
    jg no_collision
    ; Collision with right paddle
    neg byte [dir_x]
    ret

no_collision:
    ret

; Subroutine: Update Score
update_score:
    ; Check if the ball has crossed the left boundary
    mov ax, [start_x]
    mov bx, ax
    and bx, 0x00FF
    cmp bx, 0
    jne check_right_boundary
    ; Ball has crossed the left boundary, increment right player's score
    inc word [score2]
    ret

check_right_boundary:
    ; Check if the ball has crossed the right boundary
    mov ax, [start_x]
    mov bx, ax
    and bx, 0x00FF
    cmp bx, 79
    jne no_score_update
    ; Ball has crossed the right boundary, increment left player's score
    inc word [score1]
    ret

no_score_update:
    ret

; Subroutine: Display Score
display_score:
    ; Display scores at the top of the screen
    push es
    push ax
    push bx
    push di
    mov ax, 0xb800
    mov es, ax

    ; Display Player 1 Score
    mov bx, [score1]
    add bx, '0'       ; Convert to ASCII
    mov di, 1018
    mov ah, 0x0E      ; Yellow attribute
    mov al, bl
    mov [es:di], ax

    ; Display Player 2 Score
    mov bx, [score2]
    add bx, '0'       ; Convert to ASCII
    mov di, 1048    ; Offset for player 2 score
    mov al, bl
    mov [es:di], ax

    pop di
    pop bx
    pop ax
    pop es
    ret

; Subroutine: Check Win
check_win:
    ; Check if left player has won
    mov ax, [score1]
    cmp ax, [win_score]
    jge left_player_wins

    ; Check if right player has won
    mov ax, [score2]
    cmp ax, [win_score]
    jge right_player_wins

    ret

left_player_wins:
    ; Display win message for left player
    mov si, win_message_left
    call print_win_message
    jmp end_game

right_player_wins:
    ; Display win message for right player
    mov si, win_message_right
    call print_win_message
    jmp end_game

no_win:
    ret

; Subroutine: Print Win Message
print_win_message:
    push ax
    push es
    push si
    push di
    mov ax, 0xb800
    mov es, ax
    mov di, 1616 ; Position to print the win message
    mov ah, 0x0B
next_win_message:
    lodsb
    stosw
    test al, al
    jnz next_win_message
    pop di
    pop si
    pop es
    pop ax
    ret

; Subroutine: End Game
end_game:
    ; Wait for user input to restart or exit
    mov ah, 0x00
    int 0x16

    cmp al, 'R'
    je restart_game
    cmp al, 'r'
    je restart_game

    ; Exit the game
    mov ax, 0x4c00
    int 0x21

restart_game:
    ; Reset scores and positions
    mov word [score1], 0
    mov word [score2], 0
    mov word [start_x], 40
    mov word [start_y], 12
    mov byte [dir_x], 1
    mov byte [dir_y], 1
    mov word [paddle1_y], 12
    mov word [paddle2_y], 12

    ; Clear screen and redraw initial state
    call clrscr
    call draw_paddles
    call draw_char
    call display_score

    ; Jump back to the main loop
    jmp main_loop

; Win messages
win_message_left: db 'Left Player Wins! Press R to restart or any other key to exit.', 0
win_message_right: db 'Right Player Wins! Press R to restart or any other key to exit.', 0

; Subroutine: Delay
delay:
    mov cx, 0xFFFF      ; Arbitrary delay count
delay_loop:
    loop delay_loop
    ret

; Subroutine: Print Bottom Strings
print_bottom_strings:
    push es
    push ax
    push di
    mov ax, 0xb800
    mov es, ax ; point es to video base
    mov di, 3374 ; point di to the bottom of the screen

    ; Print the first string
    mov si, string1
    call print_string

    ; Move to the next line
    add di, 160

    ; Print the second string
    mov si, string2
    call print_string

    pop di
    pop ax
    pop es
    ret

; Subroutine: Print String
print_string:
    push ax
    push cx
    push si
    push di

next_char:
    lodsb
    test al, al
    jz end_string
    mov ah, 0x0D ; Light Magenta on black attribute
    stosw
    jmp next_char

end_string:
    pop di
    pop si
    pop cx
    pop ax
    ret
;Subroutine: Print top Strings
print_top_strings:
    push es
    push ax
    push di
    mov ax, 0xb800
    mov es, ax ; point es to video base
    mov di, 688 ; point di to the bottom of the screen

    ; Print the first string
    mov si, left_player
    call printstring

    ; Move to the next line
    add di, 32

    ; Print the second string
    mov si, right_player
    call printstring

    pop di
    pop ax
    pop es
    ret

; Subroutine: Print String
printstring:
    push ax
    push cx
    push si
    push di

nextchar:
    lodsb
    test al, al
    jz endstring
    mov ah, 0x0D ; Light Magenta on black attribute
    stosw
    jmp nextchar

endstring:
    pop di
    pop si
    pop cx
    pop ax
    ret
