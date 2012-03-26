var io = require('socket.io').listen(8080);

io.sockets.on('connection', function (socket) {
  socket.on('new comment', function (data) {
    socket.broadcast.emit('new comment', data);
  });
  socket.on('new reply', function(data){
  	console.log(data)
  	socket.broadcast.emit('new reply', data);
  });
});