
-- Contador Asincrono
-- Elaborado por: U581
-- Fecha: 19 de septiembre de 2021
-- Modificador por Alvarez Perez Rodrigo

--Declaracion de bibliotecas

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Declaracion de la entidad

ENTITY contadores IS

	PORT (
		clk, clr : IN STD_LOGIC; -- Entrada de reloj y reset
		Q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- Salida del contador
		D1, D2, D3, D4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);

END ENTITY;

-- Declaracion de la arquitectura

ARCHITECTURE data OF contadores IS

	CONSTANT base_1Hz : INTEGER := 50000000; -- Constante para 1Hz
	SIGNAL count1Hz : INTEGER RANGE 0 TO base_1Hz; -- Señal para 1Hz

	SIGNAL D : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000"; -- Señal para concatenacion de FF

BEGIN

	primero : PROCESS (clk, clr, D) -- Este primer proceso representa el primer FF

	BEGIN

		IF (clr = '0') THEN -- ¿El reset se activo?

			--Q(0) <= '0'; -- Si, entonces borra el contenido en Q(0)
			D1 <= "1111111"; --Se apaga por completo el display

		ELSIF (clk' event AND clk = '1') THEN -- Cuando el reloj que ejecuta el proceso

			IF count1Hz < base_1Hz THEN -- Condicional para ralentizar la velocidad del contador
				count1Hz <= count1Hz + 1; -- contador para reducir la velocidad del reloj
			ELSE

				D(0) <= NOT D(0); -- El valor de D(0) va ser el complemento del mismo D(0)
				--Q(0) <= D(0); -- El valor de D(0) se asigna a Q(0)
				D1 <= "1001111";
				count1Hz <= 0; -- Reinicia el contador

			END IF; -- Termina el if del reductor de velocidad

		END IF; -- Termina el if del control de reloj

	END PROCESS; -- Termina el proceso del FF 1

	segundo : PROCESS (D, clr) -- Este proceso representa el segundo FF

	BEGIN -- Comienza el FF

		IF (clr = '0') THEN -- ¿El reset se activo?

			--Q(1) <= '0'; -- Si, entonces borra el contenido en Q(0)
			D2 <= "1111111";
		ELSIF (D(0)' event AND D(0) = '1') THEN -- Cuando el reloj entra en 0, se ejecuta el proceso
			D(1) <= NOT D(1); -- El valor de D(1) va ser 
			--Q(1) <= D(1);
			D2 <= "0010010";
		END IF;

	END PROCESS;

	tercero : PROCESS (D, clr)

	BEGIN

		IF (clr = '0') THEN

			--Q(2) <= '0';
			D3 <= "1111111";

		ELSIF (D(1)' event AND D(1) = '1') THEN -- Cuando el reloj entra en 0, se ejecuta el proceso

			D(2) <= NOT D(2);
			--Q(2) <= D(2);
			D3 <= "0000110";

		END IF;

	END PROCESS;

	cuarto : PROCESS (D, clr)

	BEGIN

		IF (clr = '0') THEN
			--Q(3) <= '0';
			D4 <= "1111111";

		ELSIF (D(2)' event AND D(2) = '1') THEN -- Cuando el reloj entra en 0, se ejecuta el proceso

			D(3) <= NOT D(3);
			--Q(3) <= D(3);
			D4 <= "1001100";

		END IF;

	END PROCESS;
END data;