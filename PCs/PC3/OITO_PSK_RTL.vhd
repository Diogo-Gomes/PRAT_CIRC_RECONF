----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.05.2019 13:26:09
-- Design Name: 
-- Module Name: OITO_PSK_RTL - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity OITO_PSK_RTL is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           s_Dig : in STD_LOGIC;
           s_Modulado : out STD_LOGIC_VECTOR (16 downto 0));
end OITO_PSK_RTL;

architecture Behavioral of OITO_PSK_RTL is

signal s_reg : STD_LOGIC_VECTOR (2 downto 0) :=(others=>'0');
signal cos_psk : std_logic_vector(11 downto 0) :=(others=>'0');
signal amp_cos_psk : std_logic_vector(4 downto 0) :=(others=>'0');
signal mult_cos_psk : std_logic_vector(16 downto 0) :=(others=>'0');
signal sen_psk : std_logic_vector(11 downto 0) :=(others=>'0');
signal amp_sen_psk : std_logic_vector(4 downto 0) :=(others=>'0');
signal mult_sen_psk : std_logic_vector(16 downto 0) :=(others=>'0');
signal freq : std_logic_vector(2 downto 0) :=(others=>'0');
signal enable_gerador : std_logic :='0';
signal rdy_gerador : std_logic :='0';
signal rdy_mul1 : std_logic :='0';
signal rdy_mod : std_logic :='0';
signal rdy_sipo : std_logic :='0';
signal rdy_mul2 : std_logic :='0';
signal rdy_som : std_logic :='0';
signal en_mul : std_logic :='0';
signal en_mod : std_logic :='0';
signal en_som : std_logic :='0';

component gerador_de_onda is
    Port (clk : in std_logic;
    reset : in std_logic;
    enable_clk: in std_logic;
    rdy: out std_logic;
    freq : in std_logic_vector(2 downto 0);
    cosseno : out std_logic_vector(11  downto 0);
    seno : out std_logic_vector(11  downto 0));
end component;

component SIPO is
Port( reset: in std_logic;
    s_in : in std_logic;
    clk  : in std_logic;
    rdy_sipo  : out std_logic;
    pout : out std_logic_vector(2 downto 0));
end component;

component oito_PSK is
Port( data_in : in  STD_LOGIC_VECTOR (2 downto 0);
    en_mod : in std_logic;           
    rdy_mod : out std_logic;            
    amp_cos : out  STD_LOGIC_VECTOR (4 downto 0);            
    amp_sin : out  STD_LOGIC_VECTOR (4 downto 0));
end component;

component multiplicador is
Port ( onda : in STD_LOGIC_VECTOR (11 downto 0); --aqui é 12 bits se for o coss ou sen
       amplitude : in STD_LOGIC_VECTOR (4 downto 0);
       resultado : out STD_LOGIC_VECTOR (16 downto 0);
       rdy_mul   : out std_logic;
       en_mul   : in std_logic);
end component;

component somador is
Port ( a : in STD_LOGIC_VECTOR (16 downto 0);
       b : in STD_LOGIC_VECTOR (16 downto 0);
       saida : out STD_LOGIC_VECTOR (16 downto 0);
       rdy_som   : out std_logic;
       en_som    : in std_logic);
end component;

begin

gerador_onda: gerador_de_onda port map(
    clk         =>clk,
    reset       =>reset,
    enable_clk  => rdy_mod, ---era rdy_gerador
    freq        => s_reg, --freq
    rdy         => rdy_gerador,
    seno        => sen_psk,
    cosseno     => cos_psk);
    
SIPO_reg: SIPO port map(
    clk     =>clk,
    reset   =>reset,
    s_in    =>s_Dig,
    rdy_sipo => rdy_sipo,
    pout    => s_reg);
    
modulador: oito_PSK port map(
    data_in => s_reg,
    en_mod => rdy_sipo,
    rdy_mod => rdy_mod,
    amp_cos => amp_cos_psk,
    amp_sin => amp_sen_psk);
    
mul1: multiplicador port map(
    onda        => sen_psk,
    amplitude   => amp_sen_psk,
    resultado   => mult_sen_psk,
    rdy_mul   => rdy_mul1,
    en_mul => rdy_gerador);

mul2: multiplicador port map(
    onda        => cos_psk,
    amplitude   => amp_cos_psk,
    resultado   => mult_cos_psk,
    rdy_mul   => rdy_mul2,
    en_mul => rdy_gerador); 
    
add1: somador port map(
    a       => mult_sen_psk,
    b       => mult_sen_psk,
    saida   => s_modulado,
    rdy_som   => rdy_som,
    en_som => rdy_mul1);    
    
end Behavioral;
