
-- Programa de Contador de anillo con maquina de estado simple
-- Elaborado por: U581
-- Fecha: 29 de septiembre de 2021

-- ------------------------------------
--      Declaracion de bibliotecas
-- ------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- ------------------------------------
--      Declaracion de la entidad
-- ------------------------------------

ENTITY anillos IS

	PORT (
		clk, clr : IN STD_LOGIC; -- Entradas de reloj y reset
		start : IN STD_LOGIC; -- Inicio
		Q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0) -- Salida a los leds
	);

END ENTITY;

-- -----------------------------------
--     Declaracion de la arquitectura
-- -----------------------------------

ARCHITECTURE data OF anillos IS

	CONSTANT base_1Hz : INTEGER := 40000000; -- Constante para 1Hz
	SIGNAL count1Hz : INTEGER RANGE 0 TO base_1Hz; -- Señal para 1Hz

	TYPE state IS (zero, uno, dos, tres, cuatro, cinco, seis, siete);
	SIGNAL current_state, next_state : state;
BEGIN

	-- -----------------------------------   
	--   Proceso para el conteo
	-- -----------------------------------

	conteo : PROCESS (start, current_state)

	BEGIN

		CASE current_state IS -- Declaracion de los estados

			WHEN zero => -- Estado zero

				IF start = '0' THEN -- Se presiono start?
					next_state <= uno; -- Si, saltar al estado uno
				ELSE
					Q <= "0000"; -- No, reiniciar el contador
					next_state <= zero; -- Mantenerce en el estado zero
				END IF;

			WHEN uno => -- Estado uno

				Q <= "1000";
				next_state <= dos;

			WHEN dos => -- Estado dos

				Q <= "0100";
				next_state <= tres;

			WHEN tres => -- Estado tres

				Q <= "0010";
				next_state <= cuatro;

			WHEN cuatro => -- Estado cuatro

				Q <= "0001";
				next_state <= cinco;

			WHEN cinco => -- Estado cinco

				Q <= "0010";
				next_state <= seis;

			WHEN seis => -- Estado seis

				Q <= "0100";
				next_state <= siete;

			WHEN OTHERS => -- Estado siete

				Q <= "1000";
				next_state <= zero;

		END CASE;
	END PROCESS;
	-- -----------------------------------
	--   Proceso para saltos de estado
	-- -----------------------------------
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