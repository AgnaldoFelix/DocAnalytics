# Escolhe a imagem base do Node.js
FROM node:18

# Define variáveis de ambiente
ENV DEBIAN_FRONTEND=noninteractive \
    NODE_ENV=production

# Atualiza e instala dependências necessárias em uma única camada
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Cria diretório da aplicação
WORKDIR /app

# Copia apenas os arquivos necessários para instalar dependências
COPY package*.json ./

# Instala as dependências do projeto de forma consistente
RUN npm ci --only=production

# Copia o restante dos arquivos do projeto
COPY . .

# Compila o projeto (opcional, dependendo se for para produção ou dev)
# RUN npm run build

# Expõe a porta desejada (5173 no seu caso)
EXPOSE 5173

# Comando para rodar o servidor Vite
CMD ["npm", "run", "dev", "--", "--port", "5173", "--host"]
