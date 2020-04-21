require "http/server"

module WebsocketIssue
  VERSION = "0.1.0"
end

class DevelopmentServer
  @reload_channel : Channel(Int32)
  @port : Int32

  getter reload_channel, port

  def initialize(@reload_channel, @port); end

  def run!
    server = HTTP::Server.new([
      HTTP::ErrorHandler.new,
      HTTP::LogHandler.new,
      HTTP::CompressHandler.new,
      HTTP::WebSocketHandler.new do |ws, ctx|
        loop do
          select
          when msg = reload_channel.receive
            ws.send("reload")
          when timeout(1.second)
            ws.send("ping")
          end
        end
      end,
      HTTP::StaticFileHandler.new("./static/", directory_listing: false),
    ]) do |context|
      if is_html_index_request?(context)
        context.response.status_code = 301
        context.response.headers["Location"] = "#{context.request.path}index.html"
        puts "\nRedirecting implicit HTML index request..."
      else
        context.response.status_code = 404
        STDERR.puts "\nFile not found!"
      end
    end

    address = server.bind_tcp(port)
    puts "Listening on http://#{address}"

    server.listen
  end

  ###

  private def is_html_index_request?(context)
    context.request.headers["Accept"].index("text/html") &&
      context.request.path.ends_with?("/")
  end
end

port = 9000
reload_channel = Channel(Int32).new

spawn {
  DevelopmentServer.new(reload_channel: reload_channel, port: port).run!
}

puts "server listening on port 9000"

Signal::INT.trap {
  puts "break!"
  exit 1
}

loop do
  sleep 10
  puts "pinging channel..."
  reload_channel.send(1)
end
