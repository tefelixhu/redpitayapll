----------------------------------------------------------------------------------
--! @file pid_w_range.vhd
--! @author Felix Tebbenjohanns
--! @date 7.7.2018
----------------------------------------------------------------------------------


--    Simple PI filter of the type: Yn = Kp * Xn + Sn; Sn = Sn-1 + Ki * Xn
--    Additionally a Range input restricts the maximum excursion of the integral part
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

--! @brief Simple PID filter with setpoint 0.

entity pid_w_range is
  generic (
    N_IN : integer := 16;
    N_OUT : integer := 32;
    N_FACTORS : integer := 32
    );
  port (
    Clk_CI    : in std_logic;           --! Clock
    Reset_RBI : in std_logic;           --! input reset
    
    Kp : in std_logic_vector(N_FACTORS-1 downto 0);
    Ki : in std_logic_vector(N_FACTORS-1 downto 0);
    --Kd : in std_logic_vector(N-1 downto 0);
    
    Range_DI : in std_logic_vector(N_OUT-1 downto 0);
    
    
    Din_DI  : in  std_logic_vector(N_IN-1 downto 0);
    Valid_SI : in std_logic;
    
    Dout_DO : out std_logic_vector(N_OUT-1 downto 0);
    Valid_SO : out std_logic

    );
end pid_w_range;

architecture Behavioral of pid_w_range is
  signal Prop_DN, Prop_DP     : std_logic_vector(N_OUT - 1 downto 0);
  signal IntSum_DN, IntSum_DP : std_logic_vector(N_OUT - 1 downto 0);
  
  signal Total_DP, Total_DN : std_logic_vector(N_OUT-1 downto 0);
  signal PIValid_SP, PIValid_SN : std_logic;
begin


  process(Din_DI, Kp, IntSum_DP, Ki, Prop_DP, Valid_SI)
  variable product_long : std_logic_vector(N_IN + N_FACTORS - 1 downto 0);
  variable int_sum_next : std_logic_vector(N_OUT - 1 downto 0);
  begin
    Prop_DN <= Prop_DP;
    IntSum_DN <= IntSum_DP;
    
    PIValid_SN <= '0';
    
    if Valid_SI = '1' then
        product_long := std_logic_vector(signed(Din_DI) * signed(Kp));
        Prop_DN   <= product_long(N_IN + N_FACTORS - 1 downto N_IN + N_FACTORS - N_OUT);
        
        
        product_long := std_logic_vector(signed(Din_DI) * signed(Ki));
        
        int_sum_next := std_logic_vector(signed(IntSum_DP) + signed(product_long(N_IN + N_FACTORS - 1 downto N_IN + N_FACTORS - N_OUT)));

        if signed(int_sum_next) > signed(Range_DI) then
            IntSum_DN <= Range_DI;
        elsif signed(int_sum_next) < -1*signed(Range_DI) then
            IntSum_DN <= std_logic_vector(resize(-1 * signed(Range_DI), N_OUT));
        else    
            IntSum_DN <= int_sum_next;
        end if;
        
        PIValid_SN <= '1';
    end if;
    
    Total_DN <= std_logic_vector(signed(Prop_DP) + signed(IntSum_DP));
    Dout_DO <= Total_DP;
  end process;


  process(Clk_CI)
  begin
    if rising_edge(Clk_CI) then
      if Reset_RBI = '0' then
        Prop_DP   <= (others=>'0');
        IntSum_DP <= (others=>'0');
        PIValid_SP <= '0';
        Total_DP <= (others => '0');
        Valid_SO <= '0';
      else
        Prop_DP   <= Prop_DN;
        IntSum_DP <= IntSum_DN;
        PIValid_SP <= PIValid_SN;
        Total_DP <= Total_DN;
        Valid_SO <= PIValid_SP;
      end if;
    end if;
  end process;

end Behavioral;
