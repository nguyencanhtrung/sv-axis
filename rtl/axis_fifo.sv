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
// 
// Description
//     - This is a simple FIFO module that is used to connect two AXIS interfaces
//     - The DEPTH of the FIFO is defined as the following
//       + If KEEP_ENABLE = 1, DEPTH is bytes depth, therefore, the actual depth 
//         is DEPTH/KEEP_WIDTH
//       + If KEEP_ENABLE = 0, DEPTH is the actual depth 

`timescale 1ns/1ps

module axis_fifo #(
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
    ifc_axis.slave              s_axis_ifc,         // Slave interface
    ifc_axis.master             m_axis_ifc          // Master interface 
);

    logic clk, rst;
    assign clk = s_axis_ifc.clk;
    assign rst = s_axis_ifc.rst;

    // ------------------------------------------------------------------------------------------------------------
    // AXIS interface wrapper
    // ------------------------------------------------------------------------------------------------------------
    /*
     * AXIS Slave interface
     */
    logic   [DATA_WIDTH-1:0]    s_axis_tdata;       // Input data
    logic                       s_axis_tvalid;      // Input data valid
    logic                       s_axis_tready;      // Input data ready
    logic                       s_axis_tlast;       // End of frame indicator
    logic   [KEEP_WIDTH-1:0]    s_axis_tkeep;       // Input data valid
    logic   [USER_WIDTH-1:0]    s_axis_tuser;       // User extension
    logic   [ID_WIDTH-1:0]      s_axis_tid;         // Stream identifier
    logic   [DEST_WIDTH-1:0]    s_axis_tdest;       // Destination identifier

    /*
     * AXIS Master interface
     */
    logic  [DATA_WIDTH-1:0]     m_axis_tdata;       // Output data
    logic                       m_axis_tvalid;      // Output data valid
    logic                       m_axis_tready;      // Output data ready
    logic                       m_axis_tlast;       // End of frame indicator
    logic  [KEEP_WIDTH-1:0]     m_axis_tkeep;       // Output data valid
    logic  [USER_WIDTH-1:0]     m_axis_tuser;       // User extension
    logic  [ID_WIDTH-1:0]       m_axis_tid;         // Stream identifier
    logic  [DEST_WIDTH-1:0]     m_axis_tdest;       // Destination identifier

    assign s_axis_tdata         = s_axis_ifc.tdata;
    assign s_axis_tvalid        = s_axis_ifc.tvalid;
    assign s_axis_ifc.tready    = s_axis_tready;
    assign s_axis_tlast         = s_axis_ifc.tlast;
    assign s_axis_tkeep         = s_axis_ifc.tkeep;
    assign s_axis_tuser         = s_axis_ifc.tuser;
    assign s_axis_tid           = s_axis_ifc.tid;
    assign s_axis_tdest         = s_axis_ifc.tdest;

    assign m_axis_ifc.tdata     = m_axis_tdata;
    assign m_axis_ifc.tvalid    = m_axis_tvalid;
    assign m_axis_tready        = m_axis_ifc.tready;
    assign m_axis_ifc.tlast     = m_axis_tlast;
    assign m_axis_ifc.tkeep     = m_axis_tkeep;
    assign m_axis_ifc.tuser     = m_axis_tuser;
    assign m_axis_ifc.tid       = m_axis_tid;
    assign m_axis_ifc.tdest     = m_axis_tdest;

    // ------------------------------------------------------------------------------------------------------------
    // AXIS_SLAVE => [Combining all signals into a bus] => MEM => [Splitting all signals from a bus] => AXIS_MASTER
    // ------------------------------------------------------------------------------------------------------------
    // MEM BUS structure
    //                  -------------------------------------------------------------------------------------------
    // Placement:       | USER          | DEST          | ID            | LAST          | KEEP          | DATA    |
    //                  -------------------------------------------------------------------------------------------
    // Index:           |    USER_OFFSET|    DEST_OFFSET|      ID_OFFSET|    LAST_OFFSET|    KEEP_OFFSET|        0|
    // ------------------------------------------------------------------------------------------------------------
    localparam KEEP_OFFSET = DATA_WIDTH;
    localparam LAST_OFFSET = (KEEP_ENABLE) ? KEEP_OFFSET + KEEP_WIDTH   : KEEP_OFFSET;
    localparam ID_OFFSET   = (LAST_ENABLE) ? LAST_OFFSET + 1            : LAST_OFFSET;
    localparam DEST_OFFSET = (ID_ENABLE)   ? ID_OFFSET   + ID_WIDTH     : ID_OFFSET;
    localparam USER_OFFSET = (DEST_ENABLE) ? DEST_OFFSET + DEST_WIDTH   : DEST_OFFSET;
    localparam WIDTH       = (USER_ENABLE) ? USER_OFFSET + USER_WIDTH   : USER_OFFSET;
    localparam ADDR_WIDTH  = (KEEP_ENABLE) ? $clog2(DEPTH/KEEP_WIDTH) : $clog2(DEPTH);

    (* ramstyle = "no_rw_check" *)
    logic [WIDTH-1:0]       mem [(2**ADDR_WIDTH)-1:0];

    logic [ADDR_WIDTH:0]    wr_pointer, rd_pointer;
    logic [WIDTH-1:0]       wr_data, rd_data;
    logic                   wr_enb, rd_enb;
    logic                   empty, full;

    // ----------------------------------------
    // Memory input
    // ----------------------------------------
    generate
        assign wr_data[DATA_WIDTH-1:0] = s_axis_tdata;
        if (KEEP_ENABLE) assign wr_data[KEEP_OFFSET +: KEEP_WIDTH] = s_axis_tkeep;
        if (LAST_ENABLE) assign wr_data[LAST_OFFSET              ] = s_axis_tlast;
        if (ID_ENABLE  ) assign wr_data[ID_OFFSET   +: ID_WIDTH  ] = s_axis_tid;
        if (DEST_ENABLE) assign wr_data[DEST_OFFSET +: DEST_WIDTH] = s_axis_tdest;
        if (USER_ENABLE) assign wr_data[USER_OFFSET +: USER_WIDTH] = s_axis_tuser;
    endgenerate

    // ----------------------------------------
    // Memory output
    // ----------------------------------------
    assign m_axis_tdata = rd_data[DATA_WIDTH-1:0];
    assign m_axis_tkeep = ( KEEP_ENABLE ) ? rd_data [KEEP_OFFSET +: KEEP_WIDTH] : {KEEP_WIDTH{1'b1}};
    assign m_axis_tlast = ( LAST_ENABLE ) ? rd_data [LAST_OFFSET              ] : 1'b0;
    assign m_axis_tid   = ( ID_ENABLE   ) ? rd_data [ID_OFFSET   +: ID_WIDTH  ] : {ID_WIDTH{1'b0}};
    assign m_axis_tdest = ( DEST_ENABLE ) ? rd_data [DEST_OFFSET +: DEST_WIDTH] : {DEST_WIDTH{1'b0}};
    assign m_axis_tuser = ( USER_ENABLE ) ? rd_data [USER_OFFSET +: USER_WIDTH] : {USER_WIDTH{1'b0}};

    // ------------------------------------------------------------------------------------------------------------
    // Read and write mechanism
    // ------------------------------------------------------------------------------------------------------------
    //              _____________
    // wr_pointer   |     0     |  rd_pointer
    //     |        |           |       |
    //     |        |           |       |
    //     v        |           |       v
    //              |           |
    //              | DEPTH-1   |
    //              |___________| 
    //
    // wr_pointer and rd_pointer have an extra bit to indicate the full and empty status of the FIFO
    //  - If DEPTH = 32, then wr_pointer and rd_pointer are 6-bit wide
    //      + wr_pointer[4:0] and rd_pointer[4:0] are used to indicate the current position of the FIFO
    //      + wr_pointer[5] and rd_pointer[5] are used to indicate the full status of the FIFO
    //  - If wr_pointer == rd_pointer, FIFO is empty
    //  - If wr_pointer(MSB) != rd_pointer(MSB) and wr_pointer[MSB-1:0] == rd_pointer[MSB-1:0], FIFO is full
    //      + Example: DEPTH = 32 =>    wr_pointer and rd_pointer are 6-bit wide  
    //                                  wr_pointer = 6'b111111 = 63 , rd_pointer = 6'b011111 = 31 => FIFO is full
    //                                           _____________
    //                                           |     0     |  
    //                                           |           |       
    //                                           |           |       
    //                                           |           |       
    //                                           |           |
    //                                           |     31    |
    //           wr_pointer[4:0] = 5'b11111 =>   |___________|     <-  rd_pointer[4:0] = 5'b11111
    //
    //           wr_pointer[5] = 1'b1 and rd_pointer[5] = 1'b0  means:
    //              + write operation is conducted 64 times
    //              + and read operation is conducted 32 times => FIFO is full
    //           Since, when wr_pointer exceeds 63, it will be reset to 0, therefore, if wr_pointer[5] = 1'b0,
    //           and rd_pointer[5] = 1'b1, while wr_pointer[4:0] = rd_pointer[4:0], FIFO is still full
    //              + write operation may be conducted 96 times
    //              + and read operation may be conducted 64 times => FIFO is full
    // ------------------------------------------------------------------------------------------------------------
    assign empty = wr_pointer == rd_pointer;

    // assign full  = (wr_pointer[ADDR_WIDTH] != rd_pointer[ADDR_WIDTH]) && 
    //                (wr_pointer[ADDR_WIDTH-1:0] == rd_pointer[ADDR_WIDTH-1:0]);
    assign full = wr_pointer == (rd_pointer ^ {1'b1, {ADDR_WIDTH{1'b0}}});
    assign s_axis_tready    = !full;
    assign m_axis_tvalid    = !empty;

    assign wr_enb = s_axis_tvalid && !full;
    assign rd_enb = m_axis_tready && !empty;

    // ----------------------------------------
    // Write logic
    // ----------------------------------------
    always_ff @(posedge clk) begin
        if (rst) begin
            wr_pointer      <= 0;
        end else if (wr_enb) begin
            mem[wr_pointer[ADDR_WIDTH-1:0]] <= wr_data;
            wr_pointer      <= wr_pointer + 1;
        end
    end

    // ----------------------------------------
    // Read logic
    // ----------------------------------------
    always_ff @(posedge clk) begin
        if (rst) begin
            rd_pointer      <= 0;
        end else if (rd_enb) begin
            rd_data         <= mem[rd_pointer[ADDR_WIDTH-1:0]];
            rd_pointer      <= rd_pointer + 1;
        end
    end

endmodule