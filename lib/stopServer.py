# return response and shutdown the server
import threading
assassin = threading.Thread(target=server.shutdown)
assassin.daemon = True
assassin.start()
