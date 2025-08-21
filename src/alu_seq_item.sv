class alu_seq_item extends uvm_sequence_item;
   //Inputs with "rand" to randomize values
  rand logic [1:0] INP_VALID;
  rand logic MODE;
  rand logic [`CMD_WIDTH-1:0] CMD;
  rand logic [`OP_WIDTH-1:0] OPA;
  rand logic [`OP_WIDTH-1:0] OPB;
  rand logic CIN;

  //Outputs are declared without rand keyword
  logic ERR;
  logic [`OP_WIDTH:0] RES;
  logic OFLOW;
  logic COUT;
  logic G;
  logic L;
  logic E;

   `uvm_object_utils_begin(alu_seq_item)
    `uvm_field_int(INP_VALID, UVM_ALL_ON)
    `uvm_field_int(MODE, UVM_ALL_ON)
    `uvm_field_int(CMD, UVM_ALL_ON)
    `uvm_field_int(OPA, UVM_ALL_ON)
    `uvm_field_int(OPB, UVM_ALL_ON)
    `uvm_field_int(CIN, UVM_ALL_ON)
    `uvm_field_int(ERR, UVM_ALL_ON)
    `uvm_field_int(RES, UVM_ALL_ON)
    `uvm_field_int(OFLOW, UVM_ALL_ON)
    `uvm_field_int(COUT, UVM_ALL_ON)
    `uvm_field_int(G, UVM_ALL_ON)
    `uvm_field_int(L, UVM_ALL_ON)
    `uvm_field_int(E, UVM_ALL_ON)
  `uvm_object_utils_end

  //constraint cons{soft CMD inside {[0:12]}; INP_VALID inside {[1:2]};}

  function new(string name = "alu_seq_item");
    super.new(name);
  endfunction
endclass
