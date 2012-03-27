var io = require('socket.io').listen(8080);

io.sockets.on('connection', function (socket) {
	socket.on('set id', function(data){
		socket.set('id', data.id, function(){});
	});
	socket.on('new comment', function (data) {
		socket.get('id', function(err, id){
			io.sockets.clients().forEach(function(sock){
				sock.get('id', function(err, sockID){
					if(sock != socket && id == sockID)
						sock.emit('new comment', data);
				});
			});
		});
	});
	socket.on('new reply', function(data){
		socket.get('id', function(err, id){
			io.sockets.clients().forEach(function(sock){
				sock.get('id', function(err, sockID){
					if(sock != socket && id == sockID)
						sock.emit('new reply', data);
				});
			});
		});
	});
});