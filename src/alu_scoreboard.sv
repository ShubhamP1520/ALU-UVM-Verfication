class alu_scb extends uvm_scoreboard;
  `uvm_component_utils(alu_scb)

  uvm_analysis_imp#(alu_seq_item, alu_scb) analysis_export;

  alu_seq_item scb_item;
  alu_seq_item ref_pkt;
  virtual alu_inf vif;
  logic [`SHIFT_W -1 :0] shift_a;
  int match;
  int missmatch;

  function new(string name = "alu_scb", uvm_component parent);
    super.new(name, parent);
    analysis_export = new("analysis_export", this);
    //ref_pkt = new();
  endfunction

  alu_seq_item seq_q[$];

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual alu_inf)::get(this, "", "alu_inf", vif)) begin
      `uvm_error("SCB", "Set Failed")
    end
    scb_item = alu_seq_item::type_id::create("scb_item");
    ref_pkt = alu_seq_item::type_id::create("ref_pkt");
  endfunction

  task perform_operations(alu_seq_item ref_pkt);
      if(vif.ref_cb.RST) begin
      ref_pkt.RES = 9'dz;
      ref_pkt.COUT = 1'bz;
      ref_pkt.OFLOW = 1'bz;
      ref_pkt.ERR = 1'bz;
      ref_pkt.G = 1'bz;
      ref_pkt.L = 1'bz;
      ref_pkt.E = 1'bz;
    end
    else if(vif.ref_cb.CE) begin
      ref_pkt.RES = 9'bzzzzzzzzz;
      ref_pkt.COUT = 1'bz;
      ref_pkt.OFLOW = 1'bz;
      ref_pkt.ERR = 1'bz;
      ref_pkt.G = 1'bz;
      ref_pkt.L = 1'bz;
      ref_pkt.E = 1'bz;
      if(ref_pkt.MODE) begin

        case(ref_pkt.INP_VALID)
          2'b01:begin
            case(ref_pkt.CMD)
              4: begin
                ref_pkt.RES = ref_pkt.OPA + 1;
                ref_pkt.COUT = ref_pkt.RES[`OP_WIDTH];
              end
              5: begin
                ref_pkt.RES = ref_pkt.OPA - 1;
                ref_pkt.OFLOW = ref_pkt.RES[`OP_WIDTH];
                $display(" RES = %0d", ref_pkt.RES);
              end
              default: ref_pkt.ERR = 1'b1;
            endcase
          end

          2'b10:begin
            case(ref_pkt.CMD)
              6: begin
                ref_pkt.RES = ref_pkt.OPB + 1;
                ref_pkt.COUT = ref_pkt.RES[`OP_WIDTH];
              end
              7: begin
                ref_pkt.RES = ref_pkt.OPB - 1;
                ref_pkt.OFLOW = ref_pkt.RES[`OP_WIDTH];
              end
              default: ref_pkt.ERR = 1'b1;
            endcase
          end
          2'b11: begin
            case(ref_pkt.CMD)
              0: begin
                ref_pkt.RES = ref_pkt.OPA + ref_pkt.OPB;
                ref_pkt.COUT = ref_pkt.RES[`OP_WIDTH];
              end
              1: begin
                ref_pkt.RES = ref_pkt.OPA - ref_pkt.OPB;
                ref_pkt.OFLOW = (ref_pkt.OPA < ref_pkt.OPB);
              end
              2: begin
                ref_pkt.RES =ref_pkt.OPA + ref_pkt.OPB + ref_pkt.CIN;
                ref_pkt.COUT = ref_pkt.RES[`OP_WIDTH];
              end
              3: begin
                ref_pkt.RES =ref_pkt.OPA - ref_pkt.OPB - ref_pkt.CIN;
                ref_pkt.OFLOW = (ref_pkt.OPA < (ref_pkt.OPB + ref_pkt.CIN));

              end
              4: begin
                ref_pkt.RES = ref_pkt.OPA + 1;
                //ref_pkt.COUT = ref_pkt.RES[`OP_WIDTH];
              end
              5: begin
                ref_pkt.RES = ref_pkt.OPA - 1;
               // ref_pkt.OFLOW = ref_pkt.RES[`OP_WIDTH];
                $display(" RES = %0d", ref_pkt.RES);
             end
              6: begin
                ref_pkt.RES = ref_pkt.OPB + 1;
                ref_pkt.COUT = ref_pkt.RES[`OP_WIDTH];
              end
              7: begin
                ref_pkt.RES = ref_pkt.OPB - 1;
                ref_pkt.OFLOW = ref_pkt.RES[`OP_WIDTH];
              end
              8: begin
                if(ref_pkt.OPA == ref_pkt.OPB) begin
                  ref_pkt.E = 1;
                  ref_pkt.G = 1'bz;
                  ref_pkt.L = 1'bz;
                end
                else if(ref_pkt.OPA > ref_pkt.OPB) begin
                   ref_pkt.E = 1'bz;
                   ref_pkt.G = 1;
                   ref_pkt.L = 1'bz;
                end
                else begin
                  ref_pkt.E = 1'bz;
                  ref_pkt.G = 1'bz;
                  ref_pkt.L = 1;
                end
              end
              9: begin
                ref_pkt.RES = (ref_pkt.OPA + 1) * (ref_pkt.OPB + 1);
              end
              10: begin
                ref_pkt.RES = (ref_pkt.OPA << 1) * (ref_pkt.OPB);
              end
              default : ref_pkt.ERR = 1'b1;
            endcase
          end
          default: ref_pkt.ERR = 1'b1;
        endcase
      end
      else begin
        ref_pkt.RES = 9'bzzzzzzzzz;
        ref_pkt.COUT = 1'bz;
        ref_pkt.OFLOW = 1'bz;
        ref_pkt.ERR = 1'bz;
        ref_pkt.G = 1'bz;
        ref_pkt.L = 1'bz;
        ref_pkt.E = 1'bz;

        case(ref_pkt.INP_VALID)
          2'b01:begin
            case(ref_pkt.CMD)
              6 : ref_pkt.RES = {1'b0, ~(ref_pkt.OPA)};
              8 : ref_pkt.RES = ref_pkt.OPA >> 1;
              9 : ref_pkt.RES = ref_pkt.OPA << 1;
              default: ref_pkt.ERR = 1'b1;
            endcase
          end

          2'b10:begin
            case(ref_pkt.CMD)
              7 : ref_pkt.RES = {1'b0, ~(ref_pkt.OPB)};
              10 : ref_pkt.RES = ref_pkt.OPB >> 1;
              11 : ref_pkt.RES = ref_pkt.OPB << 1;
              default: ref_pkt.ERR = 1'b1;
            endcase
          end
          2'b11: begin
            case(ref_pkt.CMD)
              0 : ref_pkt.RES = ref_pkt.OPA & ref_pkt.OPB;
              1 : ref_pkt.RES = {1'b0, ~(ref_pkt.OPA & ref_pkt.OPB)};
              2 : ref_pkt.RES = ref_pkt.OPA | ref_pkt.OPB;
              3 : ref_pkt.RES = {1'b0, ~(ref_pkt.OPA | ref_pkt.OPB)};
              4 : ref_pkt.RES = ref_pkt.OPA ^ ref_pkt.OPB;
              5 : ref_pkt.RES = {1'b0, ~(ref_pkt.OPA ^ ref_pkt.OPB)};
              6 : ref_pkt.RES = {1'b0,~(ref_pkt.OPA)};
              7 : ref_pkt.RES = {1'b0,~(ref_pkt.OPB)};
              8 : ref_pkt.RES = ref_pkt.OPA >> 1;
              9 : ref_pkt.RES = ref_pkt.OPA << 1;
              10 : ref_pkt.RES = ref_pkt.OPB >> 1;
              11 : ref_pkt.RES = ref_pkt.OPB << 1;
              12: begin
                if(|ref_pkt.OPB[`OP_WIDTH-1: `SHIFT_W+1])
                  ref_pkt.ERR = 1;
                else begin
                  shift_a = ref_pkt.OPB[`SHIFT_W-1:0];
                  ref_pkt.RES = {1'b0, (ref_pkt.OPA << shift_a)|(ref_pkt.OPA >> (`OP_WIDTH - shift_a))};
                end
              end
              13: begin
                if(|ref_pkt.OPB[`OP_WIDTH-1:`SHIFT_W+1])
                  ref_pkt.ERR = 1;
                else begin
                  shift_a = ref_pkt.OPB[`SHIFT_W-1:0];
                  ref_pkt.RES = {1'b0, (ref_pkt.OPA >> shift_a)|(ref_pkt.OPA << (`OP_WIDTH - shift_a))};
                end
              end

              default : ref_pkt.ERR = 1'b1;
            endcase
          end
          default: ref_pkt.ERR = 1'b1;
        endcase
      end
    end
  endtask

  function void write(alu_seq_item req);
    seq_q.push_back(req);
  endfunction

  task run_phase(uvm_phase phase);
    bit ERR;
    forever begin
      wait(seq_q.size > 0);
      scb_item = seq_q.pop_front();
      void'(uvm_config_db#(bit)::get(this,"", "ERR", ERR));
      ref_pkt.ERR = ERR;
      ref_pkt.copy(scb_item);
      perform_operations(ref_pkt);
      //scb_item.print();
      //repeat(2)@(vif.ref_cb);
      $display("________________________________________________________________________________________________________________________________________");
      $display("");
      `uvm_info("SCB", $sformatf("Expected OP : RES = %0d ERR = %0d", ref_pkt.RES, ref_pkt.ERR), UVM_NONE)
      `uvm_info("SCB", $sformatf("Actual OP = %0d ERR = %0d", scb_item.RES, scb_item.ERR), UVM_NONE)
      if(scb_item.compare(ref_pkt)) begin
        `uvm_info("SCB","PASS", UVM_NONE)
        match++;
      end
      else begin
        `uvm_info("SCB","FAIL", UVM_NONE)
        missmatch++;
      end
      `uvm_info("SCB",$sformatf("Matches = %0d | Missmatches = %0d ", match, missmatch), UVM_NONE)
      $display("________________________________________________________________________________________________________________________________________");
    end
  endtask
endclass
