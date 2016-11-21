class GeneCoverageReport
  require 'bio-samtools'
  require 'biomart'
  require 'yaml'
  require 'trollop'
  require 'gruff'
  
  require_relative 'lib/batch'
  require_relative 'lib/gene_store'
  
  #Gruff requires ImageMagick to be installed on host system
  #yum -y install ImageMagick
  #yum -y install ruby-RMagick # needs EPEL
  #yum -y install ImageMagick-devel
  #yum -y install liberation-fonts # RHEL 5
  #yum -y install liberation-fonts-common liberation-sans-fonts # RHEL 6
  #gem install gruff
  
  def get_biomart_intervals(gene_symbol, ensembl_genes)
  	  #contact Biomart with gene_symbol and retrieve intervals for all transcripts

  	  #ensembl_genes.search( :filters => { "hgnc_symbol" => "INS" }, :attributes => ["ensembl_transcript_id", "exon_chrom_end", "exon_chrom_start", "exon_id", "ensembl_exon_id"] )
  	  results = ensembl_genes.search( :filters => { "hgnc_symbol" => "#{gene_symbol}" }, :attributes => ["ensembl_transcript_id", "chromosome_name", "transcript_start", "transcript_end"] )
  	   	  
  	  #Return hash with transcripts as keys and an array of intervals as values
  	  return results
  end
  
  def get_refseq_ensembl_transcript_ids(gene_symbol)
  	results = ensembl_genes.search( :filters => { "hgnc_symbol" => "#{gene_symbol}" }, :attributes => ["ensembl_transcript_id", "refseq_mrna"] )
  	return results
  end
  
  def open_bam_file(bam_path, reference_path)
  	#Use BioRuby::Samtools to open the target BAM file
  	bam = Bio::DB::Sam.new(:bam=>"#{bam_path}", :fasta=>"#{reference_path}")
  	bam.open
  	return bam
  end

  

  
  def run_gene_coverage_report(coverage_report)
  	  
    	opts = Trollop::options do
    		opt :genes, "Valid HGVS gene symbols - multiple symbols separated by a space.", :type => :strings
    		opt :bam_path, "Path to input BAM file.", :type => :string
    		opt :reference_path, "Path to reference genome fasta file, overrides path in config.yaml.", :type => :string
  			opt :excel_output, "Export results to an Excel spreadsheet."
  		end
	
		genes = opts[:genes]
		bam_path = opts[:bam_path]
		reference_path = opts[:reference_path]
		excel_output = opts[:excel_output]
		
		#Load the config YAML file and pass the settings to local variables
		this_batch = YAML.load_file("configuration/config.yaml")
		
		puts "#{genes.inspect}"
		
		if this_batch.biomart_url
			biomart = Biomart::Server.new("#{this_batch.biomart_url}")
		else
			biomart = Biomart::Server.new("http://grch37.ensembl.org/biomart")
		end
	
  	ensembl_genes = biomart.datasets["hsapiens_gene_ensembl"]
  	this_bam = open_bam_file(bam_path, reference_path)
  	
  	#["INS"]
  	#{:headers=>["ensembl_transcript_id", "chromosome_name", "transcript_start", "transcript_end"],
  	#:data=>[["ENST00000397262", "11", "2181009", "2182434"], ["ENST00000250971", "11", "2181009", "2182451"], ["ENST00000381330", "11", "2181009", "2182571"], ["ENST00000421783", "11", "2181013", "2182388"], ["ENST00000512523", "11", "2181082", "2182201"]]}

  		gene_store = GeneStore.new
			genes.each do |this_gene_symbol|
				puts "Retrieving #{this_gene_symbol} intervals from Biomart"
				results = get_biomart_intervals(this_gene_symbol, ensembl_genes)
				puts "#{results.fetch(:data).inspect}"
				
				this_gene = Gene.new
				this_gene.gene_symbol = this_gene_symbol
				
				results.fetch(:data).each do |this_result|
					this_transcript = Transcript.new
					this_interval = Interval.new
					this_transcript.ensembl_id = this_result[0]
					this_interval.chromosome = this_result[1]
					this_interval.genomic_start = this_result[2]
					this_interval.genomic_end = this_result[3]
					this_interval.calculate_length
					this_interval.generate_coordinates
					this_interval.generate_coverage(this_bam)
					this_transcript.intervals.push(this_interval)
					this_gene.transcripts.push(this_transcript)
				end
				
				gene_store.genes.store("#{this_gene_symbol}", this_gene)
			end
			puts gene_store.inspect
			gene_store.process_genes(this_bam)
			gene_store.render_coverage

	
  end
  
  #Main
  if __FILE__ == $0

		coverage_report = GeneCoverageReport.new()
		coverage_report.run_gene_coverage_report(coverage_report)
		
  end

  
end
