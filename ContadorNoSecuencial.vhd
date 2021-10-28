
-- Programa de contador sincrono, NO SECUENCIAL
-- Elaborado por: U581
-- Fecha: 19 de septiembre de 2021
-- Modificador por Alvarez Perez Rodrigo

-- Declaracion de bibliotecas

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Declaracion de entidad

ENTITY no_secuencial IS

	PORT (
		clk, clr : IN STD_LOGIC;
		Q : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		D : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);

END ENTITY;

-- Declaracion de la arquitectura

ARCHITECTURE data OF no_secuencial IS

	CONSTANT base_1Hz : INTEGER := 50000000; -- Constante para 1Hz
	SIGNAL count1Hz : INTEGER RANGE 0 TO base_1Hz; -- Señal para 1Hz

	TYPE state IS (zero, uno, dos, tres, cuatro, cinco);
	SIGNAL current_state, next_state : state;

BEGIN
	-- -------------------------------------------------------
	--        Proceso para hacer los saltos de estado
	-- -------------------------------------------------------

	states : PROCESS (current_state)

	BEGIN

		CASE current_state IS

			WHEN zero =>

				--Q <= "000";
				D <= "10000000"; 
				next_state <= uno;

			WHEN uno =>
				--Q <= "010";
				D <= "1111001"; 
				next_state <= dos;

			WHEN dos =>
				--Q <= "100";
				D <= "0100100"; 
				next_state <= tres;

			WHEN tres =>
				--Q <= "101";
				D <= "0110000"; 
				next_state <= cuatro;

			WHEN cuatro =>
				--Q <= "110";
				D <= "0011001"; 
				next_state <= cinco;
			WHEN OTHERS =>
				D <= "1111111";
				Q <= "111";
				next_state <= zero;

		END CASE;
	END PROCESS;

	-- -----------------------------------------------------------------
	--        Proceso para saltar de estado en estado
	-- -----------------------------------------------------------------			  

	Clock : PROCESS (next_state, count1Hz, clk, clr)

	BEGIN

		IF clr = '0' THEN

			current_state <= zero;

		ELSIF (clk' event AND clk = '1') THEN

			IF count1Hz < base_1Hz THEN
				count1Hz <= count1Hz + 1;
			ELSE
				current_state <= next_state;
				count1Hz <= 0;
			END IF;

		END IF;

	END PROCESS;
END data;