export type Socket = {
	Open: (self: Socket) -> (),
	Ping: (self: Socket) -> (),
	Send: (self: Socket, data: string) -> (),
	Close: (self: Socket) -> (),

	On: (
		self: Socket,
		event: string,
		handler: (data: string) -> ()
	) -> RBXScriptConnection,
	Wait: (self: Socket, event: string) -> string,
}

return nil
