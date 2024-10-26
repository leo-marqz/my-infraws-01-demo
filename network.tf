
resource "aws_vpc" "vpc_virginia" {
  cidr_block           = var.virginia_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "ABC Enterprise VPC"
  }

  provider = aws.virginia
}

# =======================================================
# ============== public Subnet 1 ========================
# =======================================================

resource "aws_subnet" "virginia_public_subnet_1" {
  vpc_id                  = aws_vpc.vpc_virginia.id
  cidr_block              = var.virginia_subnets[0]
  availability_zone       = var.virginia_azs[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet 1"
  }
}

# =======================================================
# ============== public Subnet 2 ========================
# =======================================================

resource "aws_subnet" "virginia_public_subnet_2" {
  vpc_id                  = aws_vpc.vpc_virginia.id
  cidr_block              = var.virginia_subnets[1]
  availability_zone       = var.virginia_azs[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet 2"
  }
}

# =======================================================
# ============= Internet Gateway 1 ======================
# =======================================================

resource "aws_internet_gateway" "virginia_igw" {
  vpc_id = aws_vpc.vpc_virginia.id
  tags = {
    Name = "Internet Gateway 1"
  }
}

resource "aws_route_table" "virginia_public_route_table" {
  vpc_id = aws_vpc.vpc_virginia.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.virginia_igw.id
  }
  tags = {
    Name = "Public Route Table 1"
  }
}

resource "aws_route_table_association" "virginia_public_subnet_1_association" {
  subnet_id      = aws_subnet.virginia_public_subnet_1.id
  route_table_id = aws_route_table.virginia_public_route_table.id
}

resource "aws_route_table_association" "virginia_public_subnet_2_association" {
  subnet_id      = aws_subnet.virginia_public_subnet_2.id
  route_table_id = aws_route_table.virginia_public_route_table.id
}


# =======================================================
# ============= Private Subnet 1 ========================
# =======================================================

resource "aws_subnet" "virginia_private_subnet_1" {
    vpc_id = aws_vpc.vpc_virginia.id
    cidr_block = var.virginia_subnets[2]
    availability_zone = var.virginia_azs[0]
    tags = {
        Name = "Private Subnet 1"
    }
}


resource "aws_route_table" "virginia_private_route_table_1" {
    vpc_id = aws_vpc.vpc_virginia.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.virginia_nat_gateway_1.id
    }
    tags = {
      Name = "Private Route Table 1"
    }
}

resource "aws_route_table_association" "virginia_private_subnet_1_association" {
    subnet_id = aws_subnet.virginia_private_subnet_1.id
    route_table_id = aws_route_table.virginia_private_route_table_1.id
}

# =======================================================
# ============= Private Subnet 2 ========================
# =======================================================

resource "aws_subnet" "virginia_private_subnet_2" {
    vpc_id = aws_vpc.vpc_virginia.id
    cidr_block = var.virginia_subnets[3]
    availability_zone = var.virginia_azs[1]
    tags = {
        Name = "Private Subnet 2"
    }
}

resource "aws_route_table" "virginia_private_route_table_2" {
    vpc_id = aws_vpc.vpc_virginia.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.virginia_nat_gateway_1.id
    }
    tags = {
      Name = "Private Route Table 2"
    }
}

resource "aws_route_table_association" "virginia_private_subnet_2_association" {
    subnet_id = aws_subnet.virginia_private_subnet_2.id
    route_table_id = aws_route_table.virginia_private_route_table_2.id
}

# =======================================================
# ================ Elastic IPv4 1 =======================
# =======================================================

resource "aws_eip" "mi_elastic_ip" {
  tags = {
    Name = "Elastic IP 1"
  }
}


# =======================================================
# ================ NAT Gateway 1 ========================
# =======================================================

resource "aws_nat_gateway" "virginia_nat_gateway_1" {
    subnet_id = aws_subnet.virginia_public_subnet_1.id
    allocation_id = aws_eip.mi_elastic_ip.id
    tags = {
        Name = "NAT Gateway 1"
    }
    depends_on = [ aws_internet_gateway.virginia_igw ]
}



