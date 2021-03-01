---------- DEFAULT LIBRARY ---------
library IEEE;
	use IEEE.STD_LOGIC_1164.all;
	use IEEE.NUMERIC_STD.ALL;
--	use IEEE.MATH_REAL.all;
------------------------------------


---------- OTHERS LIBRARY ----------
-- NONE
------------------------------------

entity fifo is
	generic (
		FIFO_WIDTH : natural := 8;
		FIFO_DEPTH : integer := 32
	);
	port (

		-------- Reset/Clock -------
		srst	: in std_logic;
		clk		: in std_logic;
		----------------------------

		--- FIFO Write Interface ---
		wr_en	: in	std_logic;
		din		: in	std_logic_vector(FIFO_WIDTH-1 downto 0);
		full	: out	std_logic;
		----------------------------

		---- FIFO Read Interface ---
		rd_en	: in	std_logic;
		dout	: out std_logic_vector(FIFO_WIDTH-1 downto 0);
		empty	: out std_logic
		----------------------------
	);
end fifo;

architecture Behavioral of fifo is

	------------------------ TYPES DECLARATION ----------------------

	------ Memory element ------
	-- define here fifo data type ...
	type FIFO_DATA_TYPE is array(0 to FIFO_DEPTH-1) of std_logic_vector(FIFO_WIDTH-1 downto 0);
	----------------------------

	-----------------------------------------------------------------


	---------------------------- SIGNALS ----------------------------

	---------- Memory element -----------
	-- declare here fifo data
	signal fifo_data : FIFO_DATA_TYPE;
	--------------------------------------

	------ Write and read "pointers" ------
    -- delcare here the read and write pointer
    signal write_index : integer range 0 to FIFO_DEPTH-1 := 0;
    signal read_index : integer range 0 to FIFO_DEPTH-1 := 0;
	---------------------------------------


	------- Number of words in FIFO ------
	-- declare here the counter of the total of occuped array cells
	signal fifo_count : integer range 0  to FIFO_DEPTH-1 := 0;
	--------------------------------------

	-- Internal replicas of full/empty --
	-- declare here the internal replicas of full/empty ...
	-- NB an out ports can not be read in a VHDL file!
	signal full_int : std_logic;
	signal empty_int : std_logic;
	--------------------------------------

begin

	----------------------------- DATA FLOW ---------------------------
    -- puts code here ....
    dout <= fifo_data(read_index);
    
    full_int <= '1' when fifo_count = FIFO_DEPTH else '0';
    empty_int <= '1' when fifo_count = 0         else '0';
    
    full <= full_int;
    empty <= empty_int;
	-------------------------------------------------------------------


	----------------------------- PROCESS ------------------------------

	------ Sync Process --------
	FIFO_engine : process (clk) is

        variable is_writing : std_logic;
        variable is_reading : std_logic;

	begin
		if rising_edge(clk) then
			if srst = '1' then
            
                -- reset here all the counts ...

			else

                is_writing := (wr_en and not full_int);
                is_reading := (rd_en and not empty_int);
				-- Keeps track of the total number of words in the FIFO
                -- puts code here ....
                if is_writing = '1' and is_reading = '0' then
                    fifo_count <= fifo_count +1;
                elsif rd_en = '1' then
                    fifo_count <= fifo_count -1;
                end if;

				-- Keeps track of the write index (and controls roll-over)
                -- puts code here ....
                if is_writing = '1' then
                    if write_index = FIFO_DEPTH -1 then
                        write_index <= 0;
                    else
                        write_index <= write_index +1;
                    end if;
                end if;

				-- Keeps track of the read index (and controls roll-over)
                -- puts code here ....
                if is_reading = '1' then
                    if read_index = FIFO_DEPTH -1 then
                        read_index <= 0;
                    else
                        read_index <= read_index +1;
                    end if;
                end if;

				-- Write the data if needed
                -- puts code here ....
                if wr_en = '1' then
                    fifo_data(write_index) <= din;
                end if;

			end if;
		end if;
	end process FIFO_engine;
	----------------------------

	-------------------------------------------------------------------



end Behavioral;
