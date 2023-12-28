import struct, binascii, socket
import sys

def convert_ip(ip, port):
    family = struct.pack('H', socket.AF_INET)        # unsigned short
    portbytes = struct.pack('H', socket.htons(port)) # unsigned short
    ipbytes = socket.inet_aton(ip)
    number = struct.unpack('Q', family + portbytes + ipbytes) # unsigned long long
    number = -number[0]  # negate the number in order to get rid of null bytes 
    return "0x" + binascii.hexlify(struct.pack('>q', number)).decode('utf-8') # long long big endian

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python3 ip_struct_gen.py <ip> <port>")
        exit(1)
    ip = sys.argv[1]
    port = int(sys.argv[2])

    print(f"struct for {ip}:{port} is: ", convert_ip(ip,port))