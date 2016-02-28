require "sinatra"
require "sinatra/reloader"
require 'tilt/erubis'

before do
  @toc = File.readlines("data/toc.txt")
end

helpers do
  def in_paragraphs(text)
    paragraphs = paragraph_array(text)
    paragraphs.map.with_index do |paragraph, id|
      "<p id=\"#{id}\">#{paragraph}</p>"
    end.join
  end

  def paragraph_array(text)
    text.split "\n\n"
  end

  def format_search_result(text, query)
    text.gsub(/(#{query})/i, '<strong>\1</strong>')
  end
end

not_found do
  redirect ''
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  erb :home
end

get '/chapters/:number' do
  chapter_number = params[:number].to_i

  @chapter_text = File.read("data/chp#{chapter_number}.txt")
  @title = "Chapter #{chapter_number}: #{@toc[chapter_number - 1]}"

  erb :chapter
end

get '/search' do
  if params[:query]
    @results = @toc.each_with_index.each_with_object([]) do |(chap, index), arr|
      chap_text = File.read("data/chp#{index + 1}.txt")
      paragraphs = paragraph_array(chap_text)
      paragraphs.each_with_index do |paragraph, paragraph_index|
        if paragraph.downcase.include? params[:query].downcase
          arr << [chap, index, paragraph, paragraph_index]
        end
      end
    end
  end

  erb :search
end
