--
-- Copyright 2019 International Business Machines
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- The patent license granted to you in Section 3 of the License, as applied
-- to the "Work," hereby includes implementations of the Work in physical form.
--
-- Unless required by applicable law or agreed to in writing, the reference design
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- The background Specification upon which this is based is managed by and available from
-- the OpenCAPI Consortium.  More information can be found at https://opencapi.org.
--

library ieee, ibm, work;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ibm.std_ulogic_support.all;
  use ibm.std_ulogic_function_support.all;
  use work.axi_pkg.all;

entity axi_regs_32_large is
  generic (
    -- Offset of register block
    offset : natural := 0;

    -- Reset and Initialization Values
    REG_00_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_01_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_02_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_03_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_04_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_05_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_06_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_07_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_08_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_09_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0A_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0B_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0C_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0D_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0E_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0F_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_10_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_11_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_12_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_13_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_14_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_15_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_16_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_17_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_18_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_19_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_1A_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_1B_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_1C_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_1D_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_1E_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_1F_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_20_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_21_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_22_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_23_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_24_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_25_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_26_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_27_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_28_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_29_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_2A_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_2B_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_2C_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_2D_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_2E_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_2F_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    --REG_30_RESET : std_ulogic_vector(31 downto 0) := x"00000000"; -- Used by exp interface
    --REG_31_RESET : std_ulogic_vector(31 downto 0) := x"00000000"; -- Used by exp interface
    --REG_32_RESET : std_ulogic_vector(31 downto 0) := x"00000000"; -- Used by exp interface
    REG_33_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_34_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_35_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_36_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_37_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_38_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_39_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_3A_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_3B_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_3C_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_3D_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_3E_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_3F_RESET : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_40_RESET : std_ulogic_vector(31 downto 0) := x"00000000";

    -- Scom Write Enable Masks
    REG_00_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_01_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_02_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_03_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_04_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_05_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_06_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_07_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_08_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_09_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_0A_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_0B_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_0C_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_0D_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_0E_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_0F_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_10_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_11_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_12_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_13_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_14_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_15_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_16_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_17_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_18_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_19_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_1A_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_1B_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_1C_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_1D_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_1E_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_1F_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_20_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_21_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_22_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_23_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_24_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_25_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_26_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_27_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_28_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_29_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_2A_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_2B_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_2C_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_2D_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_2E_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_2F_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    --REG_30_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF"; -- Used by exp interface
    --REG_31_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF"; -- Used by exp interface
    --REG_32_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF"; -- Used by exp interface
    REG_33_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_34_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_35_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_36_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_37_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_38_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_39_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_3A_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_3B_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_3C_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_3D_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_3E_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_3F_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";
    REG_40_WE_MASK : std_ulogic_vector(31 downto 0) := x"FFFFFFFF";

    -- Hardware Write Enable Masks
    REG_00_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_01_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_02_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_03_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_04_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_05_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_06_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_07_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_08_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_09_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0A_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0B_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0C_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0D_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0E_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0F_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_10_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_11_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_12_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_13_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_14_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_15_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_16_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_17_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_18_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_19_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_1A_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_1B_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_1C_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_1D_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_1E_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_1F_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_20_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_21_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_22_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_23_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_24_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_25_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_26_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_27_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_28_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_29_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_2A_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_2B_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_2C_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_2D_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_2E_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_2F_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    --REG_30_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000"; -- Used by exp interface
    --REG_31_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000"; -- Used by exp interface
    --REG_32_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000"; -- Used by exp interface
    REG_33_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_34_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_35_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_36_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_37_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_38_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_39_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_3A_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_3B_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_3C_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_3D_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_3E_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_3F_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_40_HWWE_MASK : std_ulogic_vector(31 downto 0) := x"00000000";

    -- Sticky Bit Masks
    REG_00_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_01_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_02_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_03_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_04_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_05_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_06_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_07_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_08_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_09_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0A_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0B_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0C_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0D_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0E_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_0F_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_10_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_11_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_12_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_13_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_14_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_15_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_16_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_17_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_18_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_19_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_1A_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_1B_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_1C_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_1D_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_1E_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_1F_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_20_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_21_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_22_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_23_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_24_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_25_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_26_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_27_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_28_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_29_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_2A_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_2B_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_2C_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_2D_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_2E_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_2F_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    --REG_30_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000"; -- Used by exp interface
    --REG_31_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000"; -- Used by exp interface
    --REG_32_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000"; -- Used by exp interface
    REG_33_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_34_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_35_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_36_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_37_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_38_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_39_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_3A_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_3B_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_3C_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_3D_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_3E_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_3F_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000";
    REG_40_STICKY_MASK : std_ulogic_vector(31 downto 0) := x"00000000"
    );

  port (
    -- AXI4-Lite
    s0_axi_aclk : in  std_ulogic;
    s0_axi_i    : in  t_AXI4_LITE_SLAVE_INPUT;
    s0_axi_o    : out t_AXI4_LITE_SLAVE_OUTPUT;

    -- Register Data
    reg_00_o : out std_ulogic_vector(31 downto 0);
    reg_01_o : out std_ulogic_vector(31 downto 0);
    reg_02_o : out std_ulogic_vector(31 downto 0);
    reg_03_o : out std_ulogic_vector(31 downto 0);
    reg_04_o : out std_ulogic_vector(31 downto 0);
    reg_05_o : out std_ulogic_vector(31 downto 0);
    reg_06_o : out std_ulogic_vector(31 downto 0);
    reg_07_o : out std_ulogic_vector(31 downto 0);
    reg_08_o : out std_ulogic_vector(31 downto 0);
    reg_09_o : out std_ulogic_vector(31 downto 0);
    reg_0A_o : out std_ulogic_vector(31 downto 0);
    reg_0B_o : out std_ulogic_vector(31 downto 0);
    reg_0C_o : out std_ulogic_vector(31 downto 0);
    reg_0D_o : out std_ulogic_vector(31 downto 0);
    reg_0E_o : out std_ulogic_vector(31 downto 0);
    reg_0F_o : out std_ulogic_vector(31 downto 0);
    reg_10_o : out std_ulogic_vector(31 downto 0);
    reg_11_o : out std_ulogic_vector(31 downto 0);
    reg_12_o : out std_ulogic_vector(31 downto 0);
    reg_13_o : out std_ulogic_vector(31 downto 0);
    reg_14_o : out std_ulogic_vector(31 downto 0);
    reg_15_o : out std_ulogic_vector(31 downto 0);
    reg_16_o : out std_ulogic_vector(31 downto 0);
    reg_17_o : out std_ulogic_vector(31 downto 0);
    reg_18_o : out std_ulogic_vector(31 downto 0);
    reg_19_o : out std_ulogic_vector(31 downto 0);
    reg_1A_o : out std_ulogic_vector(31 downto 0);
    reg_1B_o : out std_ulogic_vector(31 downto 0);
    reg_1C_o : out std_ulogic_vector(31 downto 0);
    reg_1D_o : out std_ulogic_vector(31 downto 0);
    reg_1E_o : out std_ulogic_vector(31 downto 0);
    reg_1F_o : out std_ulogic_vector(31 downto 0);
    reg_20_o : out std_ulogic_vector(31 downto 0);
    reg_21_o : out std_ulogic_vector(31 downto 0);
    reg_22_o : out std_ulogic_vector(31 downto 0);
    reg_23_o : out std_ulogic_vector(31 downto 0);
    reg_24_o : out std_ulogic_vector(31 downto 0);
    reg_25_o : out std_ulogic_vector(31 downto 0);
    reg_26_o : out std_ulogic_vector(31 downto 0);
    reg_27_o : out std_ulogic_vector(31 downto 0);
    reg_28_o : out std_ulogic_vector(31 downto 0);
    reg_29_o : out std_ulogic_vector(31 downto 0);
    reg_2A_o : out std_ulogic_vector(31 downto 0);
    reg_2B_o : out std_ulogic_vector(31 downto 0);
    reg_2C_o : out std_ulogic_vector(31 downto 0);
    reg_2D_o : out std_ulogic_vector(31 downto 0);
    reg_2E_o : out std_ulogic_vector(31 downto 0);
    reg_2F_o : out std_ulogic_vector(31 downto 0);
    --reg_30_o : out std_ulogic_vector(31 downto 0); -- Used by exp interface
    --reg_31_o : out std_ulogic_vector(31 downto 0); -- Used by exp interface
    --reg_32_o : out std_ulogic_vector(31 downto 0); -- Used by exp interface
    reg_33_o : out std_ulogic_vector(31 downto 0);
    reg_34_o : out std_ulogic_vector(31 downto 0);
    reg_35_o : out std_ulogic_vector(31 downto 0);
    reg_36_o : out std_ulogic_vector(31 downto 0);
    reg_37_o : out std_ulogic_vector(31 downto 0);
    reg_38_o : out std_ulogic_vector(31 downto 0);
    reg_39_o : out std_ulogic_vector(31 downto 0);
    reg_3A_o : out std_ulogic_vector(31 downto 0);
    reg_3B_o : out std_ulogic_vector(31 downto 0);
    reg_3C_o : out std_ulogic_vector(31 downto 0);
    reg_3D_o : out std_ulogic_vector(31 downto 0);
    reg_3E_o : out std_ulogic_vector(31 downto 0);
    reg_3F_o : out std_ulogic_vector(31 downto 0);
    reg_40_o : out std_ulogic_vector(31 downto 0);

    -- Expandable Register Interface
    -- Read Data
    exp_rd_valid      : out std_ulogic;
    exp_rd_address    : out std_ulogic_vector(31 downto 0);
    exp_rd_data       : in  std_ulogic_vector(31 downto 0);
    exp_rd_data_valid : in  std_ulogic;
    -- Write Data
    exp_wr_valid      : out std_ulogic;
    exp_wr_address    : out std_ulogic_vector(31 downto 0);
    exp_wr_data       : out std_ulogic_vector(31 downto 0);

    -- Hardware Write Update Values and Enables
    reg_00_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_01_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_02_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_03_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_04_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_05_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_06_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_07_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_08_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_09_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_0A_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_0B_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_0C_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_0D_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_0E_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_0F_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_10_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_11_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_12_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_13_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_14_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_15_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_16_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_17_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_18_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_19_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_1A_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_1B_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_1C_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_1D_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_1E_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_1F_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_20_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_21_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_22_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_23_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_24_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_25_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_26_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_27_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_28_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_29_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_2A_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_2B_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_2C_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_2D_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_2E_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_2F_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    --reg_30_update_i : in std_ulogic_vector(31 downto 0) := x"00000000"; -- Used by exp interface
    --reg_31_update_i : in std_ulogic_vector(31 downto 0) := x"00000000"; -- Used by exp interface
    --reg_32_update_i : in std_ulogic_vector(31 downto 0) := x"00000000"; -- Used by exp interface
    reg_33_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_34_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_35_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_36_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_37_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_38_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_39_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_3A_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_3B_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_3C_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_3D_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_3E_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_3F_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_40_update_i : in std_ulogic_vector(31 downto 0) := x"00000000";
    reg_00_hwwe_i   : in std_ulogic := '0';
    reg_01_hwwe_i   : in std_ulogic := '0';
    reg_02_hwwe_i   : in std_ulogic := '0';
    reg_03_hwwe_i   : in std_ulogic := '0';
    reg_04_hwwe_i   : in std_ulogic := '0';
    reg_05_hwwe_i   : in std_ulogic := '0';
    reg_06_hwwe_i   : in std_ulogic := '0';
    reg_07_hwwe_i   : in std_ulogic := '0';
    reg_08_hwwe_i   : in std_ulogic := '0';
    reg_09_hwwe_i   : in std_ulogic := '0';
    reg_0A_hwwe_i   : in std_ulogic := '0';
    reg_0B_hwwe_i   : in std_ulogic := '0';
    reg_0C_hwwe_i   : in std_ulogic := '0';
    reg_0D_hwwe_i   : in std_ulogic := '0';
    reg_0E_hwwe_i   : in std_ulogic := '0';
    reg_0F_hwwe_i   : in std_ulogic := '0';
    reg_10_hwwe_i   : in std_ulogic := '0';
    reg_11_hwwe_i   : in std_ulogic := '0';
    reg_12_hwwe_i   : in std_ulogic := '0';
    reg_13_hwwe_i   : in std_ulogic := '0';
    reg_14_hwwe_i   : in std_ulogic := '0';
    reg_15_hwwe_i   : in std_ulogic := '0';
    reg_16_hwwe_i   : in std_ulogic := '0';
    reg_17_hwwe_i   : in std_ulogic := '0';
    reg_18_hwwe_i   : in std_ulogic := '0';
    reg_19_hwwe_i   : in std_ulogic := '0';
    reg_1A_hwwe_i   : in std_ulogic := '0';
    reg_1B_hwwe_i   : in std_ulogic := '0';
    reg_1C_hwwe_i   : in std_ulogic := '0';
    reg_1D_hwwe_i   : in std_ulogic := '0';
    reg_1E_hwwe_i   : in std_ulogic := '0';
    reg_1F_hwwe_i   : in std_ulogic := '0';
    reg_20_hwwe_i   : in std_ulogic := '0';
    reg_21_hwwe_i   : in std_ulogic := '0';
    reg_22_hwwe_i   : in std_ulogic := '0';
    reg_23_hwwe_i   : in std_ulogic := '0';
    reg_24_hwwe_i   : in std_ulogic := '0';
    reg_25_hwwe_i   : in std_ulogic := '0';
    reg_26_hwwe_i   : in std_ulogic := '0';
    reg_27_hwwe_i   : in std_ulogic := '0';
    reg_28_hwwe_i   : in std_ulogic := '0';
    reg_29_hwwe_i   : in std_ulogic := '0';
    reg_2A_hwwe_i   : in std_ulogic := '0';
    reg_2B_hwwe_i   : in std_ulogic := '0';
    reg_2C_hwwe_i   : in std_ulogic := '0';
    reg_2D_hwwe_i   : in std_ulogic := '0';
    reg_2E_hwwe_i   : in std_ulogic := '0';
    reg_2F_hwwe_i   : in std_ulogic := '0';
    --reg_30_hwwe_i   : in std_ulogic := '0'; -- Used by exp interface
    --reg_31_hwwe_i   : in std_ulogic := '0'; -- Used by exp interface
    --reg_32_hwwe_i   : in std_ulogic := '0'; -- Used by exp interface
    reg_33_hwwe_i   : in std_ulogic := '0';
    reg_34_hwwe_i   : in std_ulogic := '0';
    reg_35_hwwe_i   : in std_ulogic := '0';
    reg_36_hwwe_i   : in std_ulogic := '0';
    reg_37_hwwe_i   : in std_ulogic := '0';
    reg_38_hwwe_i   : in std_ulogic := '0';
    reg_39_hwwe_i   : in std_ulogic := '0';
    reg_3A_hwwe_i   : in std_ulogic := '0';
    reg_3B_hwwe_i   : in std_ulogic := '0';
    reg_3C_hwwe_i   : in std_ulogic := '0';
    reg_3D_hwwe_i   : in std_ulogic := '0';
    reg_3E_hwwe_i   : in std_ulogic := '0';
    reg_3F_hwwe_i   : in std_ulogic := '0';
    reg_40_hwwe_i   : in std_ulogic := '0'
  );
