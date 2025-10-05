FROM node:20.18.0

WORKDIR /app

# Git yükle
RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# pnpm yükle
RUN npm install -g pnpm@9.14.4

# Dosyaları kopyala
COPY package.json pnpm-lock.yaml* ./

# Bağımlılıkları yükle
RUN pnpm install --frozen-lockfile

# Kaynak kodları kopyala
COPY . .

# Git bilgisini kopyala (eğer varsa)
COPY .git .git 2>/dev/null || true

# Production build yap
RUN pnpm run build

# Port
EXPOSE 5173

# Preview modunda başlat (production build'i serve eder)
CMD ["pnpm", "run", "preview", "--", "--host", "0.0.0.0", "--port", "5173"]