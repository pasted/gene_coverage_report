class GeneStore
	require 'nyaplot'
	require_relative 'gene'

	attr_accessor :genes
	
	def initialize()
		self.genes = Hash.new
	end
    
	def process_genes(bam)
		puts "#{self.genes.length}"
		self.genes.each_pair do |this_gene_symbol, this_gene|
			this_gene.process_transcripts(bam)
		end
	end
	
	def get_transcripts(gene_symbol)
		self.genes.each do |this_gene|
			if this_gene == gene_symbol
				return this_gene.transcripts
			end
		end
	end
	
	def render_coverage
  	#Produce gene base-by-base graph
  	#require "nyaplot"
  	#plot = Nyaplot::Plot.new
  	#plot.configure do
  	#	width(1000)
  	#	height(700)
  	#end
  	#plot.add(:scatter, [0,1,2],[0,1,2])
  	#plot.export_html("test.html")
  	self.genes.each_pair do |this_gene_symbol, this_gene|
			 		
  		 this_gene.transcripts.each do |this_transcript|
  		 	puts "Rendering #{this_gene_symbol} #{this_transcript.ensembl_id} plot" 
  			this_transcript.intervals.each do |this_interval|
  				  	#if this_interval.coordinates.length == this_interval.coverages.length
  							plot = Nyaplot::Plot.new
  				  		#plot.configure do
  				  		#	width(1000)
  				  		#	height(700)
              	#
  				  		#end
  				  		puts this_interval.coordinates.length
  				  		puts this_interval.coverages.length
  				  		plot.add(:line, this_interval.coordinates, this_interval.coverages)
  				  		plot.x_label("Chromosome #{this_interval.chromosome}")
  				  		plot.y_label("Read Depth")
  				  		#plot.title("#{this_gene.gene_symbol}_#{this_transcript.ensembl_id}")
  				  		plot.export_html("#{this_gene.gene_symbol}_#{this_transcript.ensembl_id}.html")
  				  	#else
  				  	#	puts "Mismatch error : number of coordinates does not match number of coverages"
  				  	#end
  			end#this_transcript.intervals
  			
  		end#this_gene.transcripts
  	end#self.genes
  		
  end
  
end
