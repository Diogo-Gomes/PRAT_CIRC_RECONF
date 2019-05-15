library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;

entity logica_FSM is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           creg : in std_logic_vector(15 downto 0) := (others=>'0');
           sw0 : in STD_LOGIC;
           sw15 : in STD_LOGIC;
           ccnt0 : out STD_LOGIC_VECTOR (3 downto 0);
           ccnt1 : out STD_LOGIC_VECTOR (3 downto 0);
           cenable : out STD_LOGIC := '0';
           clr : out STD_LOGIC := '1';
           cplayer : out STD_LOGIC := '0');
end logica_FSM;

architecture Behavioral of logica_FSM is

type state is (inicio,player0, player1, des_esq, des_dir);
signal current_state, next_state : state := inicio;

signal cnt0, cnt1 : STD_LOGIC_VECTOR (3 downto 0);

begin
--processo para armazenar o estado atual
process(clk, reset)
begin
    if reset='1' then
        current_state <= inicio;
    elsif rising_edge (clk) then
        current_state <= next_state;
    end if;
end process;

--processo para atualizar o estado 
process(current_state,sw0,sw15)

begin
    case current_state is
        when inicio =>
        cnt0<="0000";
        cnt1<="0000";
            if sw0='1' then
                next_state <= des_esq;                
            else 
                next_state <= inicio;
            end if;
        when player0 =>
            cenable <= '0';
            if cnt0="1001" then
                next_state <= inicio;
                cnt0<="0000";
                cnt1<="0000";
            elsif sw0='1'then
                next_state <= des_esq;
            elsif sw15='1'then
                next_state <= player0;
                cnt0 <= cnt0 + 1;
            else
                next_state <= player1;
                cnt1 <= cnt1 + 1;
            end if;
        when des_esq =>
            clr <= '1'; --desloca esquerda lr = 1 
            cenable <= '1';
            if  sw15='1' then 
                next_state <= player0;
                cnt0 <= cnt0 + 1;
            elsif creg = "1000000000000000" then
                next_state <= player1;
            else
                next_state <= des_esq;
            end if;      
        when player1 =>
            cenable <= '0';
            if cnt1="1001" then
                next_state <= inicio;
                cnt0<="0000";
                cnt1<="0000";
            elsif sw15='1' then
                next_state <= des_dir;
            elsif sw0='1' then
                next_state <= player1;
                cnt1 <= cnt1 + 1;
            else
                next_state <= player0;
                cnt0 <= cnt0 + 1;
            end if;
                 
        when des_dir =>
            clr <= '0'; --desloca direita lr = 0
            cenable <= '1';
            if  sw0='1' then
                next_state <= player1;
                cnt1 <= cnt1 +1;
            elsif creg = "0000000000000001" then
                next_state <= player0;
            else
                next_state <= des_dir;
            end if;
    end case;   
    
end process;
ccnt0 <= cnt0;
ccnt1 <= cnt1;


end Behavioral;