library IEEE;

use IEEE.std_logic_1164.all;

entity tb_registerfile_generic is
end tb_registerfile_generic;

architecture testbench of tb_registerfile_generic is
	
    signal CLK: std_logic := '0';
    signal RESET: std_logic;
    signal ENABLE: std_logic;
	signal RD1: std_logic;
	signal RD2: std_logic;
	signal WR: std_logic;
	signal ADD_WR: std_logic_vector(4 downto 0);
	signal ADD_RD1: std_logic_vector(4 downto 0);
	signal ADD_RD2: std_logic_vector(4 downto 0);
	signal DATAIN: std_logic_vector(63 downto 0);
	signal OUT1: std_logic_vector(63 downto 0);
	signal OUT2: std_logic_vector(63 downto 0);

    signal CALL, FILL, RET, SPILL: std_logic;
    signal TOMEM, FROMEM: std_logic_vector(64-1 downto 0);

    component windowing_rf is
        generic(
            NBIT_DATA:  integer := 64;
            NBIT_ADD:   integer := 5;
            M:          integer := 1; -- number of global register 
            N:          integer := 1; -- number of registers in each IN, OUT, LOCAL
            F:          integer := 1  -- number of windows
        );
        port( 
        
            -- Register File External Interface
            CLK: 		IN std_logic;
            RESET: 	    IN std_logic;
            ENABLE: 	IN std_logic;
            RD1: 		IN std_logic;
            RD2: 		IN std_logic;
            WR: 		IN std_logic;
            ADD_WR: 	IN std_logic_vector(NBIT_ADD - 1 downto 0);
            ADD_RD1: 	IN std_logic_vector(NBIT_ADD - 1 downto 0);
            ADD_RD2: 	IN std_logic_vector(NBIT_ADD - 1 downto 0);
            DATAIN: 	IN std_logic_vector(NBIT_DATA- 1 downto 0);
            OUT1: 		OUT std_logic_vector(NBIT_DATA - 1 downto 0);
            OUT2: 		OUT std_logic_vector(NBIT_DATA - 1 downto 0);

            -- Other I/O
            CALL:       IN std_logic;
            RET:        IN std_logic;
            FILL:       OUT std_logic; -- POP towards memory
            SPILL:      OUT std_logic; -- PUSH towards memory

            -- TO MEMORY
            BUS_TOMEM:  OUT std_logic_vector(NBIT_DATA - 1 downto 0);
            BUS_FROMEM:  OUT std_logic_vector(NBIT_DATA - 1 downto 0)

        );
    end component;

begin 

	RG: windowing_rf 
        GENERIC MAP (64, 5, 8, 8, 5) 
        PORT MAP (CLK, RESET, ENABLE, RD1, RD2, WR, ADD_WR, ADD_RD1, ADD_RD2, DATAIN, OUT1, OUT2, CALL, RET, FILL, SPILL, TOMEM, FROMEM);

    CALL <= '0', '1' after 12 ns, '0' after 13 ns, '1' after 28 ns, '0' after 30.7 ns;
    RET <= '0', '1' after 24 ns, '0' after 25 ns;

	RESET <= '1','0' after 5 ns;
	ENABLE <= '0','1' after 3 ns, '0' after 10 ns, '1' after 15 ns;
	WR <= '0','1' after 6 ns, '0' after 7 ns, '1' after 10 ns, '0' after 20 ns;
	RD1 <= '1','0' after 5 ns, '1' after 13 ns, '0' after 20 ns, '1' after 21 ns; 
	RD2 <= '0','1' after 17 ns;
	ADD_WR <= "10110", "01000" after 9 ns, "00100" after 18 ns, "10101" after 20 ns;
	ADD_RD1 <="10110", "01000" after 9 ns, "00100" after 18 ns, "10101" after 20 ns;
	ADD_RD2<= "11100", "01000" after 9 ns, "00100" after 18 ns, "10101" after 20 ns;
	DATAIN<=(others => '0'),(others => '1') after 8 ns;

	PCLOCK : process(CLK)
	begin
		CLK <= not(CLK) after 0.5 ns;	
	end process;

end testbench;

---
-- configuration CFG_TESTRF of tb_registerfile is
--   for testbench
-- 	for RG : register_file
-- 		use configuration WORK.CFG_RF_BEH;
-- 	end for; 
--   end for;
-- end CFG_TESTRF;