end axi_regs_32_large;

architecture axi_regs_32_large of axi_regs_32_large is

  signal s0_axi_aresetn : std_ulogic;
  signal s0_axi_awvalid : std_ulogic;
  signal s0_axi_awready : std_ulogic;
  signal s0_axi_awaddr  : std_ulogic_vector(31 downto 0);
  signal s0_axi_awprot  : std_ulogic_vector(2 downto 0);
  signal s0_axi_wvalid  : std_ulogic;
  signal s0_axi_wready  : std_ulogic;
  signal s0_axi_wdata   : std_ulogic_vector(31 downto 0);
  signal s0_axi_wstrb   : std_ulogic_vector(3 downto 0);
  signal s0_axi_bvalid  : std_ulogic;
  signal s0_axi_bready  : std_ulogic;
  signal s0_axi_bresp   : std_ulogic_vector(1 downto 0);
  signal s0_axi_arvalid : std_ulogic;
  signal s0_axi_arready : std_ulogic;
  signal s0_axi_araddr  : std_ulogic_vector(31 downto 0);
  signal s0_axi_arprot  : std_ulogic_vector(2 downto 0);
  signal s0_axi_rvalid  : std_ulogic;
  signal s0_axi_rready  : std_ulogic;
  signal s0_axi_rdata   : std_ulogic_vector(31 downto 0);
  signal s0_axi_rresp   : std_ulogic_vector(1 downto 0);

  signal axi_rd_state_d     : std_ulogic_vector(3 downto 0);
  signal axi_rd_state_q     : std_ulogic_vector(3 downto 0);
  signal axi_rd_state_ns0_0 : std_ulogic;
  signal axi_rd_state_ns0_1 : std_ulogic;
  signal axi_rd_state_ns0_2 : std_ulogic;
  signal axi_rd_state_ns0_3 : std_ulogic;
  signal axi_rd_state_ns1_0 : std_ulogic;
  signal axi_rd_state_ns1_1 : std_ulogic;
  signal axi_rd_state_ns1_2 : std_ulogic;
  signal axi_rd_state_ns1_3 : std_ulogic;
  signal axi_rd_state_ns2_0 : std_ulogic;
  signal axi_rd_state_ns2_1 : std_ulogic;
  signal axi_rd_state_ns2_2 : std_ulogic;
  signal axi_rd_state_ns2_3 : std_ulogic;
  signal axi_rd_state_ns3_0 : std_ulogic;
  signal axi_rd_state_ns3_1 : std_ulogic;
  signal axi_rd_state_ns3_2 : std_ulogic;
  signal axi_rd_state_ns3_3 : std_ulogic;

  signal reg_rd_valid   : std_ulogic;
  signal reg_rd_addr_d  : std_ulogic_vector(31 downto 0);
  signal reg_rd_addr_q  : std_ulogic_vector(31 downto 0);

  signal axi_wr_state_d     : std_ulogic_vector(4 downto 0);
  signal axi_wr_state_q     : std_ulogic_vector(4 downto 0);
  signal axi_wr_state_ns0_0 : std_ulogic;
  signal axi_wr_state_ns0_1 : std_ulogic;
  signal axi_wr_state_ns0_2 : std_ulogic;
  signal axi_wr_state_ns0_3 : std_ulogic;
  signal axi_wr_state_ns0_4 : std_ulogic;
  signal axi_wr_state_ns1_0 : std_ulogic;
  signal axi_wr_state_ns1_1 : std_ulogic;
  signal axi_wr_state_ns1_2 : std_ulogic;
  signal axi_wr_state_ns1_3 : std_ulogic;
  signal axi_wr_state_ns1_4 : std_ulogic;
  signal axi_wr_state_ns2_0 : std_ulogic;
  signal axi_wr_state_ns2_1 : std_ulogic;
  signal axi_wr_state_ns2_2 : std_ulogic;
  signal axi_wr_state_ns2_3 : std_ulogic;
  signal axi_wr_state_ns2_4 : std_ulogic;
  signal axi_wr_state_ns3_0 : std_ulogic;
  signal axi_wr_state_ns3_1 : std_ulogic;
  signal axi_wr_state_ns3_2 : std_ulogic;
  signal axi_wr_state_ns3_3 : std_ulogic;
  signal axi_wr_state_ns3_4 : std_ulogic;
  signal axi_wr_state_ns4_0 : std_ulogic;
  signal axi_wr_state_ns4_1 : std_ulogic;
  signal axi_wr_state_ns4_2 : std_ulogic;
  signal axi_wr_state_ns4_3 : std_ulogic;
  signal axi_wr_state_ns4_4 : std_ulogic;

  signal reg_wr_valid   : std_ulogic;
  signal reg_wr_addr_d  : std_ulogic_vector(31 downto 0);
  signal reg_wr_addr_q  : std_ulogic_vector(31 downto 0);
  signal s0_axi_wdata_d : std_ulogic_vector(31 downto 0);
  signal s0_axi_wdata_q : std_ulogic_vector(31 downto 0);

  signal reg_00_d : std_ulogic_vector(31 downto 0);
  signal reg_01_d : std_ulogic_vector(31 downto 0);
  signal reg_02_d : std_ulogic_vector(31 downto 0);
  signal reg_03_d : std_ulogic_vector(31 downto 0);
  signal reg_04_d : std_ulogic_vector(31 downto 0);
  signal reg_05_d : std_ulogic_vector(31 downto 0);
  signal reg_06_d : std_ulogic_vector(31 downto 0);
  signal reg_07_d : std_ulogic_vector(31 downto 0);
  signal reg_08_d : std_ulogic_vector(31 downto 0);
  signal reg_09_d : std_ulogic_vector(31 downto 0);
  signal reg_0A_d : std_ulogic_vector(31 downto 0);
  signal reg_0B_d : std_ulogic_vector(31 downto 0);
  signal reg_0C_d : std_ulogic_vector(31 downto 0);
  signal reg_0D_d : std_ulogic_vector(31 downto 0);
  signal reg_0E_d : std_ulogic_vector(31 downto 0);
  signal reg_0F_d : std_ulogic_vector(31 downto 0);
  signal reg_00_q : std_ulogic_vector(31 downto 0) := REG_00_RESET;
  signal reg_01_q : std_ulogic_vector(31 downto 0) := REG_01_RESET;
  signal reg_02_q : std_ulogic_vector(31 downto 0) := REG_02_RESET;
  signal reg_03_q : std_ulogic_vector(31 downto 0) := REG_03_RESET;
  signal reg_04_q : std_ulogic_vector(31 downto 0) := REG_04_RESET;
  signal reg_05_q : std_ulogic_vector(31 downto 0) := REG_05_RESET;
  signal reg_06_q : std_ulogic_vector(31 downto 0) := REG_06_RESET;
  signal reg_07_q : std_ulogic_vector(31 downto 0) := REG_07_RESET;
  signal reg_08_q : std_ulogic_vector(31 downto 0) := REG_08_RESET;
  signal reg_09_q : std_ulogic_vector(31 downto 0) := REG_09_RESET;
  signal reg_0A_q : std_ulogic_vector(31 downto 0) := REG_0A_RESET;
  signal reg_0B_q : std_ulogic_vector(31 downto 0) := REG_0B_RESET;
  signal reg_0C_q : std_ulogic_vector(31 downto 0) := REG_0C_RESET;
  signal reg_0D_q : std_ulogic_vector(31 downto 0) := REG_0D_RESET;
  signal reg_0E_q : std_ulogic_vector(31 downto 0) := REG_0E_RESET;
  signal reg_0F_q : std_ulogic_vector(31 downto 0) := REG_0F_RESET;
  signal reg_10_d : std_ulogic_vector(31 downto 0);
  signal reg_11_d : std_ulogic_vector(31 downto 0);
  signal reg_12_d : std_ulogic_vector(31 downto 0);
  signal reg_13_d : std_ulogic_vector(31 downto 0);
  signal reg_14_d : std_ulogic_vector(31 downto 0);
  signal reg_15_d : std_ulogic_vector(31 downto 0);
  signal reg_16_d : std_ulogic_vector(31 downto 0);
  signal reg_17_d : std_ulogic_vector(31 downto 0);
  signal reg_18_d : std_ulogic_vector(31 downto 0);
  signal reg_19_d : std_ulogic_vector(31 downto 0);
  signal reg_1A_d : std_ulogic_vector(31 downto 0);
  signal reg_1B_d : std_ulogic_vector(31 downto 0);
  signal reg_1C_d : std_ulogic_vector(31 downto 0);
  signal reg_1D_d : std_ulogic_vector(31 downto 0);
  signal reg_1E_d : std_ulogic_vector(31 downto 0);
  signal reg_1F_d : std_ulogic_vector(31 downto 0);
  signal reg_10_q : std_ulogic_vector(31 downto 0) := REG_10_RESET;
  signal reg_11_q : std_ulogic_vector(31 downto 0) := REG_11_RESET;
  signal reg_12_q : std_ulogic_vector(31 downto 0) := REG_12_RESET;
  signal reg_13_q : std_ulogic_vector(31 downto 0) := REG_13_RESET;
  signal reg_14_q : std_ulogic_vector(31 downto 0) := REG_14_RESET;
  signal reg_15_q : std_ulogic_vector(31 downto 0) := REG_15_RESET;
  signal reg_16_q : std_ulogic_vector(31 downto 0) := REG_16_RESET;
  signal reg_17_q : std_ulogic_vector(31 downto 0) := REG_17_RESET;
  signal reg_18_q : std_ulogic_vector(31 downto 0) := REG_18_RESET;
  signal reg_19_q : std_ulogic_vector(31 downto 0) := REG_19_RESET;
  signal reg_1A_q : std_ulogic_vector(31 downto 0) := REG_1A_RESET;
  signal reg_1B_q : std_ulogic_vector(31 downto 0) := REG_1B_RESET;
  signal reg_1C_q : std_ulogic_vector(31 downto 0) := REG_1C_RESET;
  signal reg_1D_q : std_ulogic_vector(31 downto 0) := REG_1D_RESET;
  signal reg_1E_q : std_ulogic_vector(31 downto 0) := REG_1E_RESET;
  signal reg_1F_q : std_ulogic_vector(31 downto 0) := REG_1F_RESET;
  signal reg_20_d : std_ulogic_vector(31 downto 0);
  signal reg_21_d : std_ulogic_vector(31 downto 0);
  signal reg_22_d : std_ulogic_vector(31 downto 0);
  signal reg_23_d : std_ulogic_vector(31 downto 0);
  signal reg_24_d : std_ulogic_vector(31 downto 0);
  signal reg_25_d : std_ulogic_vector(31 downto 0);
  signal reg_26_d : std_ulogic_vector(31 downto 0);
  signal reg_27_d : std_ulogic_vector(31 downto 0);
  signal reg_28_d : std_ulogic_vector(31 downto 0);
  signal reg_29_d : std_ulogic_vector(31 downto 0);
  signal reg_2A_d : std_ulogic_vector(31 downto 0);
  signal reg_2B_d : std_ulogic_vector(31 downto 0);
  signal reg_2C_d : std_ulogic_vector(31 downto 0);
  signal reg_2D_d : std_ulogic_vector(31 downto 0);
  signal reg_2E_d : std_ulogic_vector(31 downto 0);
  signal reg_2F_d : std_ulogic_vector(31 downto 0);
  signal reg_20_q : std_ulogic_vector(31 downto 0) := REG_20_RESET;
  signal reg_21_q : std_ulogic_vector(31 downto 0) := REG_21_RESET;
  signal reg_22_q : std_ulogic_vector(31 downto 0) := REG_22_RESET;
  signal reg_23_q : std_ulogic_vector(31 downto 0) := REG_23_RESET;
  signal reg_24_q : std_ulogic_vector(31 downto 0) := REG_24_RESET;
  signal reg_25_q : std_ulogic_vector(31 downto 0) := REG_25_RESET;
  signal reg_26_q : std_ulogic_vector(31 downto 0) := REG_26_RESET;
  signal reg_27_q : std_ulogic_vector(31 downto 0) := REG_27_RESET;
  signal reg_28_q : std_ulogic_vector(31 downto 0) := REG_28_RESET;
  signal reg_29_q : std_ulogic_vector(31 downto 0) := REG_29_RESET;
  signal reg_2A_q : std_ulogic_vector(31 downto 0) := REG_2A_RESET;
  signal reg_2B_q : std_ulogic_vector(31 downto 0) := REG_2B_RESET;
  signal reg_2C_q : std_ulogic_vector(31 downto 0) := REG_2C_RESET;
  signal reg_2D_q : std_ulogic_vector(31 downto 0) := REG_2D_RESET;
  signal reg_2E_q : std_ulogic_vector(31 downto 0) := REG_2E_RESET;
  signal reg_2F_q : std_ulogic_vector(31 downto 0) := REG_2F_RESET;
  --signal reg_30_d : std_ulogic_vector(31 downto 0); -- Used by exp interface
  --signal reg_31_d : std_ulogic_vector(31 downto 0); -- Used by exp interface
  --signal reg_32_d : std_ulogic_vector(31 downto 0); -- Used by exp interface
  signal reg_33_d : std_ulogic_vector(31 downto 0);
  signal reg_34_d : std_ulogic_vector(31 downto 0);
  signal reg_35_d : std_ulogic_vector(31 downto 0);
  signal reg_36_d : std_ulogic_vector(31 downto 0);
  signal reg_37_d : std_ulogic_vector(31 downto 0);
  signal reg_38_d : std_ulogic_vector(31 downto 0);
  signal reg_39_d : std_ulogic_vector(31 downto 0);
  signal reg_3A_d : std_ulogic_vector(31 downto 0);
  signal reg_3B_d : std_ulogic_vector(31 downto 0);
  signal reg_3C_d : std_ulogic_vector(31 downto 0);
  signal reg_3D_d : std_ulogic_vector(31 downto 0);
  signal reg_3E_d : std_ulogic_vector(31 downto 0);
  signal reg_3F_d : std_ulogic_vector(31 downto 0);
  --signal reg_30_q : std_ulogic_vector(31 downto 0) := REG_30_RESET; -- Used by exp interface
  --signal reg_31_q : std_ulogic_vector(31 downto 0) := REG_31_RESET; -- Used by exp interface
  --signal reg_32_q : std_ulogic_vector(31 downto 0) := REG_32_RESET; -- Used by exp interface
  signal reg_33_q : std_ulogic_vector(31 downto 0) := REG_33_RESET;
  signal reg_34_q : std_ulogic_vector(31 downto 0) := REG_34_RESET;
  signal reg_35_q : std_ulogic_vector(31 downto 0) := REG_35_RESET;
  signal reg_36_q : std_ulogic_vector(31 downto 0) := REG_36_RESET;
  signal reg_37_q : std_ulogic_vector(31 downto 0) := REG_37_RESET;
  signal reg_38_q : std_ulogic_vector(31 downto 0) := REG_38_RESET;
  signal reg_39_q : std_ulogic_vector(31 downto 0) := REG_39_RESET;
  signal reg_3A_q : std_ulogic_vector(31 downto 0) := REG_3A_RESET;
  signal reg_3B_q : std_ulogic_vector(31 downto 0) := REG_3B_RESET;
  signal reg_3C_q : std_ulogic_vector(31 downto 0) := REG_3C_RESET;
  signal reg_3D_q : std_ulogic_vector(31 downto 0) := REG_3D_RESET;
  signal reg_3E_q : std_ulogic_vector(31 downto 0) := REG_3E_RESET;
  signal reg_3F_q : std_ulogic_vector(31 downto 0) := REG_3F_RESET;
  signal reg_40_d : std_ulogic_vector(31 downto 0);
  signal reg_40_q : std_ulogic_vector(31 downto 0) := REG_40_RESET;

  attribute keep                         : string;
  attribute mark_debug                   : string;
  attribute keep of axi_rd_state_q       : signal is "true";
  attribute mark_debug of axi_rd_state_q : signal is "true";
  attribute keep of axi_wr_state_q       : signal is "true";
  attribute mark_debug of axi_wr_state_q : signal is "true";

