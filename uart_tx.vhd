
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_tx is
port (
clk , en , send , rst : in std_logic ;
char : in std_logic_vector (7 downto 0) ;
ready , tx : out std_logic
) ;
end uart_tx ;
architecture Behavioral of uart_tx is

type state is (idle, start, data);
signal currentState: state := idle;

signal data_input: std_logic_vector(7 downto 0);
signal counter: integer := 0;

begin
process(clk)
    begin
    

    if(rising_edge(clk)) then
        if(rst = '1') then
            currentstate <= idle;
            data_input <= (others => '0');
            counter <= 0;
            ready <= '1';
            tx <= '1';
        elsif(en = '1') then
            case currentState is
                when idle =>
                        if(send = '1') then
                            data_input <= char;
                            tx <= '0';
                            ready <= '0';
                            currentstate <= start;
                        else
                        ready <= '1';
                        tx <= '1';
                        end if;
                when start => 
                    tx <= data_input(0);
                    data_input <= '0' & data_input(7 downto 1);
                    counter <= 0;
                    currentstate <= data;
                when data => 
                    if(counter < 7) then
                        tx <= data_input(0);
                        counter <= counter + 1;
                        currentstate <= data;
                        data_input <= '0' & data_input(7 downto 1);
                    else 
                        tx <= '1';
                        currentState <= idle;
                    end if;
                when others =>
                    currentstate <= idle;
                end case;
        end if;                   
    end if;
end process;
end Behavioral;