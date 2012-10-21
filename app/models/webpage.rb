require 'nokogiri'

class Webpage < ActiveRecord::Base

  def wordcount
 	 
	 node = Nokogiri.parse(response)
	 @text = node.xpath("//text()") - node.xpath("//script//text()") - node.xpath("//style//text()")
	 
	words = text.inject([]) do |all,textnode|
		textnode.text().scan(/(\$?\w+([\.@\-']\w+)*)/).each {|match| all << match}
		all
	end


	injdict = words.inject(Hash.new(0)) {|dict, match| dict[match.first.upcase] += 1; dict}
	test = injdict.sort{|a,b| b[1] <=> a[1]}	
	test[0...10]
	
	  
  end
  def text
	  @text ||= ""
  end
end