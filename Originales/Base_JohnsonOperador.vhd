
-- Programa del contador Johnson con operador
-- Elaborado por: U581
-- Fecha: 7 de octubre de 2021
-- ------------------------------------
--      Declaracion de bibliotecas
-- ------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

-- ------------------------------------
--      Declaracion de la entidad
-- ------------------------------------

ENTITY Johnsono IS

	PORT (
		clk, clr : IN STD_LOGIC; -- Entradas de reloj y reset
		start : IN STD_LOGIC; -- Inicio
		Q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- Salida a los leds
	);

END ENTITY;

-- -----------------------------------
--     Declaracion de la arquitectura
-- -----------------------------------

ARCHITECTURE data OF johnsono IS

	CONSTANT base_1Hz : INTEGER := 10000000; -- Constante para 1Hz
	SIGNAL count1Hz : INTEGER RANGE 0 TO base_1Hz; -- Señal para 1Hz

	SIGNAL inicio : STD_LOGIC_VECTOR(7 DOWNTO 0) := "10000000";

	TYPE state IS (zero, uno, dos); -- Tipo para creacion de estados    
	SIGNAL current_state, next_state : state; -- señales tipo estado	
	SIGNAL clk1hz : STD_LOGIC;
BEGIN
	-- -----------------------------------   
	--   Proceso para el conteo
	-- -----------------------------------
	conteo : PROCESS (current_state, start, clk1hz, clr)

		VARIABLE aux : STD_LOGIC_VECTOR(3 DOWNTO 0); -- Variable para el conteo

	BEGIN

		IF clr = '0' THEN -- Si hay un reset:
			inicio <= "10000000"; -- Que la señal inicio tenga un valor inicial

		ELSIF (clk1hz' event AND clk1hz = '1') THEN -- Uso de reloj ralentizado
			CASE current_state IS -- Casos para declarar estados

				WHEN zero => -- Estado Zero

					IF start = '0' THEN -- Si se presiono start, que inicie el contador
						next_state <= uno; -- Saltar al estado uno
					ELSE
						aux := "0000"; -- en caso de no ser presionado Start, 
						inicio <= "10000000"; -- Que ponga la variable y señal con estados iniciales
						next_state <= zero; -- Que se mantenga en el estado zero
					END IF;

				WHEN uno => -- Estado uno

					IF aux = "0110" THEN -- Si el contador llega a 6
						next_state <= dos; -- El siguiente estado debe ser dos
					ELSE
						aux := aux + 1; -- Incremento del contador una vez
						inicio <= STD_LOGIC_VECTOR(shift_right(signed(inicio), 1)); -- corrimiento aritmetico a la derecha
						Q <= inicio; -- La señal de inicio se asigna a la salida Q
					END IF;

				WHEN OTHERS => -- Estado dos

					IF aux = "1111" THEN -- Si el contador llega a 15
						next_state <= zero; -- Regresar al estado zero
					ELSE
						aux := aux + 1; -- Incremento del contador una vez
						inicio <= STD_LOGIC_VECTOR(shift_right(unsigned(inicio), 1)); -- corrimiento logico a la derecha
						Q <= inicio; -- La señal de inicio se asigna a la salida Q
					END IF;

			END CASE;
		END IF;
	END PROCESS;
	-- -----------------------------------
	--   Proceso para saltos de estado
	-- -----------------------------------
	Clock : PROCESS (clk1hz, count1Hz, clk)

	BEGIN

		IF (clk' event AND clk = '1') THEN

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