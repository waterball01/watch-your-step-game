# Watch Your Step 

A VGA-based game implemented in Verilog for the **Basys3 FPGA** development board, built with Xilinx Vivado. The design generates a 640×480 VGA signal and uses onboard buttons, switches, LEDs, and a 7-segment display to drive an interactive game.

---

## Hardware Requirements

| Component | Details |
|-----------|---------|
| FPGA Board | [Digilent Basys3](https://digilentinc.com/Products/Detail.cfm?NavPath=2,400,1232&Prod=BASYS3) (Artix-7 XC7A35T) |
| Development Tool | Xilinx Vivado (2019.x or later recommended) |
| Display | VGA monitor (640×480 @ 60 Hz) |
| Clock Input | 100 MHz onboard oscillator |

---

## Controls

| Input | Basys3 Button | Function |
|-------|--------------|----------|
| `btnC` | Center button | Start game |
| `btnU` | Up button | Jump |
| `btnR` | Right button | Global reset (`greset`) |
| `btnL` | Left button | Extra credit feature |
| `sw[15:0]` | Slide switches | Game configuration (default `16'h2300`) |

---

## Outputs

| Signal | Interface | Description |
|--------|-----------|-------------|
| `Hsync` / `Vsync` | VGA connector | Horizontal and vertical sync |
| `vgaRed[3:0]` | VGA connector | 4-bit red channel |
| `vgaGreen[3:0]` | VGA connector | 4-bit green channel |
| `vgaBlue[3:0]` | VGA connector | 4-bit blue channel |
| `seg[6:0]` / `dp` / `an[3:0]` | 7-segment display | Score or status readout |
| `led[15:0]` | Onboard LEDs | Game state indicators |

---

## Project Structure

```
watch-your-step-game/
├── Lab6.xpr                # Vivado project file
├── Lab6.hw/                # Hardware handoff files
├── Lab6.srcs/              # HDL source files and constraints
├── Basys3_Master.xdc       # Pin constraint file for Basys3
├── labVGA_clks.v           # Clock management module (pixel clock + digit select)
└── test_lab6_sync.v        # VGA sync & RGB testbench
```

---

## Module Overview

### `labVGA_clks` (Clock Management)

Generates the clocks needed by the rest of the design from the 100 MHz board oscillator.

| Port | Direction | Description |
|------|-----------|-------------|
| `clkin` | Input | 100 MHz board clock |
| `greset` | Input | Global reset (`btnR`) |
| `clk` | Output | Application/pixel clock (via BUFG) |
| `digsel` | Output | Digit select for 7-segment display multiplexing |

Internally uses:
- **`clk_wiz_0`** — wraps `MMCME2_ADV` to condition the 100 MHz input (VCO ×9.125, ÷36.5 → ~25 MHz)
- **`clkcntrl4`** — chains six `CB4CE_MXILINX` 4-bit ripple-enable counters to derive `clk` and `digsel`
- **`STARTUPE2`** — routes `greset` through the Artix-7 global set/reset primitive

### `lab6Top` (Top-Level Game Module)

The main game logic module instantiated by the testbench. Expected ports:

```verilog
lab6Top (
    .clkin,          // 100 MHz board clock
    .btnC,           // Start game
    .btnU,           // Jump
    .btnR,           // Global reset
    .btnL,           // Extra credit feature
    .sw[15:0],       // Switches
    .seg[6:0],       // 7-segment cathodes
    .dp,             // Decimal point
    .an[3:0],        // 7-segment anodes
    .led[15:0],      // LEDs
    .Hsync,          // VGA horizontal sync
    .Vsync,          // VGA vertical sync
    .vgaRed[3:0],
    .vgaGreen[3:0],
    .vgaBlue[3:0]
)
```

> ⚠️ **`lab6Top.v` is not yet committed to this repository** — see [What's Missing](#whats-missing) below.

---

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/waterball01/watch-your-step-game.git
cd watch-your-step-game
```

### 2. Open in Vivado

```
File → Open Project → Lab6.xpr
```

### 3. Run Synthesis & Implementation

In the Vivado Flow Navigator:

1. Click **Run Synthesis**
2. Click **Run Implementation**
3. Click **Generate Bitstream**

### 4. Program the Basys3

```
Open Hardware Manager → Open Target → Auto Connect → Program Device
```

Select the generated `.bit` file from `Lab6.runs/impl_1/`.

---

## Running Simulation

The testbench `test_lab6_sync.v` validates both VGA sync timing and RGB signal correctness.

### What it checks

- **Sync errors (`SERRORS`)** — compares your `Hsync`/`Vsync` against the 640×480 @ 60 Hz reference and counts mismatches
- **RGB errors (`RGBERRORS`)** — verifies all RGB outputs are zero outside the active display region
- **BMP frame output** — saves a `frame_N.bmp` image file per simulated frame for visual inspection

### How to run

1. Add `test_lab6_sync.v` as a **Simulation Source** in Vivado
2. Click **Run Simulation → Run Behavioral Simulation**
3. Add `SERRORS` and `RGBERRORS` to the waveform viewer (under `GUT` and `RUT`)
4. Reset simulation time to 0, set step size to **17 ms**, and step through frames
5. Check `oops` and `rgb_oops` signal transitions to locate any timing issues

The `NUM_FRAMES` parameter (default: `3`) controls how many frames are simulated before stopping.

---

## VGA Timing Reference (640×480 @ 60 Hz)

| Parameter | Value |
|-----------|-------|
| Active pixels (H) | 640 |
| Active lines (V) | 480 |
| Hsync pulse width | 96 pixels |
| Vsync pulse width | 2 lines |
| Pixel clock | ~25 MHz |

---
