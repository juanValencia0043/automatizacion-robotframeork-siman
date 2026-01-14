import os
import sys  # ✅ Este import debe estar al inicio
import yaml
import json
import datetime
import shutil
from robot import run
from robot.api import ExecutionResult

def load_env_config(env):
    """Carga el archivo de configuración YAML del entorno"""
    config_path = os.path.join("configs", f"env_{env}.yaml")
    if not os.path.exists(config_path):
        raise FileNotFoundError(f"No se encontró el archivo de configuración: {config_path}")
    with open(config_path, "r", encoding="utf-8") as file:
        return yaml.safe_load(file)

def create_execution_directory(env_name):
    """Crea el directorio de ejecución actual con timestamp"""
    now = datetime.datetime.now()
    year = now.strftime("%Y")
    month = now.strftime("%m_%B").lower()
    timestamp = now.strftime("%Y%m%d_%H%M%S")
    
    execution_dir = f"results/executions/{year}/{month}/{timestamp}_{env_name}"
    os.makedirs(execution_dir, exist_ok=True)
    os.makedirs(f"{execution_dir}/screenshots", exist_ok=True)
    
    # SOLUCIÓN SIMPLIFICADA: En Windows, no usar symlinks
    latest_link = "results/executions/latest"
    
    if os.name == 'nt':  # Windows
        # En Windows, crear un archivo de texto con la ruta en lugar de symlink
        latest_file = "results/executions/latest.txt"
        with open(latest_file, 'w') as f:
            f.write(execution_dir)
        print(f"📝 Ruta de última ejecución guardada en: {latest_file}")
    else:  # Linux/Mac
        # Manejo de symlink para sistemas Unix
        if os.path.exists(latest_link) or os.path.islink(latest_link):
            try:
                os.remove(latest_link)
            except Exception as e:
                print(f"⚠️ No se pudo eliminar symlink anterior: {e}")
        
        try:
            os.symlink(os.path.abspath(execution_dir), latest_link)
            print(f"🔗 Symlink creado: {latest_link} -> {execution_dir}")
        except Exception as e:
            print(f"⚠️ No se pudo crear symlink: {e}")
    
    return execution_dir

def update_dashboard_data(output_file, env_name, config):
    """Actualiza los datos del dashboard"""
    try:
        result = ExecutionResult(output_file)
        
        dashboard_data = {
            "timestamp": datetime.datetime.now().strftime("%Y%m%d_%H%M%S"),
            "environment": env_name,
            "base_url": config.get('base_url', 'N/A'),
            "browser": config.get('browser', 'N/A'),
            "total_tests": result.statistics.total.total,
            "passed": result.statistics.total.passed,
            "failed": result.statistics.total.failed,
            "success_rate": round((result.statistics.total.passed / result.statistics.total.total) * 100, 2) if result.statistics.total.total > 0 else 0,
            "execution_time": result.suite.elapsedtime,
            "suite_name": result.suite.name
        }
        
        # Agregar a historial
        history_file = "results/dashboards/data/execution_history.json"
        os.makedirs(os.path.dirname(history_file), exist_ok=True)
        
        history = []
        if os.path.exists(history_file):
            try:
                with open(history_file, 'r') as f:
                    history = json.load(f)
            except json.JSONDecodeError:
                history = []
        
        history.append(dashboard_data)
        
        # Mantener solo últimos 50 ejecuciones
        if len(history) > 50:
            history = history[-50:]
        
        with open(history_file, 'w') as f:
            json.dump(history, f, indent=2)
            
        print(f"📈 Dashboard actualizado: {history_file}")
        
    except Exception as e:
        print(f"⚠️ Error actualizando dashboard: {e}")

