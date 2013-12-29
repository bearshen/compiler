jmp L001
L000:	push fp[-4]
push 2
mul
ret
push 0
ret
L001:	jmp L003
L002:	push fp[-4]
call L004, 1
push fp[-4]
call L000, 1
push fp[0]
push fp[1]
add
ret
push 0
ret
L003:	jmp L006
L005:	push fp[-4]
push 0
compeq
j0 L007
push "zero!"
puts
jmp L008
L007: push fp[-4]
puti
push fp[-4]
push 1
sub
call L005, 1
pop ac
L008: push 0
ret
L006:	push 3
call L004, 1
puti
push ""
puts
push 2
call L000, 1
puti
push ""
puts
push 4
call L002, 1
puti
push ""
puts
push 3
call L005, 1
puti
