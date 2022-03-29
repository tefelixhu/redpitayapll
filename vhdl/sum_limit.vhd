----------------------------------------------------------------------------------
--! @file sum_limit.vhd
--! @author Felix Tebbenjohanns
--! @date 7.7.2018
----------------------------------------------------------------------------------


--    Performs a calculation of the type: C = A + B
--    If the output would exceed the range, it is limited to the max. or min. value
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
use ieee.numeric_std.all;


library work;


entity sum_limit is
  generic (
    N : integer := 16
    );
  port (
    Clk_CI    : in std_logic;           --! Clock
    Reset_RBI : in std_logic;           --! input reset

    A_DI      : in std_logic_vector(N-1 downto 0);
    B_DI      : in std_logic_vector(N-1 downto 0);
    ValidA_SI : in std_logic;
    ValidB_SI : in std_logic;

    C_DO     : out std_logic_vector(N-1 downto 0);
    Valid_SO : out std_logic

    );
end sum_limit;

architecture Behavioral of sum_limit is
  
  signal A_DP, A_DN : std_logic_vector(N-1 downto 0);
  signal B_DP, B_DN : std_logic_vector(N-1 downto 0);
  signal C_DN, C_DP : std_logic_vector(N - 1 downto 0);
begin
  A_DN     <= A_DI when ValidA_SI = '1' else A_DP;
  B_DN     <= B_DI when ValidB_SI = '1' else B_DP;
  C_DO     <= C_DP;
  Valid_SO <= '1';

  process(A_DP, B_DP)
    variable sum_long : std_logic_vector(N downto 0);
    constant MAX      : std_logic_vector(N-1 downto 0) := (N-1 => '0', others => '1');
    constant min      : std_logic_vector(N-1 downto 0) := (N-1 => '1', others => '0');
  begin
    
    sum_long := std_logic_vector(resize(signed(A_DP), N+1) + signed(B_DP));

    if (signed(sum_long) > signed(MAX)) then
      C_DN <= MAX;
    elsif (signed(sum_long) < signed(min)) then
      C_DN <= min;
    else
      C_DN <= std_logic_vector(resize(signed(sum_long), N));
    end if;
    
  end process;


  process(Clk_CI)
  begin
    if rising_edge(Clk_CI) then
      if Reset_RBI = '0' then
        A_DP <= (others => '0');
        B_DP <= (others => '0');
        C_DP <= (others => '0');
      else
        A_DP <= A_DN;
        B_DP <= B_DN;
        C_DP <= C_DN;
      end if;
    end if;
  end process;

end Behavioral;
