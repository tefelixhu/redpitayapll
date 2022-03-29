library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

library work;
use work.clock_div_dec_filter;


entity axis_red_pitaya_adc is
  generic ( 
    AXIS_TDATA_WIDTH : integer := 32;
    ADC_DATA_WIDTH : integer := 14;
    LOG_DIV : integer := 2
    );
  port (    
    adc_clk_p:in std_logic;
    adc_clk_n:in std_logic;
    adc_dat_a:in std_logic_vector(ADC_DATA_WIDTH-1 downto 0);
    adc_dat_b:in std_logic_vector(ADC_DATA_WIDTH-1 downto 0);
    
    adc_clk : out std_logic;
    adc_csn : out std_logic;
    
    adc_a : out std_logic_vector(ADC_DATA_WIDTH+LOG_DIV-1 downto 0);
    adc_b : out std_logic_vector(ADC_DATA_WIDTH+LOG_DIV-1 downto 0)
    );
end axis_red_pitaya_adc;

architecture Behavioral of axis_red_pitaya_adc is

signal int_clk, int_clk0 : std_logic;

signal int_dat_a_reg, int_dat_b_reg : std_logic_vector(ADC_DATA_WIDTH-1 downto 0);
signal int_dat_a_dec_reg, int_dat_b_dec_reg : std_logic_vector(ADC_DATA_WIDTH+LOG_DIV-1 downto 0);
--signal int_m_axis_tdata : std_logic_vector(AXIS_TDATA_WIDTH-1 downto 0);

constant zero_padding : std_logic_vector(AXIS_TDATA_WIDTH/2-1 downto ADC_DATA_WIDTH) := (others => '0');

begin

  clock_div_dec_filter_inst : entity clock_div_dec_filter
    generic map (
      N => ADC_DATA_WIDTH,
      LOG_DIV => LOG_DIV
      )
    port map (
    Clk_CI    => int_clk,
    Reset_RBI => '1',
 
    InA_DI(ADC_DATA_WIDTH-1) => int_dat_a_reg(ADC_DATA_WIDTH-1),
    InA_DI(ADC_DATA_WIDTH-2 downto 0) => not(int_dat_a_reg(ADC_DATA_WIDTH-2 downto 0)),
    
    InB_DI(ADC_DATA_WIDTH-1) => int_dat_b_reg(ADC_DATA_WIDTH-1),
    InB_DI(ADC_DATA_WIDTH-2 downto 0) => not(int_dat_b_reg(ADC_DATA_WIDTH-2 downto 0)),
 
    Clk_CO => adc_clk,
    
    OutA_DO => adc_a, 
    OutB_DO => adc_b
      );

  adc_clk_inst0 : IBUFGDS
    port map (O => int_clk0, I => adc_clk_p, IB => adc_clk_n);
 
      
  adc_clk_inst : BUFG
   port map (
      I  => int_clk0,
      O => int_clk
      );
      
  adc_csn <= '1';
  
  --m_axis_tvalid <= '1';
  
  --int_m_axis_tdata <= 
  --    zero_padding & 
  --    int_dat_b_reg(ADC_DATA_WIDTH-1 downto ADC_DATA_WIDTH-1) & 
  --    not(int_dat_b_reg(ADC_DATA_WIDTH-2 downto 0)) & 
  --    zero_padding & 
  --    int_dat_a_reg(ADC_DATA_WIDTH-1 downto ADC_DATA_WIDTH-1) & 
  --    not(int_dat_a_reg(ADC_DATA_WIDTH-2 downto 0)); 
  
 -- out_gen : for I in 0 to ADC_DATA_WIDTH-2 generate
 --   int_m_axis_tdata(I) <= not(int_dat_a_reg(I));
 --   int_m_axis_tdata(I+AXIS_TDATA_WIDTH/2) <= not(int_dat_b_reg(I));
 -- end generate out_gen;
 -- 
 -- int_m_axis_tdata(ADC_DATA_WIDTH-1) <= int_dat_a_reg(ADC_DATA_WIDTH-1);
 -- int_m_axis_tdata(ADC_DATA_WIDTH+AXIS_TDATA_WIDTH/2-1) <= int_dat_b_reg(ADC_DATA_WIDTH-1);
 -- 
 -- zero_gen : for I in ADC_DATA_WIDTH to AXIS_TDATA_WIDTH/2-1 generate
 --   int_m_axis_tdata(I) <= '0';
 --   int_m_axis_tdata(I+AXIS_TDATA_WIDTH/2) <= '0';
 -- end generate zero_gen;
   
      
  process(int_clk)
  begin
    if rising_edge(int_clk) then
        int_dat_a_reg     <= adc_dat_a;
        int_dat_b_reg     <= adc_dat_b;
    end if;
  end process;

end Behavioral;
