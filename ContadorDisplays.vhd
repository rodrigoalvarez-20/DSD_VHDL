
-- Contador Utilizando los displays de 7 segmentos
-- Hecho por Rodrigo Alvarez Perez

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity CDisplays is
	port (
		clk, clr, start: in std_logic;
		d0, d1, d2, d3, d4, d5, d6, d7: out std_logic_vector(6 downto 0) --Todos los displays 
	);
end entity;

architecture data of CDisplays is
	--CONSTANT base_1Hz : INTEGER := 10000000; -- Constante para 1Hz
	CONSTANT base_1Hz : INTEGER := 1; -- Constante para 1Hz
	SIGNAL count1Hz : INTEGER RANGE 0 TO base_1Hz; -- Señal para 1Hz
	SIGNAL clk1hz : STD_LOGIC;
	
	TYPE state IS (cero, mono); -- Tipo para creacion de estados    
	SIGNAL current_state, next_state : state; -- señales tipo estado
	
	-- Contadores para cada display (al llegar a 9, se incrementa en 1 el sig display y se resetea el actual)
	SIGNAL cd0: std_logic_vector(3 downto 0) := "0000";
	SIGNAL cd1: std_logic_vector(3 downto 0) := "0000";
	SIGNAL cd2: std_logic_vector(3 downto 0) := "0000";
	SIGNAL cd3: std_logic_vector(3 downto 0) := "0000";
	SIGNAL cd4: std_logic_vector(3 downto 0) := "0000";
	SIGNAL cd5: std_logic_vector(3 downto 0) := "0000";
	SIGNAL cd6: std_logic_vector(3 downto 0) := "0000";
	SIGNAL cd7: std_logic_vector(3 downto 0) := "0000";
	
	-- Constantes para los D7S
	CONSTANT zero : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1000000"; -- Constante de cero
	CONSTANT uno : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1111001"; -- Constante de uno  
	CONSTANT dos : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0100100"; -- Constante de dos
	CONSTANT tres : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0110000"; -- Constante de tres
	CONSTANT cuatro : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0011001"; -- Constante de cuatro
	CONSTANT cinco : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0010010"; -- Constante de cinco
	CONSTANT seis : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000010"; -- Constante de seis
	CONSTANT siete : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1111000"; -- Constante de siete
	CONSTANT ocho : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000"; -- Constante de ocho
	CONSTANT nueve : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0010000"; -- Constante de Nueve

	
	BEGIN
	
	-- Evaluo el valor del contador del primer display y con ello voy asignando el valor al display
	WITH cd0 SELECT
		d0 <= zero WHEN "0000",
		uno WHEN "0001",
		dos WHEN "0010",
		tres WHEN "0011",
		cuatro WHEN "0100",
		cinco WHEN "0101",
		seis WHEN "0110",
		siete WHEN "0111",
		ocho WHEN "1000",
		nueve WHEN others;
		
	WITH cd1 SELECT
		d1 <= zero WHEN "0000",
		uno WHEN "0001",
		dos WHEN "0010",
		tres WHEN "0011",
		cuatro WHEN "0100",
		cinco WHEN "0101",
		seis WHEN "0110",
		siete WHEN "0111",
		ocho WHEN "1000",
		nueve WHEN others;
	
	WITH cd2 SELECT
		d2 <= zero WHEN "0000",
		uno WHEN "0001",
		dos WHEN "0010",
		tres WHEN "0011",
		cuatro WHEN "0100",
		cinco WHEN "0101",
		seis WHEN "0110",
		siete WHEN "0111",
		ocho WHEN "1000",
		nueve WHEN others;
	
	WITH cd3 SELECT
		d3 <= zero WHEN "0000",
		uno WHEN "0001",
		dos WHEN "0010",
		tres WHEN "0011",
		cuatro WHEN "0100",
		cinco WHEN "0101",
		seis WHEN "0110",
		siete WHEN "0111",
		ocho WHEN "1000",
		nueve WHEN others;
	
	WITH cd4 SELECT
		d4 <= zero WHEN "0000",
		uno WHEN "0001",
		dos WHEN "0010",
		tres WHEN "0011",
		cuatro WHEN "0100",
		cinco WHEN "0101",
		seis WHEN "0110",
		siete WHEN "0111",
		ocho WHEN "1000",
		nueve WHEN others;
	
	WITH cd5 SELECT
		d5 <= zero WHEN "0000",
		uno WHEN "0001",
		dos WHEN "0010",
		tres WHEN "0011",
		cuatro WHEN "0100",
		cinco WHEN "0101",
		seis WHEN "0110",
		siete WHEN "0111",
		ocho WHEN "1000",
		nueve WHEN others;
	
	WITH cd6 SELECT
		d6 <= zero WHEN "0000",
		uno WHEN "0001",
		dos WHEN "0010",
		tres WHEN "0011",
		cuatro WHEN "0100",
		cinco WHEN "0101",
		seis WHEN "0110",
		siete WHEN "0111",
		ocho WHEN "1000",
		nueve WHEN others;
		
	WITH cd7 SELECT
		d7 <= zero WHEN "0000",
		uno WHEN "0001",
		dos WHEN "0010",
		tres WHEN "0011",
		cuatro WHEN "0100",
		cinco WHEN "0101",
		seis WHEN "0110",
		siete WHEN "0111",
		ocho WHEN "1000",
		nueve WHEN others;
	
	states : PROCESS (current_state, start, clk1hz)
	VARIABLE ax0, ax1, ax2, ax3, ax4, ax5, ax6, ax7 : STD_LOGIC_VECTOR(3 DOWNTO 0); -- Declaracion de variable para contador
	BEGIN
		IF clk1hz' event AND clk1hz = '1' THEN -- Uso del reloj ralentizado
			CASE current_state IS -- Declaracion de los estados
				WHEN cero => -- Estado cero
					IF start = '0' THEN -- Se presiono start
						next_state <= mono; -- Si, saltar al estado uno
					ELSE
						ax0 := "0000"; -- No, reiniciar el contador
						ax1 := "0000"; -- No, reiniciar el contador
						ax2 := "0000"; -- No, reiniciar el contador
						ax3 := "0000"; -- No, reiniciar el contador
						ax4 := "0000"; -- No, reiniciar el contador
						ax5 := "0000"; -- No, reiniciar el contador
						ax6 := "0000"; -- No, reiniciar el contador
						ax7 := "0000"; -- No, reiniciar el contador
						next_state <= cero; -- Mantenerse en el estado cero
					END IF;
				WHEN mono => -- Estado uno
					IF cd0 = "1001" THEN -- El contador del DS0 llego a 9?
						cd0 <= "0000"; -- Reiniciar Contador para el valor en Display
						ax0 := "0000"; -- Reiniciar contador para el ciclo
						ax1 := cd1 + "0001"; -- Incrementar en 1 al siguiente display
						cd1 <= ax1; -- Asignar ese nuevo valor al segundo display
					ELSE
						ax0 := cd0 + "0001"; -- No? incrementa el contador una vez
						cd0 <= ax0; -- El valor de la variable auxiliar se asigna la señal del contador
					END IF;
					IF cd1 = "1001" THEN -- Evaluando el valor del segundo display a 9
						cd1 <= "0000"; -- Reinicio el contador del display
						ax1 := "0000"; -- Reinicio el contador del ciclo
						ax2 := cd2 + "0001"; -- Ahora incremento el contador auxiliar del 3er display
						cd2 <= ax2;
					END IF;
					IF cd2 = "1001" THEN
						cd2 <= "0000";
						ax2 := "0000";
						ax3 := cd3 + "0001";
						cd3 <= ax3;
					END IF;	
					IF cd3 = "1001" THEN
						cd3 <= "0000";
						ax3 := "0000";
						ax4 := cd4 + "0001";
						cd4 <= ax4;
					END IF;
					IF cd4 = "1001" THEN
						cd4 <= "0000";
						ax4 := "0000";
						ax5 := cd5 + "0001";
						cd5 <= ax5;
					END IF;
					IF cd5 = "1001" THEN
						cd5 <= "0000";
						ax5 := "0000";
						ax6 := cd6 + "0001";
						cd6 <= ax6;
					END IF;
					IF cd6 = "1001" THEN
						cd6 <= "0000";
						ax6 := "0000";
						ax7 := cd7 + "0001";
						cd7 <= ax7;
					END IF;
					IF cd7 = "1001" THEN
						next_state <= cero;
					END IF;
				WHEN OTHERS =>
			END CASE;
		END IF;

	END PROCESS;
	
	
	-- Proceso del reloj para ir saltando entre estados
	
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
end architecture;