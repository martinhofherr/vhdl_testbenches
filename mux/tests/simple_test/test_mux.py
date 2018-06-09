# Simple tests for a multiplexer module
import cocotb
from cocotb.triggers import Timer
from cocotb.result import TestFailure


@cocotb.test()
def mux_basic_test(dut):
	yield Timer(2)

	data_input = "1010"
	dut.data_i = int(data_input, 2)

	for select in range(0,4):
		yield Timer(2)
		dut.sel_i = select
		yield Timer(2)
		dut._log.info("dut.sel_i = {} dut.data_o = {}".format(select, dut.data_o))
		if int(dut.data_o) != int(data_input[3-select]):
			raise TestFailure("with sel_i = {} data_o = {} but should be {}".format(select,
				dut.data_o, data_input[3-select]))
