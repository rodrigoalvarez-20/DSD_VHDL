Library ieee;
use ieee.std_logic_1164.all;

entity States is
	port (
		clk, clr : in std_logic;
		input : in std_logic_vector(2 downto 0)
	);
end States;

architecture behave of States is
	type states_t is (q0,q1,q2,q3,q4,q5);
	signal s_actual, s_next : states_t;
	begin
		process(input, s_actual) begin
			s_next <= s_actual;
			case (s_actual) is
				when q0 =>
					if (input = "010" ) then
						s_next <= q1;
					else s_next <= q0;
					end if;
				when q1 =>
					if (input = "100") then
						s_next <= q2;
					else s_next <= q1;
					end if;
				when q2 => 
					if (input = "101") then
						s_next <= q3;
					else s_next <= q2;
					end if;
				when q3 => 
					if (input = "110") then
						s_next <= q4;
					else s_next <= q3;
					end if;
				when q4 => 
					if (input = "111") then
						s_next <= q5;
					else s_next <= q4;
					end if;
				when q5 => 
					if (input = "000") then
						s_next <= q0;
					else s_next <= q5;
					end if;
				when others => null;
			end case;
		end process;
		
		process (clk, clr) begin
			if(clr = '1') then
				s_actual <= q0;
			elsif (clk' event and clk = '1') then
				s_actual <= s_next;
			end if;
		end process;
end behave;
	
