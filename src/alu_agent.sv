class alu_agt extends uvm_agent;
  `uvm_component_utils(alu_agt)

  function new(string name = "alu_agt", uvm_component parent);
    super.new(name, parent);
  endfunction

  alu_driver drv;
  alu_monitor mon;
  alu_sequencer seqr;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", UVM_ACTIVE)) begin
      `uvm_error("AGT","Set Failed")
    end
    if(get_is_active == UVM_ACTIVE) begin
      drv = alu_driver::type_id::create("drv", this);
      seqr = alu_sequencer::type_id::create("sqr", this);
    end
    mon = alu_monitor::type_id::create("mon", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(get_is_active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(seqr.seq_item_export);
    end
  endfunction
endclass
