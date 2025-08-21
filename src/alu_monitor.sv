class alu_monitor extends uvm_monitor;
  `uvm_component_utils(alu_monitor)

  virtual alu_inf vif;
  uvm_analysis_port #(alu_seq_item) analysis_port;
  uvm_analysis_port #(alu_seq_item) analysis_cov_ip_port;
  uvm_analysis_port #(alu_seq_item) analysis_cov_op_port;
  alu_seq_item mon_item;
  alu_seq_item cov_item;

  function new(string name = "alu_monitor", uvm_component parent = null);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
    analysis_cov_ip_port = new("analysis_cov_ip_port", this);
    analysis_cov_op_port = new("analysis_cov_op_port", this);
  endfunction

  task receive_inputs();
    //$display("__________________________________________________________________________________________________________________________________________");
    //$display("");
    //`uvm_info("MON INPUTS", $sformatf(" OPA = %0d, OPB = %0d, CIN = %0d, CMD = %0d, MODE = %0d, INP_VALID = %0d",vif.OPA, vif.OPB, vif.CIN, vif.CMD, vif.MODE, vif.INP_VALID), UVM_NONE);
    mon_item.OPA = vif.mon_cb.OPA;

    mon_item.OPB = vif.mon_cb.OPB;
    mon_item.CMD = vif.mon_cb.CMD;
    mon_item.MODE = vif.mon_cb.MODE;
    mon_item.INP_VALID = vif.mon_cb.INP_VALID;
    mon_item.CIN = vif.mon_cb.CIN;
    //mon_item.RST = vif.mon_cb.RST;
    //mon_item.CE = vif.mon_cb.CE;
    analysis_cov_ip_port.write(mon_item);
  endtask

  task receive_outputs();
    mon_item.RES = vif.mon_cb.RES;
    mon_item.COUT = vif.mon_cb.COUT;
    mon_item.ERR = vif.mon_cb.ERR;
    mon_item.OFLOW = vif.mon_cb.OFLOW;
    mon_item.G = vif.mon_cb.G;
    mon_item.L = vif.mon_cb.L;
    mon_item.E = vif.mon_cb.E;

  endtask

  function int is_single_operand(input logic MODE, input logic [`CMD_WIDTH-1:0] CMD);
    if(MODE) begin // Arithmetic mode
      case(CMD)
        4,5,6,7: return 1; // Single operand arithmetic operations
        default: return 0;
      endcase
    end
    else begin // Logical mode
      case(CMD)
        6,7,8,9,10,11: return 1; // Single operand logical operations
        default: return 0;
      endcase
    end
  endfunction

  task collect();
    bit timeout_flag = 0;
    int count = 0;

    receive_inputs();
    repeat(1)@(vif.mon_cb);

    if(mon_item.INP_VALID == 3 || mon_item.INP_VALID == 0) begin
      if(mon_item.MODE == 1 && (mon_item.CMD == 9 || mon_item.CMD == 10)) begin
        repeat(1)@(vif.mon_cb); // Extra cycle for multiplication operations
      end
    end
    else begin
      if(is_single_operand(mon_item.MODE, mon_item.CMD)) begin
        `uvm_info("MON", "Single operand operation detected", UVM_LOW);
      end
      else begin
        `uvm_info("MON", "Two operand operation - entering wait loop", UVM_LOW);
        for(int i = 0; i < 16; i++) begin
          receive_inputs();
          repeat(1)@(vif.mon_cb);
          count = i + 1;

          `uvm_info("MON_LOOP", $sformatf("Loop iteration %0d: INP_VALID = %0d", i, mon_item.INP_VALID), UVM_LOW);

          if(mon_item.INP_VALID == 3) begin
            `uvm_info("MON_LOOP_COUNT", $sformatf("Valid inputs received at count = %0d", count), UVM_LOW);
            if(mon_item.MODE == 1 && (mon_item.CMD == 9 || mon_item.CMD == 10)) begin
              repeat(1)@(vif.mon_cb); // Extra cycle for multiplication
            end
            break;
          end
        end

        if(count == 16 && mon_item.INP_VALID != 3) begin
          timeout_flag = 1;
          `uvm_info("MON LOOP", "ERROR: 16-cycle timeout occurred", UVM_NONE);

          if(mon_item.MODE == 1 && (mon_item.CMD == 9 || mon_item.CMD == 10)) begin
            repeat(1)@(vif.mon_cb);
          end
        end
      end
    end
    receive_outputs();
    analysis_port.write(mon_item);
    analysis_cov_op_port.write(mon_item);

    `uvm_info("MON OUTPUTS", $sformatf("RES = %0d, ERR = %0d, COUT = %0d, OFLOW = %0d, G = %0b, L = %0b, E = %0b", vif.RES, vif.ERR, vif.COUT, vif.OFLOW, vif.G, vif.L, vif.E), UVM_LOW);
    $display("__________________________________________________________________________________________________________________________________________");
    repeat(2)@(vif.mon_cb);
  endtask

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual alu_inf)::get(this, "", "alu_inf", vif))
      `uvm_fatal("MON_BUILD", "Could not retrieve virtual interface in monitor");
  endfunction

  task run_phase(uvm_phase phase);
    repeat(4)@(vif.mon_cb);

    forever begin
      mon_item = alu_seq_item::type_id::create("mon_item");
      collect();
    end
  endtask
endclass
