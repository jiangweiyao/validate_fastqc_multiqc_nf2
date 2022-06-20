#!/usr/bin/env nextflow

nextflow.enable.dsl=2
import groovy.json.JsonOutput
include { validate_fastqc_multiqc_pipeline } from './validate_fastqc_multiqc_dsl2.nf'
include { fastqc_multiqc_pipeline } from './fastqc_multiqc_dsl2.nf'

fastq_file = Channel.fromPath(params.in, type: 'file')

workflow {
    if( params.validate) {
        validate_fastqc_multiqc_pipeline(fastq_file)
    }
    else {
        fastqc_multiqc_pipeline(fastq_file)
    }
}

