#!/usr/bin/env python3

import socket
import os
import sys
from time import sleep
import random
from struct import pack

# Create a UDP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

host, port = '192.168.0.8', 65000
server_address = (host, port)

# Generate some random start values
x, y, z = random.random(), random.random(), random.random()

# Send a few messages
for i in range(10):

    # Pack three 32-bit floats into message and send
    message = pack('3f', x)
    sock.sendto(message, server_address)
    x =  os.system(cat /tmp/adc.fifo)
    
