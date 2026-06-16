# Block diagram

```mermaid
flowchart LR
    Host["Host or demo board"] --> Cmd["ui_in command/data"]
    Cmd --> Decode["Command decode"]
    Decode --> Regs["target/current/attempt registers"]
    Regs --> FSM["write-verify FSM"]
    FSM --> Pulses["pulse_up / pulse_down events"]
    FSM --> Verify["verify_ok / fault"]
    FSM --> Public["public telemetry outputs"]
    Public --> UO["uo_out status bits"]
    Public --> UIO["uio_out attempt/state"]
```

Interpretation:

- The host loads symbolic state.
- The FSM does bounded control.
- The tile emits public events and status.
- A future memristive core would replace the symbolic current update with physical conductance update and sensing.
