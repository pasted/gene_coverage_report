class Gene
	require_relative 'transcript'
	
	attr_accessor :gene_symbol
	attr_accessor :transcripts
	
	def initialize()
		self.transcripts = Array.new
	end

	def process_transcripts(bam)
		puts "Number of transcripts #{self.gene_symbol} :: #{self.transcripts.length}"
		self.transcripts.each do |this_transcript|
			this_transcript.process_intervals(bam)
		end
	end
end
