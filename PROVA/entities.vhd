-------------------------------------------------
-- Company:       GRACO-UnB
-- Engineer:      DANIEL MAURICIO MU�OZ ARBOLEDA
-- 
-- Create Date:   04-Sep-2012 
-- Design name:   FPUs
-- Module name:   entities
-- Description:   package defining IO of the components
-- Automatically generated using the vFPU_gen.m v1.0
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.fpupack.all;

package Entities is

component lfsr_fixtofloat_20bits	is
port (reset     :  in std_logic;
    clk       :  in std_logic;
    start     :  in std_logic;
    istart    :  in std_logic;
    init      :  in std_logic_vector(15 downto 0);
    lfsr_out  : out std_logic_vector(FP_WIDTH-1 downto 0);
    ready     : out std_logic);
end component;

component addsubfsm_v6 is
port (reset     :  in std_logic;
    clk       :  in std_logic;
    op        :  in std_logic;
    op_a    	 :  in std_logic_vector(FP_WIDTH-1 downto 0);
    op_b    	 :  in std_logic_vector(FP_WIDTH-1 downto 0);
    start_i	 :  in std_logic;
    addsub_out : out std_logic_vector(FP_WIDTH-1 downto 0);
    ready_as  : out std_logic);
end component;

component multiplierfsm_v2 is
port (reset     :  in std_logic;
    clk       :  in std_logic;
    op_a    	 :  in std_logic_vector(FP_WIDTH-1 downto 0);
    op_b    	 :  in std_logic_vector(FP_WIDTH-1 downto 0);
    start_i	 :  in std_logic;
    mul_out   : out std_logic_vector(FP_WIDTH-1 downto 0);
    ready_mul : out std_logic);
end component;

component fixMul is
port (op_a    	 :  in std_logic_vector(FRAC_WIDTH downto 0);
    op_b    	 :  in std_logic_vector(FRAC_WIDTH downto 0);
    mul_out   : out std_logic_vector(FRAC_WIDTH*2+1 downto 0));
end component;

component divNR is
port (reset     :  in std_logic;
    clk       :  in std_logic;
    op_a    	 :  in std_logic_vector(FP_WIDTH-1 downto 0);
    op_b    	 :  in std_logic_vector(FP_WIDTH-1 downto 0);
    start_i	 :  in std_logic;
    div_out   : out std_logic_vector(FP_WIDTH-1 downto 0);
    ready_div : out std_logic);
end component;

component cordic_exp
port (reset	:  in std_logic;
	clk	:  in std_logic;
	start	:  in std_logic;
	Ain	:  in std_logic_vector(FP_WIDTH-1 downto 0);
	exp    : out std_logic_vector(FP_WIDTH-1 downto 0);
	ready  : out std_logic);
end component;

component decFP is
port (reset    :  in std_logic;
    start	:  in std_logic;
    clk      :  in std_logic;
    Xin    	:  in std_logic_vector(FP_WIDTH-1 downto 0);
    quad     : out std_logic_vector(1 downto 0);
    decX     : out std_logic_vector(FP_WIDTH-1 downto 0);
    ready : out std_logic);
end component;

component serialcom
port( reset	   :  in std_logic;
    clk 		   :  in std_logic;
	start       :  in std_logic;
    d1         :  in std_logic_vector(FP_WIDTH-1 downto 0);
    d2         :  in std_logic_vector(FP_WIDTH-1 downto 0);
    d3         :  in std_logic_vector(FP_WIDTH-1 downto 0);
	din     	   :  in std_logic;
	data        : out std_logic_vector(7 downto 0);
    rdy_data    : out std_logic;
	   dout        : out std_logic);
end component;

component polinomio
Port( x : in STD_LOGIC_VECTOR (26 downto 0);
      fx : out STD_LOGIC_VECTOR (26 downto 0);
      clk : in STD_LOGIC;
      start : in STD_LOGIC;
      reset : in STD_LOGIC;
      bntU : in STD_LOGIC;
      bntD : in STD_LOGIC;
      ready : out STD_LOGIC;
      led : out STD_LOGIC_VECTOR (26 downto 0));
end component;
--component neuronio    
--Port ( clk : in STD_LOGIC;
--		  reset : in STD_LOGIC;
--		  start : in STD_LOGIC;
--		  x 	  : in t_input;
--		  w 	  : in t_input;
--		  bias  : in STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0);
--		  saida : out STD_LOGIC_VECTOR (FP_WIDTH-1 downto 0);
--		  ready : out STD_LOGIC);
--end component;

--component RNA443 is
--    Port ( clk 	: in STD_LOGIC;
--           reset 	: in STD_LOGIC;
--           start 	: in STD_LOGIC;
--           x 		: in t_input;
--           saida 	: out t_output;
--           ready 	: out STD_LOGIC);
--end component;

end Entities;