#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: quay.io/biocontainers/quast@sha256:2d2566a6da65293c7ab06cc1f4fa61f9f492ea870817f3d60cdf5ccbd13131b5
  SoftwareRequirement:
    packages:
      quast:
        specs: [ "https://doi.org/10.1093/bioinformatics/btt086" ]



inputs:
  assembly_fasta:
    label: Assembled genome sequence FASTA files to be evaluated
    type: File
    format: edam:format_2200  # FASTA
    inputBinding:
      itemSeparator: ' '

  reference_fasta:
    label: Reference ground-truth genome sequence FASTA files
    type: File[]
    format: edam:format_2200  # FASTA
    inputBinding:
      prefix: '-R'
      itemSeparator: ','



outputs:
  assembly_metrics:
    label: Quast assembly metrics for contiguity and errors
    type: File
    format: edam:format_3475 # TSV key-value pairs of metrics
    outputBinding:
      glob: 'quast/report.tsv'
  stderr: stderr



baseCommand: ['quast.py', '--no-plots']

arguments:
  - prefix: --threads
    valueFrom: $(runtime.cores)
  - prefix: --output-dir
    valueFrom: $(runtime.outdir)/quast



$namespaces:
  edam: http://edamontology.org/
  s: http://schema.org/
$schemas:
  - http://edamontology.org/EDAM_1.17.owl
  - https://schema.org/docs/schema_org_rdfa.html
