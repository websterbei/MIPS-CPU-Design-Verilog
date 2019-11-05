print('module ThirtyTwoBitAdder(A,B,cin,S,cout);')
print('input [31:0] A,B;')
print('input cin;')
print('output [31:0] S;')
print('output cout;')
print('wire g0,g1,g2,g3,g4,g5,g6,g7,g8,g9,g10,g11,g12,g13,g14,g15,g16,g17,g18,g19,g20,g21,g22,g23,g24,g25,g26,g27,g28,g29,g30,g31,p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22,p23,p24,p25,p26,p27,p28,p29,p30,p31,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,c31;')
ginputs = ['g{}'.format(i) for i in range(-1, 32)]
gstring = ','.join(['.{}({})'.format(x,x) for x in ginputs])
pinputs = ['p{}'.format(i) for i in range(32)]
pstring = ','.join(['.{}({})'.format(x,x) for x in pinputs])
outputs = ['c{}'.format(i) for i in range(1,33)]
ostring = ','.join(['.{}({})'.format(x,x) for x in outputs])
print('ThirtyTwoBitCarryGenerator carryGenerator({},{},{});'.format(gstring,pstring,ostring))
for i in range(32):
	print('CarryLookaheadCell cell{}(.a(A[{}]), .b(B[{}]), .c(c{}), .s(S[{}]), .g(g{}), .p(p{}));'.format(i, i, i, i, i, i, i))
print('endmodule')
