#!/usr/bin/python

import socket
import sys

def usage():
	print './myRIclient [DomName] [Budget] [Period] [Priority]'

if(len(sys.argv) != 5):
	print 'Wrong Argument'
	usage()
	sys.exit(-1)

message = sys.argv[1] + ',' + sys.argv[2] + ',' + sys.argv[3] + ',' + sys.argv[4]

# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Connect the socket to the port where the server is listening
server_address = ('192.168.1.1', 18585)
print '[PYDMM] Connect to HMM'
sock.connect(server_address)


try:
	# Send data
	print '[PYDMM] Send: Dom %s (%s, %s)' % (sys.argv[1], sys.argv[2], sys.argv[3])
	sock.sendall(message)

finally:
	print '[PYDMM] Close Socket'
	sock.close()


