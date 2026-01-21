#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script para generar un reporte detallado de las ejecuciones de pruebas
Combina información de Robot Framework con análisis adicional
"""

import os
import json
import xml.etree.ElementTree as ET
from datetime import datetime
from pathlib import Path
from robot.api import ExecutionResult
import re

class DetailedReportGenerator:
    def __init__(self):
        self.results_dir = "results"
        self.output_xml = os.path.join(self.results_dir, "output.xml")
        self.report_output = os.path.join(self.results_dir, "DETAILED_REPORT.html")
        
    def get_test_details(self):
        """Extrae detalles detallados de los tests"""
        if not os.path.exists(self.output_xml):
            print(f"⚠️ No se encontró {self.output_xml}")
            return None
        
        result = ExecutionResult(self.output_xml)
        tests_info = []
        
        for test in result.suite.tests:
            test_data = {
                'name': test.name,
                'status': test.status,
                'elapsed_time': test.elapsedtime / 1000,  # Convertir a segundos
                'start_time': self._format_time(test.starttime),
                'end_time': self._format_time(test.endtime),
                'tags': list(test.tags),
                'documentation': test.doc,
                'keywords': []
            }
            
            # Extraer información de keywords
            for keyword in test.keywords:
                kw_data = {
                    'name': keyword.name,
                    'status': keyword.status,
                    'elapsed_time': keyword.elapsedtime / 1000,
                    'args': list(keyword.args) if keyword.args else []
                }
                test_data['keywords'].append(kw_data)
            
            tests_info.append(test_data)
        
        return {
            'suite_name': result.suite.name,
            'total_tests': result.statistics.total.total,
            'passed': result.statistics.total.passed,
            'failed': result.statistics.total.failed,
            'skipped': result.statistics.total.skipped,
            'total_time': result.suite.elapsedtime / 1000,
            'success_rate': round((result.statistics.total.passed / result.statistics.total.total) * 100, 2) if result.statistics.total.total > 0 else 0,
            'start_time': self._format_time(result.suite.starttime),
            'end_time': self._format_time(result.suite.endtime),
            'tests': tests_info
        }
    
    def _format_time(self, timestamp):
        """Formatea timestamp a fecha legible"""
        if timestamp:
            # Robot Framework puede usar diferentes formatos
            try:
                # Si es un timestamp en milisegundos (número)
                if isinstance(timestamp, (int, float)):
                    return datetime.fromtimestamp(int(timestamp) / 1000).strftime("%Y-%m-%d %H:%M:%S")
                # Si ya es un string con formato legible
                elif isinstance(timestamp, str):
                    return timestamp
            except (ValueError, OSError):
                return str(timestamp)
        return "N/A"
    
    def get_execution_history(self):
        """Obtiene histórico de ejecuciones"""
        history_file = os.path.join(self.results_dir, "dashboards", "data", "execution_history.json")
        
        if os.path.exists(history_file):
            with open(history_file, 'r', encoding='utf-8') as f:
                return json.load(f)
        return []
    
    def analyze_failures(self, tests_info):
        """Analiza y categoriza los fallos"""
        failures = {
            'total': 0,
            'by_test': [],
            'common_patterns': {}
        }
        
        for test in tests_info['tests']:
            if test['status'] == 'FAIL':
                failures['total'] += 1
                
                # Buscar el keyword que falló
                failed_keyword = None
                for kw in test['keywords']:
                    if kw['status'] == 'FAIL':
                        failed_keyword = kw['name']
                        break
                
                failures['by_test'].append({
                    'test_name': test['name'],
                    'failed_at': failed_keyword,
                    'elapsed_time': test['elapsed_time']
                })
                
                # Registrar patrones comunes
                if failed_keyword:
                    failures['common_patterns'][failed_keyword] = failures['common_patterns'].get(failed_keyword, 0) + 1
        
        return failures
    
    def generate_html_report(self, tests_info):
        """Genera reporte HTML detallado"""
        if tests_info is None:
            print("❌ No hay datos para generar el reporte")
            return
        
        failures = self.analyze_failures(tests_info)
        history = self.get_execution_history()
        
        html_content = f"""
        <!DOCTYPE html>
        <html lang="es">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Reporte Detallado de Pruebas - {tests_info['suite_name']}</title>
            <style>
                * {{
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }}
                
                body {{
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: #333;
                    padding: 20px;
                }}
                
                .container {{
                    max-width: 1400px;
                    margin: 0 auto;
                    background: white;
                    border-radius: 10px;
                    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
                    overflow: hidden;
                }}
                
                .header {{
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                    padding: 40px;
                    text-align: center;
                }}
                
                .header h1 {{
                    font-size: 2.5em;
                    margin-bottom: 10px;
                }}
                
                .header p {{
                    font-size: 0.95em;
                    opacity: 0.9;
                }}
                
                .summary {{
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                    gap: 20px;
                    padding: 40px;
                    background: #f8f9fa;
                }}
                
                .summary-card {{
                    background: white;
                    padding: 25px;
                    border-radius: 8px;
                    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                    border-left: 5px solid;
                    transition: transform 0.3s ease;
                }}
                
                .summary-card:hover {{
                    transform: translateY(-5px);
                }}
                
                .card-passed {{
                    border-left-color: #28a745;
                }}
                
                .card-failed {{
                    border-left-color: #dc3545;
                }}
                
                .card-total {{
                    border-left-color: #007bff;
                }}
                
                .card-rate {{
                    border-left-color: #ffc107;
                }}
                
                .card-value {{
                    font-size: 2.5em;
                    font-weight: bold;
                    margin-bottom: 10px;
                }}
                
                .card-label {{
                    font-size: 0.9em;
                    color: #666;
                    text-transform: uppercase;
                    letter-spacing: 1px;
                }}
                
                .content {{
                    padding: 40px;
                }}
                
                .section {{
                    margin-bottom: 40px;
                }}
                
                .section h2 {{
                    font-size: 1.5em;
                    color: #333;
                    border-bottom: 3px solid #667eea;
                    padding-bottom: 15px;
                    margin-bottom: 25px;
                }}
                
                .status-badge {{
                    display: inline-block;
                    padding: 5px 15px;
                    border-radius: 20px;
                    font-weight: bold;
                    font-size: 0.85em;
                }}
                
                .status-pass {{
                    background: #d4edda;
                    color: #155724;
                }}
                
                .status-fail {{
                    background: #f8d7da;
                    color: #721c24;
                }}
                
                .status-skip {{
                    background: #e2e3e5;
                    color: #383d41;
                }}
                
                table {{
                    width: 100%;
                    border-collapse: collapse;
                    margin-bottom: 30px;
                }}
                
                thead {{
                    background: #f8f9fa;
                }}
                
                th {{
                    padding: 15px;
                    text-align: left;
                    font-weight: 600;
                    color: #333;
                    border-bottom: 2px solid #dee2e6;
                }}
                
                td {{
                    padding: 12px 15px;
                    border-bottom: 1px solid #dee2e6;
                }}
                
                tbody tr:hover {{
                    background: #f8f9fa;
                }}
                
                .time {{
                    color: #666;
                    font-size: 0.9em;
                }}
                
                .keyword-list {{
                    background: #f8f9fa;
                    border-left: 3px solid #667eea;
                    padding: 15px;
                    margin-bottom: 10px;
                    border-radius: 4px;
                }}
                
                .keyword-item {{
                    padding: 8px 0;
                    font-family: 'Courier New', monospace;
                    font-size: 0.9em;
                }}
                
                .keyword-fail {{
                    color: #dc3545;
                    font-weight: bold;
                }}
                
                .timeline {{
                    position: relative;
                    padding: 20px 0;
                }}
                
                .timeline-item {{
                    display: flex;
                    margin-bottom: 20px;
                }}
                
                .timeline-marker {{
                    width: 40px;
                    height: 40px;
                    border-radius: 50%;
                    background: #667eea;
                    color: white;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-weight: bold;
                    flex-shrink: 0;
                    margin-right: 20px;
                }}
                
                .timeline-marker.fail {{
                    background: #dc3545;
                }}
                
                .timeline-content {{
                    flex-grow: 1;
                }}
                
                .timeline-content p {{
                    margin: 5px 0;
                }}
                
                .footer {{
                    background: #f8f9fa;
                    padding: 20px 40px;
                    text-align: center;
                    color: #666;
                    font-size: 0.9em;
                }}
                
                .chart-container {{
                    margin-bottom: 30px;
                    text-align: center;
                }}
                
                @media print {{
                    body {{
                        background: white;
                    }}
                    
                    .container {{
                        box-shadow: none;
                    }}
                }}
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <h1>📊 Reporte Detallado de Pruebas</h1>
                    <p>Suite: {tests_info['suite_name']}</p>
                    <p>Generado: {datetime.now().strftime("%d/%m/%Y %H:%M:%S")}</p>
                </div>
                
                <div class="summary">
                    <div class="summary-card card-total">
                        <div class="card-value">{tests_info['total_tests']}</div>
                        <div class="card-label">Pruebas Totales</div>
                    </div>
                    <div class="summary-card card-passed">
                        <div class="card-value">{tests_info['passed']}</div>
                        <div class="card-label">Pasadas ✓</div>
                    </div>
                    <div class="summary-card card-failed">
                        <div class="card-value">{tests_info['failed']}</div>
                        <div class="card-label">Fallidas ✗</div>
                    </div>
                    <div class="summary-card card-rate">
                        <div class="card-value">{tests_info['success_rate']}%</div>
                        <div class="card-label">Tasa de Éxito</div>
                    </div>
                </div>
                
                <div class="content">
                    <!-- Información General -->
                    <div class="section">
                        <h2>📋 Información General</h2>
                        <table>
                            <tr>
                                <th>Métrica</th>
                                <th>Valor</th>
                            </tr>
                            <tr>
                                <td>Tiempo Total de Ejecución</td>
                                <td><strong>{tests_info['total_time']:.2f}s</strong></td>
                            </tr>
                            <tr>
                                <td>Inicio</td>
                                <td>{tests_info['start_time']}</td>
                            </tr>
                            <tr>
                                <td>Fin</td>
                                <td>{tests_info['end_time']}</td>
                            </tr>
                            <tr>
                                <td>Pruebas Omitidas</td>
                                <td>{tests_info['skipped']}</td>
                            </tr>
                        </table>
                    </div>
                    
                    <!-- Análisis de Fallos -->
                    {self._generate_failure_section(failures)}
                    
                    <!-- Detalle de Pruebas -->
                    <div class="section">
                        <h2>🧪 Detalle de Pruebas</h2>
                        <table>
                            <thead>
                                <tr>
                                    <th>Prueba</th>
                                    <th>Estado</th>
                                    <th>Tiempo (s)</th>
                                    <th>Tags</th>
                                </tr>
                            </thead>
                            <tbody>
                                {self._generate_tests_table(tests_info['tests'])}
                            </tbody>
                        </table>
                    </div>
                    
                    <!-- Keywords Ejecutados -->
                    <div class="section">
                        <h2>⚙️ Keywords Ejecutados</h2>
                        {self._generate_keywords_section(tests_info['tests'])}
                    </div>
                </div>
                
                <div class="footer">
                    <p>Este reporte fue generado automáticamente por el sistema de automatización</p>
                    <p>Para más detalles, consulta: <strong>results/log.html</strong> y <strong>results/report.html</strong></p>
                </div>
            </div>
        </body>
        </html>
        """
        
        with open(self.report_output, 'w', encoding='utf-8') as f:
            f.write(html_content)
        
        print(f"✅ Reporte detallado generado: {self.report_output}")
    
    def _generate_failure_section(self, failures):
        """Genera sección de análisis de fallos"""
        if failures['total'] == 0:
            return """
            <div class="section">
                <h2>✅ Análisis de Fallos</h2>
                <p style="color: #28a745; font-weight: bold;">¡Excelente! Todas las pruebas pasaron correctamente.</p>
            </div>
            """
        
        failures_html = """
            <div class="section">
                <h2>❌ Análisis de Fallos</h2>
                <p>Se encontraron <strong>{}</strong> pruebas fallidas:</p>
                <table>
                    <thead>
                        <tr>
                            <th>Prueba</th>
                            <th>Falló en</th>
                            <th>Tiempo (s)</th>
                        </tr>
                    </thead>
                    <tbody>
        """.format(failures['total'])
        
        for fail in failures['by_test']:
            failures_html += f"""
                        <tr>
                            <td>{fail['test_name']}</td>
                            <td><span class="keyword-fail">{fail['failed_at'] or 'N/A'}</span></td>
                            <td>{fail['elapsed_time']:.2f}s</td>
                        </tr>
            """
        
        failures_html += """
                    </tbody>
                </table>
        """
        
        if failures['common_patterns']:
            failures_html += """
                <h3 style="margin-top: 20px; color: #666;">Patrones de Fallos Comunes:</h3>
                <ul>
            """
            for keyword, count in sorted(failures['common_patterns'].items(), key=lambda x: x[1], reverse=True):
                failures_html += f"<li><strong>{keyword}</strong>: falló {count} vez(ces)</li>"
            failures_html += """
                </ul>
            """
        
        failures_html += "</div>"
        return failures_html
    
    def _generate_tests_table(self, tests):
        """Genera filas de la tabla de pruebas"""
        rows = ""
        for test in tests:
            status_class = f"status-{test['status'].lower()}"
            tags = ", ".join(test['tags']) if test['tags'] else "—"
            rows += f"""
            <tr>
                <td>{test['name']}</td>
                <td><span class="status-badge {status_class}">{test['status']}</span></td>
                <td class="time">{test['elapsed_time']:.2f}s</td>
                <td>{tags}</td>
            </tr>
            """
        return rows
    
    def _generate_keywords_section(self, tests):
        """Genera sección de keywords ejecutados"""
        html = ""
        for test in tests:
            if test['keywords']:
                html += f"""
                <div class="keyword-list">
                    <strong>{test['name']}</strong>
                    <ul style="margin-top: 10px; margin-left: 20px;">
                """
                for kw in test['keywords']:
                    status_class = "keyword-fail" if kw['status'] == 'FAIL' else ""
                    html += f"""
                        <li class="keyword-item {status_class}">
                            {kw['name']} <span class="time">({kw['elapsed_time']:.2f}s)</span>
                        </li>
                    """
                html += """
                    </ul>
                </div>
                """
        return html
    
    def generate_report(self):
        """Genera todos los reportes"""
        print("\n" + "="*60)
        print("  GENERADOR DE REPORTE DETALLADO DE PRUEBAS")
        print("="*60 + "\n")
        
        tests_info = self.get_test_details()
        self.generate_html_report(tests_info)
        
        print("\n" + "="*60)
        print("✅ Proceso completado\n")


if __name__ == "__main__":
    generator = DetailedReportGenerator()
    generator.generate_report()
