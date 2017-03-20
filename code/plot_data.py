import matplotlib.pyplot as plt
import numpy as np
import string

fidpath = '/home/peng/dataset'

fid1 = open(fidpath + '/deqing_flow/errorfile.txt', 'r')
fid2 = open(fidpath + '/brox_flow/errorfile.txt', 'r')
fid3 = open(fidpath + '/farnback_flow/errorfile.txt', 'r')
data1 = fid1.readlines()
data2 = fid2.readlines()
data3 = fid3.readlines()


def print_char(astring):
    for i in range(len(astring)):
        print(astring[i])


def construct_err(data):
    aae = []
    aepe = []
    for line in data:
        x, y = line.split(' ')
        aae.append(x)
        aepe.append(y[:-1])
    print(aae)
    print(aepe)
    return aae, aepe


aae1, aepe1 = construct_err(data1)
aae2, aepe2 = construct_err(data2)
aae3, aepe3 = construct_err(data3)


plt.figure(1)
plt.plot([x+1 for x in range(len(data1))], aae1)
plt.plot([x+1 for x in range(len(data2))], aae2)
plt.plot([x+1 for x in range(len(data3))], aae3)
plt.legend(['Deqing', 'Brox', 'Farnback'], loc='upper right')
plt.ylabel('AAE')
plt.xlabel('frames')

plt.figure(2)
plt.plot([x+1 for x in range(len(data1))], aepe1)
plt.plot([x+1 for x in range(len(data2))], aepe2)
plt.plot([x+1 for x in range(len(data3))], aepe3)
plt.legend(['Deqing', 'Brox', 'Farnback'], loc='upper right')
plt.ylabel('AEPE')
plt.xlabel('frames')

plt.show()