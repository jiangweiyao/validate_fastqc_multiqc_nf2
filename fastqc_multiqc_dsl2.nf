#!/usr/bin/env nextflow

nextflow.enable.dsl=2

//fastq_file = Channel.fromPath(params.in, type: 'file')

process fastqc {

    cpus 1
    memory 1.GB
    errorStrategy 'ignore'
    publishDir "${params.publish_dir}", mode: "copy", overwrite: true
    //publishDir params.out, mode: 'copy', overwrite: true

    //Note to self: specifying the file name literally coerces the input file into that name. It doesn't select files matching pattern of the literal.
    input:
    file(fastq) 
 
    output:
    file "*_fastqc.{zip,html}" 
    """
    fastqc ${fastq}
    """
}


process multiqc {
    cpus 2
    memory 2.GB
    publishDir "${params.publish_dir}", mode: "copy", overwrite: true
    //publishDir params.out, mode: 'copy', overwrite: true

    input:
    file(reports)

    output:
    file "multiqc_report.html"

    """
    multiqc $reports
    """
}

workflow fastqc_multiqc_pipeline {
    take: fastq_file
    main:
        //fastq_file = Channel.fromPath(params.in, type: 'file')
        fastqc(fastq_file)
        multiqc(fastqc.out.collect())
    emit:
        fastqc.out 
}

workflow {
    //fastq_file = Channel.fromPath(params.in, type: 'file')
    fastqc_multiqc_pipeline(fastq_file)
}
