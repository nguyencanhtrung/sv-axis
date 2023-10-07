onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/clk
add wave -noupdate /tb/rst
add wave -noupdate -expand -group din /tb/dut/s_axis_ifc/tdata
add wave -noupdate -expand -group din /tb/dut/s_axis_ifc/tvalid
add wave -noupdate -expand -group din /tb/dut/s_axis_ifc/tready
add wave -noupdate -expand -group din /tb/dut/s_axis_ifc/tlast
add wave -noupdate -expand -group dout /tb/dut/m_axis_ifc/tdata
add wave -noupdate -expand -group dout /tb/dut/m_axis_ifc/tvalid
add wave -noupdate -expand -group dout /tb/dut/m_axis_ifc/tlast
add wave -noupdate -expand -group dout /tb/dut/m_axis_ifc/tready
add wave -noupdate -radix unsigned /tb/err
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {309525 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 300
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {482010 ps}
