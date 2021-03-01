
---------- DEFAULT LIBRARY ---------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;
--	use IEEE.MATH_REAL.all;
------------------------------------


---------- OTHERS LIBRARY ----------
-- NONE
------------------------------------

entity tb_FIFO is
end tb_FIFO;

architecture Behavioral of tb_FIFO is

	------------------ CONSTANT DECLARATION -------------------------

	-- Constant For Test Bench (TB) --
	constant PERIOD 	: time := 10 ns;
	-----------------------------------

	--------- Constants For DUT -------
	constant FIFO_WIDTH : integer := 8;
	constant FIFO_DEPTH : integer := 8;
	-----------------------------------

	-----------------------------------------------------------------



	------------------------ TYPES DECLARATION ----------------------

	--------- TB TYPE ----------
	type sample_data_type is array(0 to 15) of std_logic_vector(FIFO_WIDTH-1 DOWNTO 0);
	----------------------------

	-----------------------------------------------------------------



	--------------------- COMPONENTS DECLARETION --------------------

	--------- DUT FIFO ---------
	component fifo is
		generic(
			FIFO_WIDTH	: integer := 16;
			FIFO_DEPTH	: integer := 32
		);
		Port (
			clk			: in std_logic;
			srst		: in std_logic;

			full		: out std_logic;
			empty		: out std_logic;

			rd_en		: in std_logic;
			wr_en		: in std_logic;

			din			: in std_logic_vector(FIFO_WIDTH-1 DOWNTO 0);
			dout		: out std_logic_vector(FIFO_WIDTH-1 DOWNTO 0)
		);
	end component;
	----------------------------


	-----------------------------------------------------------------



	---------------------------- SIGNALS ----------------------------

	------- Reset/Clock --------
	signal  reset	:   STD_LOGIC := '0';
	signal  clk		:   STD_LOGIC := '0';
	----------------------------

	------- FIFO signals ------
	signal din, dout 	: std_logic_vector(FIFO_WIDTH-1 DOWNTO 0);

	signal full, empty	: std_logic;
	signal rd_en, wr_en	: std_logic := '0';
	----------------------------

	--------- TB TYPE ----------
	signal sample_data	: sample_data_type :=
		(x"10", x"11", x"12", x"13", x"14", x"15", x"16", x"17",
		 x"18", x"19", x"1a", x"1b", x"1c", x"1d", x"1e", x"1f");

	signal count : integer := 0;
	----------------------------
	----------------------------------------------------------------



begin


	--------------------- COMPONENTS DECLARETION --------------------


	--------- DUT FIFO ---------
	dut_fifo : fifo
		generic map(
			FIFO_WIDTH	=> FIFO_WIDTH,
			FIFO_DEPTH	=> FIFO_DEPTH
		)
		Port map(
			clk			=> clk,
			srst		=> reset,

			full		=> full,
			empty		=> empty,

			rd_en		=> rd_en,
			wr_en		=> wr_en,

			din			=> din,
			dout		=> dout
		);
	----------------------------



	-------------------------------------------------------------------

	----------------------------- DATA FLOW ---------------------------

	--------- Clock -----------
	clk	<= not clk after PERIOD/2;
	----------------------------

	-------------------------------------------------------------------




	----------------------------- PROCESS ------------------------------

	------- Simulation ---------
	dut_pattern	:	process
	begin

		-- Reset the FIFO
		wait for period;
		reset <= '1';
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		reset <= '0';
		wait until rising_edge(clk);
		wait until rising_edge(clk);

		-- Write 16 words: the first 8 will be written correctly,
		-- the remaining ones won't (the fifo is full)
		wr_en	<= '1';
		for count in 0 TO 15 loop
			din		<= sample_data(count);
			wait until rising_edge(clk);
		end loop;
		wr_en	<= '0';

		wait until rising_edge(clk);
		wait until rising_edge(clk);

		-- Read 16 words: the first 8 will be returned correctly,
		-- the remaining ones won't (the fifo is empty)
		rd_en	<= '1';
		for count in 0 TO 15 loop
			wait until rising_edge(clk);
		end loop;
		rd_en	<= '0';

		---------------------------

		-- Reset the FIFO
		wait for period;
		reset <= '1';
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		reset <= '0';
		wait until rising_edge(clk);
		wait until rising_edge(clk);

		-- Write the FIFO while reading it
		-- At each clock cycle, one word is written and one is read, so the
		-- FIFO is never full
		wr_en	<= '1';
		rd_en	<= '1';
		for count in 0 TO 15 loop
			din		<= sample_data(count);
			wait until rising_edge(clk);
		end loop;
		wr_en	<= '0';
		rd_en	<= '0';

		wait;

	end process;
	----------------------------


	-------------------------------------------------------------------

end Behavioral;
