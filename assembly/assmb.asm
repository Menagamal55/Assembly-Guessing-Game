.model small
.stack 128

.data   
; ------------------ Designs ------------------
design0 db "    *****    *******  *******  *******   ***   ***   ******   ***      **   **  $"        
design1 db "   *******   **       **       **        **** ****   **   **  ***      *** ***  $"            
design2 db "  ***   ***  *******  *******  *******   *********   ******   ***       *****   $"             
design3 db "  *********  *******  *******  *******   *** * ***   ******   ***        ***    $"             
design4 db "  ***   ***       **       **  **        ***   ***   **   **  *******    ***    $"             
design5 db "  ***   ***  *******  *******  *******   ***   ***   ******   *******    ***    $"             

design6 db "        ******   ******       ** *******     *****     ******     *****         $"        
design7 db "        **   **  **   **     **  **         *******    **   **   *******        $"            
design8 db "        **   **  ******     **   *******   ***   ***   ******   ***   ***       $"              
design9 db "        **   **  *******   **    *******   *********   *******  *********       $"              
design10 db "        **   **  **   **  **          **   ***   ***   **   **  ***   ***       $"              
design11 db "        ******   **   ** **      *******   ***   ***   **   **  ***   ***       $"

; ------------------ Menu ------------------
menu db "*SELECT GAME", 0Dh,0Ah, "1.  Guessing number Game", 0Dh,0Ah, "2.  Guessing letter game", 0Dh,0Ah, "3.  Encryption Game", 0Dh,0Ah, "4.  EXIT ",0Dh,0Ah,"Enter your choice: $"
invalid_choice db "Invalid choice. Please try again.$"

; ------------------ Number Guessing Game ------------------
prompt db "Guess a number between 1 and 10: $"
wrong_guess db "Wrong guess, try again.$" 
greater db "Your guess is greater than the target. Try a smaller number.$"
smaller db "Your guess is smaller than the target. Try a greater number.$"
correct db "Correct! You guessed it! Congratulations!$"
gameOver db "Game Over! You've exceeded the maximum attempts.$"
msg_target db "The correct number was: $"
guess db 0        
target db 0       
newline db 0Dh, 0Ah, "$"
header db "--------------------- Welcome to the Number Guessing Game! ---------------------$"
game_started db 0 
attempts db 0     
attempts_remaining_msg db "Attempts remaining: $"

; ------------------ Letter Guessing Game ------------------
game_name db "--------------------- Welcome to the Letter Guessing Game! ---------------------$" 
line_fence db "--------------------------------------------------------------------------------$" 

words db "COMPUTER$PROGRAM$LANGUAGE$STUDENT$TEACHER$SCHOOL$SYSTEM$MEMORY$"
num_words db 8
current_word db 20 dup('$')
masked_word db 20 dup('$')
hidden_char db 0
hidden_pos db 0
word_index db 0

msg_prompt db "Guess the missing letter: $"
msg_correct db "Correct! The missing letter was: $"
msg_wrong db "Wrong! Try again.$"
msg_win db "You win! Congratulations!$"  
msg_lose db "You lose! Game Over. The word was: $"   
input db 0                 
max_attempts db 3          
attemptss db 0
attempts_remaining_letter db "Attempts remaining: $"
already_msg db "  You have already tried this letter. Try a different one.$"
guessed_letters db 26 dup(0)

; ------------------ Encryption Game ------------------
Enc_name db "----------------------- Welcome to the Encryption Game! ------------------------$" 
buffer db 255 dup(0)
answer db 255 dup(0)
encrypted db 255 dup(0) 
prompt2 db "Enter a string: $"
prompt3 db "Enter your solution: $"
encrypted_msg db 13, 10, 'Encrypted string: $'
msg_equal db "Strings are equal.$"      
msg_not_equal db "Strings are not equal.$" 

; ------------------ Exit ------------------
goodbye db "         GOODBYE :(","$"

