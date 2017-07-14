test: env test_quast

$(shell mkdir -p tmp)

# Need to set the TMPDIR to a local directory for OSX + boot2docker
cwltool = \
    TMPDIR=$(abspath tmp) \
    PATH=$(PATH):$(abspath env/bin) \
    cwltool

test_quast: \
	tmp/data/assembler_benchmark/assembly.fasta \
	tmp/data/assembler_benchmark/references/reference.fasta
	$(cwltool) \
		implementations/reference_genome_evaluation/quast/4_5.cwl \
		--assembly_fasta $< \
		--reference_fasta $(lastword $^)


tmp/data/%:
	mkdir -p $(dir $@)
	wget \
		https://raw.githubusercontent.com/bioboxes/command-line-interface/master/biobox_cli/verification/data/$* \
		--output-document $@

env:
	virtualenv $@
	$@/bin/pip install cwltool
