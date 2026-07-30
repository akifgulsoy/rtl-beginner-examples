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
