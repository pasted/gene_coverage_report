class Transcript
	require_relative 'interval'
	
	attr_accessor :refseq_id, :ensembl_id
	attr_accessor :intervals
	
	def initialize()
		self.intervals = Array.new
	end
	
	def process_intervals(bam)
		self.intervals.each do |this_interval|
			this_interval.generate_coverage(bam)
		end
	end

end
