
-- Contador Johnson con decodificador
-- Elaborado por: U581
-- Fecha 1 de octubre 

-- ------------------------------------
--      Declaracion de bibliotecas
-- ------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
-- ------------------------------------
--      Declaracion de la entidad
-- ------------------------------------

ENTITY JohnsonD IS

	PORT (
		clk, clr : IN STD_LOGIC; -- Entradas de reloj y reset
		start : IN STD_LOGIC; -- Inicio de contador
		Q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- Salida a los leds
	);

END ENTITY;

-- -----------------------------------
--     Declaracion de la arquitectura
-- -----------------------------------

ARCHITECTURE data OF JohnsonD IS

	CONSTANT base_1Hz : INTEGER := 10000000; -- Constante para 1Hz
	SIGNAL count1Hz : INTEGER RANGE 0 TO base_1Hz; -- Señal para 1Hz	
	TYPE state IS (cero, mono); -- Tipo para creacion de estados    
	SIGNAL current_state, next_state : state; -- señales tipo estado	

	SIGNAL contador : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000"; -- señal de conteo
	SIGNAL clk1hz : STD_LOGIC;

	-- ---------------------------------------------------------------------------
	--        Declaracion de constantes de salidas
	-- ---------------------------------------------------------------------------	  

	CONSTANT flak0 : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
	CONSTANT flak1 : STD_LOGIC_VECTOR(7 DOWNTO 0) := "10000000";
	CONSTANT flak2 : STD_LOGIC_VECTOR(7 DOWNTO 0) := "11000000";
	CONSTANT flak3 : STD_LOGIC_VECTOR(7 DOWNTO 0) := "11100000";
	CONSTANT flak4 : STD_LOGIC_VECTOR(7 DOWNTO 0) := "11110000";
	CONSTANT flak5 : STD_LOGIC_VECTOR(7 DOWNTO 0) := "11111000";
	CONSTANT flak6 : STD_LOGIC_VECTOR(7 DOWNTO 0) := "11111100";
	CONSTANT flak7 : STD_LOGIC_VECTOR(7 DOWNTO 0) := "11111110";

BEGIN

	-- ------------------------------------
	--          Decodificador
	-- ------------------------------------

	WITH contador SELECT

		Q <= flak0 WHEN "0000",
		flak1 WHEN "0001",
		flak2 WHEN "0010",
		flak3 WHEN "0011",
		flak4 WHEN "0100",
		flak5 WHEN "0101",
		flak6 WHEN "0110",
		flak7 WHEN "0111",
		NOT flak0 WHEN "1000",
		NOT flak1 WHEN "1001",
		NOT flak2 WHEN "1010",
		NOT flak3 WHEN "1011",
		NOT flak4 WHEN "1100",
		NOT flak5 WHEN "1101",
		NOT flak6 WHEN "1110",
		NOT flak7 WHEN OTHERS;
	-- ------------------------------------
	--    Proceso de incremento de '1'
	-- ------------------------------------

	conteo : PROCESS (current_state, start, clk1hz)

		VARIABLE aux : STD_LOGIC_VECTOR(3 DOWNTO 0); -- Declaracion de variable para un conteo

	BEGIN

		IF clk1hz' event AND clk1hz = '1' THEN -- Ejecucion del reloj lento

			CASE current_state IS -- Declaracion de estados

				WHEN cero => -- Estado zero

					IF start = '0' THEN -- Se presiono start?
						next_state <= mono; -- Si, saltar al estado uno
					ELSE
						contador <= "0000"; -- No, el contador de pone en 0
						next_state <= cero; -- Se mantiene en el estado cero
					END IF;

				WHEN mono => -- Estado uno

					IF contador = "1111" THEN -- El contador llego a 15?
						next_state <= cero; -- Si, regresar al estado cero
					ELSE
						aux := contador + 1; -- La variable auxiliar se incrementa una vez
						contador <= aux; -- la variable auxiliar se asigna a la señal contador
					END IF;

				WHEN OTHERS =>

			END CASE;

		END IF;

	END PROCESS;
	-- -----------------------------------
	--   Proceso para saltos de estado
	-- -----------------------------------
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