proc generate {drv_handle} {
    # try to source the common tcl procs
    # assuming the order of return is based on repo priority
    foreach i [get_sw_cores device_tree] {
        set common_tcl_file "[get_property "REPOSITORY" $i]/data/common_proc.tcl"
        if {[file exists $common_tcl_file]} {
            source $common_tcl_file
            break
        }
    }
    set_drv_conf_prop $drv_handle c_can_tx_dpth xlnx,can-tx-dpth hexint
    set_drv_conf_prop $drv_handle c_can_rx_dpth xlnx,can-rx-dpth hexint

    set proc_type [get_sw_proc_prop IP_NAME]
    switch $proc_type {
        "ps7_cortexa9" {
            # for 2014.4
            set_drv_prop_if_empty $drv_handle "clock-names" "s_axi_aclk" stringlist
        } "microblaze" {}
        default {
            error "Unknown arch"
        }
    }
}
