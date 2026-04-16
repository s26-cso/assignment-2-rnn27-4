.data
    space_fmt: .string "%d "
    last_fmt: .string "%d\n"
    newline_fmt: .string "\n"

.text
.globl main
main:
    #using s means we have to also save it...
    addi sp, sp, -64
    sd ra, 0(sp)
    sd s0, 8(sp)
    sd s1, 16(sp)
    sd s2, 24(sp)
    sd s3, 32(sp)
    sd s4, 40(sp)
    sd s5, 48(sp)
    sd s6, 56(sp)
    addi s0, a0, -1    #-1 cause the count also include the call to the executable file
    ble s0, zero, the_end    #just in case there is nothing there forced by ai
    #storing argc as we calling multiple functions we migth loose it other wise
    mv s6, a1
    #mallocing for storing numbers,result&stack
    mv a0, s0
    slli a0, a0, 3
    call malloc
    mv s1, a0
    mv a0, s0
    slli a0, a0, 3
    call malloc
    mv s2, a0
    mv a0, s0
    slli a0, a0, 3
    call malloc
    #redoing a0 cause its getting erased everytime also storing it ofc
    mv s4, a0
    #s4 now stores actual shite intead of argv
    #now we want load up s3 we get argv
    li s3, 0
conversion:
    #calling atoi to convert
    bge s3, s0, reset
    addi t0, s3, 1
    slli t0, t0, 3
    add t0, s6, t0
    ld a0, 0(t0)
    call atoi
    slli t1, s3, 3
    add t1, s1, t1
    sd a0, 0(t1)
    li t2, -1    #initialising results to -1...
    slli t1, s3, 3
    add t1, s2, t1
    sd t2, 0(t1)
    addi s3, s3, 1
    #would it have been smarter to just make a contant 8 and then use it everywhere?
    #yess, but i am not smart enuf for that
    j conversion
reset:
    li s5, -1
    addi s3, s0, -1
    blt s3, zero, print
yet:
    #so if nothing is there we put in if not we have conditions
    blt s5, zero, end_condition
    slli t0, s5, 3
    add t0, s4, t0
    ld t1, 0(t0)
    slli t2, t1, 3
    add t2, s1, t2
    ld t2, 0(t2)
    slli t3, s3, 3
    add t3, s1, t3
    ld t3, 0(t3)    #all this to get arr[stack.top()] and arr[i]
    #now if arr[stack.top()] > arr[i] stop popping
    bgt t2, t3, result
    #yeetin
    addi s5, s5, -1
    j yet
result:
    #now we will have to update the result
    slli t0, s3, 3
    add t0, s2, t0
    sd t1, 0(t0)
end_condition:
    ble s3, zero, print
    addi s5, s5, 1
    slli t0, s5, 3
    add t0, s4, t0
    sd s3, 0(t0)
    addi s3, s3, -1
    j yet
print:
    li s3, 0
looping:
    bge s3, s0, the_end
    slli t1, s3, 3
    add t1, s2, t1
    ld a1, 0(t1)

    # Check if this is the last element
    addi t2, s0, -1
    beq s3, t2, print_last

    la a0, space_fmt
    call printf
    addi s3, s3, 1
    j looping

print_last:
    # Print last element with newline, then restore
    la a0, last_fmt
    call printf
    j restore_peace

the_end:
    #for the newline grandmasti (only runs if array was empty)
    la a0, newline_fmt
    call printf

restore_peace:
    #restoring peace
    ld ra, 0(sp)
    ld s0, 8(sp)
    ld s1, 16(sp)
    ld s2, 24(sp)
    ld s3, 32(sp)
    ld s4, 40(sp)
    ld s5, 48(sp)
    ld s6, 56(sp)
    addi sp, sp, 64
    li a0, 0
    ret
