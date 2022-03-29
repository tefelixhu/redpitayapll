----------------------------------------------------------------------------------
--! @file mult_n_1.vhd
--! @author Felix Tebbenjohanns
--! @date 2.7.2018
----------------------------------------------------------------------------------


--    Multiplys a n-bit number with a 1-bit number (interpreted as +1 or -1)
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
use IEEE.numeric_std.all;

library work;

--! @brief Multiplies a signed value of N bits with a 1-bit value

entity mult_n_1 is
  generic(
    N : integer
    );
  port (
    Clk_CI    : in std_logic;           --! Clock
    Reset_RBI : in std_logic;           --! input reset
    
    A_DI : in std_logic_vector(N-1 downto 0);
    B_DI : in std_logic;

    C_DO : out std_logic_vector(N-1 downto 0)

    );
end mult_n_1;

architecture Behavioral of mult_n_1 is

signal C_DN : std_logic_vector(N-1 downto 0);
begin

  process(B_DI, A_DI)
  begin
    if B_DI = '1' then                  -- '+1'
      C_DN <= A_DI;
    else                                -- '-1'
      C_DN <= std_logic_vector(to_signed((-1)*to_integer(signed(A_DI)), N));
    end if;
  end process;


  process(Clk_CI)
  begin
    if rising_edge(Clk_CI) then
      if Reset_RBI = '0' then
        C_DO   <= (others=>'0');
      else
        C_DO   <= C_DN;
      end if;
    end if;
  end process;
end Behavioral;
