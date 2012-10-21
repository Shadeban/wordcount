require 'nokogiri'

class Webpage < ActiveRecord::Base
  
  #WORD_REGEX is intended to slightly improve on \w+ for finding 'words' on a webpage
  #it handles things like very simple webpage names "webpage.com" and emails
  #this regex would be the preferred method of tweaking what counts as a word 
	
  WORD_REGEX =  /(\$?\w+([\.@\-']\w+)*)/

  #word_count returns the top n words in sorted_word_count
  #memoizing the result so the response only gets parsed once per object 
	  
  def word_count(n=10)
	@word_count ||= sorted_word_count	
	@word_count[0...n]
	  
  end
  
  #text_nodes uses Nokogiri to parse the response and returns only nodes containing text
  #specifically, it excludes anything in a script or style tag

  def text_nodes
	  
	 node = Nokogiri.parse(response)
	 node.xpath("//text()") - node.xpath("//script//text()") - node.xpath("//style//text()")

  end	  

  #sorted_word_count scans for WORD_REGEX in the nodes returned by text_nodes,
  #returning the counts as a 2d array of form [[word1, count],[word2,count]]
  #ordered by count (descending)
  
  def sorted_word_count

	  counts = text_nodes.inject(Hash.new(0)) do |word_counts, node|
		node.text().scan(WORD_REGEX).each {|match| word_counts[match.first.upcase] += 1}
		word_counts
	  end
	  counts.sort{|a,b| b[1] <=> a[1]}

  end

end
