# Data source para obter a AMI mais recente do Amazon Linux 2023
# O filtro busca pela AMI com o nome que segue o padrão "al2023-ami-2023.6.20241212.0-kernel-*"
# O parâmetro 'owners' limita a busca às AMIs criadas pela AWS (ID do proprietário: 137112412989)
# O campo 'most_recent' garante que será retornada a versão mais recente da AMI que corresponde aos critérios.
# Isso assegura que a última versão disponível do Amazon Linux 2023 será utilizada.

data "aws_ami" "server_ami" {
    most_recent = true
    owners = ["137112412989"]

    filter {
      name   = "name"
      values = ["al2023-ami-2023.6.20241212.0-kernel-6.1-x86_64"]
    }
}
