----------------------------------------------------------------------------------
--! @file dac_out_switch.vhd
--! @author Felix Tebbenjohanns
--! @date 4.7.2018
----------------------------------------------------------------------------------


--    Large switch to connect to the DACs. Up to 8 channels can be conneted.
--
--    Copyright (C) 2018  Felix Tebbenjohanns
--
--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with this program.  If not, see <http://www.gnu.org/licenses/>.




--! Use standard library
library IEEE;
use IEEE.STD_LOGIC_1164.all;


library work;


entity dac_out_switch is
  port (
    Clk_CI    : in std_logic;           --! Clock
    Reset_RBI : in std_logic;           --! input reset

    In0_DI : in std_logic_vector(13 downto 0);
    In1_DI : in std_logic_vector(13 downto 0);
    In2_DI : in std_logic_vector(13 downto 0);
    In3_DI : in std_logic_vector(13 downto 0);
    In4_DI : in std_logic_vector(13 downto 0);
    In5_DI : in std_logic_vector(13 downto 0);
    In6_DI : in std_logic_vector(13 downto 0);
    In7_DI : in std_logic_vector(13 downto 0);

    Valid0_SI : in std_logic;
    Valid1_SI : in std_logic;
    Valid2_SI : in std_logic;
    Valid3_SI : in std_logic;
    Valid4_SI : in std_logic;
    Valid5_SI : in std_logic;
    Valid6_SI : in std_logic;
    Valid7_SI : in std_logic;

    SwitchDac0_SI : in std_logic_vector(2 downto 0);
    SwitchDac1_SI : in std_logic_vector(2 downto 0);

    DacOut_DO : out std_logic_vector(31 downto 0);
    Valid_SO : out std_logic
    );
end dac_out_switch;

architecture Behavioral of dac_out_switch is

  signal In0_DP, In0_DN : std_logic_vector(13 downto 0);
  signal In1_DP, In1_DN : std_logic_vector(13 downto 0);
  signal In2_DP, In2_DN : std_logic_vector(13 downto 0);
  signal In3_DP, In3_DN : std_logic_vector(13 downto 0);
  signal In4_DP, In4_DN : std_logic_vector(13 downto 0);
  signal In5_DP, In5_DN : std_logic_vector(13 downto 0);
  signal In6_DP, In6_DN : std_logic_vector(13 downto 0);
  signal In7_DP, In7_DN : std_logic_vector(13 downto 0);

  signal DacOut_DP, DacOut_DN : std_logic_vector(31 downto 0);

begin
  DacOut_DO <= DacOut_DP;
  Valid_SO <= '1';


  In0_DN <= In0_DI when Valid0_SI = '1' else In0_DP;
  In1_DN <= In1_DI when Valid1_SI = '1' else In1_DP;
  In2_DN <= In2_DI when Valid2_SI = '1' else In2_DP;
  In3_DN <= In3_DI when Valid3_SI = '1' else In3_DP;
  In4_DN <= In4_DI when Valid4_SI = '1' else In4_DP;
  In5_DN <= In5_DI when Valid5_SI = '1' else In5_DP;
  In6_DN <= In6_DI when Valid6_SI = '1' else In6_DP;
  In7_DN <= In7_DI when Valid7_SI = '1' else In7_DP;

  DacOut_DN(13 downto 0) <=
    In0_DP when SwitchDac0_SI = "000" else
    In1_DP when SwitchDac0_SI = "001" else
    In2_DP when SwitchDac0_SI = "010" else
    In3_DP when SwitchDac0_SI = "011" else
    In4_DP when SwitchDac0_SI = "100" else
    In5_DP when SwitchDac0_SI = "101" else
    In6_DP when SwitchDac0_SI = "110" else
    In7_DP;

  DacOut_DN(15 downto 14) <= "00";

  DacOut_DN(29 downto 16) <=
    In0_DP when SwitchDac1_SI = "000" else
    In1_DP when SwitchDac1_SI = "001" else
    In2_DP when SwitchDac1_SI = "010" else
    In3_DP when SwitchDac1_SI = "011" else
    In4_DP when SwitchDac1_SI = "100" else
    In5_DP when SwitchDac1_SI = "101" else
    In6_DP when SwitchDac1_SI = "110" else
    In7_DP;

  DacOut_DN(31 downto 30) <= "00";

  process(Clk_CI)
  begin
    if rising_edge(Clk_CI) then
      if Reset_RBI = '0' then
        In0_DP <= (others => '0');
        In1_DP <= (others => '0');
        In2_DP <= (others => '0');
        In3_DP <= (others => '0');
        In4_DP <= (others => '0');
        In5_DP <= (others => '0');
        In6_DP <= (others => '0');
        In7_DP <= (others => '0');

        DacOut_DP <= (others => '0');
      else
        In0_DP <= In0_DN;
        In1_DP <= In1_DN;
        In2_DP <= In2_DN;
        In3_DP <= In3_DN;
        In4_DP <= In4_DN;
        In5_DP <= In5_DN;
        In6_DP <= In6_DN;
        In7_DP <= In7_DN;

        DacOut_DP <= DacOut_DN;
      end if;
    end if;
  end process;
end Behavioral;
