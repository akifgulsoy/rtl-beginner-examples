$ErrorActionPreference = "Stop"

$rootDir = Split-Path -Parent $PSScriptRoot
$buildDir = Join-Path $rootDir "build"

New-Item -ItemType Directory -Force -Path $buildDir | Out-Null

$tests = @(
    @{
        Name = "logic_gates"
        Rtl = "examples/01_logic_gates/logic_gates.sv"
        Testbench = "examples/01_logic_gates/tb_logic_gates.sv"
        Top = "tb_logic_gates"
    },
    @{
        Name = "mux2"
        Rtl = "examples/02_mux2/mux2.sv"
        Testbench = "examples/02_mux2/tb_mux2.sv"
        Top = "tb_mux2"
    },
    @{
        Name = "d_flip_flop"
        Rtl = "examples/03_d_flip_flop/d_flip_flop.sv"
        Testbench = "examples/03_d_flip_flop/tb_d_flip_flop.sv"
        Top = "tb_d_flip_flop"
    },
    @{
        Name = "counter"
        Rtl = "examples/04_counter/counter.sv"
        Testbench = "examples/04_counter/tb_counter.sv"
        Top = "tb_counter"
    },
    @{
        Name = "shift_register"
        Rtl = "examples/05_shift_register/shift_register.sv"
        Testbench = "examples/05_shift_register/tb_shift_register.sv"
        Top = "tb_shift_register"
    },
    @{
        Name = "traffic_light_fsm"
        Rtl = "examples/06_traffic_light_fsm/traffic_light_fsm.sv"
        Testbench = "examples/06_traffic_light_fsm/tb_traffic_light_fsm.sv"
        Top = "tb_traffic_light_fsm"
    },
    @{
        Name = "rising_edge_detector"
        Rtl = "examples/07_rising_edge_detector/rising_edge_detector.sv"
        Testbench = "examples/07_rising_edge_detector/tb_rising_edge_detector.sv"
        Top = "tb_rising_edge_detector"
    },
    @{
        Name = "two_flip_flop_synchronizer"
        Rtl = "examples/08_two_flip_flop_synchronizer/two_flip_flop_synchronizer.sv"
        Testbench = "examples/08_two_flip_flop_synchronizer/tb_two_flip_flop_synchronizer.sv"
        Top = "tb_two_flip_flop_synchronizer"
    },
    @{
        Name = "pulse_stretcher"
        Rtl = "examples/09_pulse_stretcher/pulse_stretcher.sv"
        Testbench = "examples/09_pulse_stretcher/tb_pulse_stretcher.sv"
        Top = "tb_pulse_stretcher"
    },
    @{
        Name = "clock_enable_generator"
        Rtl = "examples/10_clock_enable_generator/clock_enable_generator.sv"
        Testbench = "examples/10_clock_enable_generator/tb_clock_enable_generator.sv"
        Top = "tb_clock_enable_generator"
    },
    @{
        Name = "pwm_generator"
        Rtl = "examples/11_pwm_generator/pwm_generator.sv"
        Testbench = "examples/11_pwm_generator/tb_pwm_generator.sv"
        Top = "tb_pwm_generator"
    },
    @{
        Name = "priority_encoder"
        Rtl = "examples/12_priority_encoder/priority_encoder.sv"
        Testbench = "examples/12_priority_encoder/tb_priority_encoder.sv"
        Top = "tb_priority_encoder"
    },
    @{
        Name = "round_robin_arbiter"
        Rtl = "examples/13_round_robin_arbiter/round_robin_arbiter.sv"
        Testbench = "examples/13_round_robin_arbiter/tb_round_robin_arbiter.sv"
        Top = "tb_round_robin_arbiter"
    },
    @{
        Name = "input_debouncer"
        Rtl = "examples/14_input_debouncer/input_debouncer.sv"
        Testbench = "examples/14_input_debouncer/tb_input_debouncer.sv"
        Top = "tb_input_debouncer"
    },
    @{
        Name = "saturating_counter"
        Rtl = "examples/15_saturating_counter/saturating_counter.sv"
        Testbench = "examples/15_saturating_counter/tb_saturating_counter.sv"
        Top = "tb_saturating_counter"
    },
    @{
        Name = "up_down_counter"
        Rtl = "examples/16_up_down_counter/up_down_counter.sv"
        Testbench = "examples/16_up_down_counter/tb_up_down_counter.sv"
        Top = "tb_up_down_counter"
    },
    @{
        Name = "binary_to_gray"
        Rtl = "examples/17_binary_to_gray/binary_to_gray.sv"
        Testbench = "examples/17_binary_to_gray/tb_binary_to_gray.sv"
        Top = "tb_binary_to_gray"
    },
    @{
        Name = "logical_shifter"
        Rtl = "examples/18_logical_shifter/logical_shifter.sv"
        Testbench = "examples/18_logical_shifter/tb_logical_shifter.sv"
        Top = "tb_logical_shifter"
    },
    @{
        Name = "arithmetic_right_shifter"
        Rtl = "examples/19_arithmetic_right_shifter/arithmetic_right_shifter.sv"
        Testbench = "examples/19_arithmetic_right_shifter/tb_arithmetic_right_shifter.sv"
        Top = "tb_arithmetic_right_shifter"
    },
    @{
        Name = "bit_rotator"
        Rtl = "examples/20_bit_rotator/bit_rotator.sv"
        Testbench = "examples/20_bit_rotator/tb_bit_rotator.sv"
        Top = "tb_bit_rotator"
    },
    @{
        Name = "parity_checker"
        Rtl = "examples/21_parity_checker/parity_checker.sv"
        Testbench = "examples/21_parity_checker/tb_parity_checker.sv"
        Top = "tb_parity_checker"
    }
)

foreach ($test in $tests) {
    Write-Host "==> $($test.Name)"

    $outputFile = Join-Path $buildDir "$($test.Name).out"
    & iverilog -g2012 -Wall -s $test.Top `
        -o $outputFile `
        (Join-Path $rootDir $test.Rtl) `
        (Join-Path $rootDir $test.Testbench)

    if ($LASTEXITCODE -ne 0) {
        throw "Compilation failed: $($test.Name)"
    }

    & vvp $outputFile

    if ($LASTEXITCODE -ne 0) {
        throw "Simulation failed: $($test.Name)"
    }
}

Write-Host "All RTL simulations passed."