def format_xray_date(robot_date):
    """Convierte fecha de Robot a formato XRay Server"""
    try:
        if not robot_date:
            return datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%S.000-0600")
        
        # Formato Robot: 20251102 23:55:21.324
        # Formato XRay: 2024-11-02T23:55:21.324-0600
        date_part = robot_date[:8]  # 20251102
        time_part = robot_date[9:]  # 23:55:21.324
        
        formatted_date = f"{date_part[:4]}-{date_part[4:6]}-{date_part[6:8]}T{time_part}-0600"
        return formatted_date
    except Exception:
        return datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%S.000-0600")

def generate_xray_payload(output_file, env_name, config):
    """Genera payload para XRay Server/Data Center"""
    try:
        if not os.path.exists(output_file):
            print("❌ No se encontró el output.xml para XRay")
            return None
        
        result = ExecutionResult(output_file)
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        
        xray_payload = {
            "testExecutionKey": f"SIMAN-{timestamp}",
            "info": {
                "summary": f"Automated Execution - {env_name}",
                "description": f"Robot Framework execution for {env_name}",
                "user": config.get('jira_user', 'juan_valencia@siman.com'),
                "startDate": format_xray_date(result.suite.starttime if hasattr(result.suite, 'starttime') else None),
                "finishDate": format_xray_date(result.suite.endtime if hasattr(result.suite, 'endtime') else None),
                "testPlanKey": config.get('test_plan_key', ''),
                "testEnvironments": []  # ⬅️ Array vacío - omite ambientes
            },
            "tests": []
        }
        
        # Procesar tests recursivamente
        tests_found = process_tests_recursive(result.suite, xray_payload['tests'])
        
        if tests_found == 0:
            print("⚠️ No se encontraron tests para el payload de XRay")
            return None
        
        # Guardar payload
        xray_file = f"results/xray/payloads/xray_{timestamp}_{env_name}.json"
        os.makedirs(os.path.dirname(xray_file), exist_ok=True)
        
        with open(xray_file, 'w', encoding='utf-8') as f:
            json.dump(xray_payload, f, indent=2, ensure_ascii=False)
        
        print(f"📦 Payload XRay generado: {xray_file} ({tests_found} tests)")
        return xray_file
        
    except Exception as e:
        print(f"❌ Error generando payload XRay: {e}")
        return None

def process_tests_recursive(suite, tests_list):
    """Procesa tests recursivamente para XRay Server"""
    count = 0
    
    for test in suite.tests:
        count += 1
        
        status = "PASSED" if test.passed else "FAILED"
        
        # Buscar cualquier tag que empiece con CSC-
        test_key = None
        for tag in test.tags:
            if tag.startswith('CSC-'):
                test_key = tag
                break
        
        if not test_key:
            print(f"⚠️ No se encontró tag CSC- en test: {test.name}")
            continue
        
        test_data = {
            "testKey": test_key,
            "start": format_xray_date(test.starttime),
            "finish": format_xray_date(test.endtime),
            "status": status,
            "comment": f"Automated test execution: {test.name}",
            "steps": [
                {
                    "status": status,
                    "actualResult": f"Test {test.name} completed with status: {status}"
                }
            ]
        }
        
        tests_list.append(test_data)
        print(f"✅ Test agregado: {test_key}")
    
    for sub_suite in suite.suites:
        count += process_tests_recursive(sub_suite, tests_list)
    
    return count

def ensure_results_structure():
    """Asegura que exista la estructura completa de directorios"""
    base_dirs = [
        "results/executions",
        "results/dashboards/data",
        "results/dashboards/templates", 
        "results/xray/payloads",
        "results/xray/evidence/screenshots",
        "results/xray/evidence/logs",
        "results/artifacts/test-results/junit",
        "results/artifacts/test-results/allure",
        "results/artifacts/reports"
    ]
    
    for directory in base_dirs:
        os.makedirs(directory, exist_ok=True)

