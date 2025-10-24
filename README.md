# 🧠 Siman.com - Proyecto de Automatización de Pruebas (Robot Framework)

Este proyecto contiene la automatización de pruebas funcionales, de regresión y API para el e-commerce [siman.com](https://www.siman.com), desarrollado con **Robot Framework**.
Su estructura está diseñada para ser **modular, escalable y mantenible** a largo plazo.

---

## 📁 Estructura general

```
siman-automation/
│
├── resources/
│   ├── locators/
│   ├── keywords/
│   ├── variables/
│   └── libraries/
│
├── tests/
│   ├── smoke/
│   ├── regression/
│   ├── api/
│   └── performance/
│
├── results/
│   ├── logs/
│   ├── reports/
│   └── screenshots/
│
├── configs/
│
├── .env
├── requirements.txt
├── run_tests.py
└── README.md
```

---

## 📘 Descripción por carpeta y archivo

### 🔹 `resources/`

Contiene **todos los elementos reutilizables** del framework: localizadores, keywords, variables y librerías personalizadas.

#### 🗂 `resources/locators/`

Archivos `.resource` con todos los **selectores UI** de cada módulo del sitio.
Ejemplo:

* `home_locators.resource` → localizadores del homepage.
* `search_locators.resource` → buscador y resultados.
* `cart_locators.resource` → botones y campos del carrito.

💡 *Ventaja*: Si cambia el frontend, solo actualizas estos archivos, sin tocar los tests.

Ejemplo:

```robot
*** Variables ***
${SEARCH_INPUT}    xpath=//input[@id='searchInput']
${ADD_TO_CART_BTN}    css=.add-to-cart-button
```

---

#### 🗂 `resources/keywords/`

Define los **keywords personalizados** (acciones o flujos) que se reutilizan en las pruebas.
Organizados por módulo o proceso del negocio.

Ejemplo de archivos:

* `browser_keywords.resource` → abrir/cerrar navegador, configurar entorno.
* `search_keywords.resource` → búsqueda de productos.
* `checkout_keywords.resource` → flujos de pago.

Ejemplo de keyword:

```robot
*** Keywords ***
Search Product
    [Arguments]    ${product_name}
    Input Text    ${SEARCH_INPUT}    ${product_name}
    Press Keys    ${SEARCH_INPUT}    RETURN
    Wait Until Page Contains    ${product_name}
```

---

#### 🗂 `resources/variables/`

Define **variables globales** y configuraciones reutilizables.

* `urls.resource` → URLs base por entorno (sandbox, stage, prod).
* `users.resource` → usuarios de prueba.
* `environment.resource` → variables comunes (browser, país, moneda).
* `testdata.resource` → datos específicos para pruebas.

Ejemplo:

```robot
*** Variables ***
${BASE_URL}    https://sv.siman.com
${DEFAULT_BROWSER}    chrome
${QA_USER}    qa_user@siman.com
${QA_PASS}    secret123
```

---

#### 🗂 `resources/libraries/`

Contiene **archivos Python personalizados** para extender Robot Framework.
Ideal para lógica compleja, cálculos o integraciones con APIs externas.

Ejemplo:

* `CustomLibrary.py` → funciones de soporte (fechas, strings, validaciones).
* `ApiUtils.py` → wrappers para peticiones REST.

---

### 🔹 `tests/`

Contiene los **suites de prueba**, organizados por tipo o nivel.

#### 🧩 `tests/smoke/`

Pruebas rápidas de validación básica (home, búsqueda, login).
Usadas en pipelines CI/CD para validación antes de cada despliegue.

#### 🧩 `tests/regression/`

Flujos completos de usuario o validaciones de negocio (compra, checkout, promociones).

#### 🧩 `tests/api/`

Pruebas de endpoints del backend (creación de órdenes, validación de carrito, pagos).

#### 🧩 `tests/performance/`

Pruebas simples de carga o estrés, combinadas con tiempos de respuesta.

💡 *Cada suite importa solo los recursos que necesita.*

Ejemplo de cabecera:

```robot
*** Settings ***
Resource    ../../resources/keywords/search_keywords.resource
Resource    ../../resources/variables/environment.resource
Test Setup  Open Browser To Homepage
Test Teardown  Close Browser
```

---

### 🔹 `results/`

Carpeta donde se generan automáticamente los **logs, reportes y capturas de pantalla** después de cada ejecución.

Subcarpetas:

* `logs/` → logs `.xml` o `.txt`.
* `reports/` → reportes HTML (Robot Report, Allure, etc.).
* `screenshots/` → evidencias capturadas al fallar una prueba.

---

### 🔹 `configs/`

Archivos `.yaml` por entorno (sandbox, stage, prod).
Contienen configuraciones de entorno, URLs, credenciales y parámetros.

Ejemplo `env_stage.yaml`:

```yaml
base_url: "https://stage.siman.com"
api_url: "https://api-stage.siman.com"
browser: "chrome"
headless: true
credentials:
  user: "qa_stage@siman.com"
  password: "secret123"
```

---

### 🔹 `.env`

Archivo con variables de entorno que se cargan automáticamente (por ejemplo, claves API o credenciales de prueba).

---

### 🔹 `requirements.txt`

Dependencias del proyecto:

```
robotframework
robotframework-seleniumlibrary
robotframework-requests
robotframework-jsonlibrary
pabot
PyYAML
```

---

### 🔹 `run_tests.py`

Script Python para ejecutar las pruebas con diferentes entornos o configuraciones.

Ejemplo:

```python
import sys
from robot import run

env = sys.argv[1] if len(sys.argv) > 1 else "sandbox"
run("tests", variable=[f"ENV:{env}"], outputdir=f"results/{env}")
```

Ejecución:

```bash
python run_tests.py stage
```

---

## 🚀 Ejecución de pruebas

Ejemplo desde consola:

```bash
robot -d results/smoke tests/smoke/home_smoke.robot
```

Ejemplo con entorno:

```bash
python run_tests.py prod
```

Ejemplo en paralelo con Pabot:

```bash
pabot --processes 4 --outputdir results/regression tests/regression/
```

---

## 💡 Buenas prácticas

1. **No mezclar lógica de negocio con localizadores.**
2. **Usar keywords descriptivos y reutilizables.**
3. **Agrupar por módulos funcionales (Search, Cart, Checkout).**
4. **Mantener los tests simples y legibles.**
5. **Usar control de versiones (Git) y ramas por feature.**
6. **Ejecutar smoke tests en cada build (CI/CD).**
7. **Actualizar locators desde un único punto (`resources/locators`).**
8. **Integrar reportes Allure o ReportPortal para trazabilidad.**

---

## 👨‍💻 Mantenido por el equipo de QA Automation - Siman

📧 Contacto: [juan_valencia@siman.com](ronald_renderos@siman.com)
🧪 Framework: Robot Framework + SeleniumLibrary + RequestsLibrary
