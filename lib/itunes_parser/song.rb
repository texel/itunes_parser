module ItunesParser
  class Song
    attr_accessor :metadata
    
    def initialize
      @metadata = {}
    end
  end
end