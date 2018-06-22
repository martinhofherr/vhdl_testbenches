import cocotb
from cocotb.monitors import Monitor
from cocotb.drivers import Driver
from cocotb.triggers import Timer, RisingEdge, FallingEdge
from cocotb.decorators import coroutine
from cocotb.binary import BinaryValue
from cocotb.regression import TestFactory
from cocotb.scoreboard import Scoreboard
from cocotb.result import TestFailure, TestSuccess
import bcd_converter_model as bcdmodel


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
        self._callback = None

    def add_callback(self, callback):
        self._callback = callback
    
    def start(self):
        self._cr = cocotb.fork(self._cr_stim())
    
    def stop(self):
        self._cr.kill()
    
    @cocotb.coroutine   
    def _cr_stim(self):
        if self._generator is None:
            raise Exception("No generator provided for Bin2BcdDriver!")

        edge = RisingEdge(self._clk)

        val = self._generator() 

        while True:
            data = next(val)
            self._data <= data
            self._start <= 1
            for _ in range(3):
                yield edge
            self._start <= 0
            yield FallingEdge(self._busy)

            if self._callback is not None:
                self._callback(data)
            

# generator function used by Bin2BcdDriver to generate the input data.
def number_gen():
    i = 0;
    while True:
        yield i;
        i = (i+1) % 255

# Monitor class that collects bin2bcds output in an deque
class Bin2BcdMonitor(Monitor):
    def __init__(self, name, bcd_out, busy):
        self.name = name
        self._bcd_out = bcd_out
        self._busy = busy
        Monitor.__init__(self)
    

    @coroutine
    def _monitor_recv(self):
        busy_rising = RisingEdge(self._busy)
        busy_falling = FallingEdge(self._busy)

        while True:
            yield busy_rising
            yield busy_falling
            vec = self._bcd_out.value
            self._recv(vec)


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

        #setup output mointor that collects output of bin2bcd on falling edge of busy
        self.monitor = Bin2BcdMonitor("Bin2BcdMonitor", self.dut.bcd_o, self.dut.busy_o)

        #setup scoreboard to register and compare dut and model output
        self.expected_output = []
        #self.scoreboard = Scoreboard(dut)
        #self.scoreboard.add_interface(self.monitor, self.expected_output)

    
    # callback that is called from the Driver to add new expected output
    def append_input_data(self, data):
        bcd_vec = cocotb.binary.BinaryValue()
        bcd_vec.integer = bcdmodel.int2digits(data, 3)
        print("Appending expected ouput {} == {}".format(bcd_vec.integer, bcd_vec))
        self.expected_output.append(bcd_vec)

    def start(self):
        self.stim.add_callback(self.append_input_data)
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

    # Reset DUT
    dut.reset_i <= 1
    yield Timer(10)
    dut.reset_i <= 0
    yield Timer(10)

    # Apply random input data by input_gen via BitDriver for 100 clock cycle.
    tb.start()
    for i in range(10000):
        yield clkedge

    # Stop generation of input data. One more clock cycle is needed to capture
    # the resulting output of the DUT.
    tb.stop()
    yield clkedge


# ==============================================================================
# Register test.
factory = TestFactory(run_test)
factory.generate_tests()
