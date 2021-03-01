---------- DEFAULT LIBRARY ---------
library IEEE;
	use IEEE.STD_LOGIC_1164.all;
	use IEEE.NUMERIC_STD.ALL;
--	use IEEE.MATH_REAL.all;
------------------------------------


---------- OTHERS LIBRARY ----------
-- NONE
------------------------------------

entity tb_RAM is
	-- Nothing here
end tb_RAM;

architecture Behavioral of tb_RAM is


	------------------ CONSTANT DECLARATION -------------------------

	-- Constant For Test Bench (TB) --
	constant	RESET_ON	: STD_LOGIC := '1';
	constant	CLK_PERIOD 	: time := 10 ns;
	constant	RESET_WND 	: time := 100 ns;
	-----------------------------------

	--------- Constants For DUT -------
	constant	DUT_RAM_BIT_DATA	:   NATURAL  := 4;
	constant	DUT_RAM_BIT_ADDR	:   NATURAL  := 2;
	constant	DUT_RAM_INIT		:   INTEGER  := 0;
	-----------------------------------

	-----------------------------------------------------------------


	--------------------- COMPONENTS DECLARETION --------------------

	--------- DUT RAM-----------
	COMPONENT RAM
		generic(
			RAM_BIT_ADDR	:	NATURAL;
			RAM_BIT_DATA	:	NATURAL;
			RAM_INIT		:	INTEGER
		);
		port (
			------ Reset/Clock --------
			reset	:	IN	STD_LOGIC;
			clk		:	IN	STD_LOGIC;
			----------------------------

			---- Write Enable/addr -----
			we		:	IN	STD_LOGIC;
			addr	:	IN	STD_LOGIC_VECTOR(RAM_BIT_ADDR-1 downto 0);
			----------------------------

			------------ Data ----------
			din		:	IN	STD_LOGIC_VECTOR(RAM_BIT_DATA-1 downto 0);
			dout	:	OUT	STD_LOGIC_VECTOR(RAM_BIT_DATA-1 downto 0)
			----------------------------
		);
	END COMPONENT;
	----------------------------


	-----------------------------------------------------------------




	---------------------------- SIGNALS ----------------------------

	------- Reset/Clock --------
	signal  reset	:   STD_LOGIC := RESET_ON;
	signal  clk		:   STD_LOGIC := '1';
	----------------------------

	------- RAM signals ------
	signal  dut_we		:   STD_LOGIC := '0';
	signal  dut_addr	:   STD_LOGIC_VECTOR(DUT_RAM_BIT_ADDR-1 downto 0) := (Others => '0');

	signal  dut_din   :   STD_LOGIC_VECTOR(DUT_RAM_BIT_DATA-1 downto 0) := (Others => '0');
	signal  dut_dout  :   STD_LOGIC_VECTOR(DUT_RAM_BIT_DATA-1 downto 0);
	----------------------------


	----------------------------------------------------------------







begin


	--------------------- COMPONENTS DECLARETION --------------------


	--------- DUT RAM-----------
	dut_RAM : RAM
		generic map(
			RAM_BIT_ADDR	=> DUT_RAM_BIT_ADDR,
			RAM_BIT_DATA	=> DUT_RAM_BIT_DATA,
			RAM_INIT		=> DUT_RAM_INIT
		)
		port map (
			------- Reset/Clock --------
			reset   => reset,
			clk		=> clk,
			----------------------------

			---- Write Enable/addr -----
			we		=> dut_we,
			addr	=> dut_addr,
			----------------------------

			------------ Data ----------
			din		=> dut_din,
			dout	=> dut_dout
			----------------------------
		);
	----------------------------



	-------------------------------------------------------------------

	----------------------------- DATA FLOW ---------------------------

	--------- Clock -----------
	clk	<= not clk after CLK_PERIOD/2;
	----------------------------


	-------------------------------------------------------------------

	----------------------------- PROCESS ------------------------------

	------- Simulation ---------
	dut_pattern : process
	begin
		-- Reset window
		reset <= '1';
		wait for RESET_WND;
		reset <= '0';

		-- Start Writing
		dut_we	  <= '1';

		for I in 0 to 2**DUT_RAM_BIT_ADDR-1 loop
			dut_addr	<= std_logic_vector(to_unsigned(I, dut_addr'LENGTH));
			dut_din	 <= std_logic_vector(to_unsigned(I + 10, dut_din'LENGTH));
			wait for CLK_PERIOD;
		end loop;

		-- Stop Writing, wait for 4 clock cycles
		dut_we	 <= '0';
		dut_din	 <= (others => '0'); -- Not really required, just to have a clean waveform
		wait for 4*CLK_PERIOD;

		-- Start Reading
		for I in 0 to 2**DUT_RAM_BIT_ADDR-1 loop
			dut_addr	<= std_logic_vector(to_unsigned(I, dut_addr'LENGTH));
			wait for CLK_PERIOD;
		end loop;

		-- Stop
		wait;

	end process;
	----------------------------


	-------------------------------------------------------------------

end Behavioral;
