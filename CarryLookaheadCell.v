module CarryLookaheadCell(a,b,c,s,g,p);
input a,b,c;
output g,p,s;
and and0(g, a, b);
or or0(p, a, b);
xor xor0(s, a, b, c);
endmodule 