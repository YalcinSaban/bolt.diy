FROM node:20.18.0

WORKDIR /app

# Sistem paketlerini güncelle ve Git yükle
RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# pnpm'i global olarak yükle (DOĞRU VERSİYON!)
RUN npm install -g pnpm@9.14.4

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
CMD ["pnpm", "run", "dev", "--", "--host", "0.0.0.0", "--port", "5173"]