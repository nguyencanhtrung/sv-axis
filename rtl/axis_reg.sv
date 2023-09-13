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

`timescale 1ns/1ps
module axis_reg #
(
    parameter DATA_WIDTH    = 8,
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
    ifc_axis.slave      s_axis_ifc,
    ifc_axis.master     m_axis_ifc
);
    // ------------------------------------------------------------------------------------------------------------
    // BUS structure
    //                  -------------------------------------------------------------------------------------------
    // Placement:       | USER          | DEST          | ID            | LAST          | KEEP          | DATA    |
    //                  -------------------------------------------------------------------------------------------
    // Index:           |    USER_OFFSET|    DEST_OFFSET|      ID_OFFSET|    LAST_OFFSET|    KEEP_OFFSET|        0|
    // ------------------------------------------------------------------------------------------------------------
    localparam KEEP_OFFSET = DATA_WIDTH;
    localparam LAST_OFFSET = (KEEP_ENABLE) ? ( KEEP_OFFSET + KEEP_WIDTH ) : KEEP_OFFSET;
    localparam ID_OFFSET   = (LAST_ENABLE) ? ( LAST_OFFSET + 1          ) : LAST_OFFSET;
    localparam DEST_OFFSET = (ID_ENABLE)   ? ( ID_OFFSET   + ID_WIDTH   ) : ID_OFFSET;
    localparam USER_OFFSET = (DEST_ENABLE) ? ( DEST_OFFSET + DEST_WIDTH ) : DEST_OFFSET;
    localparam WIDTH       = (USER_ENABLE) ? ( USER_OFFSET + USER_WIDTH ) : USER_OFFSET;

    logic clk, rst;

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

    assign clk = s_axis_ifc.clk;
    assign rst = s_axis_ifc.rst;

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
    
    // Input combination
    logic [WIDTH-1:0]           s_axis;
    generate
        assign s_axis[DATA_WIDTH-1:0] = s_axis_tdata;
        if (KEEP_ENABLE) assign s_axis[KEEP_OFFSET +: KEEP_WIDTH] = s_axis_tkeep;
        if (LAST_ENABLE) assign s_axis[LAST_OFFSET              ] = s_axis_tlast;
        if (ID_ENABLE  ) assign s_axis[ID_OFFSET   +: ID_WIDTH  ] = s_axis_tid;
        if (DEST_ENABLE) assign s_axis[DEST_OFFSET +: DEST_WIDTH] = s_axis_tdest;
        if (USER_ENABLE) assign s_axis[USER_OFFSET +: USER_WIDTH] = s_axis_tuser;
    endgenerate

    // Output splitting
    logic [WIDTH-1:0]           m_axis;
    assign m_axis_tdata = m_axis[DATA_WIDTH-1:0];
    assign m_axis_tkeep = ( KEEP_ENABLE ) ? m_axis[KEEP_OFFSET +: KEEP_WIDTH] : {KEEP_WIDTH{1'b1}};
    assign m_axis_tlast = ( LAST_ENABLE ) ? m_axis[LAST_OFFSET              ] : 1'b0;
    assign m_axis_tid   = ( ID_ENABLE   ) ? m_axis[ID_OFFSET   +: ID_WIDTH  ] : {ID_WIDTH{1'b0}};
    assign m_axis_tdest = ( DEST_ENABLE ) ? m_axis[DEST_OFFSET +: DEST_WIDTH] : {DEST_WIDTH{1'b0}};
    assign m_axis_tuser = ( USER_ENABLE ) ? m_axis[USER_OFFSET +: USER_WIDTH] : {USER_WIDTH{1'b0}};


    logic [WIDTH-1:0]   expansion_data_reg;
    logic               expansion_valid_reg;

    logic [WIDTH-1:0]   primary_data_reg;
    logic               primary_valid_reg;

    always_ff @(posedge clk) 
    begin

        if (s_axis_tready == 1'b1) begin
            primary_data_reg        <= s_axis;
            primary_valid_reg       <= s_axis_tvalid;

            if (m_axis_tready == 1'b0) begin
                expansion_data_reg  <= primary_data_reg;
                expansion_valid_reg <= primary_valid_reg;
            end
        end

        if (m_axis_tready == 1'b1) begin
            expansion_valid_reg     <= 1'b0;
        end
    end

    assign s_axis_tready = !(expansion_valid_reg);
    
    // m_axis_tvalid = (expansion_valid_reg) ? expansion_valid_reg : primary_valid_reg;
    assign m_axis_tvalid = expansion_valid_reg | primary_valid_reg;
    assign m_axis = (expansion_valid_reg) ? expansion_data_reg : primary_data_reg;

endmodule