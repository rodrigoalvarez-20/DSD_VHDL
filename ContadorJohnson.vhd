
-- Contador Johnson con desplazamiento
-- Elaborado por: U581
-- Fecha 1 de octubre 

-- ------------------------------------
--      Declaracion de bibliotecas
-- ------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;
-- ------------------------------------
--      Declaracion de la entidad
-- ------------------------------------

ENTITY jhonson IS

	PORT (
		clk, clr : IN STD_LOGIC; -- Entradas de reloj y reset
		Q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- Salida a los leds
	);

END ENTITY;

-- -----------------------------------
--     Declaracion de la arquitectura
-- -----------------------------------

ARCHITECTURE data OF jhonson IS

	CONSTANT base_1Hz : INTEGER := 90000000; -- Constante para 1Hz
	SIGNAL count1Hz : INTEGER RANGE 0 TO base_1Hz; -- Señal para 1Hz									  

	SIGNAL clk1hz : STD_LOGIC;
	SIGNAL constQ : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";

BEGIN

	conteo : PROCESS (clk1hz, clr, constQ)

	BEGIN
		IF (clk1hz' event AND clk1hz = '1') THEN
			IF constQ(7) = '0' THEN
				FOR i IN 0 TO 7 LOOP
					constQ(i) <= '1';
				END LOOP;
			END IF;
			IF constQ(7) = '1' THEN

				FOR i IN 0 TO 7 LOOP
					constQ(i) <= '0';
				END LOOP;

			END IF;
			Q <= constQ;
		END IF;
	END PROCESS;
	-- -----------------------------------
	--   Proceso para saltos de estado
	-- -----------------------------------
	Clock : PROCESS (count1Hz, clk, clk1hz, clr, constQ)

	BEGIN

		IF clr = '0' THEN

			constQ <= "00000000";

		ELSIF (clk' event AND clk = '1') THEN

			IF count1Hz < base_1Hz THEN
				count1Hz <= count1Hz + 1;
			ELSE
				clk1hz <= NOT clk1hz;
				count1Hz <= 0;
			END IF;

		END IF;
	END PROCESS;
END data;