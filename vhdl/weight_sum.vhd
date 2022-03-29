----------------------------------------------------------------------------------
--! @file weight_sum.vhd
--! @author Felix Tebbenjohanns
--! @date 7.7.2018
----------------------------------------------------------------------------------

--    Performs a calculation of the type: C = WA*A+WB*B
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


entity weight_sum is
  generic (
    N_IN : integer := 16;
    N_WEIGHTS : integer := 16;
    N_OUT : integer := 16
    );
  port (
    Clk_CI    : in std_logic;           --! Clock
    Reset_RBI : in std_logic;           --! input reset
    
    A_DI : in std_logic_vector(N_IN-1 downto 0);
    B_DI : in std_logic_vector(N_IN-1 downto 0);
    Valid_SI : in std_logic;
    
    WA_DI : in std_logic_vector(N_WEIGHTS-1 downto 0);
    WB_DI : in std_logic_vector(N_WEIGHTS-1 downto 0);
    
    C_DO : out std_logic_vector(N_OUT-1 downto 0);
    Valid_SO : out std_logic

    );
end weight_sum;

architecture Behavioral of weight_sum is

  signal AMult_DN, AMult_DP     : std_logic_vector(N_OUT - 1 downto 0);
  signal BMult_DN, BMult_DP     : std_logic_vector(N_OUT - 1 downto 0);
  
  signal MultValid_SN, MultValid_SP : std_logic;
  
  signal C_DN, C_DP     : std_logic_vector(N_OUT - 1 downto 0);
begin

    C_DO <= C_DP;

  process(AMult_DP, BMult_DP, Valid_SI, A_DI, B_DI, WA_DI, WB_DI)  
      variable sum_long : std_logic_vector(N_OUT downto 0);
      constant MAX: std_logic_vector(N_OUT-1 downto 0) := (N_OUT-1=>'0', others => '1');
      constant MIN: std_logic_vector(N_OUT-1 downto 0) := (N_OUT-1=>'1', others => '0');
  begin
    AMult_DN <= AMult_DP;
    BMult_DN <= BMult_DP;
    
    MultValid_SN <= Valid_SI;
    if Valid_SI = '1' then
        AMult_DN <= std_logic_vector(resize(signed(A_DI) * signed(WA_DI) / (2**(N_WEIGHTS-1)), N_OUT));
        BMult_DN <= std_logic_vector(resize(signed(B_DI) * signed(WB_DI) / (2**(N_WEIGHTS-1)), N_OUT));
    end if;
    
    sum_long := std_logic_vector(resize(signed(AMult_DP), N_OUT+1) + signed(BMult_DP));
    
    if (signed(sum_long) > signed(MAX)) then
        C_DN <= MAX;
    elsif (signed(sum_long) < signed(MIN)) then
        C_DN <= MIN;
    else
        C_DN <= std_logic_vector(resize(signed(sum_long), N_OUT));
    end if;
    
  end process;


  process(Clk_CI)
  begin
    if rising_edge(Clk_CI) then
      if Reset_RBI = '0' then
        AMult_DP   <= (others=>'0');
        BMult_DP <= (others=>'0');
        MultValid_SP <= '0';
        C_DP <= (others => '0');
        Valid_SO <= '0';
      else
        AMult_DP <= AMult_DN;
        BMult_DP <= BMult_DN;
        MultValid_SP <= MultValid_SN;
        C_DP <= C_DN;
        Valid_SO <= MultValid_SP;
      end if;
    end if;
  end process;

end Behavioral;
