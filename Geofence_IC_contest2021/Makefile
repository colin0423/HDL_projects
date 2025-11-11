root_dir := $(PWD)
wv_dir := waveform
sim_dir := sim
src_dir := src
hex_dir := hex
FSDB_DEF :=
ifeq ($(WV),1)
FSDB_DEF := +FSDB
else ifeq ($(WV),2)
FSDB_DEF := +FSDB_ALL
endif

$(wv_dir):
	@mkdir -p $(wv_dir)
 


vcs: | $(wv_dir)
	@cd $(wv_dir); \
	vcs -R -sverilog $(PWD)/$(sim_dir)/tb.sv -debug_access+all -full64 -debug_region+cell +memcbk \
	+incdir+$(root_dir)/$(src_dir) \
	+notimingcheck \
	+define+$(FSDB_DEF) \



ta: | $(wv_dir)
	@cd $(wv_dir); \
	vcs -R -sverilog $(PWD)/$(sim_dir)/lab4_tb.svp -debug_access+all -full64 -debug_region+cell +memcbk \
	+incdir+$(root_dir)/$(src_dir) \
	+notimingcheck \
	+define+$(FSDB_DEF) \
	+hex_path=$(root_dir)/$(hex_dir)

wave:
	@cd $(wv_dir); \
	nWave &

clean:
	@rm -rf $(wv_dir)


RED=\033[1;31m
BLUE=\033[1;34m


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