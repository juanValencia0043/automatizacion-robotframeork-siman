#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Exportador de reportes en múltiples formatos (JSON, CSV, Markdown)
"""

import os
import json
import csv
from datetime import datetime
from robot.api import ExecutionResult


class ReportExporter:
    def __init__(self):
        self.results_dir = "results"
        self.output_xml = os.path.join(self.results_dir, "output.xml")
        self.export_dir = os.path.join(self.results_dir, "exports")
        os.makedirs(self.export_dir, exist_ok=True)
    
    def export_to_json(self):
        """Exporta los resultados a JSON"""
        if not os.path.exists(self.output_xml):
            print("⚠️ No se encontró output.xml")
            return
        
        result = ExecutionResult(self.output_xml)
        
        data = {
            'export_date': datetime.now().isoformat(),
            'suite': {
                'name': result.suite.name,
                'documentation': result.suite.doc,
                'start_time': str(result.suite.starttime),
                'end_time': str(result.suite.endtime),
                'elapsed_time': result.suite.elapsedtime / 1000
            },
            'statistics': {
                'total': {
                    'total': result.statistics.total.total,
                    'passed': result.statistics.total.passed,
                    'failed': result.statistics.total.failed,
                    'skipped': result.statistics.total.skipped
                },
                'by_tag': {}
            },
            'tests': []
        }
        
        # Agregar estadísticas por tags
        if result.statistics.tags:
            for tag_stat in result.statistics.tags:
                data['statistics']['by_tag'][tag_stat.name] = {
                    'total': tag_stat.total,
                    'passed': tag_stat.passed,
                    'failed': tag_stat.failed
                }
        
        # Agregar detalles de tests
        for test in result.suite.tests:
            test_data = {
                'name': test.name,
                'status': test.status,
                'tags': list(test.tags),
                'documentation': test.doc,
                'elapsed_time': test.elapsedtime / 1000,
                'start_time': str(test.starttime),
                'end_time': str(test.endtime),
                'keywords': []
            }
            
            for keyword in test.keywords:
                kw_data = {
                    'name': keyword.name,
                    'status': keyword.status,
                    'elapsed_time': keyword.elapsedtime / 1000,
                    'args': list(keyword.args) if keyword.args else [],
                    'doc': keyword.doc
                }
                test_data['keywords'].append(kw_data)
            
            data['tests'].append(test_data)
        
        json_file = os.path.join(self.export_dir, "results.json")
        with open(json_file, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        
        print(f"✅ JSON exportado: {json_file}")
        return json_file
    
    def export_to_csv(self):
        """Exporta los resultados a CSV"""
        if not os.path.exists(self.output_xml):
            print("⚠️ No se encontró output.xml")
            return
        
        result = ExecutionResult(self.output_xml)
        
        # Archivo principal de tests
        csv_file = os.path.join(self.export_dir, "test_results.csv")
        with open(csv_file, 'w', newline='', encoding='utf-8') as f:
            writer = csv.writer(f)
            writer.writerow(['Test Name', 'Status', 'Elapsed Time (s)', 'Tags', 'Start Time', 'End Time'])
            
            for test in result.suite.tests:
                writer.writerow([
                    test.name,
                    test.status,
                    f"{test.elapsedtime / 1000:.2f}",
                    "|".join(test.tags) if test.tags else "",
                    str(test.starttime),
                    str(test.endtime)
                ])
        
        print(f"✅ CSV exportado: {csv_file}")
        
        # Archivo de keywords
        kw_file = os.path.join(self.export_dir, "keyword_results.csv")
        with open(kw_file, 'w', newline='', encoding='utf-8') as f:
            writer = csv.writer(f)
            writer.writerow(['Test', 'Keyword', 'Status', 'Elapsed Time (s)'])
            
            for test in result.suite.tests:
                for keyword in test.keywords:
                    writer.writerow([
                        test.name,
                        keyword.name,
                        keyword.status,
                        f"{keyword.elapsedtime / 1000:.2f}"
                    ])
        
        print(f"✅ Keywords CSV exportado: {kw_file}")
        return csv_file
    
    def export_to_markdown(self):
        """Exporta los resultados a Markdown"""
        if not os.path.exists(self.output_xml):
            print("⚠️ No se encontró output.xml")
            return
        
        result = ExecutionResult(self.output_xml)
        
        md_content = f"""# Reporte de Pruebas - {result.suite.name}

