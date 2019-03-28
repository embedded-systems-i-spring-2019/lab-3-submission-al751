
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debounce is
Port (clk, btn: in std_logic;
      dbnc: out std_logic);
end debounce;

architecture Behavioral of debounce is

signal counter: std_logic_vector(21 downto 0);
signal count_set: std_logic;
signal shift_register: std_logic_vector(1 downto 0);

begin
    process(clk)
    begin
    count_set <= shift_register(1) xor shift_register(0);
        if(rising_edge(clk)) then  
            shift_register(0) <= btn;
            shift_register(1) <= shift_register(0);
                if(count_set = '1') then
                    counter <= (others => '0');
                elsif(counter(21) = '0') then
                    counter <= std_logic_vector(unsigned(counter) + 1);
                else
                    dbnc <= shift_register(1);
                end if;
        end if;
     end process;
end Behavioral;