# simple VHDL rom generator. It generates a VHDL ROM file generated from
# a template specified on the command line

import math as m
import argparse

# generate a table conataining the sine values in the range [0, pi/2]
def generate_sintab(n_elements, data_width):
    vals = [m.sin(m.pi/2*i/(n_elements - 1)) for i in range(0, n_elements)]
    maxval = 2**data_width-1
    sintab = [int(i*maxval) for i in vals]
    return sintab

def generate_sinrom(n_elements, data_width, col_width, shift_spaces=0):
    hexdigits = m.ceil(data_width/4)
    
    sintab = generate_sintab(n_elements, data_width)
    romstr = " "*shift_spaces

    written = 0
    for v in sintab:
        romstr += 'x"{:0{}x}"'.format(v, hexdigits)
        
        written = written + 1
        if written < n_elements:
            if written % col_width == 0:
                romstr += ',\n' + ' '*shift_spaces
            else:
                romstr += ', '
    
    addr_width = m.ceil(m.log2(n_elements))

    parameters = {'addrwidth' : addr_width-1,
                  'datawidth' : data_width-1,
                  'elements'  : n_elements-1,
                  'datablock' : romstr}

    return parameters;

def load_template(filename):
    with open(filename, "r") as f:
        data = f.read()

        return data


def main():
    parser = argparse.ArgumentParser(description="Generate a sine romtable")
    
    #required params
    parser.add_argument('template', type=str,
        help="ROM template file")
    parser.add_argument('elements', type=int, 
        help="The number of elements the ROM will hold")
    parser.add_argument('bits', type=int,
        help="The bit width of the elements int the table")

    #optional
    parser.add_argument('--shift', type=int, default=0,
        help="Indent for table values")
    parser.add_argument('--cols', type=int, default=8,
        help="Number of columns in rom table")


    args = parser.parse_args()

    data = load_template(args.template)
    values = generate_sinrom(args.elements, args.bits, args.cols, args.shift) 
    print(data.format(**values))
    

if __name__ == "__main__":
    main()
