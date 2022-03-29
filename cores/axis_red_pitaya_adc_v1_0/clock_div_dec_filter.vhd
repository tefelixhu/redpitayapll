----------------------------------------------------------------------------------
--! @file clock_div_dec_filter.vhd
--! @author Felix Tebbenjohanns
--! @date 4.7.2018
----------------------------------------------------------------------------------

--! Use standard library
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

library UNISIM;
use UNISIM.vcomponents.all;

library work;

-- see https://forums.xilinx.com/t5/7-Series-FPGAs/How-to-divide-a-clock-by-2-with-a-simple-primitive-without-Clock/td-p/783488

entity clock_div_dec_filter is
  generic (
    N       : integer := 12;
    LOG_DIV : integer := 2
    );
  port (
    Clk_CI    : in std_logic;           --! Clock
    Reset_RBI : in std_logic;           --! input reset

    InA_DI : in std_logic_vector(N-1 downto 0);
    InB_DI : in std_logic_vector(N-1 downto 0);

    Clk_CO  : out std_logic;
    OutA_DO : out std_logic_vector(N+LOG_DIV-1 downto 0);
    OutB_DO : out std_logic_vector(N+LOG_DIV-1 downto 0)
    );
end clock_div_dec_filter;

architecture Behavioral of clock_div_dec_filter is

  signal ClkOut_C               : std_logic;
  signal CounterMax_S           : std_logic;
  signal Counter_SP, Counter_SN : std_logic_vector(LOG_DIV-1 downto 0);
  signal SumA_DP, SumA_DN       : std_logic_vector(N+LOG_DIV-1 downto 0);
  signal SumB_DP, SumB_DN       : std_logic_vector(N+LOG_DIV-1 downto 0);

  signal OutA_DP, OutA_DN : std_logic_vector(N+LOG_DIV-1 downto 0);
  signal OutB_DP, OutB_DN : std_logic_vector(N+LOG_DIV-1 downto 0);
begin
  Counter_SN <= std_logic_vector((unsigned(Counter_SP) + 1) mod (2**LOG_DIV));

  CounterMax_S <= '1' when (unsigned(Counter_SP) = 2**LOG_DIV-1) else '0';

  OutA_DO <= OutA_DP;
  OutB_DO <= OutB_DP;


  BUFGCE_inst : BUFGCE                  -- see Xilinx UG768
    port map (
      O  => ClkOut_C,
      I  => Clk_CI,
      CE => CounterMax_S
      );

  Clk_CO <= ClkOut_C;

  process(CounterMax_S, InA_DI, OutA_DP, SumA_DP)
  begin
    SumA_DN <= std_logic_vector(signed(SumA_DP) + signed(InA_DI));
    OutA_DN <= OutA_DP;

    if CounterMax_S = '1' then
      SumA_DN <= std_logic_vector(resize(signed(InA_DI), SumA_DN'length));
      OutA_DN <= SumA_DP;
    end if;
  end process;



  process(CounterMax_S, InB_DI, OutB_DP, SumB_DP)
  begin
    SumB_DN <= std_logic_vector(signed(SumB_DP) + signed(InB_DI));
    OutB_DN <= OutB_DP;

    if CounterMax_S = '1' then
      SumB_DN <= std_logic_vector(resize(signed(InB_DI), SumB_DN'length));
      OutB_DN <= SumB_DP;
    end if;
  end process;

  process(Clk_CI)
  begin
    if rising_edge(Clk_CI) then
      if Reset_RBI = '0' then
        SumA_DP    <= (others => '0');
        SumB_DP    <= (others => '0');
        Counter_SP <= (others => '0');
        OutA_DP    <= (others => '0');
        OutB_DP    <= (others => '0');
      else
        SumA_DP    <= SumA_DN;
        SumB_DP    <= SumB_DN;
        Counter_SP <= Counter_SN;
        OutA_DP    <= OutA_DN;
        OutB_DP    <= OutB_DN;
      end if;
    end if;
  end process;
end Behavioral;
