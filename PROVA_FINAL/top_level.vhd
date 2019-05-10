library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

use work.fpupack.all;
use work.entities.all;

entity top_level is
    Port ( xul : in STD_LOGIC_VECTOR (26 downto 0);
           xir : in STD_LOGIC_VECTOR (26 downto 0);
           clk : in STD_LOGIC;
           start : in STD_LOGIC;
           reset : in STD_LOGIC;
           ready : out STD_LOGIC;
           xf : out STD_LOGIC_VECTOR (26 downto 0) := (others => '0');
           led : out STD_LOGIC_VECTOR (15 downto 0));
           
           
end top_level;

architecture Behavioral of top_level is

signal outmul : std_logic_vector(FP_WIDTH-1 downto 0):= (others=>'0');
signal outmu2 : std_logic_vector(FP_WIDTH-1 downto 0):= (others=>'0');
signal outmu3 : std_logic_vector(FP_WIDTH-1 downto 0):= (others=>'0');

signal sigmak1 : std_logic_vector(FP_WIDTH-1 downto 0):= (others=>'0');
signal sig_next : std_logic_vector(FP_WIDTH-1 downto 0):= (others=>'0');
signal sigout : std_logic_vector(FP_WIDTH-1 downto 0):= (others=>'0');
signal gk1 : std_logic_vector(FP_WIDTH-1 downto 0):= (others=>'0');
signal gkout : std_logic_vector(FP_WIDTH-1 downto 0):= (others=>'0');
signal gk_next : std_logic_vector(FP_WIDTH-1 downto 0):= (others=>'0');
signal rdygk1 : STD_LOGIC := '0';
signal rdysigmak1 : STD_LOGIC := '0';
signal r_sigmanext : STD_LOGIC := '0';
signal start_xf_gk : STD_LOGIC := '0';

signal count : STD_LOGIC := '0';

signal rdymul : STD_LOGIC := '0';
signal rdymu2 : STD_LOGIC := '0';
signal rdymu3 : STD_LOGIC := '0';
signal rdyadd_0 : STD_LOGIC := '0';
signal rdyadd_1 : STD_LOGIC := '0';
signal rdyadd_2 : STD_LOGIC := '0';
signal rdyadd_3 : STD_LOGIC := '0';

signal r_gkout : STD_LOGIC := '0';
signal r_sigout : STD_LOGIC := '0';
signal start_next : STD_LOGIC := '0';
signal rdyxf : STD_LOGIC := '0';

signal outadd_0 : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
signal outadd_1 : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
signal outadd_2 : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');
signal outadd_3 : STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0) := (others=>'0');

signal sxf : STD_LOGIC_VECTOR (26 downto 0) := (others => '0');
signal bntled : STD_LOGIC := '0';
signal bntxir : STD_LOGIC := '0';
signal bntxul : STD_LOGIC := '0';

begin

------------ XF --------------------    
    add0: addsubfsm_v6 port map(
    reset      => reset,
    clk        => clk,   
    op         => '1',   
    op_a       => xir,
    op_b       => xul,
    start_i    => start,
    addsub_out => outadd_0,
    ready_as   => rdyadd_0);

    mul1: multiplierfsm_v2 port map(
    reset       => reset,
    clk         => clk,   
    op_a        => gkout, --gkout ou gk1
    op_b        => outadd_0,
    start_i     => start_xf_gk, --start_next
    mul_out     => outmul,
    ready_mul   => rdymul);
    
    add1: addsubfsm_v6 port map(
    reset      => reset,
    clk        => clk,   
    op         => '0',   
    op_a       => xul,
    op_b       => outmul,
    start_i    => rdymul,
    addsub_out => xf,
    ready_as   => rdyxf);
------------------------------------------
    
------------- G1 >> singal g1 -----------   
    add2: addsubfsm_v6 port map(
    reset      => reset,
    clk        => clk,   
    op         => '0',   
    op_a       => sigmak0,
    op_b       => sigmaz,
    start_i    => start,
    addsub_out => outadd_2,
    ready_as   => rdyadd_2);    
    
    div1: divNR port map(
    reset      => reset,
    clk        => clk,   
    op_a       => sigmak0,
    op_b       => outadd_2,
    start_i    => rdyadd_2,
    div_out    => gk1,
    ready_div  => rdygk1);
-----------------------------------

----------- SIGMA1 -----------
    mul2: multiplierfsm_v2 port map(
    reset     => reset,
    clk       => clk,   
    op_a      => gk1,
    op_b      => sigmak0,
    start_i   => rdygk1,
    mul_out   => outmu2,
    ready_mul => rdymu2);
    
    add3: addsubfsm_v6 port map(
    reset      => reset,
    clk        => clk,   
    op         => '1',   
    op_a       => sigmak0,
    op_b       => outmu2,
    start_i    => rdymu2,
    addsub_out => sigmak1,
    ready_as   => rdysigmak1);
------------------------------------

----------- SIGMA NEXT -----------
    mul3: multiplierfsm_v2 port map(
    reset     => reset,
    clk       => clk,   
    op_a      => gk_next, --gkout
    op_b      => sigmak1, --sigout
    start_i   => r_gkout,
    mul_out   => outmu3,
    ready_mul => rdymu3);
    
    add4: addsubfsm_v6 port map(
    reset      => reset,
    clk        => clk,   
    op         => '1',   
    op_a       => sigmak1, --sigout
    op_b       => outmu3,
    start_i    => rdymu3,
    addsub_out => sig_next,
    ready_as   => r_sigmanext);
------------------------------------

------------- G NEXT -----------   
    add5: addsubfsm_v6 port map(
    reset      => reset,
    clk        => clk,   
    op         => '0',   
    op_a       => sigmak1, --sigout
    op_b       => sigmaz,
    start_i    => rdysigmak1, --r_sigout
    addsub_out => outadd_3,
    ready_as   => rdyadd_3);    
    
    div2: divNR port map(
    reset      => reset,
    clk        => clk,   
    op_a       => sigmak1, --sigout
    op_b       => outadd_3,
    start_i    => rdyadd_3,
    div_out    => gk_next,
    ready_div  => r_gkout);
-----------------------------------

process(rdygk1)
begin
    case rdygk1 is
        when '0' => gkout <= gk1;
        when '1' => gkout <= gk_next;
        when others => gkout <= (others=>'0');       
    end case;
end process;

start_xf_gk <= r_gkout or rdygk1;
    
end Behavioral;
