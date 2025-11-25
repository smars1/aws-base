import logging

# general logger configuration (usar solo en el entrypoint)
logging.basicConfig(
    level=logging.INFO,  # default level
    #format="%(asctime)s | %(levelname)s | %(name)s | %(message)s",
    format="%(asctime)s | %(levelname)s  | %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S"
)

logger = logging.getLogger()

class Dev_ipv4_cidr_logger:
    def __init__(self, cidr_block, debug=False):
        if not isinstance(cidr_block, str):
            raise ValueError("CIDR block must be ipv4 string format")
        if '/' not in cidr_block:
            raise ValueError("CIDR block must contain '/' character")
        if cidr_block.count('.') != 3:
            raise ValueError("CIDR block must be in ipv4 format")
        if not (0 <= int(cidr_block.split('/')[1]) <= 32):
            raise ValueError("CIDR prefix must be between 0 and 32")
        
        self.cidr_block = cidr_block
        

    def get_mycidr(self):
            return self.cidr_block
    
    def get_aws_usable_ips(self):
        prefix = int(self.cidr_block.split('/')[1])
        logger.info(f"Calculating AWS usable IPs for CIDR: {self.cidr_block} with prefix: {prefix}")
        total_ips = 2 ** (32 - prefix)
        logger.info(f"Total IPs calculated: {total_ips}")
        if total_ips <= 4:
            no_usable_ip= max(0, total_ips - 2)  # No usable IPs for /31 and /32
            logger.info(f"CIDR block too small, returning {no_usable_ip} usable IPs")
            return no_usable_ip
        return total_ips - 5  # Subtract AWS reserved IPs
    
def main():
    cidr = Dev_ipv4_cidr_logger("10.0.0./27")
    logger.info(f"Total usable AWS IPs in {cidr.get_mycidr()} are: {cidr.get_aws_usable_ips()}")  # Output: Total usable AWS IPs in

if __name__ == "__main__":
    main()