.code
main proc far
    mov ax, @data
    mov ds, ax

    lea dx, design0
    mov ah, 09h
    int 21h
    lea dx, design1
    mov ah, 09h
    int 21h
    lea dx, design2
    mov ah, 09h
    int 21h
    lea dx, design3
    mov ah, 09h
    int 21h
    lea dx, design4
    mov ah, 09h
    int 21h
    lea dx, design5
    mov ah, 09h
    int 21h
    lea dx, newline
    mov ah, 09h
    int 21h
    lea dx, design6
    mov ah, 09h
    int 21h
    lea dx, design7
    mov ah, 09h
    int 21h
    lea dx, design8
    mov ah, 09h
    int 21h
    lea dx, design9
    mov ah, 09h
    int 21h
    lea dx, design10
    mov ah, 09h
    int 21h
    lea dx, design11
    mov ah, 09h
    int 21h

main_menu:
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, menu
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    sub al, '0'

    cmp al, 1
    jne skip_guessing_game
    jmp guessing_game
skip_guessing_game:
    cmp al, 2
    jne skip_Letter_Guessing_Game
    jmp Letter_Guessing_Game
skip_Letter_Guessing_Game:
    cmp al, 3
    jne exit_check
    jmp encrypt_game
exit_check:
    cmp al, 4
    jne invalid_choice_label
    jmp exit_prog

invalid_choice_label:
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, invalid_choice
    mov ah, 09h
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h

    jmp main_menu

exit_prog:
    lea dx, newline
    mov ah, 09h
    int 21h
    lea dx, newline
    mov ah, 09h
    int 21h
    lea dx, goodbye   
    mov ah, 09h
    int 21h
    mov ah, 4ch
    int 21h

guessing_game:
    mov byte ptr [attempts], 0

    mov ah, 2Ch
    int 21h
    mov al, dh
    mov bl, 10
    xor ah, ah
    div bl
    inc ah
    mov target, ah

    mov ax, 0b800H
    mov es, ax
    mov ax, 0003H
    int 10H

    lea dx, header
    mov ah, 09h
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, line_fence
    mov ah, 09h
    int 21h  

    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, prompt
    mov ah, 09h
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h

    mov byte ptr [game_started], 1

guess_number:
    lea dx, newline
    mov ah, 09h
    int 21h
    
    lea dx, attempts_remaining_msg
    mov ah, 09h
    int 21h
    
    mov al, 3
    sub al, [attempts]
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    
    lea dx, newline
    mov ah, 09h
    int 21h

    mov al, [attempts]
    cmp al, 3
    jae gameOver_display

    mov ah, 01h
    int 21h
    sub al, '0'
    mov guess, al
    
    lea dx, newline
    mov ah, 09h
    int 21h
    
    mov al, [target]
    cmp [guess], al
    je correct_guess
    jl smaller_guess
    jmp greater_guess

smaller_guess:
    inc byte ptr [attempts]
    lea dx, smaller
    mov ah, 09h
    int 21h
    lea dx, newline
    mov ah, 09h
    int 21h
    jmp guess_number

greater_guess:
    inc byte ptr [attempts]
    lea dx, greater
    mov ah, 09h
    int 21h
    lea dx, newline
    mov ah, 09h
    int 21h
    jmp guess_number

correct_guess:
    lea dx, correct
    mov ah, 09h
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h
    lea dx, msg_target
    mov ah, 09h
    int 21h
    mov al, [target]
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    lea dx, newline
    mov ah, 09h
    int 21h

    jmp main_menu

gameOver_display:
    lea dx, gameOver
    mov ah, 09h
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h
    lea dx, msg_target
    mov ah, 09h
    int 21h
    mov al, [target]
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    lea dx, newline
    mov ah, 09h
    int 21h

    jmp main_menu

