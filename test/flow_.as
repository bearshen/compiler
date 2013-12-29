push 0
push 0
push sp[-1]
pop sb[0]
pop ac
L000:push sb[0]
push 5
complt
j0 L002
push sb[0]
push 2
mod
push 0
compeq
j0 L003
push "even"
puts
jmp L004
L003: push "odd"
puts
L004: L001: push sb[0]
push 1
add
push sp[-1]
pop sb[0]
pop ac
jmp L000
L002: push ""
puts
push 0
push 0
push sp[-1]
pop sb[1]
pop ac
L005:push sb[1]
push 3
complt
j0 L007
push 0
push 0
push sp[-1]
pop sb[2]
pop ac
L008:push sb[2]
push 3
complt
j0 L010
push sb[1]
push sb[2]
add
puti
L009: push sb[2]
push 1
add
push sp[-1]
pop sb[2]
pop ac
jmp L008
L010: L006: push sb[1]
push 1
add
push sp[-1]
pop sb[1]
pop ac
jmp L005
L007: push ""
puts
push 0
L011: push sb[3]
push 4
complt
j0 L012
push sb[3]
puti
push sb[3]
push 1
add
push sp[-1]
pop sb[3]
pop ac
jmp L011
L012: 