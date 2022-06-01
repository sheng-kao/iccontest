module JAM (
input CLK,
input RST,
output reg [2:0] W,
output reg [2:0] J,
input [6:0] Cost,
output reg [3:0] MatchCount,
output reg [9:0] MinCost,
output reg Valid );

reg [6:0] Costmem [7:0][7:0];
reg [3:0] cur_state;
reg [3:0] next_state;
reg [2:0] W_temp;
reg [2:0] J_temp;
reg flag0;//01
reg flag1;//12
reg flag2;//23
reg flag3;//34
reg flag4;//45
reg flag5;//56
reg flag6;//67

reg signed [3:0] diff [6:0];
reg signed [3:0] min;
reg        [2:0] find_index;
reg signed [3:0] val [7:0];
reg              swap_fin;

reg [2:0] casecon;
reg       cnt2;


wire  [9:0] MinCost_wire;
wire  [9:0] add_temp1 , add_temp2 , add_temp3 , add_temp4 ,add_temp12 , add_temp34;

assign  add_temp1 = Costmem[0][val[0]] + Costmem[1][val[1]];
assign  add_temp2 = Costmem[2][val[2]] + Costmem[3][val[3]];
assign  add_temp3 = Costmem[4][val[4]] + Costmem[5][val[5]];
assign  add_temp4 = Costmem[6][val[6]] + Costmem[7][val[7]];

assign  add_temp12 = add_temp1 + add_temp2;
assign  add_temp34 = add_temp3 + add_temp4;
assign  MinCost_wire =  add_temp12 +  add_temp34 ;

parameter [3:0] STATE_READ          = 4'b0000,
                STATE_SEARCH        = 4'b0001,
                STATE_CASE          = 4'b0010,
                STATE_COMP          = 4'b0011,
                STATE_SWAP          = 4'b0100,
                STATE_ADD           = 4'b0101,
                STATE_OUT           = 4'b0110;
 
always @(posedge CLK or posedge RST) begin
	if (RST) begin
		cur_state <= STATE_READ;
	end
	else begin
		cur_state <= next_state;
	end
end

always@(*) begin
    case (cur_state)
        STATE_READ : begin   //0
            if (W_temp== 3'b111 & J_temp == 3'b111) begin
                next_state = STATE_SEARCH;
            end
            else begin
                next_state = STATE_READ;
            end

        end
        STATE_SEARCH : begin  //1
            if(~Valid)
                next_state = STATE_CASE;
            else
                next_state = STATE_OUT;
        end
        STATE_CASE : begin      //2
            if (casecon ==0)begin
                next_state = STATE_SWAP;
            end
            else begin
                next_state = STATE_CASE;
            end

        end
        STATE_COMP : begin      //3


        end
        STATE_SWAP : begin      //4
            if (/*swap_fin*/flag6 || swap_fin)
                next_state = STATE_ADD;
            else
                next_state =STATE_SWAP;
        end
        STATE_ADD : begin       //5
            next_state = STATE_SEARCH;

        end
        STATE_OUT : begin


        end        
    endcase
end

integer i;
integer k;
integer m;

always @(*) begin

    case (cur_state)
         STATE_READ : begin

        end
        STATE_SEARCH : begin

        end
        STATE_CASE : begin

        end
        STATE_COMP : begin


        end
        STATE_SWAP : begin


        end
        STATE_ADD : begin


        end
        STATE_OUT : begin


        end        
    endcase
end

