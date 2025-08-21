class alu_env extends uvm_env;
  `uvm_component_utils(alu_env)

  function new(string name = "alu_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  alu_agt a_agt;
  alu_agt p_agt;
  alu_scb scb;
  alu_cov cov;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_db#(uvm_active_passive_enum)::set(this, "*", "is_active", UVM_ACTIVE);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "*", "is_active", UVM_PASSIVE);

    a_agt = alu_agt::type_id::create("a_gt", this);
    p_agt =alu_agt::type_id::create("p_agt", this);
    scb = alu_scb::type_id::create("scb", this);
    cov = alu_cov::type_id::create("cov", this);
    //uvm_config_db#(agt)::set(this, "agt", "is_active()", UVM_ACTIVE);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    p_agt.mon.analysis_port.connect(scb.analysis_export);
    a_agt.mon.analysis_cov_ip_port.connect(cov.analysis_cov_ip_export);
    p_agt.mon.analysis_cov_op_port.connect(cov.analysis_cov_op_export);
  endfunction

endclass