**Fecha de Generación:** {datetime.now().strftime("%d/%m/%Y %H:%M:%S")}

## 📊 Resumen Ejecutivo

| Métrica | Valor |
|---------|-------|
| Total de Pruebas | {result.statistics.total.total} |
| ✅ Pasadas | {result.statistics.total.passed} |
| ❌ Fallidas | {result.statistics.total.failed} |
| ⏭️ Omitidas | {result.statistics.total.skipped} |
| 📈 Tasa de Éxito | {round((result.statistics.total.passed / result.statistics.total.total) * 100, 2)}% |
| ⏱️ Tiempo Total | {result.suite.elapsedtime / 1000:.2f}s |

## 📋 Información General

- **Suite:** {result.suite.name}
- **Documentación:** {result.suite.doc or "N/A"}
- **Inicio:** {result.suite.starttime}
- **Fin:** {result.suite.endtime}

## 🧪 Detalle de Pruebas

"""
        
        # Pruebas pasadas
        passed_tests = [t for t in result.suite.tests if t.status == 'PASS']
        if passed_tests:
            md_content += f"\n### ✅ Pruebas Pasadas ({len(passed_tests)})\n\n"
            for test in passed_tests:
                tags_str = f" `{', '.join(test.tags)}`" if test.tags else ""
                md_content += f"- **{test.name}**{tags_str}\n"
                md_content += f"  - Tiempo: {test.elapsedtime / 1000:.2f}s\n"
        
        # Pruebas fallidas
        failed_tests = [t for t in result.suite.tests if t.status == 'FAIL']
        if failed_tests:
            md_content += f"\n### ❌ Pruebas Fallidas ({len(failed_tests)})\n\n"
            for test in failed_tests:
                tags_str = f" `{', '.join(test.tags)}`" if test.tags else ""
                md_content += f"- **{test.name}**{tags_str}\n"
                md_content += f"  - Tiempo: {test.elapsedtime / 1000:.2f}s\n"
                
                # Mostrar keyword que falló
                for kw in test.keywords:
                    if kw.status == 'FAIL':
                        md_content += f"  - **Falló en:** `{kw.name}`\n"
                        break
        
        # Estadísticas por tags
        if result.statistics.tags:
            md_content += "\n## 🏷️ Estadísticas por Tags\n\n"
            md_content += "| Tag | Total | ✅ Pasadas | ❌ Fallidas |\n"
            md_content += "|-----|-------|-----------|----------|\n"
            
            for tag_stat in result.statistics.tags:
                md_content += f"| {tag_stat.name} | {tag_stat.total} | {tag_stat.passed} | {tag_stat.failed} |\n"
        
        # Keywords más lentos
        all_keywords = []
        for test in result.suite.tests:
            for kw in test.keywords:
                all_keywords.append({
                    'name': kw.name,
                    'time': kw.elapsedtime / 1000,
                    'test': test.name
                })
        
        if all_keywords:
            all_keywords.sort(key=lambda x: x['time'], reverse=True)
            md_content += "\n## ⚙️ Keywords Más Lentos\n\n"
            for kw in all_keywords[:10]:  # Top 10
                md_content += f"- `{kw['name']}` - **{kw['time']:.2f}s** (en {kw['test']})\n"
        
        md_file = os.path.join(self.export_dir, "REPORTE.md")
        with open(md_file, 'w', encoding='utf-8') as f:
            f.write(md_content)
        
        print(f"✅ Markdown exportado: {md_file}")
        return md_file
    
    def export_all(self):
        """Exporta en todos los formatos"""
        print("\n" + "="*60)
        print("  EXPORTADOR DE REPORTES")
        print("="*60 + "\n")
        
        self.export_to_json()
        self.export_to_csv()
        self.export_to_markdown()
        
        print("\n" + "="*60)
        print(f"✅ Todos los reportes exportados a: {self.export_dir}\n")


if __name__ == "__main__":
    exporter = ReportExporter()
    exporter.export_all()
