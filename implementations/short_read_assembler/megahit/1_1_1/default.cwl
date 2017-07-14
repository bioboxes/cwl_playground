cwlVersion: cwl:v1.0
class: Workflow
requirements: 
  - class: StepInputExpressionRequirement
inputs:
  fastq:
    type: File[]
    format: edam:format_1931  # FASTQ
outputs:
  contigs:
    type: File
    outputSource: rename/out
steps:
  megahit:
    run:
     class: CommandLineTool
     
     hints:
       DockerRequirement:
         dockerPull: quay.io/biocontainers/megahit:1.1.1--py36_0
       SoftwareRequirement:
         packages:
           megahit:
             specs: [ "https://doi.org/10.1093/bioinformatics/btv033" ]
     
     inputs:
       fastq:
         type: File[]
         label: interleaved & gzipped fasta/q paired-end files
         format: edam:format_1931  # FASTQ
         inputBinding:
           prefix: --12
           itemSeparator: ','
     baseCommand: megahit
     
     arguments:  # many of these could be turned into configurable inputs
       - prefix: --num-cpu-threads
         valueFrom: $(runtime.cores)
       - prefix: --min-count
         valueFrom: "2"
       - prefix: --k-max
         valueFrom: "99"
       - prefix: --k-step
         valueFrom: "20"
       - prefix: --out-dir
         valueFrom: $(runtime.outdir)/output
       - prefix: --mem-flag
         valueFrom: "2"
     
     outputs:
       megahit_contigs:
         type: File
         format: edam:format_1929  # FASTA
         outputBinding:
           glob: 'output/final.contigs.fa'
       stderr: stderr
    in:
      fastq: fastq
    out:
      - megahit_contigs
  rename:
    run:
      class: CommandLineTool
      baseCommand: mv
      inputs:
        infile:
          type: File
          inputBinding:
            position: 1
        outfile:
          type: string
          inputBinding:
            position: 2
      outputs:
        out:
          type: File
          outputBinding:
            glob: $(inputs.outfile)

    in:
      infile: megahit/megahit_contigs
      outfile: 
        valueFrom: "contigs.fa"
    out:
      - out
