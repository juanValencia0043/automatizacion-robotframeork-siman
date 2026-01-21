# 📊 Guía de Generación de Reportes Detallados

Este proyecto incluye herramientas avanzadas para generar reportes detallados de las pruebas automatizadas con Robot Framework.

## 📋 Tipos de Reportes Disponibles

### 1. **Reporte HTML Detallado** 
Reporte visual interactivo con estadísticas completas
- **Archivo:** `results/DETAILED_REPORT.html`
- **Contenido:**
  - Resumen visual con tarjetas de métricas
  - Tabla de todas las pruebas
  - Análisis de fallos
  - Detalles de keywords ejecutados
  - Timeline de ejecución

### 2. **Reportes Estándar de Robot Framework**
- **Reporte HTML:** `results/report.html`
- **Log HTML:** `results/log.html`
- **XML:** `results/output.xml` (datos crudos)

### 3. **Exportaciones en Múltiples Formatos**
Ubicación: `results/exports/`

- **JSON:** `results.json` - Datos estructurados completos
- **CSV Tests:** `test_results.csv` - Resultados de pruebas en tabla
- **CSV Keywords:** `keyword_results.csv` - Keywords y tiempos
- **Markdown:** `REPORTE.md` - Reporte legible en texto

### 4. **Dashboard Interactivo**
- **Archivo:** `results/dashboards/index.html`
- **Datos:** `results/dashboards/data/execution_history.json`

## 🚀 Formas de Usar

### Opción 1: Ejecución con Reportes Automáticos (⭐ Recomendado)
```bash
python run_and_report.py sandbox
```
O para producción:
```bash
python run_and_report.py prod
```

**Esto ejecutará:**
1. Las pruebas
2. Generará el reporte HTML detallado
3. Exportará a JSON, CSV y Markdown
4. Actualizará el dashboard

### Opción 2: Generar Reporte Detallado Solamente
Si ya ejecutaste las pruebas y solo necesitas el reporte:
```bash
python generate_detailed_report.py
```

### Opción 3: Exportar a Múltiples Formatos
```bash
python export_test_reports.py
```

### Opción 4: Ejecución Tradicional + Reportes Manuales
```bash
python run_tests.py sandbox
python generate_detailed_report.py
python export_test_reports.py
```

## 📊 Interpretar el Reporte HTML Detallado

### Sección de Resumen (Summary Cards)
- **Pruebas Totales:** Número total de casos de prueba
- **Pasadas ✓:** Cantidad de pruebas exitosas
- **Fallidas ✗:** Cantidad de pruebas con errores
- **Tasa de Éxito:** Porcentaje de pruebas pasadas

### Sección de Información General
Muestra:
- Tiempo total de ejecución
- Hora de inicio y fin
- Pruebas omitidas

### Análisis de Fallos
Si hay fallos, muestra:
- **Prueba que falló:** Nombre del test
- **Falló en:** Keyword donde ocurrió el error
- **Tiempo:** Cuánto tiempo llevaba ejecutándose
- **Patrones comunes:** Keywords que fallan frecuentemente

### Detalle de Pruebas
Tabla con:
- Nombre de la prueba
- Estado (PASS/FAIL/SKIP)
- Tiempo de ejecución
- Tags asociados

### Keywords Ejecutados
Desglose de cada keyword por prueba:
- Nombre del keyword
- Estado
- Tiempo de ejecución

## 📈 Exportar Datos para Análisis

### JSON - Para Sistemas Externos
```bash
python export_test_reports.py
# Genera: results/exports/results.json
```

Ejemplo de estructura:
```json
{
  "export_date": "2026-01-21T14:30:00",
  "suite": {
    "name": "Automatizacion-Robotframeork-Siman",
    "elapsed_time": 125.45
  },
  "statistics": {
    "total": {
      "passed": 8,
      "failed": 2,
      "total": 10
    }
  },
  "tests": [...]
}
```

### CSV - Para Excel
Los archivos CSV pueden abrirse directamente en Excel:
- `test_results.csv` - Análisis por prueba
- `keyword_results.csv` - Análisis de performance de keywords

### Markdown - Para Documentación
El archivo `REPORTE.md` contiene:
- Resumen ejecutivo
- Listado de pruebas pasadas/fallidas
- Estadísticas por tags
- Keywords más lentos

## 🔍 Casos de Uso

### Caso 1: Verificar rápidamente si las pruebas pasaron
```bash
python run_and_report.py sandbox
# Abre: results/DETAILED_REPORT.html
```

### Caso 2: Analizar un fallo específico
1. Abre `results/DETAILED_REPORT.html`
2. Ve a la sección "Análisis de Fallos"
3. Identifica el keyword que falló
4. Abre `results/log.html` para más detalles

### Caso 3: Compartir resultados en reunión
- Usa `results/exports/REPORTE.md` para presentación
- Adjunta `results/DETAILED_REPORT.html` para análisis visual

### Caso 4: Integración con CI/CD
```bash
python run_and_report.py sandbox
# Los reportes se generan automáticamente
# Adjunta results/exports/results.json a tu sistema de reporte
```

### Caso 5: Análisis histórico de performance
1. Los datos se guardan en `results/dashboards/data/execution_history.json`
2. El dashboard en `results/dashboards/index.html` muestra tendencias

## ⚙️ Personalizar los Reportes

### Modificar Colores
En `generate_detailed_report.py`, busca la sección `<style>` y modifica los colores:
```css
background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
```

### Agregar Nuevas Secciones
Edita la función `_generate_html_report()` en `generate_detailed_report.py`

### Cambiar Formatos de Exportación
Modifica `export_test_reports.py` para agregar nuevos formatos

## 📝 Notas Importantes

1. Los reportes se generan automáticamente después de cada ejecución
2. El archivo `output.xml` debe existir en `results/` para generar reportes
3. Se recomienda usar `run_and_report.py` para automatización completa
4. Los reportes HTML son independientes y pueden compartirse fácilmente
5. Los datos exportados en JSON/CSV pueden integrarse con herramientas externas

## 🐛 Solución de Problemas

### "No se encontró output.xml"
- Asegúrate de haber ejecutado primero las pruebas con `python run_tests.py <env>`
- Verifica que exista el archivo `results/output.xml`

### "No se encontró el archivo de configuración"
- Verifica que existan `configs/env_sandbox.yaml` o `configs/env_prod.yaml`

### Los reportes no se actualizan
- Borra la carpeta `results/__pycache__`
- Ejecuta de nuevo: `python run_and_report.py sandbox`

## 📞 Soporte

Para reportes adicionales o modificaciones:
1. Edita los archivos Python correspondientes
2. Prueba localmente con `python <script>.py`
3. Ajusta según tus necesidades

---

**Última actualización:** Enero 2026
