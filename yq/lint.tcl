

source /home/liuyunqi/tree/flexfile/demo/lint/lint.tcl

fde_add -obj lint.user_config -name user_config -position on {
    set design(top_name)    "os_pe_array"
    set design(filelist)    "/home/liuyunqi/tree/systolic_array/yq/filelist.f"
    set lint(waiver)        "/home/liuyunqi/tree/systolic_array/yq/empty.awl"


}