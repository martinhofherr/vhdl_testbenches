import cocotb
from cocotb.monitors import Monitor
from cocotb.drivers import Driver
from cocotb.triggers import Timer, RisingEdge, FallingEdge
from cocotb.decorators import coroutine
from cocotb.binary import BinaryValue
from cocotb.regression import TestFactory
from cocotb.scoreboard import Scoreboard
from cocotb.result import TestFailure, TestSuccess


# Driver for the binary2bcd converter
# The driver puts a 8 Bit binary number on the data_i input. It has to
# wait until busy_o is '0' until it can start a new conversion by asserting
# start_i '1'
class Bin2BcdDriver(object):
	def __init__(self, clk, start, busy, data, generator):
		self._clk = clk
		self._start = start
		self._busy = busy
		self._data = data
		self._generator = generator
	
	def start(self):
		self._cr = cocotb.fork(self._cr_stim())
	
	def stop(self):
		self._cr.kill()
	
	@cocotb.coroutine	
	def _cr_stim(self):
		if self._generator is None:
			raise Exception("No generator provided for Bin2BcdDriver!")

		edge = RisingEdge(self._clk)

		while True:
			val = next(self._generator())
			self._data <= val
			self._start <= 1
			for _ in range(3):
				yield edge
			self._start <= 0
			yield FallingEdge(self._busy)

def number_gen():
	for i in range(0, 256):
		yield i

# ==============================================================================
@cocotb.coroutine
def clock_gen(signal):
    """Generate the clock signal."""
    while True:
        signal <= 0
        yield Timer(5000) # ps
        signal <= 1
        yield Timer(5000) # ps


#bin2bcd test class
class BIN2BCD_TB:
	def __init__(self, dut):
		self.dut = dut;
		
		#setup stimulus driver
		self.stim = Bin2BcdDriver(dut.clk_i, dut.start_i, dut.busy_o, dut.data_i, number_gen)

	def start(self):
		self.stim.start()
	
	def stop(self):
		self.stim.stop()

# ==============================================================================
@cocotb.coroutine
def run_test(dut):
    """Setup testbench and run a test."""
    cocotb.fork(clock_gen(dut.clk_i))
    tb = BIN2BCD_TB(dut)
    clkedge = RisingEdge(dut.clk_i)

    dut._log.debug("Started clock")

    # Apply random input data by input_gen via BitDriver for 100 clock cycle.
    tb.start()
    for i in range(100):
        yield clkedge

    # Stop generation of input data. One more clock cycle is needed to capture
    # the resulting output of the DUT.
    tb.stop()
    yield clkedge


# ==============================================================================
# Register test.
factory = TestFactory(run_test)
factory.generate_tests()
