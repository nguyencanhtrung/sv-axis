# ---------------------------------------------------------------------------
#            ___  _    __         =        ___  _  __    __ ___            --   
#           / ._\| |  / /         =       /   | \\/ /   / // ._\           --         
#           \ __ | | / /          =      / /| |  / /   / / \ __            --
#         ____. \| |/ /           =     / /_| | / /\  / /____. \           --
#        /______/|___/            =    /_/  |_|/_/ \\/_//______/           --
#                               =====                                      --
#                                ===                                       --
# ------------------------------  =  ----------------------------------------
#  Copyright © 2023, 2024 - Nguyen Canh Trung
#  (nguyencanhtrung 'at' me 'dot' com)
# 
#  Permission is hereby granted, free of charge, to any person obtaining a
#  copy of this software and associated documentation files (the "Software"),
#  to deal in the Software without restriction, including without limitation
#  the rights to use, copy, modify, merge, publish, distribute, sublicense,
#  and/or sell copies of the Software, and to permit persons to whom the
#  Software is furnished to do so, subject to the following conditions:
# 
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
# 
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
#  DEALINGS IN THE SOFTWARE.
# 
#  DEPENDENCIES: none
# 
# Description: 
#           Run at transcript window of QuestaSim
#               Recompile desgin
#               Re-Elaborate design
#               Restart waveform
#               Re-run simulation
#
#           $ source ./relaunch.sh
# HISTORY:
# Date      	By	Comments
# ----------	---	---------------------------------------------------------
# 2023-10-17	NCT	File created
# ----------------------------------------------------------------------------

make compile
make elaborate
restart -force
run -all