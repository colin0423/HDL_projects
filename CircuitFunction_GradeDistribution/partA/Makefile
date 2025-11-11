root_dir := $(PWD)
wv_dir := waveform
sim_dir := sim
src_dir := src

$(wv_dir):
	@mkdir -p $(wv_dir)

vcs: | $(wv_dir)
	@cd $(wv_dir); \
	vcs -R -sverilog $(PWD)/$(sim_dir)/tb.sv -debug_access+all -full64 -debug_region+cell +memcbk \
	+incdir+$(root_dir)/$(src_dir) \
	+notimingcheck \
	+path=$(root_dir)/$(sim_dir)

wave:
	@cd $(wv_dir); \
	nWave &

clean:
	@rm -rf $(wv_dir)