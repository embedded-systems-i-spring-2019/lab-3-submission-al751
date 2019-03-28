 library IEEE;
 use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

 entity clock_div is
 port (
 clk : in std_logic;

 div : out std_logic
 );
 end clock_div;

 architecture cnt1 of clock_div is
 signal count : std_logic_vector (15 downto 0) := (others => '0');

 begin

 --div <= enable;

 process(clk) 
 begin
    if rising_edge(clk) then
        if (unsigned(count) < 1085) then
            count <= std_logic_vector( unsigned(count) + 1 );
             div <= '1';
        else
            count <= (others => '0');
            div <= '0';
            
        end if;
            if(unsigned(count) = 543) then
                div <= '1';
            else
                div <= '0';
            end if;
    end if;
end process;
end cnt1;