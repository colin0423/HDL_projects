root_dir := $(PWD)
wv_dir := waveform
sim_dir := sim
src_dir := src
syn_dir := syn
in_dir := image
out_dir := image_out
bld_dir := build

FSDB_DEF :=
ifeq ($(WV),1)
FSDB_DEF := FSDB
else ifeq ($(WV),2)
FSDB_DEF := FSDB_ALL
endif

CSC_DEF :=
ifeq ($(CSC),0)
CSC_DEF := RGB2YUV
else ifeq ($(CSC),1)
CSC_DEF := YUV2RGB
else ifeq ($(CSC),2)
CSC_DEF := RGB2RGB
endif

IMG_PTH := $(root_dir)/$(in_dir)/original.bmp
TXT_PTH := $(root_dir)/$(in_dir)/original.txt

PASS_DEF :=
ifeq ($(PASS),1)
PASS_DEF := PASS_TEST
else
PASS_DEF := NONE
endif

$(wv_dir):
	@mkdir -p $(wv_dir)

$(bld_dir):
	mkdir -p $(bld_dir)

$(out_dir):
	@mkdir -p $(out_dir)

$(syn_dir):
	mkdir -p $(syn_dir)

bmp :
	./bmp2txt $(IMG_PTH) $(TXT_PTH)

vcs0: clean bmp $(wv_dir) $(out_dir)
	@cd $(wv_dir); \
	vcs -R -sverilog $(PWD)/$(sim_dir)/DUT_tb.sv -debug_access+all -full64 -debug_region+cell +memcbk \
	+incdir+$(root_dir)/$(src_dir)+$(root_dir)/$(sim_dir)\
	+notimingcheck \
	+nospecify \
	+define+AP_TB+$(PASS_DEF)+$(FSDB_DEF); \
	eog $(IMG_PTH) $(root_dir)/$(out_dir)/mode_0.bmp $(root_dir)/$(out_dir)/mode_1.bmp \
	$(root_dir)/$(out_dir)/mode_2.bmp $(root_dir)/$(out_dir)/mode_3.bmp $(root_dir)/$(out_dir)/mode_4.bmp \
	$(root_dir)/$(out_dir)/mode_5.bmp $(root_dir)/$(out_dir)/mode_6.bmp $(root_dir)/$(out_dir)/mode_7.bmp \
	$(root_dir)/$(out_dir)/mode_8.bmp $(root_dir)/$(out_dir)/mode_9.bmp $(root_dir)/$(out_dir)/mode_10.bmp \
	$(root_dir)/$(out_dir)/mode_11.bmp $(root_dir)/$(out_dir)/mode_12.bmp $(root_dir)/$(out_dir)/mode_13.bmp \
	$(root_dir)/$(out_dir)/mode_14.bmp $(root_dir)/$(out_dir)/mode_15.bmp &

vcs1: clean bmp $(wv_dir) $(out_dir)
	@cd $(wv_dir); \
	vcs -R -sverilog $(PWD)/$(sim_dir)/DUT_tb.sv -debug_access+all -full64 -debug_region+cell +memcbk \
	+incdir+$(root_dir)/$(src_dir)+$(root_dir)/$(sim_dir)\
	+notimingcheck \
	+nospecify \
	+define+CSC_TB+$(CSC_DEF)+$(FSDB_DEF); \

syn0: clean bmp $(wv_dir) $(out_dir)
	@cd $(wv_dir); \
	vcs -R -sverilog +neg_tchk -negdelay -v "/usr/cad/CBDK/Executable_Package/Collaterals/IP/stdcell/N16ADFP_StdCell/VERILOG/N16ADFP_StdCell.v" \
	$(PWD)/$(sim_dir)/DUT_tb.sv -debug_access+all -full64 -debug_region+cell +memcbk \
	+incdir+$(root_dir)/$(src_dir)+$(root_dir)/$(sim_dir)\
	+notimingcheck \
	+nospecify \
	+define+AP_TB+SYN+$(PASS_DEF)+$(FSDB_DEF); \
	eog $(IMG_PTH) $(root_dir)/$(out_dir)/mode_0.bmp $(root_dir)/$(out_dir)/mode_1.bmp \
	$(root_dir)/$(out_dir)/mode_2.bmp $(root_dir)/$(out_dir)/mode_3.bmp $(root_dir)/$(out_dir)/mode_4.bmp \
	$(root_dir)/$(out_dir)/mode_5.bmp $(root_dir)/$(out_dir)/mode_6.bmp $(root_dir)/$(out_dir)/mode_7.bmp \
	$(root_dir)/$(out_dir)/mode_8.bmp $(root_dir)/$(out_dir)/mode_9.bmp $(root_dir)/$(out_dir)/mode_10.bmp \
	$(root_dir)/$(out_dir)/mode_11.bmp $(root_dir)/$(out_dir)/mode_12.bmp $(root_dir)/$(out_dir)/mode_13.bmp \
	$(root_dir)/$(out_dir)/mode_14.bmp $(root_dir)/$(out_dir)/mode_15.bmp &

syn1: clean bmp $(wv_dir) $(out_dir)
	@cd $(wv_dir); \
	vcs -R -sverilog  +neg_tchk -negdelay -v "/usr/cad/CBDK/Executable_Package/Collaterals/IP/stdcell/N16ADFP_StdCell/VERILOG/N16ADFP_StdCell.v" \
	$(PWD)/$(sim_dir)/DUT_tb.sv -debug_access+all -full64 -debug_region+cell +memcbk \
	+incdir+$(root_dir)/$(src_dir)+$(root_dir)/$(sim_dir)\
	+notimingcheck \
	+nospecify \
	+define+CSC_TB+SYN+$(CSC_DEF)+$(FSDB_DEF); \

synthesize0: $(syn_dir) $(bld_dir)
	cp script/synopsys_dc.setup $(bld_dir)/.synopsys_dc.setup; \
	cd $(bld_dir); \
	dc_shell -no_home_init -f ../script/synthesis_AP.tcl

synthesize1: $(syn_dir) $(bld_dir)
	cp script/synopsys_dc.setup $(bld_dir)/.synopsys_dc.setup; \
	cd $(bld_dir); \
	dc_shell -no_home_init -f ../script/synthesis_CSC.tcl

wave:
	@cd $(wv_dir); \
	nWave &

clean:
	@rm -rf $(wv_dir); \
	rm -rf $(out_dir); \
	rm -rf $(bld_dir);


RED=\033[1;31m
BLUE=\033[1;34m
NORMAL=\033[0m 


tar: clean
	@read -p "Please enter your student ID: " STUDENTID; \
	if [ "$$(basename $$PWD)" = "$$STUDENTID" ]; then \
		ID_LEN=$$(expr length $$STUDENTID); \
		if [ $$ID_LEN -eq 9 ]; then \
			if [[ $$STUDENTID =~ ^[A-Z][A-Z0-9][0-9]+$$ ]]; then \
					echo -e "$(BLUE)Start compressing your folder...$(NORMAL)"; \
					cd ..; \
					tar -cvf $$STUDENTID.tar $$STUDENTID; \
			else \
				echo -e "$(RED)Student ID number should be one capital letter and 8 numbers (or 2 capital letters and 7 numbers)$(NORMAL)"; \
				exit 1; \
			fi \
		else \
			echo -e "$(RED)Student ID number length isn't 9$(NORMAL)"; \
			exit 1; \
		fi \
	else \
		echo -e "$(RED)Your student ID and folder name do not match.$(NORMAL)"; \
		exit 1; \
	fi; \
