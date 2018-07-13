# Simple tests for an adder module
import cocotb
from cocotb.triggers import Timer
from cocotb.result import TestFailure
import random

@cocotb.test()
def multiply_basic_test(dut):
    yield Timer(5)
    A = 5
    B = 5
    dut.a_i = A
    dut.b_i = B
    yield Timer(5)
    if dut.prod_o != A*B:
        raise TestFailure("Multiplication result is incorrect! {} != {}".format(
            A*B, dut.prod_o))
    else:
        dut._log.info("OK!")


@cocotb.test()
def mulitply_random_test(dut):
    yield Timer(5)

    for i in range(100):
        A = random.randint(0, 255)
        B = random.randint(0, 255)

        dut.a_i = A
        dut.b_i = B

        yield Timer(5)
        
        if dut.prod_o != A*B:
            raise TestFailure("Multiplication result is incorrect! {} != {}".format(
                A*B, dut.prod_o))


@cocotb.test()
def multiply_full_test(dut):
    
    yield Timer(5)

    for A in range(255):
        for B in range(255):
            dut.a_i = A
            dut.b_i = B
                
            yield Timer(5)

            if dut.prod_o != A*B:
                raise TestFailure("Multiplication result is incorrect! {} != {}".format(
                    A*B, dut.prod_o))

