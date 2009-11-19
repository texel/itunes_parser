require 'active_support'
require 'nokogiri'

module ItunesParser
  class Library
    
    attr_accessor :songs
    
    def initialize
      @songs = []
    end
    
    def parse(xml)
      results = {}
      
      doc     = Nokogiri::XML(xml)
      version = doc.xpath('/plist/dict/string[1]')[0]
      
      first_song = doc.xpath('/plist/dict/dict/dict[1]/key')
      
      results['first_song'] = 
        first_song.inject({}) do |song_info, key|
          song_info[key.content.downcase.underscore] = key.next.content
          song_info
        end
      
      
      
      all_songs = doc.xpath('/plist/dict/dict/dict')
        
      results['songs'] = []
      
      all_songs.each do |track|
        
        metadata = {}
        song = Song.new
        
        track.xpath('/key').each do |key|
          song.metadata[key.content.downcase.underscore] = key.next.content
        end
        
        results['songs'] << song
      end
      
      results['version'] = version.content
      
      results
    end
  end
end