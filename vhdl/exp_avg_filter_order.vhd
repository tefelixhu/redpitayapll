----------------------------------------------------------------------------------
--! @file exp_avg_filter_order.vhd
--! @author Felix Tebbenjohanns
--! @date 13.7.2018
----------------------------------------------------------------------------------


--    Exponential smoothing filter with variable order. 
--    This wrapper file takes care of the order
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
use work.exp_avg_filter;


entity exp_avg_filter_order is
  generic(
    N       : integer := 16;
    N_ALPHA : integer := 20;
    LOG_MAX_ORDER : integer := 3
    );
  port (
    Clk_CI    : in std_logic;           --! Clock
    Reset_RBI : in std_logic;           --! input reset

    X_DI     : in std_logic_vector(N-1 downto 0);
    Valid_SI : in std_logic;

    Y_DO     : out std_logic_vector(N-1 downto 0);
    Valid_SO : out std_logic;

    Alpha_DI : in std_logic_vector(N_ALPHA-1 downto 0);

    Order_SI : in std_logic_vector(LOG_MAX_ORDER-1 downto 0)

    );
end exp_avg_filter_order;

architecture Behavioral of exp_avg_filter_order is
  constant MAX_ORDER : integer := 2**LOG_MAX_ORDER;
  type ARR_TYPE is array (0 to MAX_ORDER-1) of std_logic_vector(N-1 downto 0);

  signal Xn_D, Ynm1_D, Yn_D : std_logic_vector(N-1 downto 0);

  signal Y_DP, Y_DN : ARR_TYPE;

  signal State_SN, State_SP : integer range 0 to MAX_ORDER-1;

  signal Valid_SN, Valid_SP : std_logic;

begin

  exp_avg_filter_inst : entity exp_avg_filter
    generic map (
      N       => N,
      N_ALPHA => N_ALPHA
      )
    port map (
      Xn_DI    => Xn_D,
      Ynm1_DI  => Ynm1_D,
      Yn_DO    => Yn_D,
      Alpha_DI => Alpha_DI
      );


  Valid_SO <= Valid_SP;

  process(Order_SI, State_SP, Valid_SI, Valid_SP, X_DI, Y_DP, Yn_D)
  begin

    Y_DO     <= Y_DP((State_SP-1) mod MAX_ORDER);
    Valid_SN <= '0';

    if State_SP = 0 then
      Xn_D <= X_DI;
    else
      Xn_D <= Y_DP(State_SP - 1);
    end if;

    Ynm1_D <= Y_DP(State_SP);

    Y_DN     <= Y_DP;
    State_SN <= State_SP;


    if (State_SP = 0 and Valid_SI = '1') or (not (State_SP = 0)) then
      Y_DN(State_SP) <= Yn_D;
      State_SN       <= (State_SP +1) mod MAX_ORDER;

      --if Valid_SP = '1' then
      --  State_SN <= 0;
      --end if;

      if State_SP = to_integer(unsigned(Order_SI)) then
        Valid_SN <= '1';
      end if;
    end if;
  end process;


  process(Clk_CI)
  begin
    if rising_edge(Clk_CI) then
      if Reset_RBI = '0' then
        Y_DP     <= (others => (others => '0'));
        State_SP <= 0;
        Valid_SP <= '0';
      else
        State_SP <= State_SN;
        Y_DP     <= Y_DN;
        Valid_SP <= Valid_SN;
      end if;
    end if;
  end process;

end Behavioral;
