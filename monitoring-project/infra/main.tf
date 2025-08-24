provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_http"
  }
}

# Obtener datos de la cuenta actual
data "aws_caller_identity" "current" {}

# Crear key pair (con clave generada localmente)
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "monitoring-project-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Guardar la clave privada en AWS SSM Parameter Store (encriptada con KMS por defecto)
resource "aws_ssm_parameter" "private_key" {
  name  = "/ssh/monitoring-project"
  type  = "SecureString"
  value = tls_private_key.ssh_key.private_key_pem
}

# Ejemplo de policy para dar acceso solo a ese parámetro
resource "aws_iam_policy" "ssm_policy" {
  name        = "SSMGetParameterMonitoring"
  description = "Allow access to monitoring-project SSH private key in SSM"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Resource = "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/ssh/monitoring-project"
      }
    ]
  })
}


resource "aws_instance" "nginx_server" {
  ami                         = "ami-0c2b8ca1dad447f8a"
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.allow_ssh_http.id]
  associate_public_ip_address = true

  key_name  = aws_key_pair.generated_key.key_name
  user_data = <<-EOF
              #!/bin/bash
              # Actualizar el sistema
              yum update -y

              # Instalar Docker
              amazon-linux-extras enable docker
              amazon-linux-extras install -y docker
              systemctl enable docker
              systemctl start docker

              # Agregar ec2-user al grupo docker
              usermod -aG docker ec2-user

              # Instalar Docker Compose
              curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

              # Instalar Git
              yum install -y git

              # Clonar proyecto
              mkdir -p /opt/monitoring
              cd /opt/monitoring
              if [ ! -d ".git" ]; then
                git clone https://github.com/Rivce06/DevOps_Project_Portfolio.git .
              fi

              # Dar permisos a ec2-user
              chown -R ec2-user:ec2-user /opt/monitoring

              # Levantar stack (solo para probar, el pipeline luego hará pull/update)
              docker-compose pull || true
              docker-compose up -d || true
              EOF

  tags = {
    Name = "nginx-monitoring"
  }
}