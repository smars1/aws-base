class CidrCalc:
    def __init__(self, cidr_block: str):
        """
        param cidr_block: str: CIDR block en cadena de texto (e.g., "10.0.0.0/27"
        """
        self.cidr_block = cidr_block
        print(f"este es el bloque cidr {cidr_block}")
        validate_cidr_block = cidr_block.split('/')
        print(f"este es el bloque cidr cuando se hace split a la cadena {validate_cidr_block}")
        print(f"este es el tipo de dato del cidr_block {type(cidr_block)}")
        print(f"este es el tipo de dato del validate_cidr_block[1]: valor: {validate_cidr_block[1]} es tipo {type(validate_cidr_block[1])}")
        int_cidr_suffix = int(validate_cidr_block[1])
        print(f"este es el valor y tipo de dato del int_cidr: valor {int_cidr_suffix} tipo: {type(int_cidr_suffix)}")
        
        if not isinstance(cidr_block, str):
            raise ValueError("CIDR debe ser una cadena de texto")
        if not (16 <= int_cidr_suffix <= 28):
            raise ValueError("CIDR debe estar entre 16 y 28")
        self.cidr_block = cidr_block

    def get_cidr(self):
        return self.cidr_block
    
    def get_total_ips(self):
        prefix = int(self.cidr_block.split('/')[1])
        total_ips = (2 ** (32 - prefix)) - 5  # Restar 5 IPs reservadas por AWS
        return total_ips
    

def main():
    cidr = CidrCalc("10.0.0.0/8")
    print(f"CIDR Block: {cidr.get_cidr()}")  # Output: CIDR Block:  
    print(f"Total IPs en {cidr.get_cidr()}: {cidr.get_total_ips()}")  # Output: Total IPs in

if __name__ == "__main__":
    main()