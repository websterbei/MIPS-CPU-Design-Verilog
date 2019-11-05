ginputs = ['g{}'.format(i) for i in range(-1, 32)]
pinputs = ['p{}'.format(i) for i in range(32)]
outputs = ['c{}'.format(i) for i in range(1,33)]

ginputstring = ','.join(ginputs)
pinputstring = ','.join(pinputs)
outputstring = ','.join(outputs)

print('module ThirtyTwoBitCarryGenerator({},{},{});'.format(ginputstring,pinputstring, outputstring))

print('wire {};'.format(','.join(['w{}'.format(i) for i in range(528)])))
print('input {},{};'.format(pinputstring, ginputstring))
print('output {};'.format(outputstring))

topAndSet = []
for i in range(1, 33):
	andSet = []
	for j in range(i):
		curSet = []
		curSet.append('g{}'.format(i-j-2))
		for k in range(i-j-1, i):
			curSet.append('p{}'.format(k))
		andSet.append(curSet)
	topAndSet.append(andSet)

w = 0
ind = 0
for row in topAndSet:
	wireSet = []
	for entry in row:
		print('and and{}(w{},{});'.format(w,w,','.join(entry)))
		wireSet.append('w{}'.format(w))
		w+=1
	print('or or{}(c{},g{},{});'.format(ind, ind+1, ind, ','.join(wireSet)))
	ind+=1

print('endmodule')