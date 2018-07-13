import cocotb

from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer


@cocotb.test()
def basic_test(dut):
    
    dut.reset_n_i <= 0

    #start a clock
    cocotb.fork(Clock(dut.clk_i, 5000).start())

    yield RisingEdge(dut.clk_i)
    yield Timer(10000)
    dut.reset_n_i <= 1
    dut.step_i <= 1


    for i in range(1, 254, 5):

        yield RisingEdge(dut.dir_o)
        yield FallingEdge(dut.dir_o)

        dut.step_i <= i

        yield RisingEdge(dut.dir_o)
        yield FallingEdge(dut.dir_o)

