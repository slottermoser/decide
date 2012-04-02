# Decide

An app facilitating group decisions, patterned after Google Wave.

## Requirements

Works on OS X 10.7.3 with the following. YMMV.

1. Ruby 1.9.3
2. Rails 3.2.0
3. Sqlite3 3.7.10
4. Node.js 0.6.14
5. Npm 1.1.12

## Installation

  git clone git@github.com:holdtotherod/decide.git
  cd decide/event_server
  npm install socket.io 
  cd ..
  bundle
  node event_server/event_server.js &
  rails s

Assuming you did this on your local machine, point your browser to http://127.0.0.1:3000 and enjoy. It's probable better to run the node command from a different shell window to separate the node debug output from the rails server debug output.