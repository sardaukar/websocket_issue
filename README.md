# websocket_issue

This repo is a tool to help test the [broken pipe error](https://github.com/crystal-lang/crystal/issues/9135) issue reported to the Crystal bug tracker.

## Installation

Just clone, no `shards install` needed.

## Usage

Run `crystal src/websocket_issue.cr`. Then point your browser to `https://localhost:9000`.

## Expected output

Something similar to this after ~20 seconds:

```
server listening on port 9000
Listening on http://127.0.0.1:9000
GET /index.html - 200 (24.73ms)
GET /favicon.ico - 200 (83.02µs)
pinging channel...
GET /index.html - 200 (131.70µs)
GET /favicon.ico - 200 (91.49µs)
pinging channel...
pinging channel...
GET / - Unhandled exception:
Error writing to socket: Broken pipe (IO::Error)
  from /home/sardaukar/.asdf/installs/crystal/0.34.0/share/crystal/src/socket.cr:82:13 in 'unbuffered_write'
  from /home/sardaukar/.asdf/installs/crystal/0.34.0/share/crystal/src/io/buffered.cr:218:5 in 'flush'
  from /home/sardaukar/.asdf/installs/crystal/0.34.0/share/crystal/src/io/buffered.cr:226:5 in 'close'
  from /home/sardaukar/.asdf/installs/crystal/0.34.0/share/crystal/src/http/server/handlers/websocket_handler.cr:47:9 in 'call'
  from /home/sardaukar/.asdf/installs/crystal/0.34.0/share/crystal/src/http/server/handler.cr:28:7 in 'call_next'
  from /home/sardaukar/.asdf/installs/crystal/0.34.0/share/crystal/src/http/server/handlers/compress_handler.cr:12:5 in 'call'
  from /home/sardaukar/.asdf/installs/crystal/0.34.0/share/crystal/src/http/server/handler.cr:28:7 in 'call_next'
  from /home/sardaukar/.asdf/installs/crystal/0.34.0/share/crystal/src/http/server/handlers/log_handler.cr:11:30 in 'call'
  from /home/sardaukar/.asdf/installs/crystal/0.34.0/share/crystal/src/http/server/handler.cr:28:7 in 'call_next'
  from /home/sardaukar/.asdf/installs/crystal/0.34.0/share/crystal/src/http/server/handlers/error_handler.cr:15:7 in 'call'
  from /home/sardaukar/.asdf/installs/crystal/0.34.0/share/crystal/src/http/server/request_processor.cr:48:11 in 'process'
  from /home/sardaukar/.asdf/installs/crystal/0.34.0/share/crystal/src/http/server/request_processor.cr:22:3 in 'process'
  from /home/sardaukar/.asdf/installs/crystal/0.34.0/share/crystal/src/http/server.cr:498:5 in 'handle_client'
  from /home/sardaukar/.asdf/installs/crystal/0.34.0/share/crystal/src/http/server.cr:464:13 in '->'
  from /home/sardaukar/.asdf/installs/crystal/0.34.0/share/crystal/src/fiber.cr:255:3 in 'run'
  from /home/sardaukar/.asdf/installs/crystal/0.34.0/share/crystal/src/fiber.cr:92:34 in '->'
  from ???
```

This happens to me on Crystal 0.33 and 0.34 on Linux.

```
Crystal 0.34.0 [4401e90f0] (2020-04-06)

LLVM: 8.0.0
Default target: x86_64-unknown-linux-gnu
```

```
Crystal 0.33.0 [612825a53] (2020-02-14)

LLVM: 8.0.0
Default target: x86_64-unknown-linux-gnu
```
