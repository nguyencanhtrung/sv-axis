# ----------------------------------------------------------------------------
# 
# Project   : 
# Filename  : xrestart
# 
# Author    : Nguyen Canh Trung
# Email     : nguyencanhtrung 'at' me 'dot' com
# Date      : 2023-10-17 12:00:28
# Last Modified : 2023-10-17 12:54:28
# Modified By   : Nguyen Canh Trung
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