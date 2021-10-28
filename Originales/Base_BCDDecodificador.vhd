
-- Programa de contador BCD con decodificador
-- Elaborado por: U581
-- Fecha: 7 de octubre de 2021

-- -----------------------------------------------
--      Declaracion de bibliotecas
-- -----------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

--      Declaracion de entidad

ENTITY BCDeco IS

	PORT (
		clk, clr, start : IN STD_LOGIC;
		Displays : OUT STD_LOGIC_VECTOR(13 DOWNTO 0)
	);

END ENTITY;

-- ------------------------------------------------
--     Declaracion de arquitectura
-- ------------------------------------------------

ARCHITECTURE data OF BCDeco IS

	CONSTANT base_1Hz : INTEGER := 20000000; -- Constante para 1Hz
	SIGNAL count1Hz : INTEGER RANGE 0 TO base_1Hz; -- Señal para 1Hz

	SIGNAL contador : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000"; -- señal de conteo
	SIGNAL clk1hz : STD_LOGIC;

	TYPE state IS (cero, mono); -- Tipo para creacion de estados    
	SIGNAL current_state, next_state : state; -- señales tipo estado

	-- declaracion de constantes

	-- Declaracion de constantes para el display

	CONSTANT zero : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1000000"; -- Constante para mostrar 0
	CONSTANT uno : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1111001"; -- Constante para mostrar 1
	CONSTANT dos : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0100100"; -- Constante para mostrar 2
	CONSTANT tres : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0110000"; -- Constante para mostrar 3
	CONSTANT quat : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0011001"; -- Constante para mostrar 4
	CONSTANT qint : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0010010"; -- Constante para mostrar 5
	CONSTANT sixt : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000010"; -- Constante para mostrar 6
	CONSTANT sept : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1111000"; -- Constante para mostrar 7
	CONSTANT octo : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000"; -- Constante para mostrar 8
	CONSTANT nono : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0010000"; -- Constante para mostrar 9
	CONSTANT OFF : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1111111"; -- Display apagado
BEGIN
	-- -------------------------------------------------		 
	--         Decodificador BCD
	-- -------------------------------------------------	

	WITH contador SELECT
		Displays <= (zero & zero) WHEN "0000", -- 00
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
		VARIABLE aux : STD_LOGIC_VECTOR(3 DOWNTO 0); -- Variable auxiliar para hacer un conteo
	BEGIN
		IF clk1hz' event AND clk1hz = '1' THEN -- Ejecucion secuencial con el reloj ralentizado 
			CASE current_state IS -- Declaracion de estados
				WHEN cero => -- Estado cero
					IF start = '0' THEN -- Se presiono start?
						next_state <= mono; -- Si, saltar al estado uno
					ELSE
						contador <= "0000"; -- No, reiniciar el contador
						next_state <= cero; -- Mantenerce en el estado cero
					END IF;
				WHEN mono =>
					IF contador = "1111" THEN -- El contador llego a 15?
						next_state <= cero; -- Si, regresar al estado cero
					ELSE
						aux := contador + "0001"; -- No, incrementa una vez el contador
						contador <= aux; -- Asignar la variable auxiliar a la señal del contador
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