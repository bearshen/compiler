push 0
push sp
push 9
add
pop sp
push 10
push sp[-1]
push 0
push 0
add
pop ac
pop sb[ac]
pop ac
jmp L001
L000:	push 0
push 0
push 0
push fp[-4]
push fp[-5]
compge
j0 L002
push 0
ret
L002: push fp[-4]
push sp[-1]
pop fp[2]
pop ac
push fp[-4]
push 1
add
push sp[-1]
pop fp[1]
pop ac
L003:push fp[1]
push fp[-5]
comple
j0 L005
push fp[1]
push 0
add
pop ac
push sb[ac]
push fp[-4]
push 0
add
pop ac
push sb[ac]
complt
j0 L006
push fp[2]
push 1
add
push sp[-1]
pop fp[2]
pop ac
push fp[2]
push 0
add
pop ac
push sb[ac]
push sp[-1]
pop fp[0]
pop ac
push fp[1]
push 0
add
pop ac
push sb[ac]
push sp[-1]
push fp[2]
push 0
add
pop ac
pop sb[ac]
pop ac
push fp[0]
push sp[-1]
push fp[1]
push 0
add
pop ac
pop sb[ac]
pop ac
L006: L004: push fp[1]
push 1
add
push sp[-1]
pop fp[1]
pop ac
jmp L003
L005: push fp[-4]
push 0
add
pop ac
push sb[ac]
push sp[-1]
pop fp[0]
pop ac
push fp[2]
push 0
add
pop ac
push sb[ac]
push sp[-1]
push fp[-4]
push 0
add
pop ac
pop sb[ac]
pop ac
push fp[0]
push sp[-1]
push fp[2]
push 0
add
pop ac
pop sb[ac]
pop ac
push fp[2]
push 1
sub
push fp[-4]
call L000, 2
pop ac
push fp[-5]
push fp[2]
push 1
add
call L000, 2
pop ac
push 0
ret
L001:	push 5
push sp[-1]
push 1
push 0
add
pop ac
pop sb[ac]
pop ac
push 2
push sp[-1]
push 2
push 0
add
pop ac
pop sb[ac]
pop ac
push 3
push sp[-1]
push 3
push 0
add
pop ac
pop sb[ac]
pop ac
push 13
push sp[-1]
push 4
push 0
add
pop ac
pop sb[ac]
pop ac
push 5
push sp[-1]
push 5
push 0
add
pop ac
pop sb[ac]
pop ac
push 21
push sp[-1]
push 6
push 0
add
pop ac
pop sb[ac]
pop ac
push 7
push sp[-1]
push 7
push 0
add
pop ac
pop sb[ac]
pop ac
push 0
push sp[-1]
push 8
push 0
add
pop ac
pop sb[ac]
pop ac
push 6
push sp[-1]
push 9
push 0
add
pop ac
pop sb[ac]
pop ac
push 9
push 0
call L000, 2
pop ac
push 0
pop ac
push 0
pop ac
L007: push ac
push 10
complt
j0 L008
push sb[ac]
puti_
push '	'
putc_
push ac
push 1
add
pop ac
jmp L007
L008: push ''
putc
