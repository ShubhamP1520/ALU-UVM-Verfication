class alu_test extends uvm_test;
  `uvm_component_utils(alu_test)

  function new(string name = "alu_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  alu_env env;
  alu_seq seq;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = alu_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = alu_seq::type_id::create("seq");
   `uvm_info("TEST", "The seq is created successfully", UVM_NONE)
    seq.start(env.a_agt.seqr);
    phase.drop_objection(this);
  endtask
endclass

class arithmetic_single_test extends alu_test;
  `uvm_component_utils(arithmetic_single_test)

  function new(string name = "arithmetic_single_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  arithmetic_single_op aseq1;

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    aseq1 = arithmetic_single_op::type_id::create("aseq1");
    aseq1.start(env.a_agt.seqr);
    phase.drop_objection(this);
  endtask
endclass

class arithmetic_two_test extends alu_test;
  `uvm_component_utils(arithmetic_two_test)

  function new(string name = "arithmetic_two_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  arithmetic_two_op aseq2;

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    aseq2 = arithmetic_two_op::type_id::create("aseq2");
    aseq2.start(env.a_agt.seqr);
    phase.drop_objection(this);
  endtask
endclass

class logical_single_test extends alu_test;
  `uvm_component_utils(logical_single_test)

  function new(string name = "logical_two_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  logical_single_op lseq1;

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    lseq1 = logical_single_op::type_id::create("lseq2");
    lseq1.start(env.a_agt.seqr);
    phase.drop_objection(this);
  endtask
endclass

class logical_two_test extends alu_test;
  `uvm_component_utils(logical_two_test)

  function new(string name = "logical_two_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  logical_two_op lseq2;

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    lseq2 = logical_two_op::type_id::create("lseq2");
    lseq2.start(env.a_agt.seqr);
    phase.drop_objection(this);
  endtask
endclass

class error_test extends alu_test;
  `uvm_component_utils(error_test)

  function new(string name = "error_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  error_seq eseq;

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    eseq = error_seq::type_id::create("eseq");
    eseq.start(env.a_agt.seqr);
    phase.drop_objection(this);
  endtask
endclass

class regression_test extends alu_test;
  `uvm_component_utils(regression_test)

  function new(string name = "regression_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  regression_seq rseq;

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    rseq = regression_seq::type_id::create("rseq");
    rseq.start(env.a_agt.seqr);
//    phase.phase_done.set_drain_time(this, 50);
    phase.drop_objection(this);
  endtask
endclass
