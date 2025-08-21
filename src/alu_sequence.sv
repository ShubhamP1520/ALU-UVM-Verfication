class alu_seq extends uvm_sequence#(alu_seq_item);
  `uvm_object_utils(alu_seq)

  function new(string name = "alu_seq");
    super.new(name);
  endfunction

  alu_seq_item req;

  task body();
    repeat(`no_of_transactions) begin
      req = alu_seq_item::type_id::create("req");
      wait_for_grant();
      if(!req.randomize()) begin
        `uvm_error("SEQ", "Randomization failed")
      end
      send_request(req);
      $display("==========================================================================================================================================");
      $display("");
      wait_for_item_done();
      //get_response(req);
    end
  endtask
endclass

class arithmetic_single_op extends uvm_sequence#(alu_seq_item);
  `uvm_object_utils(arithmetic_single_op)

  function new(string name = "arithmetic_single_op");
    super.new(name);
  endfunction
  alu_seq_item req;
  task body();
    repeat(`no_of_transactions) begin
    `uvm_do_with(req, {req.CMD inside {[4:7]}; req.INP_VALID == 3; req.MODE == 1;})
    end
  endtask
endclass

class arithmetic_two_op extends uvm_sequence#(alu_seq_item);
  `uvm_object_utils(arithmetic_two_op)

  function new(string name = "arithmetic_two_op");
    super.new(name);
  endfunction

  task body();
    repeat(`no_of_transactions) begin
    `uvm_do_with(req, {req.CMD inside {[0:3],[8:10]}; req.INP_VALID == 3; req.MODE == 1;})
    end
  endtask
endclass


class logical_single_op extends uvm_sequence#(alu_seq_item);
  `uvm_object_utils(logical_single_op)

  function new(string name = "logical_single_op");
    super.new(name);
  endfunction

  task body();
    repeat(`no_of_transactions) begin
    `uvm_do_with(req, {req.CMD inside {[6:11]}; req.INP_VALID == 3; req.MODE == 0;})
    end
  endtask
endclass


class logical_two_op extends uvm_sequence#(alu_seq_item);
  `uvm_object_utils(logical_two_op)

  function new(string name = "logical_two_op");
    super.new(name);
  endfunction

  task body();
    repeat(`no_of_transactions) begin
    `uvm_do_with(req, {req.CMD inside {[0:5], 12, 13}; req.INP_VALID == 3; req.MODE == 0;})
    `uvm_info(get_type_name(),$sformatf("sequence item: INP_VALID = %d| MODE = %d | CMD = %d |OPA = %d| OPB = %d|", req.INP_VALID,req.MODE, req.CMD, req.OPA, req.OPB), UVM_NONE)
    end
  endtask
endclass

class error_seq extends uvm_sequence#(alu_seq_item);
  `uvm_object_utils(error_seq)

  function new(string name = "error_seq");
    super.new(name);
  endfunction

  task body();
    repeat(`no_of_transactions) begin
      `uvm_do_with(req, {req.INP_VALID == 1;})
      `uvm_info(get_type_name(),$sformatf("sequence item: INP_VALID = %d| MODE = %d | CMD = %d |OPA = %d| OPB = %d|", req.INP_VALID,req.MODE, req.CMD, req.OPA, req.OPB), UVM_NONE)
    end
  endtask
endclass

class regression_seq extends uvm_sequence#(alu_seq_item);
  `uvm_object_utils(regression_seq)

  alu_seq seq;
  arithmetic_single_op seq1;
  arithmetic_two_op seq2;
  logical_single_op seq3;
  logical_two_op seq4;
  error_seq seq5;

  function new(string name= "regression_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_do(seq)

    `uvm_do(seq1)

    `uvm_do(seq2)

    `uvm_do(seq3)

    `uvm_do(seq4)

//    `uvm_do(seq5)

  endtask
endclass
