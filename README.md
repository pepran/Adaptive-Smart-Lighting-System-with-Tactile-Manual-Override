# Adaptive-Smart-Lighting-System-with-Tactile-Manual-Override

## Overview
This project is an FPGA-based smart lighting controller designed to maintain optimal room illumination. It features an **Auto** mode that dynamically adjusts LED brightness based on ambient light levels and a **Manual** mode controlled via a rotary encoder. The system is implemented on a ZedBoard and drives high-brightness LEDs.

## Hardware Components
- **ZedBoard** (Zynq 7000 xc7z020clg484 -1)
- **Pmod ALS** (Ambient Light Sensor)
- **Pmod ENC** (Rotary Encoder)
- **Pmod 8LD** (High Brightness LEDs)

## Features
- **Automatic Mode:** Uses SPI Mode 3 to read data from the ambient light sensor. The 12-bit ADC output is scaled to an 8-bit count to automatically dim or brighten the LEDs based on the room's lighting condition.
- **Manual Mode:** A rotary encoder allows tactile, precise brightness control. The FPGA hardware handles signal debouncing and direction detection (CW/CCW) to increment or decrement the brightness counter.
- **Flicker-Free PWM Control:** Operates using a 100 MHz system clock and a 256-cycle period, adjusting the LED duty cycle for smooth scaling that is invisible to the human eye.
- **Seamless Switching:** A hardware multiplexer switch easily toggles the data path between the automatic sensor and the manual encoder.

## Project Architecture (Core Modules)
1. **`smart_lighting_top`**: Top-level module that handles the mode multiplexer and routes signals between all peripheral drivers.
2. **`pmod_als_driver`**: A hardware SPI translator driven by a 3-phase state machine (IDLE, SHIFT, DONE) running on a downscaled 2 MHz clock.
3. **`rotary_encoder_driver`**: Reads the encoder's signals, processes them through internal flip-flops to eliminate noise, and tracks rotation direction.
4. **`pmod8LD_driver`**: A continuous PWM counter generating the required duty cycle signals for the Pmod 8LD module.

## Applications
- Maintains constant illumination for productivity and reduced eye strain.
- Minimizes unnecessary power consumption for household, industrial, or street lighting uses.
- Offers direct manual override for situations where automation is not preferred.
