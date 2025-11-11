root_dir := $(PWD)
wv_dir := waveform
sim_dir := sim
src_dir := src
hex_dir := hex
in_dir := image_in
out_dir := image_out

FSDB_DEF :=
ifeq ($(WV),1)
FSDB_DEF := FSDB
else ifeq ($(WV),2)
FSDB_DEF := FSDB_ALL
endif

IMG_SEL :=
IMG_PTH :=
TXT_PTH :=
ifeq ($(IMG),1)
IMG_SEL := IMG1
IMG_PTH := $(root_dir)/$(in_dir)/karina_noisy.bmp
TXT_PTH := $(root_dir)/$(in_dir)/karina_noisy.txt
else ifeq ($(IMG),2)
IMG_SEL := IMG2
IMG_PTH := $(root_dir)/$(in_dir)/miyeon_noisy.bmp
TXT_PTH := $(root_dir)/$(in_dir)/miyeon_noisy.txt
else ifeq ($(IMG),3)
IMG_SEL := IMG3
IMG_PTH := $(root_dir)/$(in_dir)/yuna_noisy.bmp
TXT_PTH := $(root_dir)/$(in_dir)/yuna_noisy.txt
endif

PASS_DEF :=
ifeq ($(PASS),1)
PASS_DEF := PASS_TEST
else
PASS_DEF := NONE
endif

$(wv_dir):
	@mkdir -p $(wv_dir)

$(out_dir):
	@mkdir -p $(out_dir)

bmp :
	./bmp2txt $(IMG_PTH) $(TXT_PTH)

vcs: bmp $(wv_dir) $(out_dir)
	@cd $(wv_dir); \
	vcs -R -sverilog $(PWD)/$(sim_dir)/DUT_tb.v -debug_access+all -full64 -debug_region+cell +memcbk \
	+incdir+$(root_dir)/$(src_dir)+$(root_dir)/$(sim_dir)\
	+notimingcheck \
	+define+$(FSDB_DEF)+$(IMG_SEL)+$(PASS_DEF); \
	eog $(IMG_PTH) $(root_dir)/$(out_dir)/img_out_a.bmp $(root_dir)/$(out_dir)/img_out_m.bmp&

wave:
	@cd $(wv_dir); \
	nWave &

clean:
	@rm -rf $(wv_dir); \
	rm -rf $(out_dir); \
	rm -rf $(in_dir)/*.txt;


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
