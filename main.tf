resource "aws_vpc" "opensearch_tool" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

# Create public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.opensearch_tool.id
  cidr_block              = var.public_subnet_cidr_block
  availability_zone       = var.pub_subnet_zone
  map_public_ip_on_launch = true
  tags = {
    Name = var.pub_subnet_name
  }
}

# Create bastion instance in the public subnet
resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  key_name                    = var.key_public
  associate_public_ip_address = true
  tags = {
    Name = var.instance_name
  }
}

# Create private subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.opensearch_tool.id
  cidr_block              = var.private_subnet_1_cidr_block
  availability_zone       = var.private_subnet1_zone
  map_public_ip_on_launch = false
  tags = {
    Name = var.private_subnet1_name
  }
}

resource "aws_security_group" "private_subnet_1_sg" {
  name   = var.private_sg1_name
  vpc_id = aws_vpc.opensearch_tool.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.opensearch_tool.id
  cidr_block              = var.private_subnet_2_cidr_block
  availability_zone       = var.private_subnet2_zone
  map_public_ip_on_launch = false
  tags = {
    Name = var.private_subnet2_name
  }
}

resource "aws_security_group" "private_subnet_2_sg" {
  name   = var.private_sg2_name
  vpc_id = aws_vpc.opensearch_tool.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Prvate Instance 
resource "aws_instance" "private_instance_1" {
  ami                    = var.ami_id
  instance_type          = var.private_instance_type
  subnet_id              = aws_subnet.private_subnet_1.id
  key_name               = var.key_public
  vpc_security_group_ids = [aws_security_group.private_subnet_1_sg.id]
  tags = {
    Name = var.private_instance1_name
  }
}

resource "aws_instance" "private_instance_2" {
  ami                    = var.ami_id
  instance_type          = var.private_instance_type
  subnet_id              = aws_subnet.private_subnet_2.id
  key_name               = var.key_private
  vpc_security_group_ids = [aws_security_group.private_subnet_2_sg.id]
  tags = {
    Name = var.private_instance2_name
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.opensearch_tool.id

  tags = {
    Name = var.igw_name
  }
}

# Create Elastic IP
resource "aws_eip" "nat_eip" {
  vpc = true
  tags = {
    Name = var.eip_name
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = var.nat_name
  }
}

# Create public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.opensearch_tool.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.pub_routetable_name
  }
}

# Associate public subnet with public route table
resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}



# Create private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.opensearch_tool.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = var.priv_routetable_name
  }
}

# Associate private subnets with private route table
resource "aws_route_table_association" "private_subnet_1_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_2_association" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}


# Create target group
resource "aws_lb_target_group" "target_group" {
  name        = var.tg_name
  port        = var.tg_port
  protocol    = var.tg_protocol
  vpc_id      = aws_vpc.opensearch_tool.id
  target_type = var.tg_target_type
}

# Create Application Load Balancer
resource "aws_lb" "load_balancer" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = var.lb_type
  security_groups    = [aws_security_group.private_subnet_1_sg.id, aws_security_group.private_subnet_2_sg.id]
  subnets            = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]


}

# Attach target group to load balancer
resource "aws_lb_target_group_attachment" "attachment_1" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.private_instance_1.id
  port             = 9200
}

resource "aws_lb_target_group_attachment" "attachment_2" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.private_instance_2.id
  port             = 9200
}
