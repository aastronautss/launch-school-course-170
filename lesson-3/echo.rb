require 'socket'
require 'pry'

def parse_params(params_text)
  (params_text || '').split('&').each_with_object({}) do |pair, hash|
    key, value = pair.split('=')
    hash[key] = value
  end
end

def parse_request(request_line)
  http_method, path_and_params, http = request_line.split ' '
  path, params = path_and_params.split '?'

  params = parse_params(params) if params

  [http_method, path, params]
end

server = TCPServer.new('localhost', 3003)
loop do
  client = server.accept

  request_line = client.gets
  puts request_line

  next unless request_line

  http_method, path, params = parse_request(request_line)

  rolls = (params ? params['rolls'] || '1' : '1').to_i
  sides = (params ? params['sides'] || '6' : '6').to_i

  client.puts "HTTP/1.0 200 OK"
  client.puts "ContentType: text/html"
  client.puts
  client.puts "<html>"
  client.puts "<body>"
  client.puts ""

  client.puts "<h1>Rolls:</h1>"
  rolls.times do
    roll = rand(sides) + 1
    client.puts "<p>", roll, "</p>"
  end

  client.puts "</body>"
  client.puts "</html>"

  client.close
end
