----------------------------------------------------------------------------------
--! @file dec_filter.vhd
--! @author Felix Tebbenjohanns
--! @date 4.7.2018
----------------------------------------------------------------------------------


--    Decimation filter to downsample fast data to a smaller sampling frequency.
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

--! @brief Simple decimation filter

entity dec_filter is
  generic (
    PARALLEL   : integer := 2;
    DEC        : integer := 1024;
    CEILLOGDEC : integer := 10;
    N          : integer := 32;
    N_OUT      : integer := 32;
    DIV        : integer := 1024
    );
  port (
    Clk_CI    : in std_logic;           --! Clock
    Reset_RBI : in std_logic;           --! input reset


    In_DI    : in std_logic_vector(PARALLEL*N-1 downto 0);
    Valid_SI : in std_logic;

    Out_DO   : out std_logic_vector(PARALLEL*N_OUT-1 downto 0);
    Valid_SO : out std_logic

    );
end dec_filter;

architecture Behavioral of dec_filter is

  signal Counter_DP, Counter_DN : integer range 0 to DEC-1;
  signal Sum_DP, Sum_DN         : std_logic_vector(PARALLEL*(N+CEILLOGDEC)-1 downto 0);

  signal Valid_SN       : std_logic;
  signal Out_DP, Out_DN : std_logic_vector(PARALLEL*N_OUT-1 downto 0);
begin
  
  
  process(Counter_DP, Valid_SI)
  begin
    Counter_DN <= Counter_DP;
    Valid_SN   <= '0';

    if Valid_SI = '1' then
      Counter_DN <= (Counter_DP+1) mod DEC;

      if Counter_DP = DEC-1 then
        Valid_SN <= '1';
      end if;
    end if;
  end process;

  PARALLEL_GEN : for I in 0 to PARALLEL-1 generate
    process(Counter_DP, Sum_DP, Out_DP, Valid_SI, In_DI)
    begin
      Out_DN((I+1)*N_OUT-1 downto I*N_OUT) <= Out_DP((I+1)*N_OUT-1 downto I*N_OUT);

      if Valid_SI = '1' then
        Sum_DN((I+1)*(N+CEILLOGDEC)-1 downto I*(N+CEILLOGDEC)) <=
          std_logic_vector(signed(Sum_DP((I+1)*(N+CEILLOGDEC)-1 downto I*(N+CEILLOGDEC)))
                           + signed(In_DI((I+1)*N-1 downto I*N)));

        if Counter_DP = DEC-1 then
          Sum_DN((I+1)*(N+CEILLOGDEC)-1 downto I*(N+CEILLOGDEC)) <= std_logic_vector(resize(signed(In_DI((I+1)*N-1 downto I*N)), N+CEILLOGDEC));
          Out_DN((I+1)*N_OUT-1 downto I*N_OUT)                   <= std_logic_vector(resize(signed(Sum_DP((I+1)*(N+CEILLOGDEC)-1 downto I*(N+CEILLOGDEC))) / DIV, N_OUT));
        end if;
      end if;
    end process;
  end generate PARALLEL_GEN;

  Out_DO <= Out_DP;

  process(Clk_CI)
  begin
    if rising_edge(Clk_CI) then
      if Reset_RBI = '0' then
        Out_DP     <= (others => '0');
        Counter_DP <= 0;
        Sum_DP     <= (others => '0');
        Valid_SO   <= '0';
      else
        Out_DP     <= Out_DN;
        Valid_SO   <= Valid_SN;
        Counter_DP <= Counter_DN;
        Sum_DP     <= Sum_DN;
      end if;
    end if;
  end process;

end Behavioral;
