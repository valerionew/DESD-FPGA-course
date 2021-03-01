---------- DEFAULT LIBRARY ---------
library IEEE;
	use IEEE.STD_LOGIC_1164.all;
	use IEEE.NUMERIC_STD.ALL;
--	use IEEE.MATH_REAL.all;
------------------------------------


---------- OTHERS LIBRARY ----------
-- NONE
------------------------------------

entity RAM is
	generic(
		RAM_BIT_ADDR	:   NATURAL := 4;
		RAM_BIT_DATA	:   NATURAL := 8;
		RAM_INIT		:   INTEGER := 0
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
end RAM;

architecture Behavioral of RAM is

	------------------ CONSTANT DECLARATION -------------------------

	-------- Memory Init -------
	-- define here the initailization value
	constant INIT_SLV : STD_LOGIC_VECTOR(RAM_BIT_DATA-1 downto 0) := std_logic_vector(to_unsigned(RAM_INIT,RAM_BIT_DATA));
	----------------------------

	-----------------------------------------------------------------


	------------------------ TYPES DECLARATION ----------------------

	------ Memory element ------
	-- define here RAM type 2^RAM_BIT_ADDR row og RAM_BIT_DATA bits+
	type RAM_ARRAY_TYPE is array(0 to 2**RAM_BIT_ADDR-1) of STD_LOGIC_VECTOR(RAM_BIT_DATA-1 downto 0);
	----------------------------

	-----------------------------------------------------------------


	---------------------------- SIGNALS ----------------------------

	------ Memory element ------
	-- declare here the RAM array
	signal ram_data : RAM_ARRAY_TYPE;
	----------------------------


	-----------------------------------------------------------------

begin

	----------------------------- PROCESS ------------------------------

	------ Sync Process --------
	RAM_engine: process(reset, clk) is
	begin
	
                -- write RAM engine here ...
                
		if rising_edge(clk) then
            if reset = '1' then
                -- a conversion fom raminit (integer) to std logic vector has to be performed.
                
                ram_data <= (Others =>INIT_SLV) ;
                dout <= INIT_SLV;
            else
                if we = '1' then
                    -- note that you cannot use a standard logic vector as ram_data(addr), you should use an integer.
                    -- for this we need to cast as integer, but this is not sufficient, as to cast from std_logic_vector
                    -- to int one should pass for signed/unsigned first
                     ram_data(to_integer(unsigned(addr))) <= din;
                else
                    dout <= ram_data(to_integer(unsigned(addr)));
                end if;
             end if;
            
		end if;
	end process RAM_engine;
	----------------------------

	
	-------------------------------------------------------------------

end Behavioral;
