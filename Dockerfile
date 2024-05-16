# Usa una imagen base oficial de Node.js
FROM node:14

# Establece el directorio de trabajo en el contenedor
WORKDIR /usr/src/app

# Copia package.json y package-lock.json para instalar dependencias
COPY package*.json ./

# Instala las dependencias de Node.js
RUN npm install

# Copia el resto de la aplicación
COPY . .

# Instala CUPS y otras dependencias necesarias para pdf-to-printer
RUN apt-get update && \
    apt-get install -y libcups2 libcups2-dev cups curl apt-utils && \
    npm install -g pdf-to-printer html-pdf

# Arrancar el servicio CUPS
RUN service cups start

# Expone el puerto de la aplicación y CUPS (631 es el puerto por defecto de CUPS)
EXPOSE 3000 631

# Comando para ejecutar la aplicación
CMD ["sh", "-c", "service cups start && node index.js"]
