#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script para ejecutar pruebas y generar reportes detallados automáticamente
Uso: python run_and_report.py <environment>
"""

import os
import sys
import subprocess
from generate_detailed_report import DetailedReportGenerator
from export_test_reports import ReportExporter


def run_tests_and_generate_reports(env):
    """Ejecuta pruebas y genera todos los reportes"""
    
    print("\n" + "="*70)
    print(f"  EJECUTANDO PRUEBAS Y GENERANDO REPORTES - {env.upper()}")
    print("="*70 + "\n")
    
    # Paso 1: Ejecutar pruebas
    print("📝 PASO 1: Ejecutando pruebas...")
    print("-" * 70)
    result = subprocess.run(
        [sys.executable, "run_tests.py", env],
        cwd=os.getcwd()
    )
    
    if result.returncode != 0:
        print("\n⚠️ Las pruebas tuvieron problemas, pero continuaremos con los reportes...\n")
    else:
        print("\n✅ Pruebas completadas exitosamente\n")
    
    # Paso 2: Generar reporte HTML detallado
    print("\n📊 PASO 2: Generando reporte HTML detallado...")
    print("-" * 70)
    try:
        generator = DetailedReportGenerator()
        tests_info = generator.get_test_details()
        generator.generate_html_report(tests_info)
    except Exception as e:
        print(f"❌ Error al generar reporte HTML: {e}")
    
    # Paso 3: Exportar a múltiples formatos
    print("\n📁 PASO 3: Exportando a múltiples formatos...")
    print("-" * 70)
    try:
        exporter = ReportExporter()
        exporter.export_all()
    except Exception as e:
        print(f"❌ Error al exportar reportes: {e}")
    
    # Resumen final
    print("\n" + "="*70)
    print("  RESUMEN DE REPORTES GENERADOS")
    print("="*70)
    print("\n📂 Ubicaciones de los reportes:\n")
    print("  1. HTML Detallado:     results/DETAILED_REPORT.html")
    print("  2. Reporte Estándar:   results/report.html")
    print("  3. Log Completo:       results/log.html")
    print("  4. JSON:               results/exports/results.json")
    print("  5. CSV Tests:          results/exports/test_results.csv")
    print("  6. CSV Keywords:       results/exports/keyword_results.csv")
    print("  7. Markdown:           results/exports/REPORTE.md")
    print("  8. Dashboard:          results/dashboards/index.html")
    print("\n" + "="*70)
    print("✅ Proceso completado\n")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("❌ Uso: python run_and_report.py <environment>")
        print("   Ejemplos:")
        print("   - python run_and_report.py sandbox")
        print("   - python run_and_report.py prod")
        sys.exit(1)
    
    env = sys.argv[1]
    run_tests_and_generate_reports(env)
