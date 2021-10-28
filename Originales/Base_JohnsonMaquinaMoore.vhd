
    -- Programa de Contador Johnson con maquina de estado simple
	 -- Elaborado por: U581
	 -- Fecha: 29 de septiembre de 2021
	 
	 -- ------------------------------------
	 --      Declaracion de bibliotecas
	 -- ------------------------------------
	 
	    Library ieee;
		 use ieee.std_logic_1164.all;
		 
	 -- ------------------------------------
	 --      Declaracion de la entidad
	 -- ------------------------------------
	 
	     entity Johnson is 
		  
		       port(
				        clk, clr : in std_logic;              -- Entradas de reloj y reset
						  start : in std_logic;                 -- Inicio
						  Q : out std_logic_vector(3 downto 0)  -- Salida a los leds
				      );
		  
		  end entity;
		  
	  -- -----------------------------------
	  --     Declaracion de la arquitectura
	  -- -----------------------------------
	  
	  architecture data of Johnson is
	  
	      constant base_1Hz    : Integer := 80000000; 		   -- Constante para 1Hz
			signal count1Hz    : INTEGER range 0 to base_1Hz;  -- Señal para 1Hz
		 
		    type state is (zero, uno, dos, tres, cuatro, cinco, seis, siete); 
			 signal current_state, next_state: state;
	  
	    	   
		 begin
		 
		  -- -----------------------------------   
		  --   Proceso para el conteo
	     -- -----------------------------------
	
conteo:      process(start, current_state)         -- Lista sensible, con las señales y entradas del programa

                begin
                
					 case current_state is              -- Declaracion de estados
					 
					    when zero =>                    -- Estado zero
						    
							 if start = '0' then          -- Se presiono start? 
						       next_state <= uno;        -- Si, saltar al estado uno
							 else
							    Q <= "0000";              -- No, reiniciar la salida en 0
								 next_state <= zero;       -- Mantenerse en el estado zero
							 end if;
				 	 	
						  when uno =>                    -- Estado uno
						       
								 Q <= "1000";
							    next_state <= dos;
								 
						  when dos =>                     -- Estado dos
						      
								 Q <= "1100";
								 next_state <= tres;
						  
						  when tres =>                    -- Estado tres
						  						       
						       Q <= "1110"; 
								 next_state <= cuatro;
								 
						  when cuatro =>                  -- Estado cuatro
						       
								 Q <= "1111";
							    next_state <= cinco;
								 
						  when cinco =>                   -- Estado cinco
						  						      
								 Q <= "0111";
								 next_state <= seis;
						  
						  when seis =>                    -- Estado seis
						       
						       Q <= "0011"; 
								 next_state <= siete;
						  
						  when others =>                  -- Estado siete
						  
						       Q <= "0001";
								 next_state <= zero;
								 
					  end case;
	          end process;
	

        -- -----------------------------------
		  --   Proceso para saltos de estado
		  -- -----------------------------------
		 
			  
Clock:      process(next_state, count1Hz, clk, clr)
              
             begin
				 
					 if clr = '0' then
					 
						 current_state <= zero;
						 
					 elsif (clk' event and clk = '1') then
						 
						  if count1Hz < base_1Hz then 
					             count1Hz <= count1Hz+1;
				        else
								 	 current_state <= next_state;
									 count1Hz <= 0;
				        end if;	
									 
					 end if;

            end process;
			  
			  
		 end data; 
	  
	  
	  