Letter_Guessing_Game:
    mov byte ptr [attemptss], 0
    mov ax, @data
    mov ds, ax   
    
    push es
    mov ax, @data
    mov es, ax
    lea di, guessed_letters
    mov cx, 26
    mov al, 0
    rep stosb
    pop es

    call select_random_word
    
    call hide_random_letter

    mov ax, 0b800H
    mov es, ax
    mov ax, 0003H
    int 10H

    lea dx, game_name
    mov ah, 09h
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, line_fence
    mov ah, 09h
    int 21h
    lea dx, newline
    mov ah, 09h
    int 21h

game_start:
    lea dx, attempts_remaining_letter
    mov ah, 09h
    int 21h
    
    mov al, [max_attempts]
    sub al, [attemptss]
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, masked_word
    mov ah, 09h
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, msg_prompt
    mov ah, 09h
    int 21h

    lea dx, newline
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    mov input, al              

    cmp input, 'a'
    jl not_lowercase
    cmp input, 'z'
    jg not_lowercase
    sub input, 32
not_lowercase:

    mov al, input
    cmp al, 'A'
    jl skip_already_check
    cmp al, 'Z'
    jg skip_already_check
    sub al, 'A'
    mov bl, al
    xor bh, bh
    lea si, guessed_letters
    add si, bx
    mov dl, [si]
    cmp dl, 0
    jne already_tried_label
    mov byte ptr [si], 1
skip_already_check:

    lea dx, newline
    mov ah, 09h
    int 21h

    mov al, [input]
    cmp al, [hidden_char]
    je correct_Guess           

wrong_Guess:
    inc attemptss
    mov al, [max_attempts]     
    mov bl, [attemptss]
    cmp bl, al           
    je game_Over               

    lea dx, msg_wrong
    mov ah, 09h
    int 21h
    lea dx, newline
    mov ah, 09h
    int 21h
    jmp game_start             

correct_Guess:
    lea dx, msg_correct
    mov ah, 09h
    int 21h
    lea dx, newline
    mov ah, 09h
    int 21h
    mov dl, [hidden_char]
    mov ah, 02h
    int 21h
    lea dx, newline
    mov ah, 09h
    int 21h
    lea dx, msg_win
    mov ah, 09h
    int 21h
    lea dx, newline
    mov ah, 09h
    int 21h
    jmp main_menu

game_Over:
    lea dx, msg_lose
    mov ah, 09h
    int 21h
    lea dx, current_word
    mov ah, 09h
    int 21h
    lea dx, newline
    mov ah, 09h
    int 21h
    jmp main_menu

already_tried_label:
    lea dx, already_msg
    mov ah, 09h
    int 21h
    lea dx, newline
    mov ah, 09h
    int 21h
    jmp game_start

select_random_word proc
    mov ah, 2Ch
    int 21h
    mov al, dl
    mov bl, [num_words]
    xor ah, ah
    div bl
    mov [word_index], ah
    
    mov si, offset words
    mov cl, [word_index]
    cmp cl, 0
    je copy_word
    
find_word:
    mov al, [si]
    inc si
    cmp al, '$'
    jne find_word
    dec cl
    jnz find_word

copy_word:
    mov di, offset current_word
copy_loop:
    mov al, [si]
    cmp al, '$'
    je copy_done
    mov [di], al
    inc si
    inc di
    jmp copy_loop
copy_done:
    mov byte ptr [di], '$'
    
    ret
select_random_word endp

hide_random_letter proc
    mov si, offset current_word
    mov bx, 0
count_chars:
    mov al, [si]
    cmp al, '$'
    je done_count
    cmp al, 0
    je done_count
    inc si
    inc bx
    jmp count_chars

done_count:
    cmp bx, 0
    jne not_empty
    mov bx, 1
not_empty:
    mov ah, 2Ch
    int 21h
    mov al, dl
    xor ah, ah
    div bl
    mov [hidden_pos], ah
    
    mov si, offset current_word
    mov bl, [hidden_pos]
    mov bh, 0
    add si, bx
    mov al, [si]
    mov [hidden_char], al
    
    mov si, offset current_word
    mov di, offset masked_word
    mov cx, 0
