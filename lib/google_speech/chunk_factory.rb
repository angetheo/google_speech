# -*- encoding: utf-8 -*-

module GoogleSpeech

  # break wav audio into short files
  class ChunkFactory
    attr_accessor :original_file, :chunk_duration, :overlap, :rate

    def initialize(original_file, chunk_duration, overlap, rate)
      @chunk_duration    = chunk_duration
      @original_file     = original_file
      @overlap           = overlap
      @rate              = rate
      @original_duration = GoogleSpeech::Utility.audio_file_duration(@original_file.path)
    end

    # return temp file for each chunk
    def each
      pos = 0
      while(pos < @original_duration) do
        chunk = nil
        begin
          chunk = Chunk.new(@original_file, @original_duration, pos, (@chunk_duration + @overlap), @rate)
          yield chunk
          pos = pos + [chunk.duration, @chunk_duration].min
        ensure
          chunk.close_file if chunk
        end
      end
    end

    def logger
      GoogleSpeech.logger
    end

  end
end
