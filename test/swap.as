jmp L001
L000:	push fp[-4]
ret
push 0
ret
L001:	jmp L003
L002:	push fp[-4]
ret
push 0
ret
L003:	jmp L005
L004:	push 0
push fp[-4]
pop ac
push sb[ac]
push sp[-1]
pop fp[0]
pop ac
push fp[-5]
pop ac
push sb[ac]
push sp[-1]
push fp[-4]
pop ac
pop sb[ac]
pop ac
push fp[0]
push sp[-1]
push fp[-5]
pop ac
pop sb[ac]
pop ac
push 0
ret
L005:	push 10
push 20
push 1
push 0
call L004, 2
pop ac
push sb[0]
puti
push sb[1]
puti