begin

  -----------------------------------------------------------------------------
  -- AXI4-Lite Record
  -----------------------------------------------------------------------------
  -- Global
  s0_axi_aresetn <= s0_axi_i.s0_axi_aresetn;

  -- Write Address Channel
  s0_axi_awvalid             <= s0_axi_i.s0_axi_awvalid;
  s0_axi_o.s0_axi_awready    <= s0_axi_awready;
  s0_axi_awaddr(31 downto 0) <= s0_axi_i.s0_axi_awaddr(31 downto 0);
  s0_axi_awprot(2 downto 0)  <= s0_axi_i.s0_axi_awprot(2 downto 0);

  -- Write Data Channel
  s0_axi_wvalid             <= s0_axi_i.s0_axi_wvalid;
  s0_axi_o.s0_axi_wready    <= s0_axi_wready;
  s0_axi_wdata(31 downto 0) <= s0_axi_i.s0_axi_wdata(31 downto 0);
  s0_axi_wstrb(3 downto 0)  <= s0_axi_i.s0_axi_wstrb(3 downto 0);

  -- Write Response Channel
  s0_axi_o.s0_axi_bvalid            <= s0_axi_bvalid;
  s0_axi_bready                     <= s0_axi_i.s0_axi_bready;
  s0_axi_o.s0_axi_bresp(1 downto 0) <= s0_axi_bresp(1 downto 0);

  -- Read Address Channel
  s0_axi_arvalid             <= s0_axi_i.s0_axi_arvalid;
  s0_axi_o.s0_axi_arready    <= s0_axi_arready;
  s0_axi_araddr(31 downto 0) <= s0_axi_i.s0_axi_araddr(31 downto 0);
  s0_axi_arprot(2 downto 0)  <= s0_axi_i.s0_axi_arprot(2 downto 0);

  -- Read Data Channel
  s0_axi_o.s0_axi_rvalid             <= s0_axi_rvalid;
  s0_axi_rready                      <= s0_axi_i.s0_axi_rready;
  s0_axi_o.s0_axi_rdata(31 downto 0) <= s0_axi_rdata(31 downto 0);
  s0_axi_o.s0_axi_rresp(1 downto 0)  <= s0_axi_rresp(1 downto 0);

  -----------------------------------------------------------------------------
  -- Expandable Register Interface
  -----------------------------------------------------------------------------
  -- Read Data
  exp_rd_valid   <= axi_rd_state_q(1);  -- pms one clock earlier
  exp_rd_address <= reg_rd_addr_q;
  -- Write Data
  exp_wr_valid   <= reg_wr_valid;
  exp_wr_address <= reg_wr_addr_q;
  exp_wr_data    <= s0_axi_wdata_q;

  -----------------------------------------------------------------------------
  -- Read Transaction State Machine
  -----------------------------------------------------------------------------
  -- AXI Control Inputs:  s0_axi_arvalid, s0_axi_rready
  -- AXI Control Outputs: s0_axi_arready, s0_axi_rvalid, s0_axi_rresp

  -- State 0 - Idle - 0x1
  axi_rd_state_ns0_0 <= axi_rd_state_q(0) and not s0_axi_arvalid;
  axi_rd_state_ns0_1 <= axi_rd_state_q(0) and     s0_axi_arvalid;
  axi_rd_state_ns0_2 <= axi_rd_state_q(0) and '0';
  axi_rd_state_ns0_3 <= axi_rd_state_q(0) and '0';

  -- State 1 - Received ARValid - 0x2
  axi_rd_state_ns1_0 <= axi_rd_state_q(1) and '0';
  axi_rd_state_ns1_1 <= axi_rd_state_q(1) and '0';
  axi_rd_state_ns1_2 <= axi_rd_state_q(1) and '1';
  axi_rd_state_ns1_3 <= axi_rd_state_q(1) and '0';

  -- State 2 - Wait for Data - 0x4
  axi_rd_state_ns2_0 <= axi_rd_state_q(2) and '0';
  axi_rd_state_ns2_1 <= axi_rd_state_q(2) and '0';
  axi_rd_state_ns2_2 <= axi_rd_state_q(2) and '0';
  axi_rd_state_ns2_3 <= axi_rd_state_q(2) and '1';

  -- State 3 - Send Data - 0x8
  axi_rd_state_ns3_0 <= axi_rd_state_q(3) and s0_axi_rready;
  axi_rd_state_ns3_1 <= axi_rd_state_q(3) and '0';
  axi_rd_state_ns3_2 <= axi_rd_state_q(3) and '0';
  axi_rd_state_ns3_3 <= axi_rd_state_q(3) and not s0_axi_rready;

  -- Control Outputs
  s0_axi_arready <= axi_rd_state_q(1);
  s0_axi_rvalid  <= axi_rd_state_q(3);
  s0_axi_rresp   <= "00";

  -- AXI Data Inputs:  s0_axi_araddr
  -- AXI Data Outputs: s0_axi_rdata
  -- Register Control: `reg_rd_valid, reg_rd_addr
  reg_rd_valid   <= axi_rd_state_q(2);
  reg_rd_addr_d  <= gate(reg_rd_addr_q                , not axi_rd_state_q(0)) or
                    gate(s0_axi_araddr and x"0003FFFF",     axi_rd_state_q(0));

  -- Next State
  axi_rd_state_d(0) <= axi_rd_state_ns0_0 or axi_rd_state_ns1_0 or axi_rd_state_ns2_0 or axi_rd_state_ns3_0;
  axi_rd_state_d(1) <= axi_rd_state_ns0_1 or axi_rd_state_ns1_1 or axi_rd_state_ns2_1 or axi_rd_state_ns3_1;
  axi_rd_state_d(2) <= axi_rd_state_ns0_2 or axi_rd_state_ns1_2 or axi_rd_state_ns2_2 or axi_rd_state_ns3_2;
  axi_rd_state_d(3) <= axi_rd_state_ns0_3 or axi_rd_state_ns1_3 or axi_rd_state_ns2_3 or axi_rd_state_ns3_3;

  -----------------------------------------------------------------------------
  -- Write Transaction State Machine
  -----------------------------------------------------------------------------
  -- AXI Control Inputs:  s0_axi_awvalid, s0_axi_wvalid, s0_axi_bready
  -- AXI Control Outputs: s0_axi_awready, s0_axi_wready, s0_axi_bvalid, s0_axi_bresp

  -- State 0 - Idle - 0x01
  axi_wr_state_ns0_0 <= axi_wr_state_q(0) and not s0_axi_awvalid;
  axi_wr_state_ns0_1 <= axi_wr_state_q(0) and     s0_axi_awvalid;
  axi_wr_state_ns0_2 <= axi_wr_state_q(0) and '0';
  axi_wr_state_ns0_3 <= axi_wr_state_q(0) and '0';
  axi_wr_state_ns0_4 <= axi_wr_state_q(0) and '0';

  -- State 1 - Received AWValid - 0x02
  axi_wr_state_ns1_0 <= axi_wr_state_q(1) and '0';
  axi_wr_state_ns1_1 <= axi_wr_state_q(1) and '0';
  axi_wr_state_ns1_2 <= axi_wr_state_q(1) and '1';
  axi_wr_state_ns1_3 <= axi_wr_state_q(1) and '0';
  axi_wr_state_ns1_4 <= axi_wr_state_q(1) and '0';

  -- State 2 - Wait for WValid - 0x04
  axi_wr_state_ns2_0 <= axi_wr_state_q(2) and '0';
  axi_wr_state_ns2_1 <= axi_wr_state_q(2) and '0';
  axi_wr_state_ns2_2 <= axi_wr_state_q(2) and not s0_axi_wvalid;
  axi_wr_state_ns2_3 <= axi_wr_state_q(2) and     s0_axi_wvalid;
  axi_wr_state_ns2_4 <= axi_wr_state_q(2) and '0';

  -- State 3 - Send Data - 0x08
  axi_wr_state_ns3_0 <= axi_wr_state_q(3) and '0';
  axi_wr_state_ns3_1 <= axi_wr_state_q(3) and '0';
  axi_wr_state_ns3_2 <= axi_wr_state_q(3) and '0';
  axi_wr_state_ns3_3 <= axi_wr_state_q(3) and '0';
  axi_wr_state_ns3_4 <= axi_wr_state_q(3) and '1';

  -- State 4 - Wait for BReady - 0x10
  axi_wr_state_ns4_0 <= axi_wr_state_q(4) and     s0_axi_bready;
  axi_wr_state_ns4_1 <= axi_wr_state_q(4) and '0';
  axi_wr_state_ns4_2 <= axi_wr_state_q(4) and '0';
  axi_wr_state_ns4_3 <= axi_wr_state_q(4) and '0';
  axi_wr_state_ns4_4 <= axi_wr_state_q(4) and not s0_axi_bready;

  -- Control Outputs
  s0_axi_awready <= axi_wr_state_q(1);
  s0_axi_wready  <= axi_wr_state_q(3);
  s0_axi_bvalid  <= axi_wr_state_q(4);
  s0_axi_bresp   <= "00";

  -- AXI Data Inputs:  s0_axi_awaddr
  -- AXI Data Outputs: None
  -- Register Control: reg_wr_valid, reg_wr_addr
  reg_wr_valid   <= axi_wr_state_q(3);
  reg_wr_addr_d  <= gate(reg_wr_addr_q                , not axi_wr_state_q(0)) or
                    gate(s0_axi_awaddr and x"0003FFFF",     axi_wr_state_q(0));

  -- Need to delay the write data so it's valid same cycle as reg_wr_valid
  s0_axi_wdata_d <= s0_axi_wdata;

  -- Next State
  axi_wr_state_d(0) <= axi_wr_state_ns0_0 or axi_wr_state_ns1_0 or axi_wr_state_ns2_0 or axi_wr_state_ns3_0 or axi_wr_state_ns4_0;
  axi_wr_state_d(1) <= axi_wr_state_ns0_1 or axi_wr_state_ns1_1 or axi_wr_state_ns2_1 or axi_wr_state_ns3_1 or axi_wr_state_ns4_1;
  axi_wr_state_d(2) <= axi_wr_state_ns0_2 or axi_wr_state_ns1_2 or axi_wr_state_ns2_2 or axi_wr_state_ns3_2 or axi_wr_state_ns4_2;
  axi_wr_state_d(3) <= axi_wr_state_ns0_3 or axi_wr_state_ns1_3 or axi_wr_state_ns2_3 or axi_wr_state_ns3_3 or axi_wr_state_ns4_3;
  axi_wr_state_d(4) <= axi_wr_state_ns0_4 or axi_wr_state_ns1_4 or axi_wr_state_ns2_4 or axi_wr_state_ns3_4 or axi_wr_state_ns4_4;

  -----------------------------------------------------------------------------
  -- Config Registers
  -----------------------------------------------------------------------------
  s0_axi_rdata(31 downto 0) <= gate(exp_rd_data(31 downto 0),      exp_rd_data_valid                                                                          ) or
                               gate(reg_00_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0000#, 32))) or
                               gate(reg_01_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0004#, 32))) or
                               gate(reg_02_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0008#, 32))) or
                               gate(reg_03_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#000C#, 32))) or
                               gate(reg_04_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0010#, 32))) or
                               gate(reg_05_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0014#, 32))) or
                               gate(reg_06_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0018#, 32))) or
                               gate(reg_07_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#001C#, 32))) or
                               gate(reg_08_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0020#, 32))) or
                               gate(reg_09_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0024#, 32))) or
                               gate(reg_0A_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0028#, 32))) or
                               gate(reg_0B_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#002C#, 32))) or
                               gate(reg_0C_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0030#, 32))) or
                               gate(reg_0D_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0034#, 32))) or
                               gate(reg_0E_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0038#, 32))) or
                               gate(reg_0F_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#003C#, 32))) or
                               gate(reg_10_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0040#, 32))) or
                               gate(reg_11_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0044#, 32))) or
                               gate(reg_12_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0048#, 32))) or
                               gate(reg_13_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#004C#, 32))) or
                               gate(reg_14_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0050#, 32))) or
                               gate(reg_15_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0054#, 32))) or
                               gate(reg_16_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0058#, 32))) or
                               gate(reg_17_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#005C#, 32))) or
                               gate(reg_18_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0060#, 32))) or
                               gate(reg_19_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0064#, 32))) or
                               gate(reg_1A_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0068#, 32))) or
                               gate(reg_1B_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#006C#, 32))) or
                               gate(reg_1C_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0070#, 32))) or
                               gate(reg_1D_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0074#, 32))) or
                               gate(reg_1E_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0078#, 32))) or
                               gate(reg_1F_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#007C#, 32))) or
                               gate(reg_20_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0080#, 32))) or
                               gate(reg_21_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0084#, 32))) or
                               gate(reg_22_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0088#, 32))) or
                               gate(reg_23_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#008C#, 32))) or
                               gate(reg_24_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0090#, 32))) or
                               gate(reg_25_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0094#, 32))) or
                               gate(reg_26_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0098#, 32))) or
                               gate(reg_27_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#009C#, 32))) or
                               gate(reg_28_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00A0#, 32))) or
                               gate(reg_29_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00A4#, 32))) or
                               gate(reg_2A_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00A8#, 32))) or
                               gate(reg_2B_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00AC#, 32))) or
                               gate(reg_2C_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00B0#, 32))) or
                               gate(reg_2D_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00B4#, 32))) or
                               gate(reg_2E_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00B8#, 32))) or
                               gate(reg_2F_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00BC#, 32))) or
                               --gate(reg_30_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00C0#, 32))) or -- Used by exp interface
                               --gate(reg_31_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00C4#, 32))) or -- Used by exp interface
                               --gate(reg_32_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00C8#, 32))) or -- Used by exp interface
                               gate(reg_33_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00CC#, 32))) or
                               gate(reg_34_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00D0#, 32))) or
                               gate(reg_35_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00D4#, 32))) or
                               gate(reg_36_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00D8#, 32))) or
                               gate(reg_37_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00DC#, 32))) or
                               gate(reg_38_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00E0#, 32))) or
                               gate(reg_39_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00E4#, 32))) or
                               gate(reg_3A_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00E8#, 32))) or
                               gate(reg_3B_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00EC#, 32))) or
                               gate(reg_3C_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00F0#, 32))) or
                               gate(reg_3D_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00F4#, 32))) or
                               gate(reg_3E_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00F8#, 32))) or
                               gate(reg_3F_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00FC#, 32))) or
                               gate(reg_40_q(31 downto 0),     not exp_rd_data_valid and reg_rd_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0100#, 32)));

  reg_00_d <= gate(reg_00_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0000#, 32))) and not reg_00_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_00_WE_MASK)   or (reg_00_q and not REG_00_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0000#, 32))) and not reg_00_hwwe_i) or
              gate((reg_00_update_i and REG_00_HWWE_MASK) or (reg_00_q and     (REG_00_STICKY_MASK or not REG_00_HWWE_MASK)),                                                                                                      reg_00_hwwe_i);
  reg_01_d <= gate(reg_01_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0004#, 32))) and not reg_01_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_01_WE_MASK)   or (reg_01_q and not REG_01_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0004#, 32))) and not reg_01_hwwe_i) or
              gate((reg_01_update_i and REG_01_HWWE_MASK) or (reg_01_q and     (REG_01_STICKY_MASK or not REG_01_HWWE_MASK)),                                                                                                      reg_01_hwwe_i);
  reg_02_d <= gate(reg_02_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0008#, 32))) and not reg_02_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_02_WE_MASK)   or (reg_02_q and not REG_02_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0008#, 32))) and not reg_02_hwwe_i) or
              gate((reg_02_update_i and REG_02_HWWE_MASK) or (reg_02_q and     (REG_02_STICKY_MASK or not REG_02_HWWE_MASK)),                                                                                                      reg_02_hwwe_i);
  reg_03_d <= gate(reg_03_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#000C#, 32))) and not reg_03_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_03_WE_MASK)   or (reg_03_q and not REG_03_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#000C#, 32))) and not reg_03_hwwe_i) or
              gate((reg_03_update_i and REG_03_HWWE_MASK) or (reg_03_q and     (REG_03_STICKY_MASK or not REG_03_HWWE_MASK)),                                                                                                      reg_03_hwwe_i);
  reg_04_d <= gate(reg_04_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0010#, 32))) and not reg_04_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_04_WE_MASK)   or (reg_04_q and not REG_04_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0010#, 32))) and not reg_04_hwwe_i) or
              gate((reg_04_update_i and REG_04_HWWE_MASK) or (reg_04_q and     (REG_04_STICKY_MASK or not REG_04_HWWE_MASK)),                                                                                                      reg_04_hwwe_i);
  reg_05_d <= gate(reg_05_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0014#, 32))) and not reg_05_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_05_WE_MASK)   or (reg_05_q and not REG_05_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0014#, 32))) and not reg_05_hwwe_i) or
              gate((reg_05_update_i and REG_05_HWWE_MASK) or (reg_05_q and     (REG_05_STICKY_MASK or not REG_05_HWWE_MASK)),                                                                                                      reg_05_hwwe_i);
  reg_06_d <= gate(reg_06_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0018#, 32))) and not reg_06_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_06_WE_MASK)   or (reg_06_q and not REG_06_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0018#, 32))) and not reg_06_hwwe_i) or
              gate((reg_06_update_i and REG_06_HWWE_MASK) or (reg_06_q and     (REG_06_STICKY_MASK or not REG_06_HWWE_MASK)),                                                                                                      reg_06_hwwe_i);
  reg_07_d <= gate(reg_07_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#001C#, 32))) and not reg_07_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_07_WE_MASK)   or (reg_07_q and not REG_07_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#001C#, 32))) and not reg_07_hwwe_i) or
              gate((reg_07_update_i and REG_07_HWWE_MASK) or (reg_07_q and     (REG_07_STICKY_MASK or not REG_07_HWWE_MASK)),                                                                                                      reg_07_hwwe_i);
  reg_08_d <= gate(reg_08_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0020#, 32))) and not reg_08_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_08_WE_MASK)   or (reg_08_q and not REG_08_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0020#, 32))) and not reg_08_hwwe_i) or
              gate((reg_08_update_i and REG_08_HWWE_MASK) or (reg_08_q and     (REG_08_STICKY_MASK or not REG_08_HWWE_MASK)),                                                                                                      reg_08_hwwe_i);
  reg_09_d <= gate(reg_09_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0024#, 32))) and not reg_09_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_09_WE_MASK)   or (reg_09_q and not REG_09_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0024#, 32))) and not reg_09_hwwe_i) or
              gate((reg_09_update_i and REG_09_HWWE_MASK) or (reg_09_q and     (REG_09_STICKY_MASK or not REG_09_HWWE_MASK)),                                                                                                      reg_09_hwwe_i);
  reg_0A_d <= gate(reg_0A_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0028#, 32))) and not reg_0A_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_0A_WE_MASK)   or (reg_0A_q and not REG_0A_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0028#, 32))) and not reg_0A_hwwe_i) or
              gate((reg_0A_update_i and REG_0A_HWWE_MASK) or (reg_0A_q and     (REG_0A_STICKY_MASK or not REG_0A_HWWE_MASK)),                                                                                                      reg_0A_hwwe_i);
  reg_0B_d <= gate(reg_0B_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#002C#, 32))) and not reg_0B_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_0B_WE_MASK)   or (reg_0B_q and not REG_0B_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#002C#, 32))) and not reg_0B_hwwe_i) or
              gate((reg_0B_update_i and REG_0B_HWWE_MASK) or (reg_0B_q and     (REG_0B_STICKY_MASK or not REG_0B_HWWE_MASK)),                                                                                                      reg_0B_hwwe_i);
  reg_0C_d <= gate(reg_0C_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0030#, 32))) and not reg_0C_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_0C_WE_MASK)   or (reg_0C_q and not REG_0C_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0030#, 32))) and not reg_0C_hwwe_i) or
              gate((reg_0C_update_i and REG_0C_HWWE_MASK) or (reg_0C_q and     (REG_0C_STICKY_MASK or not REG_0C_HWWE_MASK)),                                                                                                      reg_0C_hwwe_i);
  reg_0D_d <= gate(reg_0D_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0034#, 32))) and not reg_0D_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_0D_WE_MASK)   or (reg_0D_q and not REG_0D_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0034#, 32))) and not reg_0D_hwwe_i) or
              gate((reg_0D_update_i and REG_0D_HWWE_MASK) or (reg_0D_q and     (REG_0D_STICKY_MASK or not REG_0D_HWWE_MASK)),                                                                                                      reg_0D_hwwe_i);
  reg_0E_d <= gate(reg_0E_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0038#, 32))) and not reg_0E_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_0E_WE_MASK)   or (reg_0E_q and not REG_0E_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0038#, 32))) and not reg_0E_hwwe_i) or
              gate((reg_0E_update_i and REG_0E_HWWE_MASK) or (reg_0E_q and     (REG_0E_STICKY_MASK or not REG_0E_HWWE_MASK)),                                                                                                      reg_0E_hwwe_i);
  reg_0F_d <= gate(reg_0F_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#003C#, 32))) and not reg_0F_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_0F_WE_MASK)   or (reg_0F_q and not REG_0F_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#003C#, 32))) and not reg_0F_hwwe_i) or
              gate((reg_0F_update_i and REG_0F_HWWE_MASK) or (reg_0F_q and     (REG_0F_STICKY_MASK or not REG_0F_HWWE_MASK)),                                                                                                      reg_0F_hwwe_i);
  reg_10_d <= gate(reg_10_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0040#, 32))) and not reg_10_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_10_WE_MASK)   or (reg_10_q and not REG_10_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0040#, 32))) and not reg_10_hwwe_i) or
              gate((reg_10_update_i and REG_10_HWWE_MASK) or (reg_10_q and     (REG_10_STICKY_MASK or not REG_10_HWWE_MASK)),                                                                                                      reg_10_hwwe_i);
  reg_11_d <= gate(reg_11_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0044#, 32))) and not reg_11_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_11_WE_MASK)   or (reg_11_q and not REG_11_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0044#, 32))) and not reg_11_hwwe_i) or
              gate((reg_11_update_i and REG_11_HWWE_MASK) or (reg_11_q and     (REG_11_STICKY_MASK or not REG_11_HWWE_MASK)),                                                                                                      reg_11_hwwe_i);
  reg_12_d <= gate(reg_12_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0048#, 32))) and not reg_12_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_12_WE_MASK)   or (reg_12_q and not REG_12_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0048#, 32))) and not reg_12_hwwe_i) or
              gate((reg_12_update_i and REG_12_HWWE_MASK) or (reg_12_q and     (REG_12_STICKY_MASK or not REG_12_HWWE_MASK)),                                                                                                      reg_12_hwwe_i);
  reg_13_d <= gate(reg_13_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#004C#, 32))) and not reg_13_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_13_WE_MASK)   or (reg_13_q and not REG_13_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#004C#, 32))) and not reg_13_hwwe_i) or
              gate((reg_13_update_i and REG_13_HWWE_MASK) or (reg_13_q and     (REG_13_STICKY_MASK or not REG_13_HWWE_MASK)),                                                                                                      reg_13_hwwe_i);
  reg_14_d <= gate(reg_14_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0050#, 32))) and not reg_14_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_14_WE_MASK)   or (reg_14_q and not REG_14_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0050#, 32))) and not reg_14_hwwe_i) or
              gate((reg_14_update_i and REG_14_HWWE_MASK) or (reg_14_q and     (REG_14_STICKY_MASK or not REG_14_HWWE_MASK)),                                                                                                      reg_14_hwwe_i);
  reg_15_d <= gate(reg_15_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0054#, 32))) and not reg_15_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_15_WE_MASK)   or (reg_15_q and not REG_15_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0054#, 32))) and not reg_15_hwwe_i) or
              gate((reg_15_update_i and REG_15_HWWE_MASK) or (reg_15_q and     (REG_15_STICKY_MASK or not REG_15_HWWE_MASK)),                                                                                                      reg_15_hwwe_i);
  reg_16_d <= gate(reg_16_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0058#, 32))) and not reg_16_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_16_WE_MASK)   or (reg_16_q and not REG_16_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0058#, 32))) and not reg_16_hwwe_i) or
              gate((reg_16_update_i and REG_16_HWWE_MASK) or (reg_16_q and     (REG_16_STICKY_MASK or not REG_16_HWWE_MASK)),                                                                                                      reg_16_hwwe_i);
  reg_17_d <= gate(reg_17_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#005C#, 32))) and not reg_17_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_17_WE_MASK)   or (reg_17_q and not REG_17_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#005C#, 32))) and not reg_17_hwwe_i) or
              gate((reg_17_update_i and REG_17_HWWE_MASK) or (reg_17_q and     (REG_17_STICKY_MASK or not REG_17_HWWE_MASK)),                                                                                                      reg_17_hwwe_i);
  reg_18_d <= gate(reg_18_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0060#, 32))) and not reg_18_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_18_WE_MASK)   or (reg_18_q and not REG_18_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0060#, 32))) and not reg_18_hwwe_i) or
              gate((reg_18_update_i and REG_18_HWWE_MASK) or (reg_18_q and     (REG_18_STICKY_MASK or not REG_18_HWWE_MASK)),                                                                                                      reg_18_hwwe_i);
  reg_19_d <= gate(reg_19_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0064#, 32))) and not reg_19_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_19_WE_MASK)   or (reg_19_q and not REG_19_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0064#, 32))) and not reg_19_hwwe_i) or
              gate((reg_19_update_i and REG_19_HWWE_MASK) or (reg_19_q and     (REG_19_STICKY_MASK or not REG_19_HWWE_MASK)),                                                                                                      reg_19_hwwe_i);
  reg_1A_d <= gate(reg_1A_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0068#, 32))) and not reg_1A_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_1A_WE_MASK)   or (reg_1A_q and not REG_1A_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0068#, 32))) and not reg_1A_hwwe_i) or
              gate((reg_1A_update_i and REG_1A_HWWE_MASK) or (reg_1A_q and     (REG_1A_STICKY_MASK or not REG_1A_HWWE_MASK)),                                                                                                      reg_1A_hwwe_i);
  reg_1B_d <= gate(reg_1B_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#006C#, 32))) and not reg_1B_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_1B_WE_MASK)   or (reg_1B_q and not REG_1B_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#006C#, 32))) and not reg_1B_hwwe_i) or
              gate((reg_1B_update_i and REG_1B_HWWE_MASK) or (reg_1B_q and     (REG_1B_STICKY_MASK or not REG_1B_HWWE_MASK)),                                                                                                      reg_1B_hwwe_i);
  reg_1C_d <= gate(reg_1C_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0070#, 32))) and not reg_1C_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_1C_WE_MASK)   or (reg_1C_q and not REG_1C_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0070#, 32))) and not reg_1C_hwwe_i) or
              gate((reg_1C_update_i and REG_1C_HWWE_MASK) or (reg_1C_q and     (REG_1C_STICKY_MASK or not REG_1C_HWWE_MASK)),                                                                                                      reg_1C_hwwe_i);
  reg_1D_d <= gate(reg_1D_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0074#, 32))) and not reg_1D_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_1D_WE_MASK)   or (reg_1D_q and not REG_1D_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0074#, 32))) and not reg_1D_hwwe_i) or
              gate((reg_1D_update_i and REG_1D_HWWE_MASK) or (reg_1D_q and     (REG_1D_STICKY_MASK or not REG_1D_HWWE_MASK)),                                                                                                      reg_1D_hwwe_i);
  reg_1E_d <= gate(reg_1E_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0078#, 32))) and not reg_1E_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_1E_WE_MASK)   or (reg_1E_q and not REG_1E_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0078#, 32))) and not reg_1E_hwwe_i) or
              gate((reg_1E_update_i and REG_1E_HWWE_MASK) or (reg_1E_q and     (REG_1E_STICKY_MASK or not REG_1E_HWWE_MASK)),                                                                                                      reg_1E_hwwe_i);
  reg_1F_d <= gate(reg_1F_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#007C#, 32))) and not reg_1F_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_1F_WE_MASK)   or (reg_1F_q and not REG_1F_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#007C#, 32))) and not reg_1F_hwwe_i) or
              gate((reg_1F_update_i and REG_1F_HWWE_MASK) or (reg_1F_q and     (REG_1F_STICKY_MASK or not REG_1F_HWWE_MASK)),                                                                                                      reg_1F_hwwe_i);
  reg_20_d <= gate(reg_20_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0080#, 32))) and not reg_20_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_20_WE_MASK)   or (reg_20_q and not REG_20_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0080#, 32))) and not reg_20_hwwe_i) or
              gate((reg_20_update_i and REG_20_HWWE_MASK) or (reg_20_q and     (REG_20_STICKY_MASK or not REG_20_HWWE_MASK)),                                                                                                      reg_20_hwwe_i);
  reg_21_d <= gate(reg_21_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0084#, 32))) and not reg_21_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_21_WE_MASK)   or (reg_21_q and not REG_21_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0084#, 32))) and not reg_21_hwwe_i) or
              gate((reg_21_update_i and REG_21_HWWE_MASK) or (reg_21_q and     (REG_21_STICKY_MASK or not REG_21_HWWE_MASK)),                                                                                                      reg_21_hwwe_i);
  reg_22_d <= gate(reg_22_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0088#, 32))) and not reg_22_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_22_WE_MASK)   or (reg_22_q and not REG_22_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0088#, 32))) and not reg_22_hwwe_i) or
              gate((reg_22_update_i and REG_22_HWWE_MASK) or (reg_22_q and     (REG_22_STICKY_MASK or not REG_22_HWWE_MASK)),                                                                                                      reg_22_hwwe_i);
  reg_23_d <= gate(reg_23_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#008C#, 32))) and not reg_23_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_23_WE_MASK)   or (reg_23_q and not REG_23_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#008C#, 32))) and not reg_23_hwwe_i) or
              gate((reg_23_update_i and REG_23_HWWE_MASK) or (reg_23_q and     (REG_23_STICKY_MASK or not REG_23_HWWE_MASK)),                                                                                                      reg_23_hwwe_i);
  reg_24_d <= gate(reg_24_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0090#, 32))) and not reg_24_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_24_WE_MASK)   or (reg_24_q and not REG_24_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0090#, 32))) and not reg_24_hwwe_i) or
              gate((reg_24_update_i and REG_24_HWWE_MASK) or (reg_24_q and     (REG_24_STICKY_MASK or not REG_24_HWWE_MASK)),                                                                                                      reg_24_hwwe_i);
  reg_25_d <= gate(reg_25_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0094#, 32))) and not reg_25_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_25_WE_MASK)   or (reg_25_q and not REG_25_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0094#, 32))) and not reg_25_hwwe_i) or
              gate((reg_25_update_i and REG_25_HWWE_MASK) or (reg_25_q and     (REG_25_STICKY_MASK or not REG_25_HWWE_MASK)),                                                                                                      reg_25_hwwe_i);
  reg_26_d <= gate(reg_26_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0098#, 32))) and not reg_26_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_26_WE_MASK)   or (reg_26_q and not REG_26_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0098#, 32))) and not reg_26_hwwe_i) or
              gate((reg_26_update_i and REG_26_HWWE_MASK) or (reg_26_q and     (REG_26_STICKY_MASK or not REG_26_HWWE_MASK)),                                                                                                      reg_26_hwwe_i);
  reg_27_d <= gate(reg_27_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#009C#, 32))) and not reg_27_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_27_WE_MASK)   or (reg_27_q and not REG_27_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#009C#, 32))) and not reg_27_hwwe_i) or
              gate((reg_27_update_i and REG_27_HWWE_MASK) or (reg_27_q and     (REG_27_STICKY_MASK or not REG_27_HWWE_MASK)),                                                                                                      reg_27_hwwe_i);
  reg_28_d <= gate(reg_28_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00A0#, 32))) and not reg_28_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_28_WE_MASK)   or (reg_28_q and not REG_28_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00A0#, 32))) and not reg_28_hwwe_i) or
              gate((reg_28_update_i and REG_28_HWWE_MASK) or (reg_28_q and     (REG_28_STICKY_MASK or not REG_28_HWWE_MASK)),                                                                                                      reg_28_hwwe_i);
  reg_29_d <= gate(reg_29_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00A4#, 32))) and not reg_29_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_29_WE_MASK)   or (reg_29_q and not REG_29_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00A4#, 32))) and not reg_29_hwwe_i) or
              gate((reg_29_update_i and REG_29_HWWE_MASK) or (reg_29_q and     (REG_29_STICKY_MASK or not REG_29_HWWE_MASK)),                                                                                                      reg_29_hwwe_i);
  reg_2A_d <= gate(reg_2A_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00A8#, 32))) and not reg_2A_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_2A_WE_MASK)   or (reg_2A_q and not REG_2A_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00A8#, 32))) and not reg_2A_hwwe_i) or
              gate((reg_2A_update_i and REG_2A_HWWE_MASK) or (reg_2A_q and     (REG_2A_STICKY_MASK or not REG_2A_HWWE_MASK)),                                                                                                      reg_2A_hwwe_i);
  reg_2B_d <= gate(reg_2B_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00AC#, 32))) and not reg_2B_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_2B_WE_MASK)   or (reg_2B_q and not REG_2B_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00AC#, 32))) and not reg_2B_hwwe_i) or
              gate((reg_2B_update_i and REG_2B_HWWE_MASK) or (reg_2B_q and     (REG_2B_STICKY_MASK or not REG_2B_HWWE_MASK)),                                                                                                      reg_2B_hwwe_i);
  reg_2C_d <= gate(reg_2C_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00B0#, 32))) and not reg_2C_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_2C_WE_MASK)   or (reg_2C_q and not REG_2C_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00B0#, 32))) and not reg_2C_hwwe_i) or
              gate((reg_2C_update_i and REG_2C_HWWE_MASK) or (reg_2C_q and     (REG_2C_STICKY_MASK or not REG_2C_HWWE_MASK)),                                                                                                      reg_2C_hwwe_i);
  reg_2D_d <= gate(reg_2D_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00B4#, 32))) and not reg_2D_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_2D_WE_MASK)   or (reg_2D_q and not REG_2D_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00B4#, 32))) and not reg_2D_hwwe_i) or
              gate((reg_2D_update_i and REG_2D_HWWE_MASK) or (reg_2D_q and     (REG_2D_STICKY_MASK or not REG_2D_HWWE_MASK)),                                                                                                      reg_2D_hwwe_i);
  reg_2E_d <= gate(reg_2E_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00B8#, 32))) and not reg_2E_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_2E_WE_MASK)   or (reg_2E_q and not REG_2E_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00B8#, 32))) and not reg_2E_hwwe_i) or
              gate((reg_2E_update_i and REG_2E_HWWE_MASK) or (reg_2E_q and     (REG_2E_STICKY_MASK or not REG_2E_HWWE_MASK)),                                                                                                      reg_2E_hwwe_i);
  reg_2F_d <= gate(reg_2F_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00BC#, 32))) and not reg_2F_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_2F_WE_MASK)   or (reg_2F_q and not REG_2F_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00BC#, 32))) and not reg_2F_hwwe_i) or
              gate((reg_2F_update_i and REG_2F_HWWE_MASK) or (reg_2F_q and     (REG_2F_STICKY_MASK or not REG_2F_HWWE_MASK)),                                                                                                      reg_2F_hwwe_i);
  --reg_30_d <= gate(reg_30_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00C0#, 32))) and not reg_30_hwwe_i) or -- Used by exp interface
  --            gate((s0_axi_wdata_q  and REG_30_WE_MASK)   or (reg_30_q and not REG_30_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00C0#, 32))) and not reg_30_hwwe_i) or -- Used by exp interface
  --            gate((reg_30_update_i and REG_30_HWWE_MASK) or (reg_30_q and     (REG_30_STICKY_MASK or not REG_30_HWWE_MASK)),                                                                                                      reg_30_hwwe_i); -- Used by exp interface
  --reg_31_d <= gate(reg_31_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00C4#, 32))) and not reg_31_hwwe_i) or -- Used by exp interface
  --            gate((s0_axi_wdata_q  and REG_31_WE_MASK)   or (reg_31_q and not REG_31_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00C4#, 32))) and not reg_31_hwwe_i) or -- Used by exp interface
  --            gate((reg_31_update_i and REG_31_HWWE_MASK) or (reg_31_q and     (REG_31_STICKY_MASK or not REG_31_HWWE_MASK)),                                                                                                      reg_31_hwwe_i); -- Used by exp interface
  --reg_32_d <= gate(reg_32_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00C8#, 32))) and not reg_32_hwwe_i) or -- Used by exp interface
  --            gate((s0_axi_wdata_q  and REG_32_WE_MASK)   or (reg_32_q and not REG_32_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00C8#, 32))) and not reg_32_hwwe_i) or -- Used by exp interface
  --            gate((reg_32_update_i and REG_32_HWWE_MASK) or (reg_32_q and     (REG_32_STICKY_MASK or not REG_32_HWWE_MASK)),                                                                                                      reg_32_hwwe_i); -- Used by exp interface
  reg_33_d <= gate(reg_33_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00CC#, 32))) and not reg_33_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_33_WE_MASK)   or (reg_33_q and not REG_33_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00CC#, 32))) and not reg_33_hwwe_i) or
              gate((reg_33_update_i and REG_33_HWWE_MASK) or (reg_33_q and     (REG_33_STICKY_MASK or not REG_33_HWWE_MASK)),                                                                                                      reg_33_hwwe_i);
  reg_34_d <= gate(reg_34_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00D0#, 32))) and not reg_34_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_34_WE_MASK)   or (reg_34_q and not REG_34_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00D0#, 32))) and not reg_34_hwwe_i) or
              gate((reg_34_update_i and REG_34_HWWE_MASK) or (reg_34_q and     (REG_34_STICKY_MASK or not REG_34_HWWE_MASK)),                                                                                                      reg_34_hwwe_i);
  reg_35_d <= gate(reg_35_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00D4#, 32))) and not reg_35_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_35_WE_MASK)   or (reg_35_q and not REG_35_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00D4#, 32))) and not reg_35_hwwe_i) or
              gate((reg_35_update_i and REG_35_HWWE_MASK) or (reg_35_q and     (REG_35_STICKY_MASK or not REG_35_HWWE_MASK)),                                                                                                      reg_35_hwwe_i);
  reg_36_d <= gate(reg_36_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00D8#, 32))) and not reg_36_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_36_WE_MASK)   or (reg_36_q and not REG_36_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00D8#, 32))) and not reg_36_hwwe_i) or
              gate((reg_36_update_i and REG_36_HWWE_MASK) or (reg_36_q and     (REG_36_STICKY_MASK or not REG_36_HWWE_MASK)),                                                                                                      reg_36_hwwe_i);
  reg_37_d <= gate(reg_37_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00DC#, 32))) and not reg_37_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_37_WE_MASK)   or (reg_37_q and not REG_37_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00DC#, 32))) and not reg_37_hwwe_i) or
              gate((reg_37_update_i and REG_37_HWWE_MASK) or (reg_37_q and     (REG_37_STICKY_MASK or not REG_37_HWWE_MASK)),                                                                                                      reg_37_hwwe_i);
  reg_38_d <= gate(reg_38_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00E0#, 32))) and not reg_38_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_38_WE_MASK)   or (reg_38_q and not REG_38_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00E0#, 32))) and not reg_38_hwwe_i) or
              gate((reg_38_update_i and REG_38_HWWE_MASK) or (reg_38_q and     (REG_38_STICKY_MASK or not REG_38_HWWE_MASK)),                                                                                                      reg_38_hwwe_i);
  reg_39_d <= gate(reg_39_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00E4#, 32))) and not reg_39_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_39_WE_MASK)   or (reg_39_q and not REG_39_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00E4#, 32))) and not reg_39_hwwe_i) or
              gate((reg_39_update_i and REG_39_HWWE_MASK) or (reg_39_q and     (REG_39_STICKY_MASK or not REG_39_HWWE_MASK)),                                                                                                      reg_39_hwwe_i);
  reg_3A_d <= gate(reg_3A_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00E8#, 32))) and not reg_3A_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_3A_WE_MASK)   or (reg_3A_q and not REG_3A_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00E8#, 32))) and not reg_3A_hwwe_i) or
              gate((reg_3A_update_i and REG_3A_HWWE_MASK) or (reg_3A_q and     (REG_3A_STICKY_MASK or not REG_3A_HWWE_MASK)),                                                                                                      reg_3A_hwwe_i);
  reg_3B_d <= gate(reg_3B_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00EC#, 32))) and not reg_3B_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_3B_WE_MASK)   or (reg_3B_q and not REG_3B_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00EC#, 32))) and not reg_3B_hwwe_i) or
              gate((reg_3B_update_i and REG_3B_HWWE_MASK) or (reg_3B_q and     (REG_3B_STICKY_MASK or not REG_3B_HWWE_MASK)),                                                                                                      reg_3B_hwwe_i);
  reg_3C_d <= gate(reg_3C_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00F0#, 32))) and not reg_3C_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_3C_WE_MASK)   or (reg_3C_q and not REG_3C_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00F0#, 32))) and not reg_3C_hwwe_i) or
              gate((reg_3C_update_i and REG_3C_HWWE_MASK) or (reg_3C_q and     (REG_3C_STICKY_MASK or not REG_3C_HWWE_MASK)),                                                                                                      reg_3C_hwwe_i);
  reg_3D_d <= gate(reg_3D_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00F4#, 32))) and not reg_3D_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_3D_WE_MASK)   or (reg_3D_q and not REG_3D_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00F4#, 32))) and not reg_3D_hwwe_i) or
              gate((reg_3D_update_i and REG_3D_HWWE_MASK) or (reg_3D_q and     (REG_3D_STICKY_MASK or not REG_3D_HWWE_MASK)),                                                                                                      reg_3D_hwwe_i);
  reg_3E_d <= gate(reg_3E_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00F8#, 32))) and not reg_3E_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_3E_WE_MASK)   or (reg_3E_q and not REG_3E_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00F8#, 32))) and not reg_3E_hwwe_i) or
              gate((reg_3E_update_i and REG_3E_HWWE_MASK) or (reg_3E_q and     (REG_3E_STICKY_MASK or not REG_3E_HWWE_MASK)),                                                                                                      reg_3E_hwwe_i);
  reg_3F_d <= gate(reg_3F_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00FC#, 32))) and not reg_3F_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_3F_WE_MASK)   or (reg_3F_q and not REG_3F_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#00FC#, 32))) and not reg_3F_hwwe_i) or
              gate((reg_3F_update_i and REG_3F_HWWE_MASK) or (reg_3F_q and     (REG_3F_STICKY_MASK or not REG_3F_HWWE_MASK)),                                                                                                      reg_3F_hwwe_i);
  reg_40_d <= gate(reg_40_q,                                                                                                  not (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0100#, 32))) and not reg_40_hwwe_i) or
              gate((s0_axi_wdata_q  and REG_40_WE_MASK)   or (reg_40_q and not REG_40_WE_MASK),                                   (reg_wr_valid and reg_wr_addr_q = std_ulogic_vector(to_unsigned(offset + 16#0100#, 32))) and not reg_40_hwwe_i) or
              gate((reg_40_update_i and REG_40_HWWE_MASK) or (reg_40_q and     (REG_40_STICKY_MASK or not REG_40_HWWE_MASK)),                                                                                                      reg_40_hwwe_i);

  -- Outputs
  reg_00_o <= reg_00_q;
  reg_01_o <= reg_01_q;
  reg_02_o <= reg_02_q;
  reg_03_o <= reg_03_q;
  reg_04_o <= reg_04_q;
  reg_05_o <= reg_05_q;
  reg_06_o <= reg_06_q;
  reg_07_o <= reg_07_q;
  reg_08_o <= reg_08_q;
  reg_09_o <= reg_09_q;
  reg_0A_o <= reg_0A_q;
  reg_0B_o <= reg_0B_q;
  reg_0C_o <= reg_0C_q;
  reg_0D_o <= reg_0D_q;
  reg_0E_o <= reg_0E_q;
  reg_0F_o <= reg_0F_q;
  reg_10_o <= reg_10_q;
  reg_11_o <= reg_11_q;
  reg_12_o <= reg_12_q;
  reg_13_o <= reg_13_q;
  reg_14_o <= reg_14_q;
  reg_15_o <= reg_15_q;
  reg_16_o <= reg_16_q;
  reg_17_o <= reg_17_q;
  reg_18_o <= reg_18_q;
  reg_19_o <= reg_19_q;
  reg_1A_o <= reg_1A_q;
  reg_1B_o <= reg_1B_q;
  reg_1C_o <= reg_1C_q;
  reg_1D_o <= reg_1D_q;
  reg_1E_o <= reg_1E_q;
  reg_1F_o <= reg_1F_q;
  reg_20_o <= reg_20_q;
  reg_21_o <= reg_21_q;
  reg_22_o <= reg_22_q;
  reg_23_o <= reg_23_q;
  reg_24_o <= reg_24_q;
  reg_25_o <= reg_25_q;
  reg_26_o <= reg_26_q;
  reg_27_o <= reg_27_q;
  reg_28_o <= reg_28_q;
  reg_29_o <= reg_29_q;
  reg_2A_o <= reg_2A_q;
  reg_2B_o <= reg_2B_q;
  reg_2C_o <= reg_2C_q;
  reg_2D_o <= reg_2D_q;
  reg_2E_o <= reg_2E_q;
  reg_2F_o <= reg_2F_q;
  --reg_30_o <= reg_30_q; -- Used by exp interface
  --reg_31_o <= reg_31_q; -- Used by exp interface
  --reg_32_o <= reg_32_q; -- Used by exp interface
  reg_33_o <= reg_33_q;
  reg_34_o <= reg_34_q;
  reg_35_o <= reg_35_q;
  reg_36_o <= reg_36_q;
  reg_37_o <= reg_37_q;
  reg_38_o <= reg_38_q;
  reg_39_o <= reg_39_q;
  reg_3A_o <= reg_3A_q;
  reg_3B_o <= reg_3B_q;
  reg_3C_o <= reg_3C_q;
  reg_3D_o <= reg_3D_q;
  reg_3E_o <= reg_3E_q;
  reg_3F_o <= reg_3F_q;
  reg_40_o <= reg_40_q;

  -----------------------------------------------------------------------------
  -- Latches
  -----------------------------------------------------------------------------
  process (s0_axi_aclk) is
  begin
    if rising_edge(s0_axi_aclk) then
      if (s0_axi_aresetn = '0') then
        axi_rd_state_q <= "0001";
        reg_rd_addr_q  <= x"00000000";
        axi_wr_state_q <= "00001";
        reg_wr_addr_q  <= x"00000000";
        reg_00_q       <= REG_00_RESET;
        reg_01_q       <= REG_01_RESET;
        reg_02_q       <= REG_02_RESET;
        reg_03_q       <= REG_03_RESET;
        reg_04_q       <= REG_04_RESET;
        reg_05_q       <= REG_05_RESET;
        reg_06_q       <= REG_06_RESET;
        reg_07_q       <= REG_07_RESET;
        reg_08_q       <= REG_08_RESET;
        reg_09_q       <= REG_09_RESET;
        reg_0A_q       <= REG_0A_RESET;
        reg_0B_q       <= REG_0B_RESET;
        reg_0C_q       <= REG_0C_RESET;
        reg_0D_q       <= REG_0D_RESET;
        reg_0E_q       <= REG_0E_RESET;
        reg_0F_q       <= REG_0F_RESET;
        reg_10_q       <= REG_10_RESET;
        reg_11_q       <= REG_11_RESET;
        reg_12_q       <= REG_12_RESET;
        reg_13_q       <= REG_13_RESET;
        reg_14_q       <= REG_14_RESET;
        reg_15_q       <= REG_15_RESET;
        reg_16_q       <= REG_16_RESET;
        reg_17_q       <= REG_17_RESET;
        reg_18_q       <= REG_18_RESET;
        reg_19_q       <= REG_19_RESET;
        reg_1A_q       <= REG_1A_RESET;
        reg_1B_q       <= REG_1B_RESET;
        reg_1C_q       <= REG_1C_RESET;
        reg_1D_q       <= REG_1D_RESET;
        reg_1E_q       <= REG_1E_RESET;
        reg_1F_q       <= REG_1F_RESET;
        reg_20_q       <= REG_20_RESET;
        reg_21_q       <= REG_21_RESET;
        reg_22_q       <= REG_22_RESET;
        reg_23_q       <= REG_23_RESET;
        reg_24_q       <= REG_24_RESET;
        reg_25_q       <= REG_25_RESET;
        reg_26_q       <= REG_26_RESET;
        reg_27_q       <= REG_27_RESET;
        reg_28_q       <= REG_28_RESET;
        reg_29_q       <= REG_29_RESET;
        reg_2A_q       <= REG_2A_RESET;
        reg_2B_q       <= REG_2B_RESET;
        reg_2C_q       <= REG_2C_RESET;
        reg_2D_q       <= REG_2D_RESET;
        reg_2E_q       <= REG_2E_RESET;
        reg_2F_q       <= REG_2F_RESET;
        --reg_30_q       <= REG_30_RESET; -- Used by exp interface
        --reg_31_q       <= REG_31_RESET; -- Used by exp interface
        --reg_32_q       <= REG_32_RESET; -- Used by exp interface
        reg_33_q       <= REG_33_RESET;
        reg_34_q       <= REG_34_RESET;
        reg_35_q       <= REG_35_RESET;
        reg_36_q       <= REG_36_RESET;
        reg_37_q       <= REG_37_RESET;
        reg_38_q       <= REG_38_RESET;
        reg_39_q       <= REG_39_RESET;
        reg_3A_q       <= REG_3A_RESET;
        reg_3B_q       <= REG_3B_RESET;
        reg_3C_q       <= REG_3C_RESET;
        reg_3D_q       <= REG_3D_RESET;
        reg_3E_q       <= REG_3E_RESET;
        reg_3F_q       <= REG_3F_RESET;
        reg_40_q       <= REG_40_RESET;
        s0_axi_wdata_q <= x"00000000";
      else
        axi_rd_state_q <= axi_rd_state_d;
        reg_rd_addr_q  <= reg_rd_addr_d;
        axi_wr_state_q <= axi_wr_state_d;
        reg_wr_addr_q  <= reg_wr_addr_d;
        reg_00_q       <= reg_00_d;
        reg_01_q       <= reg_01_d;
        reg_02_q       <= reg_02_d;
        reg_03_q       <= reg_03_d;
        reg_04_q       <= reg_04_d;
        reg_05_q       <= reg_05_d;
        reg_06_q       <= reg_06_d;
        reg_07_q       <= reg_07_d;
        reg_08_q       <= reg_08_d;
        reg_09_q       <= reg_09_d;
        reg_0A_q       <= reg_0A_d;
        reg_0B_q       <= reg_0B_d;
        reg_0C_q       <= reg_0C_d;
        reg_0D_q       <= reg_0D_d;
        reg_0E_q       <= reg_0E_d;
        reg_0F_q       <= reg_0F_d;
        reg_10_q       <= reg_10_d;
        reg_11_q       <= reg_11_d;
        reg_12_q       <= reg_12_d;
        reg_13_q       <= reg_13_d;
        reg_14_q       <= reg_14_d;
        reg_15_q       <= reg_15_d;
        reg_16_q       <= reg_16_d;
        reg_17_q       <= reg_17_d;
        reg_18_q       <= reg_18_d;
        reg_19_q       <= reg_19_d;
        reg_1A_q       <= reg_1A_d;
        reg_1B_q       <= reg_1B_d;
        reg_1C_q       <= reg_1C_d;
        reg_1D_q       <= reg_1D_d;
        reg_1E_q       <= reg_1E_d;
        reg_1F_q       <= reg_1F_d;
        reg_20_q       <= reg_20_d;
        reg_21_q       <= reg_21_d;
        reg_22_q       <= reg_22_d;
        reg_23_q       <= reg_23_d;
        reg_24_q       <= reg_24_d;
        reg_25_q       <= reg_25_d;
        reg_26_q       <= reg_26_d;
        reg_27_q       <= reg_27_d;
        reg_28_q       <= reg_28_d;
        reg_29_q       <= reg_29_d;
        reg_2A_q       <= reg_2A_d;
        reg_2B_q       <= reg_2B_d;
        reg_2C_q       <= reg_2C_d;
        reg_2D_q       <= reg_2D_d;
        reg_2E_q       <= reg_2E_d;
        reg_2F_q       <= reg_2F_d;
        --reg_30_q       <= reg_30_d; -- Used by exp interface
        --reg_31_q       <= reg_31_d; -- Used by exp interface
        --reg_32_q       <= reg_32_d; -- Used by exp interface
        reg_33_q       <= reg_33_d;
        reg_34_q       <= reg_34_d;
        reg_35_q       <= reg_35_d;
        reg_36_q       <= reg_36_d;
        reg_37_q       <= reg_37_d;
        reg_38_q       <= reg_38_d;
        reg_39_q       <= reg_39_d;
        reg_3A_q       <= reg_3A_d;
        reg_3B_q       <= reg_3B_d;
        reg_3C_q       <= reg_3C_d;
        reg_3D_q       <= reg_3D_d;
        reg_3E_q       <= reg_3E_d;
        reg_3F_q       <= reg_3F_d;
        reg_40_q       <= reg_40_d;
        s0_axi_wdata_q <= s0_axi_wdata_d;
      end if;
    end if;
  end process;

end axi_regs_32_large;
