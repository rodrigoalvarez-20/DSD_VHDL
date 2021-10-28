
-- Contador de anillo con operador de rotacion
-- Elaborado por: U581
-- Fecha: 3 de octubre 2021
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

ENTITY anillo IS

	PORT (
		clk, clr : IN STD_LOGIC; -- Entradas de reloj y reset
		izq, der : IN STD_LOGIC; -- Control a la izq o der
		Q : INOUT unsigned(7 DOWNTO 0) -- Salida a los leds
	);

END ENTITY;

-- -----------------------------------
--     Declaracion de la arquitectura
-- -----------------------------------

ARCHITECTURE data OF anillo IS

	CONSTANT base_1Hz : INTEGER := 10000000; -- Constante para 1Hz
	SIGNAL count1Hz : INTEGER RANGE 0 TO base_1Hz; -- Señal para 1Hz

	CONSTANT inicio : unsigned(7 DOWNTO 0) := "00000001";

	TYPE state IS (zero, uno, dos); -- Tipo para creacion de estados    
	SIGNAL current_state, next_state : state; -- señales tipo estado	
	SIGNAL clk1hz : STD_LOGIC;
BEGIN
	-- -----------------------------------   
	--   Proceso para el conteo
	-- -----------------------------------
	conteo : PROCESS (current_state, izq, der, clk1hz, clr)

		VARIABLE aux : STD_LOGIC_VECTOR(3 DOWNTO 0); -- Declaracion de la variable auxiliar para el contador

	BEGIN

		IF clr = '0' THEN -- Se presiono el reset?
			Q <= inicio; -- Si, asignar a la salida el valor de inicio

		ELSIF (clk1hz' event AND clk1hz = '1') THEN -- Control de reloj ralentizado

			CASE current_state IS -- Declaracion de los estados

				WHEN zero => -- Estado zero

					IF izq = '0' THEN -- Se presiono izquierda?
						next_state <= uno; -- Si, saltar al estado uno
					ELSIF der = '0' THEN -- Se presiono derecha?
						next_state <= dos; -- Si, saltar al estado dos
					ELSE
						aux := "0000"; -- Ninguno se presiono, reiniciar la variable auxiliar en 0
						next_state <= zero; -- Mantenerse en el estado zero
					END IF;

				WHEN uno => -- Estado uno

					IF aux = "1111" THEN -- El contador llego a 15?
						next_state <= zero; -- Si, regresar al estado zero
					ELSE
						aux := aux + 1; -- Incrementar el contador una vez
						Q <= Q ROL 1; -- rotar a la izquierda una vez la salida Q
					END IF;

				WHEN OTHERS =>

					IF aux = "1111" THEN -- El contador llego a 15?
						next_state <= zero; -- Si, regresar al estado zero
					ELSE
						aux := aux + 1; -- Incrementar el contador una vez
						Q <= Q ROR 1; -- Rotar a la derecha una vez la salida Q
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