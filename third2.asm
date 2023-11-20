com equ	0273h	
pa equ 0270h	
pb equ 0271h	
pc equ 0272h	



_stack segment stack
           dw 100 dup(?)
_stack ends


data segment

    led    db 10111110b
           db 10111111b
           db 10111101b
           db 11101011b
           db 11111011b
           db 11011011b

    status dw 0

data ends


code segment
                  assume ds:data, ss:_stack, cs:code


delay_500ms proc

                  push   cx
                  mov    cx,60000
                  loop   $
                  pop    cx
                  ret
delay_500ms endp

delay_2s proc
                  push   cx
                  mov    cx,4
    to_delay1:    
                  call   delay_500ms
                  loop   to_delay1
                  pop    cx
                  ret
delay_2s endp


start proc

                  mov    ax,data
                  mov    ds,ax
    input:        
                  mov    dx,com
                  mov    ax,10000010b
                  out    dx,al
                  mov    dx,pa


                  mov    al,0ffh
                  out    dx,al

                  jmp    green0


 






    green0:       
                  mov    bx,offset led
                  mov    dx,pa
                  mov    al,[bx]
                  out    dx,al


                  mov    cx,10
                  mov    dx,pb
    delay_green0: 
                
                  in     al,dx
                  and    al,80h
                  jnz    yellow0
                  and    al,40h
                  jnz    out0



                  mov    al,[bx]
                  out    dx,al
                  call   delay_500ms
                  loop   delay_green0
    out0:
                  jmp    greeen_blink0


    greeen_blink0:
                  mov    cx,4
    blink0:       
                  mov    dx,pa
                  mov    bx,offset led
                  mov    al,[bx+1]
                  out    dx,al
                  call   delay_500ms

                  mov    al,[bx]
                  out    dx,al
                  call   delay_500ms
                  loop   blink0

                  jmp    yellow0

                


    yellow0:      
                  mov    dx,pa
                  mov    bx,offset led
                  mov    al,[bx+2]
                  out    dx,al
                  call   delay_2s
                  jmp    green1



    green1:       
                  mov    bx,offset led
                  mov    dx,pa
                  mov    al,[bx+3]
                  out    dx,al


                  mov    cx,10
                  mov    dx,pb
    delay_green1: 
                
                  in     al,dx
                  and    al,80h
                  jnz    yellow1
                  and    al,40h
                  jnz    out1



                  mov    al,[bx+3]
                  out    dx,al
                  call   delay_500ms
                  loop   delay_green1
    out1:
                  jmp    greeen_blink1


    greeen_blink1:
                  mov    cx,4
    blink1:       
                  mov    dx,pa
                  mov    bx,offset led
                  mov    al,[bx+4]
                  out    dx,al
                  call   delay_500ms

                  mov    al,[bx+3]
                  out    dx,al
                  call   delay_500ms
                  loop   blink1

                  jmp    yellow1

                


    yellow1:      
                  mov    dx,pa
                  mov    bx,offset led
                  mov    al,[bx+5]
                  out    dx,al
                  call   delay_2s
                  jmp    green0








start endp
code ends
end start
