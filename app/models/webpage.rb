require 'nokogiri'

class Webpage < ActiveRecord::Base

  WORD_REGEX =  /(\$?\w+([\.@\-']\w+)*)/

  def word_count(n=10)
	@word_count ||= sorted_word_count	
	@word_count[0...10]
	  
  end

  def text_nodes
	  
	 node = Nokogiri.parse(response)
	 node.xpath("//text()") - node.xpath("//script//text()") - node.xpath("//style//text()")

  end	  

  def sorted_word_count

	  counts = text_nodes.inject(Hash.new(0)) do |word_counts, node|
		node.text().scan(WORD_REGEX).each {|match| word_counts[match.first.upcase] += 1}
		word_counts
	  end
	  counts.sort{|a,b| b[1] <=> a[1]}

  end

end
