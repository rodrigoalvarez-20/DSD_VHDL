
-- Programa de un contador BCD 
-- Elaborado por: U581
-- Fecha: 4 de octubre de 2021

-- -----------------------------------------------
--      Declaracion de bibliotecas
-- -----------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

--      Declaracion de entidad

ENTITY BCD_counter IS

	PORT (
		clk, clr, start : IN STD_LOGIC;
		Q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);

END ENTITY;

-- ------------------------------------------------
--     Declaracion de arquitectura
-- ------------------------------------------------

ARCHITECTURE data OF BCD_counter IS

	CONSTANT base_1Hz : INTEGER := 10000000; -- Constante para 1Hz
	SIGNAL count1Hz : INTEGER RANGE 0 TO base_1Hz; -- Señal para 1Hz

	SIGNAL contador : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000"; -- señal de conteo
	SIGNAL clk1hz : STD_LOGIC;

	TYPE state IS (cero, mono); -- Tipo para creacion de estados    
	SIGNAL current_state, next_state : state; -- señales tipo estado

	-- declaracion de constantes

	CONSTANT zero : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000"; -- Constante de cero
	CONSTANT uno : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001"; -- Constante de uno  
	CONSTANT dos : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010"; -- Constante de dos
	CONSTANT tres : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011"; -- Constante de tres
	CONSTANT quat : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100"; -- Constante de cuatro
	CONSTANT qint : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101"; -- Constante de cinco
	CONSTANT sixt : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110"; -- Constante de seis
	CONSTANT sept : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111"; -- Constante de siete
	CONSTANT octo : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1000"; -- Constante de ocho
	CONSTANT nono : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1001"; -- Constante de Nueve
BEGIN
	-- -------------------------------------------------		 
	--         Decodificador BCD
	-- -------------------------------------------------	

	WITH contador SELECT
		Q <= (zero & zero) WHEN "0000", -- 00
		(zero & uno) WHEN "0001", -- 01  
		(zero & dos) WHEN "0010", -- 02
		(zero & TRES) WHEN "0011", -- 03
		(zero & quat) WHEN "0100", -- 04
		(zero & qint) WHEN "0101", -- 05
		(zero & sixt) WHEN "0110", -- 06
		(zero & sept) WHEN "0111", -- 07
		(zero & octo) WHEN "1000", -- 08
		(zero & nono) WHEN "1001", -- 09
		(uno & zero) WHEN "1010", -- 10
		(uno & uno) WHEN "1011", -- 11
		(uno & dos) WHEN "1100", -- 12
		(uno & tres) WHEN "1101", -- 13
		(uno & quat) WHEN "1110", -- 14
		(uno & qint) WHEN OTHERS; -- 15

	-- -------------------------------------------------
	--     Proceso de conteo
	-- -------------------------------------------------

	states : PROCESS (current_state, start, clk1hz)

		VARIABLE aux : STD_LOGIC_VECTOR(3 DOWNTO 0); -- Declaracion de variable para contador

	BEGIN

		IF clk1hz' event AND clk1hz = '1' THEN -- Uso del reloj ralentizado

			CASE current_state IS -- Declaracion de los estados

				WHEN cero => -- Estado cero

					IF start = '0' THEN -- Se presiono start
						next_state <= mono; -- Si, saltar al estado uno
					ELSE
						contador <= "0000"; -- No, reiniciar el contador
						next_state <= cero; -- Mantenerse en el estado cero
					END IF;

				WHEN mono => -- Estado uno

					IF contador = "1111" THEN -- El contador llego a 15?
						next_state <= cero; -- Si, entonces regresa el estado cero
					ELSE
						aux := contador + uno; -- No? incrementa el contador una vez
						contador <= aux; -- El valor de la variable auxiliar se asigna la señal del contador
					END IF;

				WHEN OTHERS =>

			END CASE;

		END IF;

	END PROCESS;
	-- -----------------------------------------------------------------
	--        Proceso para saltar de estado en estado
	-- -----------------------------------------------------------------			  

	Clock : PROCESS (next_state, count1Hz, clk, clk1hz, clr)

	BEGIN

		IF clr = '0' THEN

			current_state <= cero;

		ELSIF (clk' event AND clk = '1') THEN

			IF count1Hz < base_1Hz THEN
				count1Hz <= count1Hz + 1;
			ELSE
				current_state <= next_state;
				clk1hz <= NOT clk1hz;
				count1Hz <= 0;
			END IF;

		END IF;

	END PROCESS;
END data;