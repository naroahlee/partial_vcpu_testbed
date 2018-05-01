#!/usr/bin/python
# A Server for change the Interface

import socket
import sys
import os
import subprocess

def getdomid(domname):
	mycmd = 'xl list | grep ' + domname + '| awk \'{print $2}\''
	xlout = subprocess.check_output(mycmd, shell=True)
	itemnum = xlout.count('\n')
	if(1 != itemnum):
		return -1
	else:
		return int(xlout)

if(os.geteuid() != 0):
	print 'Not Root!'
	sys.exit(-1)


# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Bind the socket to the port
server_address = ('192.168.1.1', 18585)
print >> sys.stderr, 'starting up on %s port %s' % server_address
sock.bind(server_address)

# Listen for incoming connections
sock.listen(1)

while True:
	# Wait for a connection
	print >> sys.stderr, '[PYHMM] Waiting for a Connection'
	connection, client_address = sock.accept()

	try:
		print >> sys.stderr, '[PYHMM] Connection from', client_address
		# Receive the data in small chunks and retransmit it
		data = connection.recv(255)
		domname, budget, period, priority = data.split(',')
		domid = getdomid(domname)
		if(domid > 0):
			xlcmd = 'xl sched-rtds -v all -e 0 -d ' + str(domid) + ' -b ' + budget + ' -p ' + period + ' -r ' + priority
			os.system(xlcmd)
			print '[PYHMM]', xlcmd
		else:
			print 'DomName:' + domname + ' Error!'

	except KeyboardInterrupt:
		# Clean up the connection
		connection.close()
			
	finally:
		# Clean up the connection
		connection.close()
