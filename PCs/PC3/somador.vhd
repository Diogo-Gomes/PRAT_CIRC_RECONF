library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity somador is
    Port ( a : in STD_LOGIC_VECTOR (16 downto 0);
           b : in STD_LOGIC_VECTOR (16 downto 0);
           saida : out STD_LOGIC_VECTOR (16 downto 0);
           rdy_som   : out std_logic;
           en_som    : in std_logic);
end somador;

architecture Behavioral of somador is

begin
process(en_som)
begin
    if en_som='1' then
        saida <= a + b;
        rdy_som <='1';
    else
        rdy_som <='0';
    end if;
end process;
end Behavioral;
