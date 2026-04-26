# Watch Your Step 

A VGA-based side-scrolling game implemented in Verilog for the **Basys3 FPGA** development board. A player character rides a moving bar with randomly generated holes — press jump to avoid falling through. Collect coins for points, displayed live on the 7-segment display. Rendered at 640×480 over VGA.

---

## Hardware Requirements

| Component | Details |
|-----------|---------|
| FPGA Board | Basys3 |
| Development Tool | Xilinx Vivado (2019.x or later recommended) |
| Display | VGA monitor (640×480 @ 60 Hz) |
| Clock Input | 100 MHz onboard oscillator |

---

## Controls

| Input | Basys3 Button | Function |
|-------|--------------|----------|
| `btnC` | Center button | Start game |
| `btnU` | Up button | Jump |
| `btnD` | Down button | Additional input |
| `btnR` | Right button | Global reset |

---

## Outputs

| Signal | Interface | Description |
|--------|-----------|-------------|
| `Hsync` / `Vsync` | VGA connector | Horizontal and vertical sync |
| `vgaRed[3:0]` | VGA connector | 4-bit red channel |
| `vgaGreen[3:0]` | VGA connector | 4-bit green channel |
| `vgaBlue[3:0]` | VGA connector | 4-bit blue channel |
| `seg[6:0]` / `an[3:0]` | 7-segment display | Live score readout |

---

## Project Structure

```
watch-your-step-game/
├── Lab6.xpr                            # Vivado project file
├── Lab6.hw/                            # Hardware handoff files
├── Lab6.srcs/
│   └── sources_1/
│       └── new/
│           ├── top.v                   # Top-level module
│           ├── labVGA_clks.v           # Clock management (pixel clock + digit select)
│           ├── pixeladdress.v          # VGA pixel coordinate counters
│           ├── syncs.v                 # Hsync / Vsync signal generator
│           ├── rgb.v                   # Core game logic and pixel rendering
│           ├── bar.v                   # Bar/platform and player position
│           ├── holes.v                 # Random hole generation and scrolling
│           ├── coin.v                  # Coin spawning, scrolling, and collection
│           └── negedge.v              # Falling edge detector (button/signal util)
├── Basys3_Master.xdc                   # Pin constraint file for Basys3
└── test_lab6_sync.v                    # VGA sync & RGB testbench
```

---

## How to Play

1. Press **btnC** (center) to start the game.
2. A bar scrolls upward on the left side of the screen. The player character sits on the bar.
3. Holes appear randomly in the floor — **press btnU to jump** over them.
4. If the player falls through a hole, the player flashes to indicate the fall.
5. **Coins** scroll across the screen. Catch one to increment your score.
6. Your score is displayed live on the 7-segment display.

---

## Module Overview

### `top` — Top-Level

Wires all submodules together and connects to Basys3 I/O pins. Registers `Hsync` and `Vsync` through `FDRE` flip-flops before outputting to the VGA connector.

| Port | Direction | Description |
|------|-----------|-------------|
| `clkin` | Input | 100 MHz board clock |
| `btnU/C/D/L/R` | Input | Player controls and reset |
| `sw[15:0]` | Input | Slide switches |
| `seg[6:0]`, `an[3:0]`, `dp` | Output | 7-segment display |
| `led[15:0]` | Output | LEDs (unused) |
| `Hsync`, `Vsync` | Output | VGA sync (registered) |
| `vgaRed/Green/Blue[3:0]` | Output | VGA color channels |

---

### `labVGA_clks` — Clock Management

Generates a ~25 MHz pixel clock (`clk`) and digit select signal (`digsel`) from the 100 MHz board oscillator using an `MMCME2_ADV` and a chain of six `CB4CE_MXILINX` 4-bit counters.

---

### `pixeladdress` — Pixel Counter

Counts horizontal (`H`, 0–799) and vertical (`V`, 0–524) pixel positions each clock cycle to cover the full VGA frame including blanking intervals.

---

### `syncs` — Sync Signal Generator

Generates active-low `Hsync` and `Vsync` from H and V:
- `Hsync` is low when `H` is between 655–750
- `Vsync` is low when `V` is between 489–490

---

### `rgb` — Core Game Logic & Renderer

The heart of the game. Instantiates all game objects and computes the RGB color of every pixel each clock cycle based on object positions.

**What gets drawn:**
- **Walls** — white borders at the screen edges
- **Bar** — yellow/white bar at H=32–47, height driven by `bar`
- **Floor** — cyan/blue ground region (V=320–471), with holes cut out by `holes`
- **Player** — rectangle at H=64–79, flashes **red** when falling in a hole, **green** when safe
- **Coin** — small square that scrolls left, flashes when collected

**Also handles:**
- Game start/stop logic
- Flash timers for player and coin hit feedback
- Score counting via `negedges` (increments on coin collection)
- 7-segment display driving via `ringcounter`, `selector`, and `hex7seg`

---

### `bar` — Platform & Player Physics

Tracks two positions using `countUD16L` counters:
- **`Qbar`** — the bar height, which scrolls upward continuously
- **`Qplayer`** — the player's vertical position (starts at 152)

The player falls when positioned over a hole (based on `holeL`/`holeR`). Pressing `btnU` causes the player to jump upward when the bar is low enough. `sw[15]` modifies fall behaviour.

---

### `holes` — Random Hole Generation

Uses an `rng` module to generate random hole widths (41–71 pixels). Two `countUD16L` counters track the left and right edges of the hole, which scroll from right to left across the screen. A new hole is generated each time the previous one scrolls off screen.

---

### `coin` — Coin Spawning & Collection

Spawns a coin at a random vertical position (192–252) using `rng`. The coin scrolls leftward and collision-detection checks if it overlaps the player's position. On collection, outputs `freezeout` high to trigger score increment and a flash effect. A timer limits how long the collected state is held.

---

### `negedge` (module: `negedges`) — Falling Edge Detector

A two-stage FDRE pipeline that detects when a signal transitions from high to low. Used in `rgb` to trigger score increments precisely on the falling edge of the coin-collected signal.

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

The testbench `test_lab6_sync.v` validates VGA sync timing and RGB signal correctness.

### What it checks

- **Sync errors (`SERRORS`)** — compares `Hsync`/`Vsync` against the 640×480 @ 60 Hz reference
- **RGB errors (`RGBERRORS`)** — verifies RGB outputs are zero outside the active display region
- **BMP frame output** — saves a `frame_N.bmp` screenshot per simulated frame

### How to run

1. Add `test_lab6_sync.v` as a **Simulation Source** in Vivado
2. Click **Run Simulation → Run Behavioral Simulation**
3. Add `SERRORS` and `RGBERRORS` to the waveform viewer (under `GUT` and `RUT`)
4. Reset simulation time to 0, set step size to **17 ms**, step through frames
5. Check `oops` and `rgb_oops` transitions to locate timing issues

The `NUM_FRAMES` parameter (default: `3`) controls how many frames are simulated before stopping.

---

## VGA Timing Reference (640×480 @ 60 Hz)

| Parameter | Value |
|-----------|-------|
| Active pixels (H) | 640 |
| Active lines (V) | 480 |
| Total H per line | 800 |
| Total V per frame | 525 |
| Hsync pulse (H) | 655–750 |
| Vsync pulse (V) | 489–490 |
| Pixel clock | ~25 MHz |
