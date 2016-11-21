class Interval
	require 'bio-samtools'
	require 'wait_until'
	
	attr_accessor :chromosome, :genomic_start, :genomic_end, :length
	attr_accessor :coverages, :coordinates

	def generate_coordinates
		self.coordinates = (self.genomic_start.to_i..self.genomic_end.to_i).to_a
	end

	def calculate_length
		self.length = (self.genomic_end.to_i - self.genomic_start.to_i)
	end
	
	def generate_coverage(bam)
    	#Generate base-by-base coverage

    	tmp_coverages = Array.new
    	Wait.until_true!(timeout_in_seconds: 600) {
    		#"11",2181082,100
    		#tmp_coverages = bam.chromosome_coverage("11", 2181082, 1000)
    		tmp_coverages = bam.chromosome_coverage("#{self.chromosome}", self.genomic_start.to_i, self.length.to_i)
    		
    	}
    	self.coverages = tmp_coverages
    	
    	return true
  end
    
end