def generate_dashboard():
    """Genera el archivo HTML del dashboard"""
    try:
        template_path = "results/dashboards/templates/dashboard.html"
        dashboard_path = "results/dashboards/index.html"
        
        if not os.path.exists(template_path):
            print("❌ No se encontró el template del dashboard")
            return False
        
        # Asegurar que existe el directorio destino
        os.makedirs(os.path.dirname(dashboard_path), exist_ok=True)
        
        # Copiar template a index.html
        shutil.copy2(template_path, dashboard_path)
        
        # Actualizar timestamp en el dashboard
        with open(dashboard_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Agregar timestamp de generación
        timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        content = content.replace(
            '<p>Siman.com - Resultados de Ejecución</p>', 
            f'<p>Siman.com - Resultados de Ejecución | Generado: {timestamp}</p>'
        )
        
        with open(dashboard_path, 'w', encoding='utf-8') as f:
            f.write(content)
        
        print(f"✅ Dashboard generado: {os.path.abspath(dashboard_path)}")
        return True
        
    except Exception as e:
        print(f"⚠️ Error generando dashboard: {e}")
        return False

def main():
    # ✅ Usar sys.argv directamente, sin redefinir sys
    if len(sys.argv) < 2:
        print("⚠️  Debes especificar un entorno (por ejemplo: python run_tests.py sandbox)")
        sys.exit(1)

    env = sys.argv[1]
    
    try:
        config = load_env_config(env)
    except FileNotFoundError as e:
        print(f"❌ {e}")
        sys.exit(1)

    # Asegurar estructura de directorios
    ensure_results_structure()
    
    # Crear directorio de ejecución específico
    execution_dir = create_execution_directory(env)
    
    # Define las rutas base
    test_dir = os.path.join("tests", "regression")  # Ajusta según sea necesario
    
    # Variables que se enviarán al Robot
    variables = [
        # Se configuran en archivo env
        f"BASE_URL:{config['base_url']}",
        f"BROWSER:{config['browser']}",
        f"HEADLESS:{config['headless']}",
        f"ENVIRONMENT:{env}",  # ✅ ESTA ES CLAVE
        f"EXECUTION_DIR:{execution_dir}",
        f"SCREENSHOT_DIR:{execution_dir}/screenshots",
        f"INCOGNITO_MODE:{config.get('incognito', True)}"  # ✅ Esta también
    ]
    
    # Agregar variables opcionales si existen en el config
    optional_vars = ['timeout', 'incognito', 'viewport_width', 'viewport_height']
    for var in optional_vars:
        if var in config:
            variables.append(f"{var.upper()}:{config[var]}")

    print(f"🚀 Ejecutando pruebas para el entorno: {env}")
    print(f"🌐 URL base: {config['base_url']}")
    print(f"📁 Directorio de ejecución: {execution_dir}")

    # Ejecuta Robot Framework con reporting mejorado
    output_file = os.path.join(execution_dir, "output.xml")
    
    result = run(
        test_dir,
        variable=variables,
        listener='allure_robotframework;results/allure-results',
        output=output_file,
        log=os.path.join(execution_dir, 'log.html'),
        report=os.path.join(execution_dir, 'report.html'),
        xunit=os.path.join(execution_dir, 'xunit.xml'),
        name=f"Siman Automation - {env}",
        timestampoutputs=False
    )

    # Generar reportes adicionales si la ejecución produjo resultados
    if os.path.exists(output_file):
        print("📊 Generando reportes adicionales...")
        update_dashboard_data(output_file, env, config)
        generate_xray_payload(output_file, env, config)
    else:
        print("❌ No se generó output.xml, omitiendo reportes adicionales")

    # ✅ Generar dashboard
    print("🌐 Generando dashboard...")
    generate_dashboard()

    print(f"📁 Resultados completos en: {execution_dir}")
    
    # Mostrar información de la última ejecución
    if os.name == 'nt':  # Windows
        latest_file = "results/executions/latest.txt"
        if os.path.exists(latest_file):
            with open(latest_file, 'r') as f:
                last_execution = f.read().strip()
            print(f"📝 Última ejecución: {last_execution}")

    sys.exit(result)

if __name__ == "__main__":
    main()