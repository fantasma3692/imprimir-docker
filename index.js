const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const path = require('path');
const fs = require('fs');
const { exec } = require('child_process');
const app = express();

const port = process.env.PORT || 3000; // Usar el puerto definido por la variable de entorno PORT o 10000 como valor predeterminado
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Endpoint para obtener la lista de impresoras disponibles
app.get('/printers', (req, res) => {
  exec('lpstat -a', (error, stdout, stderr) => {
    if (error) {
      console.error('Error al obtener las impresoras:', error);
      return res.status(500).send('Error al obtener las impresoras');
    }
    const printers = stdout.split('\n').map(line => {
      const [name] = line.split(' ');
      return name;
    }).filter(name => name);
    res.json(printers);
  });
});

app.post('/print', (req, res) => {
  const { content, options } = req.body;

  if (!content) {
    return res.status(400).send('El contenido es requerido');
  }

  const pdfPath = path.join(__dirname, 'temp.pdf');

  try {
    const pdf = require('html-pdf');
    pdf.create(content).toFile(pdfPath, (err, result) => {
      if (err) return res.status(500).send('Error al crear el PDF');

      const printerName = options && options.printer || 'default';
      exec(`lp -d ${printerName} ${result.filename}`, (printError, stdout, stderr) => {
        if (printError) {
          return res.status(500).send('Error al imprimir el PDF');
        }
        res.send('Impresión enviada');
        // Elimina el archivo temporal después de imprimir
        fs.unlinkSync(result.filename);
      });
    });
  } catch (error) {
    res.status(500).send(error.message);
  }
});

app.listen(port, () => {
  console.log(`Servidor de impresión escuchando en http://localhost:${port}`);
});
