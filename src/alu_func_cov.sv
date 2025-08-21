`uvm_analysis_imp_decl(_mon_cg)
`uvm_analysis_imp_decl(_drv_cg)

class alu_cov extends uvm_component;
  `uvm_component_utils(alu_cov)
  uvm_analysis_imp_mon_cg#(alu_seq_item, alu_cov) analysis_cov_op_export;
  uvm_analysis_imp_drv_cg#(alu_seq_item, alu_cov) analysis_cov_ip_export;

  alu_seq_item transd;
  alu_seq_item transm;

  covergroup drv_cg;
    MODE_CP: coverpoint transd.MODE;
    INP_VALID_CP : coverpoint transd.INP_VALID;
    CMD_CP : coverpoint transd.CMD {
      bins valid_cmd[] = {[0:13]};
      ignore_bins invalid_cmd[] = {14, 15};
    }
    OPA_CP : coverpoint transd.OPA {
      bins all_zeros_a = {0};
      bins opa = {[0:`MAX]};
      bins all_ones_a = {`MAX};
    }
    OPB_CP : coverpoint transd.OPB {
      bins all_zeros_b = {0};
      bins opb = {[0:`MAX]};
      bins all_ones_b = {`MAX};
    }
    CIN_CP : coverpoint transd.CIN;
    CMD_X_IP_V: cross CMD_CP, INP_VALID_CP;
    MODE_X_INP_V: cross MODE_CP, INP_VALID_CP;
    MODE_X_CMD: cross MODE_CP, CMD_CP;
    OPA_X_OPB : cross OPA_CP, OPB_CP;
  endgroup

  covergroup mon_cg;
      RES_CP : coverpoint transm.RES {
        bins all_zero = {0};
        bins all_ones = {9'b111111111};
        bins others = default;
      }
      ERR_CP : coverpoint transm.ERR;
      E_CP : coverpoint transm.E { bins one_e = {1};
      }
      G_CP : coverpoint transm.G { bins one_g = {1};
      }
      L_CP : coverpoint transm.L { bins one_l = {1};
      }
      OV_CP: coverpoint transm.OFLOW;
      COUT_CP: coverpoint transm.COUT;
  endgroup

  function new(string name = "alu_cov", uvm_component parent);
    super.new(name, parent);
    drv_cg = new;
    mon_cg = new;
    analysis_cov_ip_export = new("analysis_cov_ip_export", this);
    analysis_cov_op_export = new("analysis_cov_op_export", this);
  endfunction

  virtual function void write_drv_cg(alu_seq_item req);
    transd = req;
    drv_cg.sample();
   // mon_cg.sample();
  endfunction

  virtual function void write_mon_cg(alu_seq_item req);
        transm = req;
        //drv_cg.sample();
        mon_cg.sample();
  endfunction

endclass
