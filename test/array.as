push 0
push sp
push 2
add
pop sp
push 1
push sp[-1]
push 0
push 0
add
pop ac
pop sb[ac]
pop ac
push 2
push sp[-1]
push 1
push 0
add
pop ac
pop sb[ac]
pop ac
push 4
push sp[-1]
push 2
push 0
add
pop ac
pop sb[ac]
pop ac
push 0
push sp
push 5
add
pop sp
push 2
push sp[-1]
push 2
push 0
mul
push 0
add
push 3
add
pop ac
pop sb[ac]
pop ac
push 4
push sp[-1]
push 2
push 0
mul
push 1
add
push 3
add
pop ac
pop sb[ac]
pop ac
push 6
push sp[-1]
push 2
push 1
mul
push 0
add
push 3
add
pop ac
pop sb[ac]
pop ac
push 8
push sp[-1]
push 2
push 1
mul
push 1
add
push 3
add
pop ac
pop sb[ac]
pop ac
push 10
push sp[-1]
push 2
push 2
mul
push 0
add
push 3
add
pop ac
pop sb[ac]
pop ac
push 12
push sp[-1]
push 2
push 2
mul
push 1
add
push 3
add
pop ac
pop sb[ac]
pop ac
push 0
push sp
push 17
add
pop sp
push 1
push sp[-1]
push 6
push 0
mul
push 3
push 0
mul
add
push 0
add
push 9
add
pop ac
pop sb[ac]
pop ac
push 2
push sp[-1]
push 6
push 0
mul
push 3
push 0
mul
add
push 1
add
push 9
add
pop ac
pop sb[ac]
pop ac
push 3
push sp[-1]
push 6
push 0
mul
push 3
push 0
mul
add
push 2
add
push 9
add
pop ac
pop sb[ac]
pop ac
push 4
push sp[-1]
push 6
push 0
mul
push 3
push 1
mul
add
push 0
add
push 9
add
pop ac
pop sb[ac]
pop ac
push 5
push sp[-1]
push 6
push 0
mul
push 3
push 1
mul
add
push 1
add
push 9
add
pop ac
pop sb[ac]
pop ac
push 6
push sp[-1]
push 6
push 0
mul
push 3
push 1
mul
add
push 2
add
push 9
add
pop ac
pop sb[ac]
pop ac
push 7
push sp[-1]
push 6
push 1
mul
push 3
push 0
mul
add
push 0
add
push 9
add
pop ac
pop sb[ac]
pop ac
push 8
push sp[-1]
push 6
push 1
mul
push 3
push 0
mul
add
push 1
add
push 9
add
pop ac
pop sb[ac]
pop ac
push 9
push sp[-1]
push 6
push 1
mul
push 3
push 0
mul
add
push 2
add
push 9
add
pop ac
pop sb[ac]
pop ac
push 10
push sp[-1]
push 6
push 1
mul
push 3
push 1
mul
add
push 0
add
push 9
add
pop ac
pop sb[ac]
pop ac
push 11
push sp[-1]
push 6
push 1
mul
push 3
push 1
mul
add
push 1
add
push 9
add
pop ac
pop sb[ac]
pop ac
push 12
push sp[-1]
push 6
push 1
mul
push 3
push 1
mul
add
push 2
add
push 9
add
pop ac
pop sb[ac]
pop ac
push 13
push sp[-1]
push 6
push 2
mul
push 3
push 0
mul
add
push 0
add
push 9
add
pop ac
pop sb[ac]
pop ac
push 14
push sp[-1]
push 6
push 2
mul
push 3
push 0
mul
add
push 1
add
push 9
add
pop ac
pop sb[ac]
pop ac
push 15
push sp[-1]
push 6
push 2
mul
push 3
push 0
mul
add
push 2
add
push 9
add
pop ac
pop sb[ac]
pop ac
push 16
push sp[-1]
push 6
push 2
mul
push 3
push 1
mul
add
push 0
add
push 9
add
pop ac
pop sb[ac]
pop ac
push 17
push sp[-1]
push 6
push 2
mul
push 3
push 1
mul
add
push 1
add
push 9
add
pop ac
pop sb[ac]
pop ac
push 18
push sp[-1]
push 6
push 2
mul
push 3
push 1
mul
add
push 2
add
push 9
add
pop ac
pop sb[ac]
pop ac
push 0
push sp
push 2
add
pop sp
push "csis"
push sp[-1]
push 0
push 27
add
pop ac
pop sb[ac]
pop ac
push "0235"
push sp[-1]
push 1
push 27
add
pop ac
pop sb[ac]
pop ac
push "CT"
push sp[-1]
push 2
push 27
add
pop ac
pop sb[ac]
pop ac
push 0
push sp
push 7
add
pop sp
push 0
push 30
add
pop ac
push 'I'
pop sb[ac]
push ac
push 1
add
pop ac
push 'l'
pop sb[ac]
push ac
push 1
add
pop ac
push 'o'
pop sb[ac]
push ac
push 1
add
pop ac
push 'v'
pop sb[ac]
push ac
push 1
add
pop ac
push 'e'
pop sb[ac]
push ac
push 1
add
pop ac
push 'y'
pop sb[ac]
push ac
push 1
add
pop ac
push 'o'
pop sb[ac]
push ac
push 1
add
pop ac
push 'u'
pop sb[ac]
push ac
push 1
add
pop ac
push "a[1] is: "
puts_
push 1
push 0
add
pop ac
push sb[ac]
puti_
push ""
puts
push "b[2][0] is: "
puts_
push 2
push 2
mul
push 0
add
push 3
add
pop ac
push sb[ac]
puti_
push ""
puts
push "c[2][0][1] is: "
puts_
push 6
push 2
mul
push 3
push 0
mul
add
push 1
add
push 9
add
pop ac
push sb[ac]
puti_
push ""
puts
push "d[1] is: "
puts_
push 1
push 27
add
pop ac
push sb[ac]
puts_
push ""
puts
push "e is: "
puts_
push 30
pop ac
push 0
pop ac
L000: push ac
push 8
complt
j0 L001
push sb[ac]
putc_
push ac
push 1
add
pop ac
jmp L000
L001: push ""
puts
