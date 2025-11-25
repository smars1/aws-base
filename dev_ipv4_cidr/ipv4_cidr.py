import ipaddress

class Ipv4_cidr:
    def __init__(self, cidr_block):
        self.cidr_block = cidr_block
        self.network = ipaddress.ip_network(cidr_block, strict=False)

    def total_ips(self):
        return self.network.num_addresses
    
    def usable_ips(self):
        return list(self.network.hosts())
    

def main():
    cidr = Ipv4_cidr("255.0.0.0/27")
    print(f"Total IPs in {cidr.cidr_block}: {cidr.total_ips()}")    # Output: Total IPs in
    print(f"Usable IPs in {cidr.cidr_block}: {cidr.usable_ips()}")  # Output: List of usable IPs

if __name__ == "__main__":
    main()