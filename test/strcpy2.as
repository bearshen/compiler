jmp L001
L000:	push 0
push 0
push sp[-1]
pop fp[0]
pop ac
L002:push fp[0]
push fp[-6]
complt
j0 L004
push fp[-5]
push fp[0]
add
pop ac
push sb[ac]
push sp[-1]
push fp[-4]
push fp[0]
add
pop ac
pop sb[ac]
pop ac
L003: push fp[0]
push 1
add
push sp[-1]
pop fp[0]
pop ac
jmp L002
L004: push 0
ret
L001:	push 0
push sp
push 5
add
pop sp
push 0
push 0
add
pop ac
push 'a'
pop sb[ac]
push ac
push 1
add
pop ac
push 'b'
pop sb[ac]
push ac
push 1
add
pop ac
push 'c'
pop sb[ac]
push ac
push 1
add
pop ac
push ' '
pop sb[ac]
push ac
push 1
add
pop ac
push ' '
pop sb[ac]
push ac
push 1
add
pop ac
push ' '
pop sb[ac]
push ac
push 1
add
pop ac
push 0
push sp
push 2
add
pop sp
push 0
push 6
add
pop ac
push '1'
pop sb[ac]
push ac
push 1
add
pop ac
push '2'
pop sb[ac]
push ac
push 1
add
pop ac
push '3'
pop sb[ac]
push ac
push 1
add
pop ac
push 3
push 6
push 0
push 3
add
call L000, 3
pop ac
push 0
push 3
add
pop ac
