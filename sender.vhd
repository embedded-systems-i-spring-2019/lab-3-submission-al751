library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity sender is
port (clk, clk_en, rst, rdy, btn: in std_logic;
      char: out std_logic_vector(7 downto 0);
      send: out std_logic);
      
end sender;

architecture behavioral of sender is

type str is array(0 to 4) of std_logic_vector(7 downto 0);
signal word: str := (x"61", x"6C", x"37", x"35", x"31");
signal i: std_logic_vector(2 downto 0);
signal final : std_logic_vector(7 downto 0);

type state is (idle, BusyA, BusyB, BusyC);
signal send_state : state := idle;

begin
    process(clk)
    begin
        if(rising_edge(clk) and en = '1') then
            if(rst = '1') then
                i <= (others => '0');
                char <= (others => '0');
                send_state <= idle;
            else
                    case send_state is
                    when idle => 
                        if (rdy = '1' and btn = '1') then
                            if(unsigned(i) < 5) then
                                send <= '1';
                                char <= word(to_integer(unsigned(i)));
                                i <= std_logic_vector(unsigned(i) + 1);                                
                                send_state <= BusyA;
                            else
                                i <= (others => '0');
                                send_state <= idle;
                            end if;
                        end if;
                    when BusyA =>
                        send_state <= BusyB;
                        
                    when BusyB =>
                        send <= '0';
                        send_state <= BusyC;
                        
                    when busyC =>
                        if(rdy = '1' and btn = '0') then
                            send_state <= idle;
                        else
                            send_state <= BusyC;
                        end if;
                    end case;
                end if;    
            end if;
    end process;        
end behavioral;
