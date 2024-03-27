#VPC

resource "aws_vpc" "vpc_devglobo" {
  cidr_block = "10.0.0.0/21"


  tags = {
    Name = "vpc_deveqi"
  }
}

#Subnets públicas

resource "aws_subnet" "devglobo-public-a" {
  vpc_id            = aws_vpc.vpc_devglobo.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "sa-east-1a"

  tags = {
    Name = "devglobo-public-a"
  }
}



resource "aws_subnet" "devglobo-public-b" {
  vpc_id            = aws_vpc.vpc_devglobo.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "sa-east-1b"

  tags = {
    Name = "devglobo-public-b"
  }
}



#Subnets privadas

resource "aws_subnet" "devglobo-private-a" {
  vpc_id            = aws_vpc.vpc_devglobo.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "sa-east-1a"

  tags = {
    Name = "devglobo-private-a"
  }
}



resource "aws_subnet" "devglobo-private-b" {
  vpc_id            = aws_vpc.vpc_devglobo.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "sa-east-1b"

  tags = {
    Name = "devglobo-private-b"
  }
}



#Internet Gateway

resource "aws_internet_gateway" "ig-devglobo" {
  vpc_id = aws_vpc.vpc_devglobo.id

  tags = {
    Name = "ig_devglobo"
  }
}


# Associação do Internet Gateway à tabela de roteamento pública

resource "aws_route_table" "devglobo-rtpublic" {
  vpc_id = aws_vpc.vpc_devglobo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig-devglobo.id
  }

  tags = {
    Name = "devglobo-public-route"
  }
}


#Associações de tabelas de roteamento para subnets públicas

resource "aws_route_table_association" "rta-devglobo-public-a" {
  subnet_id      = aws_subnet.devglobo-public-a.id
  route_table_id = aws_route_table.devglobo-rtpublic.id
}

resource "aws_route_table_association" "rta-devglobo-public-b" {
  subnet_id      = aws_subnet.devglobo-public-b.id
  route_table_id = aws_route_table.devglobo-rtpublic.id
}



#Tabelas de roteamento privadas

resource "aws_route_table" "devglobo-rtprivate" {
  vpc_id = aws_vpc.vpc_devglobo.id
  tags = {
    Name = "devglobo-rtprivate"
  }
}


#Associações de tabelas de roteamento para subnets 

resource "aws_route_table_association" "rta-devglobo-private-a" {
  subnet_id      = aws_subnet.devglobo-private-a.id
  route_table_id = aws_route_table.devglobo-rtprivate.id
}

resource "aws_route_table_association" "rta-devglobo-private-b" {
  subnet_id      = aws_subnet.devglobo-private-b.id
  route_table_id = aws_route_table.devglobo-rtprivate.id
}




#Security Group API 

resource "aws_security_group" "sg-devglobo" {
  name        = "sg_devglobo_app"
  description = "Security group that allows ssh/https and all egress traffic"
  vpc_id      = aws_vpc.vpc_devglobo.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.devglobo-private-a.cidr_block]

  }

  tags = {
    Name = "sg-devglobo-app"
  }
}

