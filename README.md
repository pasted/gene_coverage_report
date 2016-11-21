# gene_coverage_report
Small application to demostrate Biomart, Bio-SamTools (ruby wrapper around Samtools) and graphs

First clone the repo into a suitable local directory, then run `bundle install` - this will install the dependencies including a verison of bio-samtools.

```
git clone git@github.com:pasted/gene_coverage_report.git
bundle install
```

```
ruby gene_coverage_report.rb -h
```
```
Options:
  -g, --genes=<s+>            Valid HGVS gene symbols - multiple symbols separated by a space.
  -b, --bam-path=<s>          Path to input BAM file.
  -r, --reference-path=<s>    Path to reference genome fasta file, overrides path in config.yaml.
  -e, --excel-output          Export results to an Excel spreadsheet.
  -h, --help                  Show this message

```
Example usage:

```
ruby gene_coverage_report.rb -g INS -b ../test_data/NA12878.bam -r ../test_data/reference.fasta
```

Output graphs will be written in the following format

```
INS_ENST00000250971.html
INS_ENST00000381330.html
INS_ENST00000397262.html
INS_ENST00000421783.html
INS_ENST00000512523.html
```

![alt text][INS]

[INS]: https://github.com/pasted/gene_coverage_report/blob/master/INS_ENST00000250971.png