make_mask:
    mov al, [si]
    cmp al, '$'
    je mask_done
    cmp al, 0
    je mask_done
    mov dl, cl
    cmp dl, [hidden_pos]
    je hide_it
    mov [di], al
    jmp next_char
hide_it:
    mov byte ptr [di], '_'
next_char:
    inc si
    inc di
    inc cl
    jmp make_mask

mask_done:
    mov byte ptr [di], '$'
    ret
hide_random_letter endp

encrypt_game:
    mov ax, 0b800H
    mov es, ax
    mov ax, 0003H
    int 10H 
    mov ax, @data
    mov ds, ax

    lea dx, Enc_name
    mov ah, 09h
    int 21h
    lea dx, newline
    mov ah, 09h
    int 21h
    lea dx, line_fence
    mov ah, 09h
    int 21h  
    lea dx, newline
    mov ah, 09h
    int 21h
    
    lea dx, prompt2
    mov ah, 09h
    int 21h
    
    lea si, buffer
    mov cx, 0

read_loop:
    mov ah, 01h
    int 21h
    cmp al, 13
    je done_reading         
    mov [si], al            
    inc si                  
    inc cx                  
    cmp cx, 254
    je done_reading
    jmp read_loop   

done_reading:
    mov byte ptr [si], "$"
    
    lea dx, newline
    mov ah, 09h
    int 21h
    
    lea dx, prompt3
    mov ah, 09h
    int 21h
    
    lea di, answer
    mov cx, 0

read_answer_loop:
    mov ah, 01h
    int 21h
    cmp al, 13
    je done_reading_answer
    mov [di], al
    inc di
    inc cx
    cmp cx, 254
    je done_reading_answer
    jmp read_answer_loop

done_reading_answer:
    mov byte ptr [di], "$"

    lea si, buffer
    lea di, encrypted

encrypt_loop_main:
    mov al, [si]
    cmp al, "$"
    je done_encrypt_main
    cmp al, 0
    je done_encrypt_main
    cmp al, 'A'
    jl skip_encrypt_main
    cmp al, 'Z'
    jle upper_case_encrypt
    cmp al, 'a'
    jl skip_encrypt_main
    cmp al, 'z'
    jg skip_encrypt_main

lower_case_encrypt:
    add al, 3
    cmp al, 'z'
    jle store_char_encrypt
    sub al, 26
    jmp store_char_encrypt

upper_case_encrypt:
    add al, 3
    cmp al, 'Z'
    jle store_char_encrypt
    sub al, 26

store_char_encrypt:
    mov [di], al
    jmp next_char_encrypt

skip_encrypt_main:
    mov [di], al

next_char_encrypt:
    inc si
    inc di
    jmp encrypt_loop_main

done_encrypt_main:
    mov byte ptr [di], "$"

    lea dx, newline
    mov ah, 09h
    int 21h

    lea si, answer
    lea di, encrypted

compare_loop_encrypt:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne not_equal_encrypt
    cmp al, "$"
    je strings_equal_encrypt
    cmp al, 0
    je strings_equal_encrypt
    inc si
    inc di
    jmp compare_loop_encrypt

not_equal_encrypt:
    lea dx, msg_not_equal
    jmp print_message_encrypt

strings_equal_encrypt:
    lea dx, msg_equal

print_message_encrypt:
    mov ah, 09h
    int 21h
    lea dx, newline
    mov ah, 09h
    int 21h

    lea dx, encrypted_msg
    mov ah, 09h
    int 21h
    lea dx, encrypted
    mov ah, 09h
    int 21h
    lea dx, newline
    mov ah, 09h
    int 21h
    lea dx, newline
    mov ah, 09h
    int 21h

    jmp main_menu

main endp
end main