always @(posedge CLK or posedge RST) begin

    if (RST) begin
    for ( i=0; i<=7; i=i+1) begin
        for ( k=0; k<=7; k=k+1) begin
            Costmem[i][k] <= 7'b0000000;
        end            
        end        
        W <= 0;
        J <= 0;
        W_temp <= 0;
        J_temp <= 0;
        Valid <=0;
        MatchCount <= 4'b0000;
        MinCost <=10'd0;
        flag0 <= 0;
        flag1 <= 0;
        flag2 <= 0;
        flag3 <= 0;
        flag4 <= 0;
        flag5 <= 0;
        flag6 <= 0;

        val[0]  <= 3'd0;
        val[1]  <= 3'd1;
        val[2]  <= 3'd2;
        val[3]  <= 3'd3;
        val[4]  <= 3'd4;
        val[5]  <= 3'd5;
        val[6]  <= 3'd6;
        val[7]  <= 3'd7;

        for (m=0; m<=6; m=m+1) begin
            diff[m] <= 4'd0;
        end
        min <= 'd0;
        find_index <= 0;
        casecon <= 0;
        swap_fin <= 0;

        cnt2 <= 0;

        MinCost <= 10'd1023;
    end
    else begin
        case (cur_state)
            STATE_READ :begin       //0
                Costmem[W_temp][J_temp] <= Cost;
                W_temp <= W;
                J_temp <= J;
                if (J!=7) begin
                    J<= J+1;
                end
                else if (W!=7 && J==7) begin
                    W <= W+1;
                    J <=0;
                end
                else if (W==7 && J==7) begin
                    W<=0;
                    J<=0;
                end
                else begin
                    W<=0;
                    J<=0;
                end      
            end
            STATE_SEARCH : begin        //1
                if (val[7] > val[6]) begin
                    flag6 <=1;
                    casecon <= 3'd1;
                end
                else if (val[6] > val[5]) begin
                    flag5 <=1;
                    casecon <= 3'd2;
                end
                else if (val[5] > val[4]) begin
                    flag4 <=1;
                    casecon <= 3'd3;
                end
                else if (val[4] > val[3]) begin
                    flag3 <=1;
                    casecon <= 3'd4;
                end
                else if (val[3] > val[2]) begin
                    flag2 <=1;
                    casecon <= 3'd5;
                end
                else if (val[2] > val[1]) begin
                    flag1 <=1;
                    casecon <= 3'd6;
                end
                else if (val[1] > val[0]) begin
                    flag0 <=1;
                    casecon <= 3'd7;
                end
                else
                    Valid <= 1;
            end
            STATE_CASE : begin      //2
               case(1'b1)
                flag6: begin
                    diff[3'd7-casecon] <= val[4'd8-casecon]-val[6];
                    casecon <= casecon - 1 ;
                    if(casecon == 'd1)begin
                        min  <= val[4'd8-casecon]-val[6];
                        find_index <= 4'd8-casecon;
                    end
                end
                flag5: begin
                    diff[3'd7-casecon] <= val[4'd8-casecon]-val[5];
                    casecon <= casecon - 1 ;
                    if(casecon == 'd2) begin
                        min  <= val[4'd8-casecon]-val[5];
                        find_index <=  3'd6;                   
                    end
                    else begin
                        if( (min > val[4'd8-casecon]-val[5]) && ((val[4'd8-casecon]-val[5])> 0 ))begin
                            min <= val[4'd8-casecon]-val[5];
                            find_index <= 4'd8-casecon;
                        end
                    end
                end
                flag4: begin
                    diff[3'd7-casecon] <= val[4'd8-casecon]-val[4];
                    casecon <= casecon - 1 ;
                    if(casecon == 'd3) begin
                        min  <= val[4'd8-casecon]-val[4];
                        find_index <=  3'd5;
                    end
                    else
                        if((min > val[4'd8-casecon]-val[4]) && ((val[4'd8-casecon]-val[4])> 0 ))begin
                            min <= val[4'd8-casecon]-val[4];
                            find_index <= 4'd8-casecon;
                        end
                end
                flag3: begin
                    diff[3'd7-casecon] <= val[4'd8-casecon]-val[3];
                    casecon <= casecon - 1 ;
                    if(casecon == 'd4) begin
                        min  <= val[4'd8-casecon]-val[3];
                        find_index <=  3'd4;
                    end
                    else
                        if((min > val[4'd8-casecon]-val[3]) && ((val[4'd8-casecon]-val[3])> 0 ))begin
                            min <= val[4'd8-casecon]-val[3];
                            find_index <= 4'd8-casecon;
                        end
                end
                flag2: begin
                    diff[3'd7-casecon] <= val[4'd8-casecon]-val[2];
                casecon <= casecon - 1 ;
                    if(casecon == 'd5) begin
                        min  <= val[4'd8-casecon]-val[2];
                        find_index <=  3'd3;
                    end
                    else
                        if((min > val[4'd8-casecon]-val[2]) && ((val[4'd8-casecon]-val[2])> 0 ))begin
                            min <= val[4'd8-casecon]-val[2];
                            find_index <= 4'd8-casecon;
                        end
                end
                flag1: begin
                    diff[3'd7-casecon] <= val[4'd8-casecon]-val[1];
                    casecon <= casecon - 1 ;
                    if(casecon == 'd6) begin
                        min  <= val[4'd8-casecon]-val[1];
                        find_index <=  3'd2;
                    end
                    else
                        if((min > val[4'd8-casecon]-val[1]) && ((val[4'd8-casecon]-val[1])> 0 ))begin
                            min <= val[4'd8-casecon]-val[1];
                            find_index <= 4'd8-casecon;
                        end
                end
                flag0: begin
                    diff[3'd7-casecon] <= val[4'd8-casecon]-val[0];
                    casecon <= casecon - 1 ;
                    if(casecon == 'd7) begin
                        min  <= val[4'd8-casecon]-val[0];
                        find_index <=  3'd1;
                    end
                    else
                        if((min > val[4'd8-casecon]-val[0]) && ((val[4'd8-casecon]-val[0])> 0 ))begin
                            min <= val[4'd8-casecon]-val[0];
                            find_index <= 4'd8-casecon;
                        end
                end
            endcase
            end
            STATE_SWAP : begin    //4
                casecon <= 0;
                cnt2 <= cnt2 + 1;
                case(1'b1)
                    flag6: begin
                        val[6] <= val[7];
                        val[7] <= val[6];
//                        swap_fin <= 1;
                    end
                    flag5: begin
                        if(~cnt2) begin 
                            val[5] <= val[find_index];
                            val[find_index] <= val[5];
                            swap_fin <= 1;
                        end
                        else begin
                           val[6] <= val[7];
                           val[7] <= val[6];
                           
                        end
                    end
                    flag4: begin
                        if(~cnt2) begin 
                            val[4] <= val[find_index];
                            val[find_index] <= val[4];
                            swap_fin <= 1;
                        end
                        else begin
                           val[5] <= val[7];
                           val[7] <= val[5];
                           
                        end
                    end
                    flag3: begin
                        if(~cnt2) begin 
                            val[3] <= val[find_index];
                            val[find_index] <= val[3];
                            swap_fin <= 1;
                        end
                        else begin
                           val[4] <= val[7];
                           val[7] <= val[4];
                           val[5] <= val[6];
                           val[6] <= val[5];
                           
                        end
                    end
                    flag2: begin
                        if(~cnt2) begin 
                            val[2] <= val[find_index];
                            val[find_index] <= val[2];
                            swap_fin <= 1;
                        end
                        else begin
                           val[3] <= val[7];
                           val[7] <= val[3];
                           val[4] <= val[6];
                           val[6] <= val[4];
                           
                        end
                    end
                    flag1: begin
                        if(~cnt2) begin 
                            val[1] <= val[find_index];
                            val[find_index] <= val[1];
                            swap_fin <= 1;
                        end
                        else begin
                           val[2] <= val[7];
                           val[7] <= val[2];
                           val[3] <= val[6];
                           val[6] <= val[3];
                           val[4] <= val[5];
                           val[5] <= val[4];                           
                           
                        end
                    end
                    flag0: begin
                        if(~cnt2) begin 
                            val[0] <= val[find_index];
                            val[find_index] <= val[0];
                            swap_fin <= 1; 
                        end
                        else begin
                           val[1] <= val[7];
                           val[7] <= val[1];
                           val[2] <= val[6];
                           val[6] <= val[2];
                           val[3] <= val[5];
                           val[5] <= val[3]; 


                        //    if(val[0] == 3'd0 &&
                        //  val[1] == 3'd7 &&
                        //  val[2] == 3'd6 &&
                        //  val[3] == 3'd5 &&
                        //  val[4] == 3'd4 &&
                        //  val[5] == 3'd3 &&
                        //  val[6] == 3'd2 &&
                        //  val[7] == 3'd1 )
                        //  $stop;
                            
                        end
                    end
                endcase
            end
            STATE_ADD : begin
                cnt2 <= 0;
                find_index <= 3'd0;
                swap_fin <= 0;
                if (MinCost > MinCost_wire)begin
                    MinCost <= MinCost_wire;
                    MatchCount <=  1;
                end  
                else if(MinCost == MinCost_wire)begin
                    MatchCount <=  MatchCount + 1;
                end
                flag0 <= 0;  
                flag1 <= 0;   
                flag2 <= 0;
                flag3 <= 0;
                flag4 <= 0;
                flag5 <= 0;
                flag6 <= 0;       

                //$display ("worker: %3d %3d %3d %3d %3d %3d %3d %3d",val[0],val[1],val[2],val[3],val[4],val[5],val[6],val[7]);
                
             /*   if(val[0] == 3'd1 &&
                     val[1] == 3'd0 &&
                     val[2] == 3'd7 &&
                     val[3] == 3'd6 &&
                     val[4] == 3'd5 &&
                     val[5] == 3'd4 &&
                     val[6] == 3'd3 &&
                     val[7] == 3'd2 )
                     $stop;
                $display($time);
*/
            end
        endcase
    end
    


end

endmodule


