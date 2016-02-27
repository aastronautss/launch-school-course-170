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

  params = parse_params(params) || {}

  [http_method, path, params]
end

server = TCPServer.new('localhost', 3003)
loop do
  client = server.accept

  request_line = client.gets
  puts request_line

  next unless request_line

  http_method, path, params = parse_request(request_line)

  client.puts "HTTP/1.0 200 OK"
  client.puts "ContentType: text/html"
  client.puts
  client.puts "<html>"
  client.puts "<body>"

  client.puts "<h1>Counter</h1>"

  number = params["number"].to_i
  client.puts "<p>The current number is #{number}.</p>"
  client.puts "<p><a href='?number=#{number + 1}'>Add 1</a></p>"
  client.puts "<p><a href='?number=#{number - 1}'>Subtract 1</a></p>"

  client.puts "</body>"
  client.puts "</html>"

  client.close
end
