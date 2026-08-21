# RTL Beginner Examples

Small, focused SystemVerilog examples for developers taking their first steps
in RTL design. Each example includes a self-checking testbench, so simulation
finishes with either a clear `PASS` message or an error.

## Examples

| # | Example | Main concept |
|---|---|---|
| 01 | Logic gates | Continuous assignments and combinational logic |
| 02 | 2-to-1 multiplexer | Parameters, vectors and conditional selection |
| 03 | D flip-flop | Clocked logic and asynchronous reset |
| 04 | Counter | Synchronous reset, enable and sequential state |
| 05 | Shift register | Moving serial data through registers |
| 06 | Traffic light FSM | State types, next-state logic and outputs |
| 07 | Rising-edge detector | Creating a one-clock pulse from a changing input |
| 08 | Two-flip-flop synchronizer | Safely sampling a single-bit signal from another clock domain |
| 09 | Pulse stretcher | Keeping a short event visible for a fixed number of clock cycles |
| 10 | Clock-enable generator | Creating a periodic one-clock enable without a derived clock |
| 11 | PWM generator | Creating a periodic digital waveform with an adjustable duty cycle |
| 12 | Priority encoder | Choosing the highest-priority active request |
| 13 | Round-robin arbiter | Rotating grant priority so persistent requests share access fairly |
| 14 | Input debouncer | Ignoring short input bounces until a level is stable |
| 15 | Saturating counter | Counting between fixed limits without wrapping around |
| 16 | Up/down counter | Counting in either direction with unsigned wrap-around |
| 17 | Binary-to-Gray converter | Encoding a binary value so adjacent counts change one bit |
| 18 | Logical shifter | Moving bits left or right by a variable amount while filling with zeros |
| 19 | Arithmetic right shifter | Shifting signed values right while preserving the sign bit |
| 20 | Bit rotator | Moving bits left or right while wrapping them around the word |
| 21 | Parity checker | Detecting a wrong even- or odd-parity bit with a reduction XOR |
| 22 | Magnitude comparator | Comparing two unsigned values as less than, equal to, or greater than |
| 23 | One-hot decoder | Selecting exactly one output from a binary index and enable |

## Repository Structure

```text
examples/
  01_logic_gates/
  02_mux2/
  03_d_flip_flop/
  04_counter/
  05_shift_register/
  06_traffic_light_fsm/
  07_rising_edge_detector/
  08_two_flip_flop_synchronizer/
  09_pulse_stretcher/
  10_clock_enable_generator/
  11_pwm_generator/
  12_priority_encoder/
  13_round_robin_arbiter/
  14_input_debouncer/
  15_saturating_counter/
  16_up_down_counter/
  17_binary_to_gray/
  18_logical_shifter/
  19_arithmetic_right_shifter/
  20_bit_rotator/
  21_parity_checker/
  22_magnitude_comparator/
  23_one_hot_decoder/
scripts/
  run_all.sh
  run_all.ps1
```

Every example directory contains:

- An RTL module with a `.sv` extension.
- A testbench whose name starts with `tb_`.
- Short comments describing the important behavior.

## Run All Simulations

Install [Icarus Verilog](https://steveicarus.github.io/iverilog/) and run:

### Linux or macOS

```bash
bash scripts/run_all.sh
```

### Windows PowerShell

```powershell
.\scripts\run_all.ps1
```

The same simulations run automatically on every push through GitHub Actions.

## Run One Example

```bash
mkdir -p build
iverilog -g2012 -s tb_counter \
  -o build/counter.out \
  examples/04_counter/counter.sv \
  examples/04_counter/tb_counter.sv
vvp build/counter.out
```

## Suggested Learning Path

1. Read the RTL module before opening its testbench.
2. Predict the output for each test case.
3. Run the simulation and compare the result.
4. Change a parameter such as `WIDTH`.
5. Add a new test before changing the RTL.

## Design Notes

- The examples use synthesizable RTL constructs.
- Testbenches use delays and system tasks only for simulation.
- Resets are intentionally varied so beginners can compare synchronous and
  asynchronous reset styles.
- The code favors readability over clever shortcuts.

## License

This project is available under the MIT License.
