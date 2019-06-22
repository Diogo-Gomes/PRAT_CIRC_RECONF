library ieee;
use ieee.std_logic_1164.all;

entity SIPO is
Port( reset: in std_logic;
    s_in  : in std_logic;
    clk : in std_logic;
    rdy_sipo : out std_logic;
    pout : out std_logic_vector(2 downto 0));
end SIPO;

architecture Behavioral of sipo is

signal temp: std_logic_vector (2 downto 0) := (others => '0');
begin

process(clk, reset)

begin
    if(reset = '1') then
        temp <= "000";
        rdy_sipo<='0';
    elsif rising_edge (clk) then
        temp(2) <= s_in;
        temp(1) <= temp(2);
        temp(0) <= temp(1);
        rdy_sipo<='1';
    end if;
end process;

pout <= temp;

end Behavioral;
