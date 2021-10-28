
-- Programa de contador sincrono SECUENCIAL
-- Elaborado por: U581
-- Fecha: 19 de septiembre de 2021
-- Modificador por Alvarez Perez Rodrigo

-- Declaracion de bibliotecas

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Declaracion de entidad

ENTITY contadores IS

    PORT (
        clk, clr : IN STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        display : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );

END ENTITY;

-- Declaracion de la arquitectura

ARCHITECTURE data OF contadores IS

    CONSTANT base_1Hz : INTEGER := 50000000; -- Constante para 1Hz
    SIGNAL count1Hz : INTEGER RANGE 0 TO base_1Hz; -- Señal para 1Hz

    TYPE state IS (zero, uno, dos, tres);
    SIGNAL current_state, next_state : state;

BEGIN
    -- -------------------------------------------------------
    --        Proceso para hacer los saltos de estado
    -- -------------------------------------------------------

    states : PROCESS (current_state)
    BEGIN
        CASE current_state IS
            WHEN zero =>
                --Q <= "00";
                display <= "1000000";
                next_state <= uno;
            WHEN uno =>
                --Q <= "01";
                display <= "1111001"; 
                next_state <= dos;
            WHEN dos =>
                --Q <= "10";
                display <= "0100100"; 
                next_state <= tres;

            WHEN OTHERS =>
                display <= "0110000"; 
                --Q <= "11";
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