class alu_driver extends uvm_driver#(alu_seq_item);
  `uvm_component_utils(alu_driver)

  function new(string name = "alu_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

//  int count = 0;
  virtual alu_inf drv_inf;
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual alu_inf)::get(this, "", "alu_inf", drv_inf)) begin
      `uvm_error("DRV", "Set failed")
    end
  endfunction

   function int single_operand(input logic MODE, input logic [`CMD_WIDTH-1:0] CMD);

    if(MODE) begin
      case(CMD)
        0,1,2,3,8,9,10,11: return 0;
        default: return 1;
      endcase
    end
    else begin
      case(CMD)
        0,1,2,3,4,5,12,13: return 0;
        default: return 1;
      endcase
    end

  endfunction
  task drive_inf();
      drv_inf.drv_cb.INP_VALID <= req.INP_VALID;
      drv_inf.drv_cb.CMD <= req.CMD;
      drv_inf.drv_cb.MODE <= req.MODE;
      drv_inf.drv_cb.OPA <= req.OPA;
      drv_inf.drv_cb.OPB <= req.OPB;
      drv_inf.drv_cb.CIN <= req.CIN;
  endtask

  bit flag = 0;
task run_phase(uvm_phase phase);
  repeat(3)@(drv_inf.drv_cb);
  forever begin
    seq_item_port.get_next_item(req);
    req.CMD.rand_mode(1);
    req.MODE.rand_mode(1);
    if(req.INP_VALID == 3 || req.INP_VALID == 0) begin
      drive_inf();
     `uvm_info("DRV", $sformatf("Driver driving : INP_VALID = %d| MODE = %d| CMD = %d| OPA = %d| OPB = %d\n", req.INP_VALID, req.MODE, req.CMD, req.OPA, req.OPB), UVM_NONE)
      repeat(1)@(drv_inf.drv_cb);
    end
    else begin
      if(single_operand(req.MODE, req.CMD)) begin
        drive_inf();
        `uvm_info("DRV", $sformatf("Driver driving : INP_VALID = %d| MODE = %d| CMD = %d| OPA = %d| OPB = %d\n", req.INP_VALID, req.MODE, req.CMD, req.OPA, req.OPB), UVM_NONE)
        repeat(1)@(drv_inf.drv_cb);
      end
      else if (req.INP_VALID == 1 || req.INP_VALID == 2)begin
        drive_inf();
        req.CMD.rand_mode(0);
        req.MODE.rand_mode(0);
        for(int i = 0; i < 16; i++) begin
          repeat(1)@(drv_inf.drv_cb);
          assert(req.randomize());
          drive_inf();
          `uvm_info("DRV", $sformatf("Driver driving : INP_VALID = %d| MODE = %d| CMD = %d| OPA = %d| OPB = %d\n", req.INP_VALID, req.MODE, req.CMD, req.OPA, req.OPB), UVM_NONE)
          if(req.INP_VALID == 3) begin
            flag = 1;
            repeat(1)@(drv_inf.drv_cb);
            break;
          end
        end
        if(!flag)begin
          uvm_config_db#(bit)::set(this, "*", "ERR", 1);
          @(drv_inf.drv_cb);
        end
        else
          uvm_config_db#(bit)::set(this, "*", "ERR", 0);
      end
    end
    repeat(2)@(drv_inf.drv_cb);
    if(req.MODE == 1 && (req.CMD == 9 || req.CMD == 10)) begin
      repeat(1)@(drv_inf.drv_cb);
    end
    seq_item_port.item_done();
  end
endtask
endclass
