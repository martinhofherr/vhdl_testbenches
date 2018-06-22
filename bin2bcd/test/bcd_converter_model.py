# This is the model that provides a conversion of integer numbers to
# binary BCD representation.

import math as m

def int2digits(num, ndigs):
    bcd = 0                        
    for i in range(ndigs, -1, -1):
        dig = num // pow(10,i)
        num = num - pow(10, i) * dig
        
        bcd = bcd + dig * pow(16, i)

    return bcd
