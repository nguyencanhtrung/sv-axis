//---------------------------------------------------------------------------
//           ___  _    __         =        ___  _  __    __ ___            --   
//          / ._\| |  / /         =       /   | \\/ /   / // ._\           --         
//          \ __ | | / /          =      / /| |  / /   / / \ __            --
//        ____. \| |/ /           =     / /_| | / /\  / /____. \           --
//       /______/|___/            =    /_/  |_|/_/ \\/_//______/           --
//                              =====                                      --
//                               ===                                       --
//------------------------------  =  ----------------------------------------
// Copyright © 2023, 2024 - Nguyen Canh Trung
// (nguyencanhtrung 'at' me 'dot' com)
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//
// DEPENDENCIES: none
// Language: SystemVerilog 

`timescale 1ns / 1ps

module tb;

localparam REPO         = "";
localparam REPO_DIN     = "";
localparam REPO_DOUT    = REPO_DIN;

// ---------------------------------
// Local parameters
// ---------------------------------
localparam DATA_WIDTH    = 128;
localparam DEPTH         = 16;
localparam KEEP_ENABLE   = 0;
localparam KEEP_WIDTH    = 1;
localparam LAST_ENABLE   = 1;
localparam ID_ENABLE     = 0;
localparam ID_WIDTH      = 1;
localparam DEST_ENABLE   = 0;
localparam DEST_WIDTH    = 1;
localparam USER_ENABLE   = 0;
localparam USER_WIDTH    = 1;

localparam CLK_PERIOD    = 10;

// ---------------------------------
// Clock and reset
// ---------------------------------
logic clk, rst;

initial begin
    clk = 0;
    forever begin
        clk = #(CLK_PERIOD/2) ~clk;
    end
end

initial begin
    rst = 1;
    #(10* CLK_PERIOD);
    @(posedge clk) rst = 0;
end

// ---------------------------------
// Interface
// ---------------------------------
ifc_axis #(
    .DATA_WIDTH(DATA_WIDTH),
    .KEEP_WIDTH(KEEP_WIDTH),
    .USER_WIDTH(USER_WIDTH),
    .ID_WIDTH(ID_WIDTH),
    .DEST_WIDTH(DEST_WIDTH)
    ) s_axis_ifc (clk, rst);

ifc_axis #(
    .DATA_WIDTH(DATA_WIDTH),
    .KEEP_WIDTH(KEEP_WIDTH),
    .USER_WIDTH(USER_WIDTH),
    .ID_WIDTH(ID_WIDTH),
    .DEST_WIDTH(DEST_WIDTH)
    ) m_axis_ifc (clk, rst);

// ---------------------------------
// DUT
// ---------------------------------
axis_fifo #(
    .DATA_WIDTH     (DATA_WIDTH),
    .DEPTH          (DEPTH),
    .KEEP_ENABLE    (KEEP_ENABLE),
    .KEEP_WIDTH     (KEEP_WIDTH),
    .LAST_ENABLE    (LAST_ENABLE),
    .ID_ENABLE      (ID_ENABLE),
    .ID_WIDTH       (ID_WIDTH),
    .DEST_ENABLE    (DEST_ENABLE),
    .DEST_WIDTH     (DEST_WIDTH),
    .USER_ENABLE    (USER_ENABLE),
    .USER_WIDTH     (USER_WIDTH)
) dut (
    .s_axis_ifc     (s_axis_ifc),
    .m_axis_ifc     (m_axis_ifc)
);

// ---------------------------------
// Simulation
// ---------------------------------

// ---- Back pressure -----------------
initial begin
    // m_axis_ifc.tready = 1'b1;
    while(1) begin
        @(posedge clk) m_axis_ifc.tready = $random % 2;
        @(posedge clk);
    end
end

// ---- Data generation --------------
logic [DATA_WIDTH-1:0] mem [0:2047];
initial begin
    #(2*CLK_PERIOD);
    for(int i = 0; i < 2048; i++) begin
        mem[i] = $urandom;
    end
end

// ---- Streaming input --------------------
initial begin
    static integer ii;
    static logic test_done;
    ii = 0;
    test_done = 0;
    
    $display("Start simulation!");
    s_axis_ifc.tvalid = 1'b0;
    s_axis_ifc.tlast = 1'b0;
    
    #(10*CLK_PERIOD);
    #(10*CLK_PERIOD);

    @(posedge clk)
    while(!test_done) begin
        while(!s_axis_ifc.tready) @(posedge clk);
        s_axis_ifc.tdata    = mem[ii%2048];
        s_axis_ifc.tvalid   = $random % 2;
        ii = (s_axis_ifc.tvalid ) ? ii + 1 : ii;

        if(ii == 20482048) begin
            test_done = 1;
        end

        s_axis_ifc.tlast = test_done;
        @(posedge clk);
    end
end

// ---- Self checking  --------------------
int err;
initial begin
    static integer ii;
    static logic check_done;
    ii = 0;
    check_done = 0;
    #(10*CLK_PERIOD);

    @(posedge clk)
    while(!check_done) begin
        while(!(m_axis_ifc.tvalid & m_axis_ifc.tready)) @(posedge clk);
        if(m_axis_ifc.tdata !== mem[ii%2048]) begin
            $display("Error at %d", ii);
            $write("\n  Expected: %h", mem[ii%2048]);
            $write("\n  Received: %h\n", m_axis_ifc.tdata);
            $finish;
        end
        ii++;
        check_done = m_axis_ifc.tlast;
        @(posedge clk);
    end

    $display("AXIS FIFO: PASSED!");
    $display("Simulation done!");
    $finish;
end


endmodule
