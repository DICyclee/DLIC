module traffic_light (
  input  clk,
  input  rst,
  input  pass,
  output reg R,
  output reg G,
  output reg Y
);

reg [10:0] counter; 

reg [1:0] cstate; 
reg [1:0] nstate; 

reg [1:0] check_green_type;
reg check_first_start_green; 
reg check_pass_state;

parameter GREEN = 0; 
parameter YELLOW = 1;
parameter RED = 2; 
parameter NONE = 3; 

always @(posedge clk or posedge rst) begin
  if(rst)
    cstate <= GREEN;
  else
    cstate <= nstate;
end

always @(posedge clk or posedge rst) begin
  if(rst)begin
    counter <= 0;
    R <= 0;
    G <= 1;
    Y <= 0;   
    check_green_type <= 0;
    check_first_start_green <= 0;
    check_pass_state <= 0;      
  end 
  else begin
    case(cstate)
      GREEN:begin
        R <= 0;
        G <= 1;
        Y <= 0;
        if(check_green_type > 0)begin
          if(counter == 127)begin
            counter <= 0;
            check_green_type <= 2;
          end
          else
            counter <= counter + 1;
        end    
        else begin
          if(check_first_start_green)begin
            check_pass_state <= 0; 
            if(counter == 1023)begin
              counter <= 0;
              check_green_type <= 1;  
            end
            else begin
              counter <= counter + 1;  
            end            
          end
          else begin
            check_pass_state <= 0;
            if(counter == 1022)begin
              counter <= 0;
              check_green_type <= 1;  
              check_first_start_green <= 1;
            end
            else
              counter <= counter + 1;                
          end                
        end          
      end
      YELLOW:begin
        check_green_type <= 0;
        R <= 0;
        G <= 0;
        Y <= 1;
        if(counter == 511)
          counter <= 0;
        else
          counter <= counter + 1;    
      end
      RED:begin
        R <= 1;
        G <= 0;
        Y <= 0;
        if(counter == 1023)
          counter <= 0;
        else
          counter <= counter + 1;           
      end    
      NONE:begin
        R <= 0;
        G <= 0;
        Y <= 0;
        if(counter == 127)begin
          counter <= 0;
        end
        else
          counter <= counter + 1;          
      end        
    endcase
  end
end

always @(*) begin
  case(cstate)
    GREEN:begin
      if(check_first_start_green)begin
        if(check_green_type == 2)
          if(counter == 127)
            nstate = YELLOW;
          else
            nstate = GREEN;
        else if(check_green_type == 1)
          if(counter == 127)
            nstate = NONE;
          else
            nstate = GREEN;
        else begin
          if(counter == 1023)
            nstate = NONE;
          else
            nstate = GREEN;            
        end        
      end
      else begin
        if(check_green_type == 2)
          if(counter == 127)
            nstate = YELLOW;
          else
            nstate = GREEN;
        else if(check_green_type == 1)
          if(counter == 127)
            nstate = NONE;
          else
            nstate = GREEN;
        else begin
          if(counter == 1022)
            nstate = NONE;
          else
            nstate = GREEN;            
        end            
      end
    end
    YELLOW:begin
      if(pass)begin
        cstate = GREEN;
        nstate = GREEN;
        check_pass_state = 1;    
      end
      else begin
        if(counter == 511)
          nstate = RED;
        else
          nstate = YELLOW;
      end
    end
    RED:begin          
      if(pass)begin
        cstate = GREEN;
        nstate = GREEN;
        check_pass_state = 1;                 
      end
      else begin
        if(counter == 1023)
          nstate = GREEN;
        else
          nstate = RED;          
      end        
    end
    NONE:begin
      if(pass)begin
        cstate = GREEN;
        nstate = GREEN;
        check_pass_state = 1;      
      end
      else begin
        if(counter == 127)
          nstate = GREEN;
        else
          nstate = NONE;
      end  
    end            
  endcase
end

always @(*) begin
  if(pass)begin
    if((check_pass_state == 0) && (check_green_type == 0))begin
        check_green_type = check_green_type;
        counter = counter;
    end
    else begin       
      check_green_type = 0;
      counter = 0;
    end
  end
  else begin
    check_green_type = check_green_type;
    counter = counter;    
  end
end

endmodule
