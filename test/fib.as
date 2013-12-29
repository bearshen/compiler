push 0
push 0
geti
pop sb[0]
push sb[0]
call L000, 1
push sp[-1]
pop sb[1]
pop ac
push sb[1]
puti
jmp L001
L000:	push fp[-4]
push 1
compeq
push fp[-4]
push 2
compeq
or
j0 L002
push 1
ret
jmp L003
L002: push fp[-4]
push 1
sub
call L000, 1
push fp[-4]
push 2
sub
call L000, 1
add
ret
L003: push 0
ret
L001:	