# SPDX-License-Identifier: Apache-2.0

import os
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, FallingEdge, ReadOnly, RisingEdge, Timer


CMD_NOP = 0
CMD_LOAD_TARGET = 1
CMD_LOAD_CURRENT = 2
CMD_CONTROL = 3

CLK_PERIOD_NS = 100
SETTLE_NS = 40
GATE_LEVEL = os.getenv("GATES") == "yes"


def pack(cmd, data):
    return ((cmd & 0x3) << 6) | (data & 0x3F)


async def reset(dut):
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 3)
    dut.rst_n.value = 1
    await RisingEdge(dut.clk)
    await Timer(SETTLE_NS, unit="ns")
    await ReadOnly()
    if GATE_LEVEL:
        int(dut.uo_out.value)
        int(dut.uio_out.value)
        int(dut.uio_oe.value)
        return
    assert int(dut.uo_out.value) == 0x81
    assert int(dut.uio_out.value) == 0x00
    assert int(dut.uio_oe.value) == 0xFF


async def sample(dut, value):
    await FallingEdge(dut.clk)
    dut.ui_in.value = value
    await RisingEdge(dut.clk)
    await Timer(SETTLE_NS, unit="ns")
    await ReadOnly()
    return int(dut.uo_out.value), int(dut.uio_out.value)


async def wait_terminal(dut):
    for _ in range(16):
        uo, uio = await sample(dut, pack(CMD_NOP, 0))
        if (uo & 0x30) != 0:
            return uo, uio
    raise AssertionError("terminal state not reached")


async def run_case(dut, target, current, max_attempts):
    await sample(dut, pack(CMD_LOAD_TARGET, target))
    assert int(dut.uo_out.value) == 0x81
    assert int(dut.uio_out.value) == 0x00

    await sample(dut, pack(CMD_LOAD_CURRENT, current))
    assert int(dut.uo_out.value) == 0x81
    assert int(dut.uio_out.value) == 0x00

    uo, uio = await sample(dut, pack(CMD_CONTROL, (max_attempts << 2) | 1))
    assert uo == 0x41
    assert (uio & 0x0F) == 0x01

    return await wait_terminal(dut)


@cocotb.test()
async def test_up_verify_down_verify_timeout_and_clear(dut):
    clock = Clock(dut.clk, CLK_PERIOD_NS, unit="ns")
    cocotb.start_soon(clock.start())

    await reset(dut)
    if GATE_LEVEL:
        await sample(dut, pack(CMD_LOAD_TARGET, 5))
        await sample(dut, pack(CMD_LOAD_CURRENT, 2))
        await sample(dut, pack(CMD_CONTROL, (4 << 2) | 1))
        for _ in range(8):
            await sample(dut, pack(CMD_NOP, 0))
        return

    uo, uio = await run_case(dut, target=5, current=2, max_attempts=4)
    assert uo == 0xA3
    assert uio == 0x32

    await reset(dut)
    uo, uio = await run_case(dut, target=1, current=5, max_attempts=4)
    assert uo == 0xA3
    assert uio == 0x42

    await reset(dut)
    uo, uio = await run_case(dut, target=8, current=0, max_attempts=3)
    assert uo == 0xB0
    assert uio == 0x33

    uo, uio = await sample(dut, pack(CMD_CONTROL, 0x02))
    assert uo == 0x81
    assert uio == 0x00
