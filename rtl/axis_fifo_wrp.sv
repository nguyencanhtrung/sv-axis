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
// DEPENDENCIES: 
//    - Children: axis_fifo.sv, ifc_axis.sv
//
// Language: SystemVerilog

`timescale 1ns/1ps

module axis_fifo_wrp #(
    parameter DATA_WIDTH    = 8,
    parameter DEPTH         = 64,
    parameter KEEP_ENABLE   = (DATA_WIDTH > 8),
    parameter KEEP_WIDTH    = ((DATA_WIDTH+7)/8),
    parameter LAST_ENABLE   = 0,
    parameter ID_ENABLE     = 0,
    parameter ID_WIDTH      = 8,
    parameter DEST_ENABLE   = 0,
    parameter DEST_WIDTH    = 8,
    parameter USER_ENABLE   = 0,
    parameter USER_WIDTH    = 1
)
(
    input                       clk,
    input                       rst,                // Synchronous reset (active high)

        /*
     * AXIS Slave interface
     */
    input   [DATA_WIDTH-1:0]    s_axis_tdata,       // Input data
    input                       s_axis_tvalid,      // Input data valid
    output                      s_axis_tready,      // Input data ready
    input                       s_axis_tlast,       // End of frame indicator
    input   [KEEP_WIDTH-1:0]    s_axis_tkeep,       // Input data valid
    input   [USER_WIDTH-1:0]    s_axis_tuser,       // User extension
    input   [ID_WIDTH-1:0]      s_axis_tid,         // Stream identifier
    input   [DEST_WIDTH-1:0]    s_axis_tdest,       // Destination identifier

    /*
     * AXIS Master interface
     */
    output  [DATA_WIDTH-1:0]    m_axis_tdata,       // Output data
    output                      m_axis_tvalid,      // Output data valid
    input                       m_axis_tready,      // Output data ready
    output                      m_axis_tlast,       // End of frame indicator
    output  [KEEP_WIDTH-1:0]    m_axis_tkeep,       // Output data valid
    output  [USER_WIDTH-1:0]    m_axis_tuser,       // User extension
    output  [ID_WIDTH-1:0]      m_axis_tid,         // Stream identifier
    output  [DEST_WIDTH-1:0]    m_axis_tdest        // Destination identifier
);

    ifc_axis #(
        .DATA_WIDTH     (DATA_WIDTH),
        .KEEP_WIDTH     (KEEP_WIDTH),
        .ID_WIDTH       (ID_WIDTH),
        .DEST_WIDTH     (DEST_WIDTH),
        .USER_WIDTH     (USER_WIDTH)
    ) s_axis (
        .clk           (clk),
        .rst           (rst)
    );

    ifc_axis #(
        .DATA_WIDTH     (DATA_WIDTH),
        .KEEP_WIDTH     (KEEP_WIDTH),
        .ID_WIDTH       (ID_WIDTH),
        .DEST_WIDTH     (DEST_WIDTH),
        .USER_WIDTH     (USER_WIDTH)
    ) m_axis (
        .clk           (clk),
        .rst           (rst)
    );

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
    ) axis_fifo_i
    (
        .s_axis_ifc     (s_axis),
        .m_axis_ifc     (m_axis)
    );

    assign s_axis.tdata     = s_axis_tdata;
    assign s_axis.tvalid    = s_axis_tvalid;
    assign s_axis_tready    = s_axis.tready;
    assign s_axis.tlast     = s_axis_tlast;
    assign s_axis.tkeep     = s_axis_tkeep;
    assign s_axis.tuser     = s_axis_tuser;
    assign s_axis.tid       = s_axis_tid;
    assign s_axis.tdest     = s_axis_tdest;

    assign m_axis_tdata     = m_axis.tdata;
    assign m_axis_tvalid    = m_axis.tvalid;
    assign m_axis.tready    = m_axis_tready;
    assign m_axis_tlast     = m_axis.tlast;
    assign m_axis_tkeep     = m_axis.tkeep;
    assign m_axis_tuser     = m_axis.tuser;
    assign m_axis_tid       = m_axis.tid;
    assign m_axis_tdest     = m_axis.tdest;
endmodule