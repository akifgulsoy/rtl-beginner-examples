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

echo "All RTL simulations passed."

