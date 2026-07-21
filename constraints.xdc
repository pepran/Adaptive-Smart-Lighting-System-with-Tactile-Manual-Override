# ============================================================================
# SMART LIGHTING SYSTEM - FINAL PIN CONSTRAINTS
# ============================================================================

# ----------------------------------------------------------------------------
# 1. System Clock (100 MHz)
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN Y9 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]

# ----------------------------------------------------------------------------
# 2. Controls: Reset & Mode Switch
# ----------------------------------------------------------------------------
# Reset on Left Push Button (BTNL)
set_property PACKAGE_PIN N15 [get_ports {rst}]
set_property IOSTANDARD LVCMOS33 [get_ports {rst}]

# Mode on Switch 0 (SW0) - Corrected from U14
set_property PACKAGE_PIN F22 [get_ports {mode}]
set_property IOSTANDARD LVCMOS33 [get_ports {mode}]

# ----------------------------------------------------------------------------
# 3. Pmod JA (Bottom Row) - Rotary Encoder Input
# ----------------------------------------------------------------------------
# rot_enc[1] = Encoder Pin A (JA Pin 7)
set_property PACKAGE_PIN AB11 [get_ports {rot_enc[1]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {rot_enc[1]}]

# rot_enc[0] = Encoder Pin B (JA Pin 8)
set_property PACKAGE_PIN AB10 [get_ports {rot_enc[0]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {rot_enc[0]}]

# ----------------------------------------------------------------------------
# 4. Pmod JB (Bottom Row) - ALS Sensor
# ----------------------------------------------------------------------------
# CS (JB Pin 7)
set_property PACKAGE_PIN V12 [get_ports {cs}]
set_property IOSTANDARD LVCMOS33 [get_ports {cs}]

# MISO (JB Pin 9)
set_property PACKAGE_PIN V9 [get_ports {miso}]
set_property IOSTANDARD LVCMOS33 [get_ports {miso}]

# SCLK (JB Pin 10)
set_property PACKAGE_PIN V8 [get_ports {sclk}]
set_property IOSTANDARD LVCMOS33 [get_ports {sclk}]

# ----------------------------------------------------------------------------
# 5. Pmod JC (Both Rows) - 8LD PWM LEDs
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN AB7 [get_ports {pmod_leds[0]}]
set_property PACKAGE_PIN AB6 [get_ports {pmod_leds[1]}]
set_property PACKAGE_PIN Y4  [get_ports {pmod_leds[2]}]
set_property PACKAGE_PIN AA4 [get_ports {pmod_leds[3]}]
set_property PACKAGE_PIN R6  [get_ports {pmod_leds[4]}]
set_property PACKAGE_PIN T6  [get_ports {pmod_leds[5]}]
set_property PACKAGE_PIN T4  [get_ports {pmod_leds[6]}]
set_property PACKAGE_PIN U4  [get_ports {pmod_leds[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {pmod_leds[*]}]

# ----------------------------------------------------------------------------
# 6. Onboard LEDs (Visualizing 'count_level')
# ----------------------------------------------------------------------------
set_property PACKAGE_PIN T22 [get_ports {count_level[0]}]
set_property PACKAGE_PIN T21 [get_ports {count_level[1]}]
set_property PACKAGE_PIN U22 [get_ports {count_level[2]}]
set_property PACKAGE_PIN U21 [get_ports {count_level[3]}]
set_property PACKAGE_PIN V22 [get_ports {count_level[4]}]
set_property PACKAGE_PIN W22 [get_ports {count_level[5]}]
set_property PACKAGE_PIN U19 [get_ports {count_level[6]}]
set_property PACKAGE_PIN U14 [get_ports {count_level[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {count_level[*]}]