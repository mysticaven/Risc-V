$ErrorActionPreference = "Stop"

$projectRoot = Join-Path $PSScriptRoot "riscv-cpu"
$rtlDirectory = Join-Path $projectRoot "rtl"
$testbenchDirectory = Join-Path $projectRoot "tb"
$buildDirectory = Join-Path $projectRoot "build"

New-Item -ItemType Directory -Path $buildDirectory -Force | Out-Null

$rtlSources = Get-ChildItem -Path $rtlDirectory -Filter "*.sv" |
    ForEach-Object { $_.FullName }

Write-Host "Compiling all RTL modules..."
& iverilog -g2012 -Wall -tnull @rtlSources
if ($LASTEXITCODE -ne 0) {
    throw "RTL compilation failed."
}

$testbenches = @("alu", "decoder", "pc", "regfile")

foreach ($name in $testbenches) {
    $rtlSource = Join-Path $rtlDirectory "$name.sv"
    $testbenchSource = Join-Path $testbenchDirectory "${name}_tb.sv"
    $outputFile = Join-Path $buildDirectory "${name}_tb.vvp"

    Write-Host "Compiling $name testbench..."
    & iverilog -g2012 -Wall -s "${name}_tb" -o $outputFile $rtlSource $testbenchSource
    if ($LASTEXITCODE -ne 0) {
        throw "$name testbench compilation failed."
    }

    Write-Host "Running $name testbench..."
    & vvp $outputFile
    if ($LASTEXITCODE -ne 0) {
        throw "$name simulation failed."
    }
}

Write-Host "All simulations completed. Review the displayed values; the current benches are not self-checking."