----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2019 11:31:09 AM
-- Design Name: 
-- Module Name: finalTopLevel - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity finalTopLevel is
Port (clk: in std_logic;
      btn: in std_logic_vector(1 downto 0);
      TXD: in std_logic;
      RXD: out std_logic;
      CTS, RTS: out std_logic);
end finalTopLevel;

architecture Behavioral of finalTopLevel is
signal output : std_logic_vector(2 downto 0);
signal new_character: std_logic_vector(7 downto 0);
signal new_send: std_logic;
signal new_ready: std_logic;
signal new_tx: std_logic;
---------------UART Component----------------------
component uart is
    port (

    clk, en, send, rx, rst      : in std_logic;
    charSend                    : in std_logic_vector (7 downto 0);
    ready, tx, newChar          : out std_logic;
    charRec                     : out std_logic_vector (7 downto 0)

);
end component;

-----------------Debounce component--------------------
component debounce is
Port (clk, btn: in std_logic;
      dbnc: out std_logic);
end component;

--------------------Clock Divider Component-------------------
component clock_div is
Port (clk: in std_logic;
      div: out std_logic);
end component;

---------------------Sender Component-------------------------
component sender is
port (clk, clk_en, rst, ready, btn: in std_logic;
      char: out std_logic_vector(7 downto 0);
      send: out std_logic);
end component;

begin
CTS <= '0';
RTS <= '0';

    u1: debounce
    port map(clk => clk,
             btn => btn(0),
             dbnc => output(0));
     
    u2: debounce
    port map(clk => clk,
             btn => btn(1),
             dbnc => output(1));
             
    u3: clock_div
    port map(clk => clk,
             div => output(2));
    
    u4: sender
    port map(btn => output(1),
             clk => clk,
             clk_en => output(2),
             ready => new_ready,
             rst => output(0),
             char(7 downto 0) => new_character(7 downto 0),
             send => new_send);
    
    u5: uart
    port map(charSend => new_character,
             clk => clk,
             en => output(2),
             rst => output(0),
             rx => TXD,
             send => new_send,
             ready => new_ready,
             tx => RXD);
             
end Behavioral;
