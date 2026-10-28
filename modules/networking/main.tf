resource "aws_vpc" "airflow-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "airflow-subnet" {
  vpc_id     = aws_vpc.airflow-vpc.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_security_group" "airflow-scheduler-db-dp-sg" {
  vpc_id = aws_vpc.airflow-vpc.id
  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    security_groups = [
      aws_security_group.airflow-api-server-sg.id
    ]

  }
  ingress {
    from_port   = 8793
    to_port     = 8793
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_security_group" "airflow-api-server-sg" {
  vpc_id = aws_vpc.airflow-vpc.id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_internet_gateway" "airflow-igw" {
  vpc_id = aws_vpc.airflow-vpc.id
}

resource "aws_route_table" "airflow-public-rt" {
  vpc_id = aws_vpc.airflow-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.airflow-igw.id
  }
}

resource "aws_route_table_association" "airflow-subnet-rt" {
  subnet_id      = aws_subnet.airflow-subnet.id
  route_table_id = aws_route_table.airflow-public-rt.id
}