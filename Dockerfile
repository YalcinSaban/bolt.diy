FROM node:20.18.0

WORKDIR /app

# Sistem paketlerini güncelle ve Git yükle
RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# pnpm'i global olarak yükle
RUN npm install -g pnpm@9.1.0

# Package dosyalarını kopyala
COPY package.json pnpm-lock.yaml* ./

# Bağımlılıkları yükle
RUN pnpm install --frozen-lockfile

# Tüm kaynak kodları kopyala
COPY . .

# Build yap
RUN pnpm run build

# Port aç
EXPOSE 5173

# Uygulamayı başlat
CMD ["pnpm", "run", "start"]