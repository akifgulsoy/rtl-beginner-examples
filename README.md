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
| 24 | Sequence detector | Using a Moore FSM to find overlapping `1011` bit patterns |
| 25 | Synchronous FIFO | Buffering data in first-in, first-out order with full and empty flags |
| 26 | UART transmitter | Serializing a byte as start, least-significant-bit-first data, and stop bits |
| 27 | UART receiver | Sampling a UART frame and reporting valid data or a bad stop bit |
| 28 | Single-port RAM | Storing words on clocked writes and reading the selected address asynchronously |
| 29 | Simple ALU | Selecting arithmetic, logic, and shift operations with a combinational case statement |
| 30 | Register file | Writing one register on a clock edge while reading two registers independently |
| 31 | Leading-zero counter | Finding the distance from the most-significant bit to the first one |
| 32 | Accumulator | Adding enabled input values into a running, clocked total |
| 33 | Parallel-to-serial register | Loading a word then shifting its least-significant bit out first |
| 34 | Serial-to-parallel register | Shifting least-significant-bit-first data into a completed word |
| 35 | Valid-ready register | Buffering one data word while applying backpressure to its source |
| 36 | Toggle event synchronizer | Transferring a one-cycle event safely between unrelated clock domains |
| 37 | Reset synchronizer | Asserting reset immediately while releasing it safely on clock edges |
| 38 | Request/acknowledgement synchronizer | Reliably transferring one event at a time between unrelated clock domains |
| 39 | Serial CRC-8 | Updating an error-detecting checksum one MSB-first bit at a time |
| 40 | Population counter | Counting the asserted bits in a word with a combinational loop |
| 41 | Linear-feedback shift register | Generating a repeatable pseudo-random sequence with XOR feedback |
| 42 | Gray-to-binary converter | Decoding a Gray-coded value with a cumulative XOR chain |
| 43 | Watchdog timer | Detecting a missing periodic service event after a fixed interval |
| 44 | Clock divider | Toggling a slower square wave after a programmable number of input-clock edges |
| 45 | Synchronous ROM | Reading fixed data on a clock edge to model a one-clock-latency memory |
| 46 | One-shot timer | Counting a requested delay then producing a one-clock completion pulse |
| 47 | Modulo counter | Counting through a configured maximum then wrapping back to zero |
| 48 | Pulse-width measurement | Counting the sampled high cycles of an input pulse and reporting when its width is ready |
| 49 | Sticky status register | Remembering hardware events until software clears their individual status bits |
| 50 | Hysteresis comparator | Holding an alert between separate assert and deassert thresholds to reject boundary noise |
| 51 | Majority voter | Selecting each output bit from the majority of three independent inputs |
| 52 | Signed saturating adder | Clamping signed addition to the representable range instead of wrapping on overflow |
| 53 | Ripple-carry adder | Chaining full adders to propagate a carry across a word |
| 54 | Carry-lookahead adder | Computing carries from generate and propagate terms in parallel |
| 55 | Carry-select adder | Precomputing upper-block sums for both carry values, then selecting one |
| 56 | Shift-and-add multiplier | Building an unsigned product from shifted partial sums |
| 57 | Unsigned divider | Forming quotient and remainder by restoring division while flagging a zero divisor |
| 58 | Binary-to-BCD converter | Converting a binary value to decimal-coded digits with shift-add-3 |

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
  24_sequence_detector/
  25_sync_fifo/
  26_uart_transmitter/
  27_uart_receiver/
  28_single_port_ram/
  29_simple_alu/
  30_register_file/
  31_leading_zero_counter/
  32_accumulator/
  33_parallel_to_serial/
  34_serial_to_parallel/
  35_valid_ready_register/
  36_toggle_event_synchronizer/
  37_reset_synchronizer/
  38_request_ack_synchronizer/
  39_crc8_serial/
  40_population_counter/
  41_lfsr/
  42_gray_to_binary/
  43_watchdog_timer/
  44_clock_divider/
  45_synchronous_rom/
  46_one_shot_timer/
  47_modulo_counter/
  48_pulse_width_measurement/
  49_sticky_status_register/
  50_hysteresis_comparator/
  51_majority_voter/
  52_signed_saturating_adder/
  53_ripple_carry_adder/
  54_carry_lookahead_adder/
  55_carry_select_adder/
  56_shift_add_multiplier/
  57_unsigned_divider/
  58_binary_to_bcd/
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
