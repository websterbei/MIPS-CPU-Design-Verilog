#inverse = ['\tnot not{}(inverse_binary_input[{}], binary_input[{}]);'.format(i, i, i) for i in range(5)]
#print('\n'.join(inverse))

for i in range(32):
    bin = "{0:05b}".format(i)
    operands = []
    index = 0
    for ch in bin[::-1]:
        if ch=='0':
            operands.append('inverse_binary_input[{}]'.format(index))
        else:
            operands.append('binary_input[{}]'.format(index))
        index += 1
    print('\tand and{}(onehot_output[{}],{});'.format(i, i, ','.join(operands)))

