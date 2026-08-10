#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="${ROOT_DIR}/build"

mkdir -p "${BUILD_DIR}"

run_test() {
  local name="$1"
  local rtl_file="$2"
  local testbench_file="$3"
  local top_module="$4"
  local output_file="${BUILD_DIR}/${name}.out"

  echo "==> ${name}"
  iverilog -g2012 -Wall -s "${top_module}" \
    -o "${output_file}" \
    "${ROOT_DIR}/${rtl_file}" \
    "${ROOT_DIR}/${testbench_file}"
  vvp "${output_file}"
}

run_test "logic_gates" \
  "examples/01_logic_gates/logic_gates.sv" \
  "examples/01_logic_gates/tb_logic_gates.sv" \
  "tb_logic_gates"

run_test "mux2" \
  "examples/02_mux2/mux2.sv" \
  "examples/02_mux2/tb_mux2.sv" \
  "tb_mux2"

run_test "d_flip_flop" \
  "examples/03_d_flip_flop/d_flip_flop.sv" \
  "examples/03_d_flip_flop/tb_d_flip_flop.sv" \
  "tb_d_flip_flop"

run_test "counter" \
  "examples/04_counter/counter.sv" \
  "examples/04_counter/tb_counter.sv" \
  "tb_counter"

run_test "shift_register" \
  "examples/05_shift_register/shift_register.sv" \
  "examples/05_shift_register/tb_shift_register.sv" \
  "tb_shift_register"

run_test "traffic_light_fsm" \
  "examples/06_traffic_light_fsm/traffic_light_fsm.sv" \
  "examples/06_traffic_light_fsm/tb_traffic_light_fsm.sv" \
  "tb_traffic_light_fsm"

run_test "rising_edge_detector" \
  "examples/07_rising_edge_detector/rising_edge_detector.sv" \
  "examples/07_rising_edge_detector/tb_rising_edge_detector.sv" \
  "tb_rising_edge_detector"

run_test "two_flip_flop_synchronizer" \
  "examples/08_two_flip_flop_synchronizer/two_flip_flop_synchronizer.sv" \
  "examples/08_two_flip_flop_synchronizer/tb_two_flip_flop_synchronizer.sv" \
  "tb_two_flip_flop_synchronizer"

run_test "pulse_stretcher" \
  "examples/09_pulse_stretcher/pulse_stretcher.sv" \
  "examples/09_pulse_stretcher/tb_pulse_stretcher.sv" \
  "tb_pulse_stretcher"

run_test "clock_enable_generator" \
  "examples/10_clock_enable_generator/clock_enable_generator.sv" \
  "examples/10_clock_enable_generator/tb_clock_enable_generator.sv" \
  "tb_clock_enable_generator"

run_test "pwm_generator" \
  "examples/11_pwm_generator/pwm_generator.sv" \
  "examples/11_pwm_generator/tb_pwm_generator.sv" \
  "tb_pwm_generator"

run_test "priority_encoder" \
  "examples/12_priority_encoder/priority_encoder.sv" \
  "examples/12_priority_encoder/tb_priority_encoder.sv" \
  "tb_priority_encoder"

run_test "round_robin_arbiter" \
  "examples/13_round_robin_arbiter/round_robin_arbiter.sv" \
  "examples/13_round_robin_arbiter/tb_round_robin_arbiter.sv" \
  "tb_round_robin_arbiter"

run_test "input_debouncer" \
  "examples/14_input_debouncer/input_debouncer.sv" \
  "examples/14_input_debouncer/tb_input_debouncer.sv" \
  "tb_input_debouncer"

echo "All RTL simulations passed."
