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
