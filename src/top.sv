`include "uvm_macros.svh"
`include "alu.v"
`include "interface.sv"

module top;
  import uvm_pkg::*;
  import my_pkg::*;

  bit clk, reset, CE;

  alu_inf inf(clk, reset, CE);

  ALU_DESIGN  DUT(.CLK(clk),
                 .RST(reset),
                 .CE(CE),
                 .INP_VALID(inf.INP_VALID),
                 .MODE(inf.MODE),
                 .CMD(inf.CMD),
                 .CIN(inf.CIN),
                 .ERR(inf.ERR),
                 .RES(inf.RES),
                 .OPA(inf.OPA),
                 .OPB(inf.OPB),
                 .OFLOW(inf.OFLOW),
                 .COUT(inf.COUT),
                 .G(inf.G),
                 .L(inf.L),
                 .E(inf.E));


  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    CE = 1;
    reset = 1;
    #5;
    reset = 0;

    #10 reset = 1;
    #20 reset = 0;
    #10 CE = 0;
    #20 CE = 1;
  end

  initial begin
    uvm_top.finish_on_completion = 1;
    uvm_config_db#(virtual alu_inf)::set(null, "*", "alu_inf", inf);
    run_test("regression_test");
  end

endmodule
