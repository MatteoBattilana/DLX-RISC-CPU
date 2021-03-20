library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_CARRY_GENERATOR is 
end TB_CARRY_GENERATOR; 

architecture TEST of TB_CARRY_GENERATOR is

	component CARRY_GENERATOR is
		generic (
			NBIT :		integer := 32;
			NBIT_PER_BLOCK: integer := 4);
		port (
			A :		in	std_logic_vector(NBIT-1 downto 0);
			B :		in	std_logic_vector(NBIT-1 downto 0);
			Cin :	in	std_logic;
			Co :	out	std_logic_vector((NBIT/NBIT_PER_BLOCK)-1 downto 0));
	end component;

	signal a, b, co: std_logic_vector(3 downto 0);

begin

	DUT: CARRY_GENERATOR generic map(4, 1) port map(a, b, '0', co);

	process
		variable cin: std_logic;
	begin

		for i in 0 to 15 loop
			for j in 0 to 15 loop
				a <= std_logic_vector(TO_UNSIGNED(i, a'length));
				b <= std_logic_vector(TO_UNSIGNED(j, a'length));

				wait for 0.5 ns;

				cin := '0';
				for k in 0 to 3 loop
					cin := (a(k) and b(k)) or ((a(k) or b(k)) and cin);
					assert co(k) = cin report "Error!";
				end loop;

				wait for 0.5 ns;
			end loop;
		end loop;
		
		wait;
	end process;

end TEST;